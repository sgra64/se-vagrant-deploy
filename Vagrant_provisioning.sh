#!/usr/bin/env bash

echo "\n----- Installing Java 8 JRE ------\n"
apt-get update
apt-get install python-software-properties -y
add-apt-repository ppa:openjdk-r/ppa -y
apt-get update
apt-get install openjdk-8-jdk -y

ln -s /usr/lib/jvm/java-8-openjdk-i386 /opt/java

echo "\n----- Installing Tomcat user ------\n"
groupadd tomcat
useradd -m -g tomcat -s /bin/bash -p $(openssl passwd -1 lala1234) tomcat

echo "\n----- Installing Tomcat 9 ------\n"
cd /opt
wget -q http://archive.apache.org/dist/tomcat/tomcat-9/v9.0.0.M11/bin/apache-tomcat-9.0.0.M11.tar.gz
tar xvf apache-tomcat-9.0.0.M11.tar.gz
ln -s apache-tomcat-9.0.0.M11 tomcat
chown -R tomcat /opt/tomcat/
chgrp -R tomcat /opt/tomcat/

#remove CR in CR/LF line ends used on Windows
tr -d '\r' < /tmp/tomcat.conf > /etc/init/tomcat.conf
tr -d '\r' < /tmp/webapps.manager.META-INF.context.xml > /opt/tomcat/webapps/manager/META-INF/context.xml
#insert line: <user username="tomcat" password="lala1234" roles="manager-gui,admin-gui"/> in /opt/tomcat/conf/tomcat-users.xml
sed -i 's#</tomcat-users>#  <user username="tomcat" password="lala1234" roles="manager-gui,admin-gui"/>\n</tomcat-users>#' /opt/tomcat/conf/tomcat-users.xml

#tomcat start/stop scripts
tr -d '\r' < /tmp/tomcat_ctrl > /etc/init.d/tomcat_ctrl
echo '/etc/init.d/tomcat_ctrl start' >/etc/init.d/tomcat_start
echo '/etc/init.d/tomcat_ctrl stop' >/etc/init.d/tomcat_stop
chmod +x /etc/init.d/tomcat_ctrl
chmod +x /etc/init.d/tomcat_start
chmod +x /etc/init.d/tomcat_stop

#enter tomcat start/stop in run level directories
ln -s ../init.d/tomcat_stop /etc/rc0.d/K08tomcat
ln -s ../init.d/tomcat_stop /etc/rc6.d/K08tomcat

ln -s ../init.d/tomcat_start /etc/rc1.d/S92tomcat
ln -s ../init.d/tomcat_start /etc/rc2.d/S92tomcat
ln -s ../init.d/tomcat_start /etc/rc3.d/S92tomcat
ln -s ../init.d/tomcat_start /etc/rc4.d/S92tomcat
ln -s ../init.d/tomcat_start /etc/rc5.d/S92tomcat

echo "\n----- Start Tomcat 9 ------\n"
/etc/init.d/tomcat_start

#ssh-copy-id tomcat@192.168.3.16
#tar -C target -c target/hello-spring.war | ssh vagrant@192.168.3.16 "sudo tar -x -C /opt/tomcat/webapps"
