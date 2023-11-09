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

