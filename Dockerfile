# hsteininger/DoMaLiMa
# VERSION 1.0.0

#what image to use
FROM debian

#maintainer
MAINTAINER Herbert Steininger <hsteininger@hsteininger.de>

#set env variables
ENV DEBIAN_FRONTEND noninteractive

#set timezone
RUN echo "TZ='Europe/Berlin'; export TZ" >> /root/.bashrc

#run aptitude
RUN apt-get update && apt-get install -y --fix-missing tar less vim wget lynx psmisc lsof strace

##MATLABstuff
RUN apt-get install -y --fix-missing lsb

#copy matlabstuff
ADD matlab_R2017a_glnxa64 /root/
COPY license.dat /root/license.dat
COPY activate.ini /root/activate.ini
COPY installer_input.txt /root/installer_input.txt

RUN chmod -R 755 /root
RUN /root/install -inputFile /root/installer_input.txt

ADD ./start.sh /root/bin/
RUN chmod -R 755 /root/bin/start.sh

RUN ln -s /tmp /usr/tmp

RUN adduser --disabled-password --gecos '' matlab

ENTRYPOINT ["/root/bin/start.sh"]
#CMD ["/bin/bash"]
