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

#target hardware - rpi4
CONFLINE="MACHINE = \"raspberrypi4\""
cat conf/local.conf | grep "${CONFLINE}" > /dev/null
local_conf_info=$?

#SSH support
IMAGE_F="IMAGE_FEATURES += \"ssh-server-openssh\""
cat conf/local.conf | grep "${IMAGE_F}" > /dev/null
local_imgf_info=$?

# Add Wifi support
DISTRO_F="DISTRO_FEATURES:append = \"wifi\""
cat conf/local.conf | grep "${DISTRO_F}" > /dev/null
local_distro_info=$?

# Add firmware aupport
IMAGE_ADD="IMAGE_INSTALL:append = \"linux-firmware-rpidistro-bcm43430 v4l-utils python3 ntp wpa-supplicant libgpiod libgpiod-tools libgpiod-dev\""
cat conf/local.conf | grep "${IMAGE_ADD}" > /dev/null
local_imgadd_info=$?

#add support for UART  
MODULE_UART="ENABLE_UART = \"1\""
cat conf/local.conf | grep "${MODULE_UART}" > /dev/null
local_UART_info=$?

#Add support for I2C module
MODULE_I2C="ENABLE_I2C = \"1\""
cat conf/local.conf | grep "${MODULE_I2C}" > /dev/null
local_i2c_info=$?

##############################################
#Add if support is missing in the local.conf file 
if [ $local_conf_info -ne 0 ];then
	echo "Append ${CONFLINE} in the local.conf file"
	echo ${CONFLINE} >> conf/local.conf	
else
	echo "${CONFLINE} already exists in the local.conf file"
fi

if [ $local_distro_info -ne 0 ];then
        echo "Append ${DISTRO_F} in the local.conf file"
        echo ${DISTRO_F} >> conf/local.conf
        
else
        echo "${DISTRO_F} already exists in the local.conf file"
fi

if [ $local_imgadd_info -ne 0 ];then
        echo "Append ${IMAGE_ADD} in the local.conf file"
        echo ${IMAGE_ADD} >> conf/local.conf
        
else
        echo "${IMAGE_ADD} already exists in the local.conf file"
fi

if [ $local_imgf_info -ne 0 ];then
        echo "Append ${IMAGE_F} in the local.conf file"
        echo ${IMAGE_F} >> conf/local.conf
        
else
        echo "${IMAGE_F} already exists in the local.conf file"
fi

if [ $local_coreimadd_info -ne 0 ];then
        echo "Append ${CORE_IM_ADD} in the local.conf file"
        echo ${CORE_IM_ADD} >> conf/local.conf
        
else
        echo "${CORE_IM_ADD} already exists in the local.conf file"
fi



if [ $local_UART_info -ne 0 ];then
        echo "Append ${MODULE_UART} in the local.conf file"
        echo ${MODULE_UART} >> conf/local.conf
else
        echo "${MODULE_UART} already exists in the local.conf file"
fi

if [ $local_i2c_info -ne 0 ];then
        echo "Append ${MODULE_I2C} in the local.conf file"
        echo ${MODULE_I2C} >> conf/local.conf
else
        echo "${MODULE_I2C} already exists in the local.conf file"
fi
##############################################
# Add firmware aupport
IMAGE_ADD="IMAGE_INSTALL:append = \"linux-firmware-rpidistro-bcm43430 v4l-utils python3 ntp wpa-supplicant libgpiod libgpiod-tools libgpiod-dev\""
cat conf/local.conf | grep "${IMAGE_ADD}" > /dev/null
local_imgadd_info=$?

# Add ssh support
IMAGE_F="IMAGE_FEATURES += \"ssh-server-openssh\""
cat conf/local.conf | grep "${IMAGE_F}" > /dev/null
local_imgf_info=$?

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

#adding meta-python layer
bitbake-layers show-layers | grep "meta-python" > /dev/null
layer_info=$?

if [ $layer_info -ne 0 ];then
	echo "Adding meta-python layer"
	bitbake-layers add-layer ../meta-openembedded/meta-python
else
	echo "meta-python layer already exists"
fi

#adding meta-networking layer
bitbake-layers show-layers | grep "meta-networking" > /dev/null
layer_info=$?

if [ $layer_info -ne 0 ];then
	echo "Adding meta-networking layer"
	bitbake-layers add-layer ../meta-openembedded/meta-networking
else
	echo "meta-networking layer already exists"
fi

set -e
bitbake core-image-base
