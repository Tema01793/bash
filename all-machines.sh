#!/bin/bash
# IF [os=CentOS] DO
systemctl disable --now firewalld
sed -i '7 s/*/SELINUX=disabled' /etc/selinux/config
mkdir /media/cdrom
mount /dev/cdrom /media/cdrom
yum --disablerepo=\* --enablerepo=c7-media install mc tcpdump net-tools curl vim lynx dhclient bind-utils nfs-utils cifs-utils -y



# END
# IF [os=Debian] DO
systemctl disable --now apparmor
apt-cdrom add
apt install mc tcpdump net-tools curl vim lynx bind9 dnsutils nfs-common cifs-utils openssh-server -y
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
systemctl enable sshd
systemctl restart sshd


# END
echo net.ipv4.ip_forward=1 > /etc/sysctl.conf
sysctl -p

# IF [hostname=L-CLI-A] DO
echo "127.0.0.1	localhost" > /etc/hosts
echo "172.16.20.10	L-SRV" >> /etc/hosts
echo "172.16.50.2	L-RTR-A" >> /etc/hosts
echo "172.16.55.2	L-RTR-B" >> /etc/hosts
echo "172.16.200.61	L-CLI-B" >> /etc/hosts
echo "10.10.10.1	L-FW" >> /etc/hosts
echo "10.10.10.10	ISP" >> /etc/hosts
echo "20.20.20.5	OUT-CLI" >> /etc/hosts
echo "20.20.20.100	R-FW" >> /etc/hosts
echo "192.168.20.10	R-SRV" >> /etc/hosts
echo "192.168.10.2	R-RTR" >> /etc/hosts
echo "192.168.100.100	R-CLI" >> /etc/hosts

sed -i '12 s/files/dns files' /etc/nsswitch.conf
# END
# IF [hostname=R-CLI] DO
sed -i '42 s/files dns/dns files' /etc/nsswitch.conf

echo -n "domain skill39.wsr\nsearch skill39.wsr\nnameserver 192.168.20.10" > /etc/resolv.conf
# END
# IF [hostname=OUT-CLI] DO
echo -n "domain skill39.wsr\nsearch skill39.wsr\nnameserver 10.10.10.1" > /etc/resolv.conf
# END
echo {VM-NAME-ARG} > /etc/hostname
reboot
