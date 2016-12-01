#!/bin/bash

##################################################
##################################################
# 												 #
# 	  Copyright (c) 2016, Nachiket.Namjoshi		 #
# 			 All rights reserved.				 #
# 												 #
# 	BlackReactor Kernel Build Script beta - v0.1 #
# 												 #
##################################################
##################################################

#For Time Calculation
BUILD_START=$(date +"%s")

# Housekeeping
blue='\033[0;34m'
cyan='\033[0;36m'
green='\033[1;32m'
red='\033[0;31m'
nocol='\033[0m'

# 
# Configure following according to your system
# 

# Directories
KERNEL_DIR=$PWD
KERN_IMG=$KERNEL_DIR/arch/arm/boot/Image.gz-dtb
OUT_DIR=$KERNEL_DIR/zipping/onyx
REACTOR_VERSION="alpha-0.1-TEST"

# Device Spceifics
export ARCH=arm
export CROSS_COMPILE="ccache /home/nachiket/Android/android-ndk-r13/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64/bin/aarch64-linux-android-"
export KBUILD_BUILD_USER="nachiket"
export KBUILD_BUILD_HOST="reactor"


########################
## Start Build Script ##
########################

# Remove Last builds
rm -rf $OUT_DIR/*.zip
rm -rf $OUT_DIR/zImage
rm -rf $OUT_DIR/dtb.img

compile_kernel ()
{
echo -e "$green ********************************************************************************************** $nocol"
echo "                    "
echo "                                   Compiling BlackReactor-Kernel                    "
echo "                    "
echo -e "$green ********************************************************************************************** $nocol"
# make clean && make mrproper
make cyanogenmod_oneplus3_defconfig
make -j32
if ! [ -a $KERN_IMG ];
then
echo -e "$red Kernel Compilation failed! Fix the errors! $nocol"
exit 1
fi
zipping
}

zipping() {

# make new zip
cp $KERN_IMG $OUT_DIR/zImage
cd $OUT_DIR
zip -r BlackReactor-oneplus3-$REACTOR_VERSION-$(date +"%Y%m%d")-$(date +"%H%M%S").zip *

}

compile_kernel
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$blue Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"
echo -e "$red zImage size (bytes): $(stat -c%s $KERN_IMG) $nocol"
