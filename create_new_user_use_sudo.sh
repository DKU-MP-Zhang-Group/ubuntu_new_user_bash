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

#---------------------------------------------------#
# Script Version information Displayed              #
#---------------------------------------------------#

# echo "The script name is $0"
# echo "The number of arguments is $#"
# echo "The arguments are [$@]"
# echo "The return value of the last command is $?"

password="123456"
local_ip=`ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v 172.17.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"`
data_storage="/mnt/sdb"
conda_installer="Miniconda3-latest-Linux-x86_64.sh"
nas_77_user_group="nas_77_user"
yes_flag="y"
echo "${local_ip}"
for username in $@
do
	if [ -n $username ]
	then
    read -p "user "$username" is a nas_77(Prof. Lei Zhang's group) user?[y/n]" nas_77_flag
    echo
/usr/bin/expect << EOF
    spawn adduser $username --force-badname
    expect "*New password*" {send "$password\r"}
    expect "*Retype new password*" {send "$password\r"}
    expect "*Full Name*" {send "$username\r"}
    expect "*Room Number*" {send "\r"}
    expect "*Work Phone*" {send "\r"}
    expect "*Home Phone*" {send "\r"}
    expect "*Other*" {send "\n"}
    expect "*Is the information correct?*" { send "Y\r"}
    expect eof
EOF
    # if [[ $nas_mount_flag =~ $yes_flag ]];then
    if [[ $nas_77_flag =~ $yes_flag ]];then
    sudo usermod -aG $nas_77_user_group $username
    fi
    
    sudo usermod -aG docker $username
/usr/bin/expect << EOF
    spawn sudo su
    expect -re "\](\$|#)"
    send "cp -r ./sub_scripts/ /home/$username\r"
    send "exit\r"
    expect eof
EOF
/usr/bin/expect << EOF
    spawn ssh $username@$local_ip
    
    expect {
        "*yes/no*" {send "yes\r"; exp_continue }
        "*password*" {send "$password\n\r"}
    } 
    expect -re "\](\$|#)"
    send "mkdir -p ws\r"
    send "mkdir -p ~/miniconda3\r"
    send "cd sub_scripts\r"

    send "bash $conda_installer -b -u -p ~/miniconda3\r"
    # send "\n\r"
    # expect "*Do you accept the license terms?*" {send "yes\r"}
    # expect "*Miniconda3 will now be installed into this location:*" {send "\n\r"}
    # expect "*Do you wish to update your shell profile to automatically initialize conda?*" {send "yes\r"}
    send "~/miniconda3/bin/conda init bash\r"
    send "source ~/.bashrc\r"
    send "exit\r"
    expect eof
EOF
    mkdir $data_storage/$username
    sudo chgrp $username $data_storage/$username
    chage -d 0 $username
	else
		echo "The username is null!"
	fi
    echo Done.
done
