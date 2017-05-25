#!/usr/bin/env bash
sudo apt-get update

apt-get install python-software-properties -y
add-apt-repository ppa:openjdk-r/ppa -y
apt-get update

echo "\n----- Installing Apache and Java 8 ------\n"
apt-get -y install apache2 openjdk-8-jdk
ln -s /usr/lib/jvm/java-8-openjdk-i386 /opt/java

echo "\n----- Installing Tomcat_9 ------\n"
groupadd tomcat
useradd -m -g tomcat -p $(openssl passwd -1 lala1234) tomcat

cd /opt
wget http://archive.apache.org/dist/tomcat/tomcat-9/v9.0.0.M11/bin/apache-tomcat-9.0.0.M11.tar.gz
tar xvf apache-tomcat-9.0.0.M11.tar.gz
ln -s apache-tomcat-9.0.0.M11 tomcat
chown -R tomcat /opt/tomcat/
chgrp -R tomcat /opt/tomcat/

chmod g+rwx /opt/tomcat/conf
chmod g+r /opt/tomcat/conf/*

tr -d '\r' < /tmp/tomcat.conf > /etc/init/tomcat.conf
tr -d '\r' < /tmp/webapps.manager.META-INF.context.xml > /opt/tomcat/webapps/manager/META-INF/context.xml
sed -i 's#</tomcat-users>#  <user username="admin" password="admin" roles="manager-gui,admin-gui"/>\\n</tomcat-users>#' /opt/tomcat/conf/tomcat-users.xml

tr -d '\r' < /tmp/tomcat_ctrl > /etc/init.d/tomcat_ctrl
echo '/etc/init.d/tomcat_ctrl start' >/etc/init.d/tomcat_start
echo '/etc/init.d/tomcat_ctrl stop' >/etc/init.d/tomcat_stop
chmod +x /etc/init.d/tomcat_ctrl
chmod +x /etc/init.d/tomcat_start
chmod +x /etc/init.d/tomcat_stop

ln -s ../init.d/tomcat_stop /etc/rc0.d/K08tomcat
ln -s ../init.d/tomcat_stop /etc/rc6.d/K08tomcat

ln -s ../init.d/tomcat_start /etc/rc1.d/S92tomcat
ln -s ../init.d/tomcat_start /etc/rc2.d/S92tomcat
ln -s ../init.d/tomcat_start /etc/rc3.d/S92tomcat
ln -s ../init.d/tomcat_start /etc/rc4.d/S92tomcat
ln -s ../init.d/tomcat_start /etc/rc5.d/S92tomcat

#ssh-copy-id tomcat@192.168.33.20
#tar -C target -c target/hello-spring.war | ssh vagrant@192.168.3.16 "sudo tar -x -C /opt/tomcat/webapps"
