#!/bin/sh

rm /dev/loop*
rm /dev/ram*
rm /dev/cpu*
rm /dev/kmsg
rm /dev/full
rm /dev/mem
rm /dev/network*
rm /dev/rfkill
rm /dev/ttyp*
rm /dev/ptyp*
rm /dev/tty
nv set mqtt_host=baidu.com
nv set fota_updateMode=0
nv set os_url=http://baidu.com
nv set lpa_trigger_host=baidu.com
nv set safecare_hostname=http://baidu.com
nv set safecare_mobsite=http://baidu.com
rm -rf /bin/iccid_check
rm -rf /bin/terminal_mgmt
rm -rf /sbin/aliyun_thing
rm -rf /sbin/aliyun_mqtt
nv set tc_enable=0
nv set HideSSID=0
nv set old_limitspeed=1024000
nv set dhcpDNS=114.114.114.114
nv set band_select_enable=1
nv set dns_manual_func_enable=1
nv set tr069_func_enable=0
nv set ussd_enable=1
nv set terminal_mgmt_enable=0
nv set nofast_port=
nv set TM_SERVER_NAME=baidu.com
nv set alk_sim_select=0
nv set alk_sim_current=1
nv set sim_switch=1
nv set sim_auto_switch_enable=0
nv set sim_current_type=0
nv set fl_autoswitchsim=0
rm -rf /sbin/yiming_1028.sh
rm -rf /sbin/ip_ratelimit.sh
nv set tw_fota_dm=0
nv set dm_enable=0
nv set aliyunthing_mode=0
nv set v3t_net_limit=0
nv set lock_network_status=unlock
nv set tc_enable=0
nv set fota_request_host=baidu.com
nv set remo_fota_request_host=baidu.com
nv set remo_dm_report_time=114514
nv set remo_dm_request_host=baidu.com
nv set remo_mqtt_request_host=baidu.com
nv set remo_ctiot_enable=0
nv set remo_mqtt_app_enable=0
nv set remo_dm_switch=0
nv set remo_usblan0_status=0
nv set fota_dm_enable=0
nv set remo_dm_main_enable=0
nv set limit_close_wifi=0
nv set remo_flow_mgmt_enable=0
nv set remo_mqtt_enable=0
nv set remo_mqtt_dev_enable=0
nv set remo_fota_se_enable=0
nv set remo_fota_wa=baidu.com
nv set remo_fota_watchdog_enable=0
nv set FOTA_SERVER_URL=baidu.com
nv set need_support_sms=yes
nv set fota_need_user_confirm_update=0
at_server &
at_server &
at_server &
