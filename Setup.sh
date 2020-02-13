username=$(whoami)
sudo apt-get install python python-pip python-dev libffi-dev libssl-dev -y
sudo apt-get install python-virtualenv python-setuptools -y
sudo apt-get install libjpeg-dev zlib1g-dev swig -y
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 68818C72E52529D4
sudo echo "deb http://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org
sudo systemctl start mongod
sudo systemctl enable mongod
sudo apt-get install postgresql libpq-dev -y
sudo apt-get install qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils python-libvirt -y
sudo pip install XenAPI
sudo apt-get install tcpdump -y
sudo groupadd pcap
sudo usermod -a -G pcap cuckoo
sudo chgrp pcap /usr/sbin/tcpdump
sudo setcap cap_net_raw,cap_net_admin=eip /usr/sbin/tcpdump
sudo apt-get install libcap2-bin -y
sudo apt-get install swig -y
sudo pip install m2crypto==0.24.0
sudo apt install libguac-client-rdp0 libguac-client-vnc0 libguac-client-ssh0 guacd -y
clear
sudo adduser cuckoo
sudo usermod -a -G vboxusers cuckoo
sudo usermod -a -G libvirtd cuckoo
cd
sudo pip install -U pip setuptools
sudo pip install -U cuckoo
cuckoo -d
cd
cd .cuckoo/conf/
sed -i 's/ignore_vulnerabilities = no/ignore_vulnerabilities = yes/' /home/$username/.cuckoo/conf/cuckoo.conf
echo IP of Host Machine: 
read host_ip
echo "IP of Virtual Machine (HIGHLY RECOMMEND TO SET STATIC ADDRESS): "
read vm_ip
echo 'What network Interface do you want to use?'
read net_int
echo 'Enter exact path to VMX File '
read vmx_path
echo 'What is your Virtual Machines Snapshot Name?'
read snap_name
echo 'What platform is the VM? (windows, linux) '
read platform
PS3='What Virtualization software are you using? '
options=("VMWare" "Virtualbox")
select opt in "${options[@]}"
do
	case $opt in
		"VMWare")
			sed -i "/machinery = /c\machinery = vmware" /home/$username/.cuckoo/conf/cuckoo.conf
			sed -i "/ip = /c\ip = ${host_ip}" /home/$username/.cuckoo/conf/cuckoo.conf  
			sed -i "/interface = /c\interface = ${net_int}" /home/$username/.cuckoo/conf/vmware.conf
			sed -i "/vmx_path = /c\vmx_path = ${vmx_path}" /home/$username/.cuckoo/conf/vmware.conf
			sed -i "/snapshot = /c\snapshot = ${snap_name}" /home/$username/.cuckoo/conf/vmware.conf
			sed -i "/platform = /c\platform = ${platform}" /home/$username/.cuckoo/conf/vmware.conf
			sed -i "/ip = /c\ip = ${vm_ip}" /home/$username/.cuckoo/conf/vmware.conf
			break
			;;
		"Virtualbox")
			sed -i "/machinery = /c\machinery = virtualbox" /home/$username/.cuckoo/conf/cuckoo.conf
			sed -i "/ip = /c\ip = ${host_ip}" /home/$username/.cuckoo/conf/cuckoo.conf 
			sed -i "/mode = /c\mode = gui" /home/$username/.cuckoo/conf/virtualbox.conf
			sed -i "/interface = /c\interface = ${net_int}" /home/$username/.cuckoo/conf/virtualbox.conf
                        sed -i "/vmx_path = /c\vmx_path = ${vmx_path}" /home/$username/.cuckoo/conf/virtualbox.conf
                        sed -i "/snapshot = /c\snapshot = ${snap_name}" /home/$username/.cuckoo/conf/virtualbox.conf
                        sed -i "/platform = /c\platform = ${platform}" /home/$username/.cuckoo/conf/virtualbox.conf
                        sed -i "/ip = /c\ip = ${vm_ip}" /home/$username/.cuckoo/conf/virtualbox.conf
			break
			;;
		*) echo "INVALID OPTION";;
	esac
done
clear
echo '<<< DONE >>>'
