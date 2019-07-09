#!/bin/bash -xe
echo "Updating existing packages"
sudo yum update -y

echo "Installing wget"
sudo yum install wget -y

echo "Installing OpenJDK 11"
sudo yum install java-11-openjdk-devel -y

echo "Installing Ruby"
sudo yum install ruby -y

echo "Setting up Amazon Time Sync Service"
sudo sed -i '6 a server 169.254.169.123 prefer iburst minpoll 4 maxpoll 4' /etc/chrony.conf
sudo systemctl reload-or-restart chronyd
chronyc sources -v

echo "Installing Apache Tomcat 9.0"
sudo groupadd tomcat
sudo useradd -M -s /bin/false -g tomcat -d /opt/tomcat/ tomcat
cd /tmp
sudo wget http://www-us.apache.org/dist/tomcat/tomcat-9/v9.0.21/bin/apache-tomcat-9.0.21.tar.gz
sudo mkdir /opt/tomcat
sudo tar -xvf apache-tomcat-9.0.21.tar.gz -C /opt/tomcat --strip-components=1
sleep 5
cd /opt/tomcat
pwd
sudo chgrp -R tomcat /opt/tomcat
pwd
ls -la
sudo chmod -R g+r conf
sudo chmod -R g+x conf
sudo chown -R tomcat webapps/ work/ temp/ logs/
#sudo sh -c 'chmod +x /opt/tomcat/latest/bin/*.sh'
sudo cd /usr/lib/systemd/system
sudo sh -c "echo $'# Systemd unit file for tomcat
[Unit]
Description=Apache Tomcat Web Application Container
After=syslog.target network.target
[Service]
Type=forking
Environment=JAVA_HOME=/usr/lib/jvm/java
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat
Environment=\'CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC\'
Environment=\'JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom\'
ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/bin/kill -15 $MAINPID
User=tomcat
Group=tomcat
UMask=0007
RestartSec=10
Restart=always
[Install]
WantedBy=multi-user.target' > /etc/systemd/system/tomcat.service"
sleep 5
sudo systemctl daemon-reload
sudo systemctl enable tomcat.service
sudo systemctl start tomcat.service

echo "Installing CodeDeploy Agent"
cd /tmp
pwd
ls -la
sudo wget "https://aws-codedeploy-$aws_region_id.s3.$aws_region_id.amazonaws.com/latest/install"
sudo chmod +x ./install
sudo ./install auto
sudo service codedeploy-agent start
sudo service codedeploy-agent status
