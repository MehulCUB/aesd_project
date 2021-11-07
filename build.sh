#!/bin/bash
# Script to build image for qemu.
# Author: Siddhant Jajoo.
# Modified : Mehul Patel
# reference: https://github.com/cu-ecen-aeld/yocto-assignments-base/wiki/Build-basic-YOCTO-image-for-RaspberryPi
git submodule init
git submodule sync
git submodule update

# local.conf won't exist until this step on first execution
source poky/oe-init-build-env

#target hardware
CONFLINE="MACHINE = \"raspberrypi3\""

#SSH support
cat conf/local.conf | grep "${CONFLINE}" > /dev/null
local_conf_info=$?

#Add if support is missing in the local.conf file 
if [ $local_conf_info -ne 0 ];then
	echo "Append ${CONFLINE} in the local.conf file"
	echo ${CONFLINE} >> conf/local.conf	
else
	echo "${CONFLINE} already exists in the local.conf file"
fi

#bitbake meta layers 

#meta-openembedded layer
bitbake-layers show-layers | grep "meta-oe" > /dev/null
layer_info=$?

if [ $layer_info -ne 0 ];then
	echo "Adding meta-oe layer"
	bitbake-layers add-layer ../meta-openembedded/meta-oe
else
	echo "meta-oe layer already exists"
fi

#meta-raspberrypi layer
bitbake-layers show-layers | grep "meta-raspberrypi" > /dev/null
layer_info=$?

if [ $layer_info -ne 0 ];then
	echo "Adding meta-raspberrypi layer"
	bitbake-layers add-layer ../meta-raspberrypi
else
	echo "meta-raspberrypi layer already exists"
fi


set -e
bitbake core-image-base
