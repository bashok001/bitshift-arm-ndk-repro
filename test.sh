#!/bin/bash
set -e

if [[ -z "${ANDROID_NDK}" ]]; then
    echo "ANDROID NDK PATH IS NOT SET"
    exit -1
fi

TEST_PATH=/data/local/tmp/att

echo "Waiting to connect to a device"
adb wait-for-device

${ANDROID_NDK}/ndk-build -B -j8 &> /dev/null
adb shell rm -rf $TEST_PATH
adb shell mkdir -p $TEST_PATH
adb push libs/armeabi/* $TEST_PATH

echo "============= Results with optimizations ==============="
adb shell "LD_LIBRARY_PATH=$TEST_PATH $TEST_PATH/native-lib $@"
echo "========================================================"





echo "*******************************************************************"
echo "Changing Release to Debug to turn off optimizations."
echo "*******************************************************************"

mv jni/Application.mk jni/Application.backup.mk
mv jni/Application.debug.mk jni/Application.mk
${ANDROID_NDK}/ndk-build -B -j8 &> /dev/null
adb shell rm -rf $TEST_PATH
adb shell mkdir -p $TEST_PATH
adb push libs/armeabi/* $TEST_PATH

echo "============= Results without optimizations ============"
adb shell "LD_LIBRARY_PATH=$TEST_PATH $TEST_PATH/native-lib $@"
echo "========================================================"







echo "Switching back to original states & Clean up"
mv jni/Application.mk jni/Application.debug.mk
mv jni/Application.backup.mk jni/Application.mk
rm -rf obj libs