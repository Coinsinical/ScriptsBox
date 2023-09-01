#!/bin/bash
#<UDF name="port" label="The port of the socks5." default="26188">
# PORT=
#
#<UDF name="username" label="The username of the socks5." default="123">
# USERNAME=
#<UDF name="password" label="The password of the socks5." default="123">
# PASSWORD=
distro=$(cat /etc/os-release | grep -oP '^NAME="\K[^"]+')
version=$(cat /etc/os-release | grep -oP '^VERSION_ID="\K[^"]+')
if [[ $distro =~ "Ubuntu" || $distro =~ "Debian" ]]; then
  ufw disable
  apt install wget -y
  echo "UFW firewall disabled"
elif [[ $distro =~ "CentOS" || $distro =~ "Fedora" ]]; then
  systemctl stop firewalld
  systemctl disable firewalld
  yum install wget -y
  echo "Firewalld firewall stopped and disabled"
elif [[ $distro =~ "RHEL" ]]; then
  service iptables stop
  chkconfig iptables off
  echo "iptables firewall stopped and disabled"
else
  echo "Unsupported distribution: $distro $version"
  exit 1
fi
wget --no-check-certificate https://raw.github.com/Lozy/danted/master/install.sh -O /opt/install.sh
bash /opt/install.sh  --port=$PORT --user=$USERNAME --passwd=$PASSWORD > /opt/install.log
