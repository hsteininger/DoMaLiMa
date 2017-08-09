# DoMaLiMa
## Docker Matlab License Manager


## Introducing

**DoMaLiMa** let you build, silent-install and run an dockerized **Matlab-FlexLM-Manager** which can be reached from all
other hosts in your network.

You can spawn only one or how much are needed to fullfill your license-quorum.

For this example we will use three containers

Because of the fact, that you can give an Docker-Container every Mac-Address
it is easy to port the License-Manager quickly to some other Server without deactivating the License

***


## Installation


### Software

##### This Repository

Clone this repository to an location that fits your needs
and `cd` into the newly created directory.

Copy your `license.dat` file in here and replace it with the placeholder `license.dat`

Also, don't forget to set your `fileInstallationKey` in [installer_input.txt](../blob/master/installer_input.txt)

marked with:
```
fileInstallationKey=$PUT-YOUR-KEY-HERE
```

***

##### MatLab R2017a

Download your version of Matlab (@time of writing this is R2017a) [here][1]

Unzip it into `DoMaLiMa/`, so that it looks something like `DoMaLiMa/matlab_R2017a_glnxa64`
according to your downloaded version

***


### Host Settings

In order for Docker to be able to listen to real network-adresses on your network,
we use virt. interfaces and map them to the container during the 'docker run'-command.


##### Set virt. Interfaces on Host(s) like this:

Put in `/etc/network/interfaces`, or wherever your distribution holds Interface-Config-Files

Change settings according to your needs

```bash
auto eth0:1
allow-hotplug eth0:1
iface eth0:1 inet static
        address 192.168.1.241
        netmask 255.255.255.0
        gateway 192.168.1.1
        dns-nameservers 192.168.1.1
        dns-search example.org

auto eth0:2
allow-hotplug eth0:2
iface eth0:2 inet static
        address 192.168.1.242
        netmask 255.255.255.0
        gateway 192.168.1.1
        dns-nameservers 192.168.1.1
        dns-search example.org

auto eth0:3
allow-hotplug eth0:3
iface eth0:3 inet static
        address 192.168.1.243
        netmask 255.255.255.0
        gateway 192.168.1.1
        dns-nameservers 192.168.1.1
        dns-search example.org
```

afterwards

`sudo ifup eth0:1 eth0:2 eth0:3`

to bring up the interfaces.

***


### Preparing Docker Images

##### If there are old Container running, ...
###### stop them, ...
`docker stop license01 license02 license03`
###### remove them
`docker rm license01 license02 license03`

***


##### Rebuild the Container

Now you can build the Container with:
```bash
docker build -t hsteininger/domalima .
```

If you're behind a Proxy you can use `--build-args` to set a Proxy
```bash
docker build --build-arg HTTP_PROXY=http://YOUR-HTTP-PROXY:80/ \
             --build-arg HTTPS_PROXY=http://YOUR-HTTPS-PROXY:443/ \
             --build-arg FTP_PROXY=http://YOUR-FTP-PROXY:80/ \
             -t hsteininger/domalima .
```

***


### Run Container

Keep hostname, mac-address and IP-Portmapping, because of MatLab-License-Host-Mapping

**Set Port and Mac-Adress according to your 'license.dat'**

###### license01
```
docker run -itd --restart unless-stopped -p 192.168.1.241:27000-27001:27000-27001 \
            --mac-address="00:00:00:00:00:01" -h license01 --name=license01 \
            hsteininger/domalima
```

###### license02
```
docker run -itd --restart unless-stopped -p 192.168.1.242:27000-27001:27000-27001 \
            --mac-address="00:00:00:00:00:02" -h license02 --name=license02 \
            hsteininger/domalima
```

###### license03
```
docker run -itd --restart unless-stopped -p 192.168.1.243:27000-27001:27000-27001 \
            --mac-address="00:00:00:00:00:03" -h license03 --name=license03 \
            hsteininger/domalima
```

***


##### Get Status From Hosts

```bash
docker exec license01 /usr/local/MatLab/2017a/etc/lmstat -c /usr/local/MatLab/2017a/etc/license.dat -a
docker exec license02 /usr/local/MatLab/2017a/etc/lmstat -c /usr/local/MatLab/2017a/etc/license.dat -a
docker exec license03 /usr/local/MatLab/2017a/etc/lmstat -c /usr/local/MatLab/2017a/etc/license.dat -a
```

***


##### If you need to attach to an Container

```bash
docker attach license01
docker attach license02
docker attach license03
```

To `quit` from an attached container press `ctrl-p+q`



###### Herbert Steininger 2017
[1]: https://de.mathworks.com/downloads/web_downloads/select_release
