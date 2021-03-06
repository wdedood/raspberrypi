#Install dirmngr
sudo apt-get install dirmngr
#Remove openjdk
sudo apt-get purge openjdk*
#add digital key
sudo apt-key adv --recv-key --keyserver keyserver.ubuntu.com EEA14886

#add java packet source
echo -e 'deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main\n' | sudo tee --append /etc/apt/sources.list
echo -e 'deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main\n' | sudo tee --append /etc/apt/sources.list

#install java 8
sudo apt-get update
#raspberrypi 4
sudo apt install openjdk-8-jdk openjdk-8-jre
#accept license (silent install)
#raspberrypi < 4
#sudo echo 'oracle-java8-installer shared/accepted-oracle-license-v1-1 select true' | sudo /usr/bin/debconf-set-selections
#sudo apt-get install oracle-java8-installer -y
#sudo apt-get install oracle-java8-set-default -y
#remove old Java
sudo apt-get purge openjdk*
sudo apt-get purge java7*
sudo apt-get purge java9*
sudo apt-get autoremove -Y
#check success
java -version

#add unifi packet source
echo 'deb https://www.ui.com/downloads/unifi/debian stable ubiquiti' | sudo tee -a /etc/apt/sources.list.d/ubnt.list > /dev/null
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv C0A52C50
sudo apt-get update
#Install Unifi controller
sudo apt-get install unifi -y

#Adjust memory usage unifi
sudo cp /var/lib/unifi/system.properties /var/lib/unifi/system.properties.backup
sudo echo -e 'unifi.xms=512' | sudo tee -a /var/lib/unifi/system.properties

#Remove default Mongo database
echo 'ENABLE_MONGODB=no' | sudo tee -a /etc/mongodb.conf > /dev/null

#Disable swap file
sudo systemctl disable dphys-swapfile
#Reboot
sleep 5
sudo reboot

#SSL cert (https://kallelilja.com/2017/07/install-pfx-certificate-unifi-controller/)
#find alias
sudo keytool -list -keystore /tmp/certificate.pfx -storetype pkcs12
#move current
sudo mv /var/lib/unifi/keystore /var/lib/unifi/keystore.orig
#install cert
sudo keytool -importkeystore -srckeystore '/home/pi/mappings/nas-download/ster.woutert.net 2017.pfx' -srcstoretype pkcs12 -srcalias te-dd7778a0-603e-45e7-9ae2-abbf0fc33fa9 -destkeystore /var/lib/unifi/keystore -deststoretype jks -destalias unif -deststorepass [aircontrolenterprise] -srcstorepass [xxxxx]
sudo keytool -importkeystore -srckeystore /var/lib/unifi/keystore -destkeystore /var/lib/unifi/keystore -deststoretype pkcs12 -destkeypass aircontrolenterprise


#Check swap file status
#sudo systemctl status dphys-swapfile

#check with
#sudo service unifi status
#browse to http://<your-pi-ip>:8443

#Run script on Pi with
#wget -O - https://raw.githubusercontent.com/wdedood/raspberrypi/master/01-unifi-controller.sh | sudo bash
