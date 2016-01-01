#!/bin/bash
device=$1;
. build/envsetup.sh
if [ "$device" == "" ];
then
echo "Please specify the device as a parameter";
exit 1;
fi
if [ ! -f "prebuilts/chromium/$device/media/bootanimation.zip" ]; then
mkdir -p ~/orion/prebuilts/chromium/$device/media
cp vendor/orion/config/media/bootanimation.zip prebuilts/chromium/$device/media/bootanimation.zip
fi
if grep -Fxq $device vendor/orion/orion.devices
then
export ORION_RELEASE=true
else
unset ORION_RELEASE
fi
lunch orion_$device-userdebug
make -j$(cat /proc/cpuinfo | grep -c "processor") orion 2>&1 | tee $(date +%Y%m%d)-$device.log
rm -f $OUT/orion_$device-ota*.zip
