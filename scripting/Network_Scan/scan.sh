#! /bin/bash

current_date=$(date +"%d-%m-%Y")
current_time=`date +%d_%b_%Y_%I:%M:%S_%p`
scan_folder=/home/$USER/network_scan_result/$current_date
script_location=/home/$USER/Desktop/Network_Scan

bold=$(tput bold) 
red_color='\033[6;31m'
green_color='\033[0;32m' 
no_color='\033[0m' # No Color
mkdir -p  $scan_folder
touch $scan_folder/device_unreachable_"$current_time".txt

# Network IP start from 192.168.1.26 to 192.168.1.255
isp_ip=(114.143.171.5 114.143.171.6)
host_ip=(${isp_ip[*]} `seq -f "192.168.1.%g" 1 255`)

# for array result
# for i in ${host_ip[@]}; do echo $i; done

scan_ip(){
    for ip in ${host_ip[*]} 
    {
        ping_result=`ping -c 2 $ip`
        echo $'\n' "$ping_result" >> $scan_folder/scan_result.txt
        echo "==========================================================" >> $scan_folder/scan_result.txt

        if ping -c 2 $ip 1>/dev/null 2>/dev/null; then
            echo -e $ip $green_color Device Working $no_color
        else
            echo -e $ip $red_color $bold Alart.. Device Not Working $no_color
#            device_unreachable
        fi
    }
}

# # This function stores the information whose host is not ping.
device_unreachable(){ 
        if  grep -wF $ip $script_location/hostname.csv; then
            echo $'\n' "Below Device out of Reach :$ip $current_time" >> $scan_folder/device_unreachable_"$current_time".txt
            grep $ip $script_location/hostname.csv >> $scan_folder/device_unreachable_"$current_time".txt
        fi
}
scan_ip


##########################################################END##########################################################
# send_notification(){
# Below code written. If the file is having device unreachble list then  send mail.
#     if (( `stat -c%s "$scan_folder/system_down_list.txt"` > 10 )); then
#          mail -s "Network devices are out of reach. `date`"  < $scan_folder/system_down_list.txt    
#     fi
# }
# send_notification
