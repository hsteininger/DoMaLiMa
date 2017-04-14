# hsteininger/DoMaLiMa
# VERSION 1.0.1

#what image to use
FROM debian

#maintainer
MAINTAINER Herbert Steininger <hsteininger@hsteininger.de>

#set env variables
ENV DEBIAN_FRONTEND noninteractive
ENV PATH /usr/local/MatLab/2017a/etc:/usr/local/MatLab/2017a/bin:$PATH

#set timezone
RUN echo "TZ='Europe/Berlin'; export TZ" >> /root/.bashrc

#run aptitude
RUN apt-get update && apt-get install -y --fix-missing lsb

##MATLAB
RUN adduser --disabled-password --gecos '' matlab
ADD matlab_R2017a_glnxa64 /root/
ADD start.sh /root/bin/
COPY license.dat /root/license.dat
COPY activate.ini /root/activate.ini
COPY installer_input.txt /root/installer_input.txt
RUN ln -s /tmp /usr/tmp
RUN chmod -R 755 /root
RUN /root/install -inputFile /root/installer_input.txt

ENTRYPOINT ["/root/bin/start.sh"]
