#!/usr/bin/env bash
sudo apt-get update

apt-get install python-software-properties -y
add-apt-repository ppa:openjdk-r/ppa -y
apt-get update

echo "\n----- Installing Apache and Java 8 ------\n"
apt-get -y install apache2 openjdk-8-jdk
ln -s /usr/lib/jvm/java-8-openjdk-i386 /opt/java
#update-alternatives --config java

echo "\n----- Installing Tomcat ------\n"
groupadd tomcat
#useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat
useradd -m -g tomcat -p $(openssl passwd -1 lala1234) tomcat
#wget http://mirrors.gigenet.com/apache/tomcat/tomcat-8/v8.0.30/bin/apache-tomcat-8.0.30.tar.gz
cd /opt
wget http://archive.apache.org/dist/tomcat/tomcat-9/v9.0.0.M11/bin/apache-tomcat-9.0.0.M11.tar.gz
#mkdir /opt/tomcat
tar xvf apache-tomcat-9.0.0.M11.tar.gz
ln -s apache-tomcat-9.0.0.M11 tomcat
chown -R tomcat /opt/tomcat/
#chgrp -R tomcat /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs/
chgrp -R tomcat /opt/tomcat/

chmod g+rwx /opt/tomcat/conf
chmod g+r /opt/tomcat/conf/*
#wget -q https://gist.githubusercontent.com/adeubank/1a8db1958578146120a2/raw/c796a8881d95dd2cbe47d1ffee8246463ec2c7a1/tomcat.conf
mv /tmp/tomcat.conf /etc/init/
mv /tmp/webapps.manager.META-INF.context.xml /opt/tomcat/webapps/manager/META-INF/context.xml
sed -i "s#</tomcat-users>#  <user username=\\"admin\\" password=\\"admin\\" roles=\\"manager-gui,admin-gui\\"/>\\n</tomcat-users>#" /opt/tomcat/conf/tomcat-users.xml

mv /tmp/tomcat_ctrl /etc/init.d
chmod +x /etc/init.d/tomcat_ctrl
ln -s /etc/init.d/tomcat_ctrl /etc/rc0.d/K08tomcat
ln -s /etc/init.d/tomcat_ctrl /etc/rc6.d/K08tomcat

ln -s /etc/init.d/tomcat_ctrl /etc/rc1.d/S92tomcat
ln -s /etc/init.d/tomcat_ctrl /etc/rc2.d/S92tomcat
ln -s /etc/init.d/tomcat_ctrl /etc/rc3.d/S92tomcat
ln -s /etc/init.d/tomcat_ctrl /etc/rc4.d/S92tomcat
ln -s /etc/init.d/tomcat_ctrl /etc/rc5.d/S92tomcat

#ssh-copy-id tomcat@192.168.33.20
#tar -C target -c target/hello-spring.war | ssh vagrant@192.168.3.16 "sudo tar -x -C /opt/tomcat/webapps"
