#!/bin/bash
#####################################################################################################
# Script_Name : create_new_user.sh
# Description : easily add new user
# Date : Nov. 2023
# written by : Tianyi
# WebSite :
# Version : 1.4.8   
# History : 1.4.8 - Remove Support for Ubuntu 18.04 (End of Standard Support)
#                 - Remove Support for Ubuntu 22.10 (End of Life)
#                 - Adding Support Ubuntu 23.10 
#                 - Fixing versioning package
#                 - Detecting Sound Server in use and perform sound redirection compilation accordingly
# History : 1.4.7 - adding ubuntu 23.04 support 
#         : 0.1   - Initial Script (merging custom & Std)       
# Disclaimer : Script provided AS IS. Use it at your own risk....
#              You can use this script and distribute it as long as credits are kept 
#              in place and unchanged   
####################################################################################################

#---------------------------------------------------#
# Set Script Version                                #
#---------------------------------------------------#

#--Automating Script versioning 
ScriptVer="0.1.0"
xrdp_installer="xrdp-installer_1.4.8.sh"
docker_installer="get-docker.sh"
conda_installer="Miniconda3-latest-Linux-x86_64.sh"
current_user="ubuntu"

yes_flag="y"
no_flag="n"
local_ip=`ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v 172.17.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"`
data_storage="/mnt/sdb"
# echo $local_ip
# do not store password
read -p "user "$current_user" password: " $sudo_password
echo
read -p "Install xrdp?[y/n]: " xrdp_install_flag
echo
read -p "Mount nas?[y/n]: " nas_mount_flag
echo
read -p "Install docker?[y/n]: " docker_install_flag
echo

chmod 777 $data_storage

hostnamectl set-hostname $local_ip

apt install tcl tk expect tmux thefuck -y

# edit .bashrc
cat ./bash_sup.txt >> /home/$current_user/.bashrc
sed -i.bak 's/\(PS1.*\)\(\\h\)/\1\\H/g'  /home/$current_user/.bashrc
source /home/$current_user/.bashrc

cat ./bash_sup.txt >> /etc/skel/.bashrc
sed -i.bak 's/\(PS1.*\)\(\\h\)/\1\\H/g' /etc/skel/.bashrc

unset https_proxy && unset http_proxy
aria2c https://repo.anaconda.com/miniconda/$conda_installer -o ./sub_scripts/$conda_installer
source /home/$current_user/.bashrc

function mount_nas(){
    cd /mnt
    sudo mkdir nas_77
    apt install nfs-kernel-server -y
    mount -t nfs -o rw  10.200.14.77:/lz97-leizhang /mnt/nas_77/
    echo "10.200.14.77:/lz97-leizhang /mnt/nas_77/ nfs defaults 0 0" >> /etc/fstab 
    cd /home/$current_user/ubuntu_new_user_bash
}

function install_xrdp(){
/usr/bin/expect << EOF
    spawn sudo -u $current_user bash ./sub_scripts/$xrdp_installer
        expect {
        "*Please specify which DE you are using...:*" {send "1\r"; exp_continue }
        "*password*" {send "$sudo_password\r"; exp_continue}
        }
    expect eof
EOF
}


if [[ $xrdp_install_flag =~ $yes_flag ]];then
install_xrdp
fi

if [[ $nas_mount_flag =~ $yes_flag ]];then
mount_nas
fi

if [[ $docker_install_flag =~ $yes_flag ]];then
bash ./sub_scripts/$docker_installer
fi