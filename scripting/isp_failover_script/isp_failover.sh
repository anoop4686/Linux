#!/bin/bash
current_time=$(date '+%d_%m_%Y_%H:%M:%S')
current_date=$(date '+%d_%m_%Y')

ACTIVE_ISP='isp_1';

declare -A ISP_CONFIGURATION

log_directory_path=/home/$USER/isp_gateway_failover
mkdir -p $log_directory_path

# Log File to write ping log
touch $log_directory_path/$current_date.log

isp_config() {
    isp_uid=$1;
    if [ "$isp_uid" = "isp_1" ]; then
        ISP_CONFIGURATION[gateway_ip]="192.168.10.2" 
        ISP_CONFIGURATION[interface_name]="ens36" 
        ISP_CONFIGURATION[isp_name]="TATA" 
    elif [ "$isp_uid" = "isp_2" ]; then
        ISP_CONFIGURATION[gateway_ip]="192.168.20.2" 
        ISP_CONFIGURATION[interface_name]="ens37" 
        ISP_CONFIGURATION[isp_name]="AIRTEL" 
    elif [ "$isp_uid" = "isp_3" ]; then
        ISP_CONFIGURATION[gateway_ip]="192.168.30.2" 
        ISP_CONFIGURATION[interface_name]="ens38" 
        ISP_CONFIGURATION[isp_name]="SSV" 
    fi
}

ping_isp_gateway(){
    isp_uid=$1;
    isp_config $isp_uid

    ping_result=`ping -c 1 ${ISP_CONFIGURATION[gateway_ip]}`
    echo $ping_result >> $log_directory_path/$current_date.log

    if ping -c 1 ${ISP_CONFIGURATION[gateway_ip]} 1>/dev/null 2>/dev/null; then
        echo "1" 
    else
        echo "0" 
    fi
}

switch_isp_gateway(){
    isp_uid=$1;
    isp_config $isp_uid

    if ! [[ $(ip route  | head -n 1 | grep ${ISP_CONFIGURATION[interface_name]}) ]]; then
      sudo ip route del default
      sudo route add default gw ${ISP_CONFIGURATION[gateway_ip]} dev ${ISP_CONFIGURATION[interface_name]}
      sudo service network-manager restart
    fi
}

send_gateway_unreachable_notification(){
    isp_uid=$1;
    isp_config $isp_uid

    # Log File to write email content
    touch $log_directory_path/$current_time.log

    if ! [[ `cat $log_directory_path/$current_time.log` == *"Project: it-help-desk"* ]]; then
        echo "Project: it-help-desk" >> $log_directory_path/$current_time.log
        echo \ >> $log_directory_path/$current_time.log
        echo "Tracker: Incident" >> $log_directory_path/$current_time.log
        echo \ >> $log_directory_path/$current_time.log
        echo "Priority: Urgent" >> $log_directory_path/$current_time.log
        echo \ >> $log_directory_path/$current_time.log
    fi

    subject="${ISP_CONFIGURATION[isp_name]}: ${ISP_CONFIGURATION[gateway_ip]} is NOT REACHABLE" 
    echo \ >> $log_directory_path/$current_time.log
    echo $subject >> $log_directory_path/$current_time.log
    echo \ >> $log_directory_path/$current_time.log

    mail -s "$subject" "noreply@allerin.com"  -c "network@allerin.com" < $log_directory_path/$current_time.log
}

echo \ >> $log_directory_path/$current_date.log
echo "Current Time: $current_time" >> $log_directory_path/$current_date.log
isp_1_is_active=`ping_isp_gateway 'isp_1'`
isp_2_is_active=`ping_isp_gateway 'isp_2'`
isp_3_is_active=`ping_isp_gateway 'isp_3'`

if [ $isp_1_is_active -eq "1" ]; then
    ACTIVE_ISP='isp_1'
elif [ $isp_2_is_active -eq "1" ]; then
    ACTIVE_ISP='isp_2'
elif [ $isp_3_is_active -eq "1" ]; then
    ACTIVE_ISP='isp_3'
fi

switch_isp_gateway $ACTIVE_ISP

if [ $isp_1_is_active -eq "0" ]; then
    send_gateway_unreachable_notification 'isp_1'
fi

if [ $isp_2_is_active -eq "0" ]; then
    send_gateway_unreachable_notification 'isp_2'
fi

if [ $isp_3_is_active -eq "0" ]; then
    send_gateway_unreachable_notification 'isp_3'
fi

