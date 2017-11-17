#!/usr/bin/env bash
source ./kde-push.cfg

#Global Variables.
#Uname - Print certain system information.
UnameKernelName=`uname --kernel-name`
UnameNode=`uname --nodename`
UnameKernelRelease=`uname --kernel-release`
UnameKernelVersion=`uname --kernel-version`
UnameMachine=`uname --machine`
UnameProcessor=`uname --processor`
UnameHardware=`uname --hardware-platform`
UnameOS=`uname --operating-system`
KDEVersion=`kded5 --version`

#Date & Time
DATE=`date`

#Execute an command that has been defined in a string.
function execute_string {
    eval $1
}

#Push encrypted message with Simple Push
function push_encrypted {
    sh ${send_encrypted_folder}/send-encrypted.sh -k ${id} -p ${password} -s ${salt} -t "$1" -m "$2" -e ${3}
}

function daily_rapport {

    #Prepare Report
    UpSince="${UnameNode} has Booted On "
    UpSince+=`uptime -s`
    UpTime="${UnameNode} is "
    UpTime+=`uptime -p`
    Users=`who -u`
    Upgrade=`apt-get -s upgrade`

    push_encrypted "Captain's Log - ${DATE}" "${UpSince}\n${UpTime}\n\nUsers logged in :\n${Users}\n\n${KDEVersion} ${UnameOS} ${UnameProcessor}\n${UnameKernelRelease}\n\n${Upgrade}"  "Captain's Log"
}

# Get CPU Core temperature
function temperature {
    if [[ ${check_temperature} == true ]]
    then
        #Get CPU Temperature
        TEMPERATURE=$(sensors | grep 'Package id 0')
        #Substring only on the temperature
        TEMPERATURE=${TEMPERATURE:16:2}
        #Remove all white spaces from string
        TEMPERATURE=${TEMPERATURE//[[:blank:]]/}
        #Send notification
        if (( ${TEMPERATURE} >= 80 ))
        then
            push_encrypted "CPU Temperature" "The current temperature of your CPU is ${TEMPERATURE}"  "Test"
        fi
    fi
}
# Execute all commands
temperature
daily_rapport