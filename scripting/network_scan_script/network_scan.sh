 #! /bin/bash

current_date=$(date +"%d-%m-%Y")
current_time=`date +%d_%b_%Y_%I:%M:%S_%p`

# Output text customization.
bold=$(tput bold) 
red_color='\033[6;31m'
green_color='\033[0;32m' 
no_color='\033[0m' # No Color


script_location=/home/$USER/Desktop/Network_Scan
scan_result=$script_location/result/$current_date

mkdir -p  $scan_result

# Network Devices IP
isp_ip=(114.143.171.5 114.143.171.6) 
server_ip=(192.168.1.220 192.168.1.225 192.168.1.230)
router_device=(`seq -f "192.168.1.%g" 160 164`)
access_device=(`seq -f "192.168.1.%g" 211 215`)
camera_device=(`seq -f "192.168.1.%g" 180 206`)
support_device=(`seq -f "192.168.1.%g" 173 175` 192.168.1.231 192.168.1.232 192.168.1.241)

scan_ip_list=(${isp_ip[*]} ${server_ip[*]} ${router_device[*]} ${access_device[*]} ${camera_device[*]} ${support_device[*]})

# for array result
# for i in ${scan_ip_list[@]}; do echo $i; done

function scan_ip(){
    for ip in ${scan_ip_list[*]} 
    {
        if ping  -c 2 $ip 1>/dev/null 2>/dev/null; then
            echo -e $ip $green_color Device Working $no_color
        else
            echo -e $ip $red_color $bold Alart.. Device Not Working $no_color
            device_unreachable
        fi
# Save the ping output with current date time in log file.
        echo $'\n' "`ping -c 2 $ip | while read pong; do echo "$(date): $pong"; done`" >>  $scan_result/scan_result_"$current_time".txt 
        echo ========================================================================================================= >> $scan_result/scan_result_"$current_time".txt
    }
}

function device_unreachable(){ 
# In the terminal output, retrieve the host name of the host that is not pinging and save the log file info. 
        if  grep -wF $ip  $script_location/hostname.csv;  then
            echo $'\n' "Below Device out of Reach :$ip $current_time" >> $scan_result/device_unreachable_"$current_time".txt
           grep $ip $script_location/hostname.csv >> $scan_result/device_unreachable_"$current_time".txt
        fi
}
scan_ip

