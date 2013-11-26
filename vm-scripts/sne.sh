#!/bin/env bash
echo "NETWORKING=yes
HOSTNAME=sne" > /etc/sysconfig/network
hostname sne
service iptables stop
service ip6tables stop
chkconfig iptables off
chkconfig ip6tables off
yum install git -y
yum install sqlite-devel -y
\curl -L https://get.rvm.io | bash
source /etc/profile.d/rvm.sh
rvm install 1.9.3
rvm use 1.9.3 --default
echo "gem: --no-ri --no-rdoc" > ~/.gemrc
git clone https://github.com/CMU-SSN/SSN
mv facebook.yml SSN/social-network-engine/config
cd SSN/social-network-engine/
bundle install
gem install passenger
rake db:migrate
cd ~
echo "#!/bin/env sh
alias start_sne='cd SSN/social-network-engine ; rm -rf tmp/pids/* ; passenger start -p 80 -d'
start_sne" > ~/onboot.sh
chmod +x ~/onboot.sh
echo "su - root -c /root/onboot.sh" >> /etc/rc.d/rc.local
echo "DEVICE=eth0
TYPE=Ethernet
ONBOOT=yes
NM_CONTROLLED=no
BOOTPROTO=static
IPADDR=10.0.55.4
NETMASK=255.255.255.0
GATEWAY=10.0.55.3" > /etc/sysconfig/network-scripts/ifcfg-eth0
reboot
