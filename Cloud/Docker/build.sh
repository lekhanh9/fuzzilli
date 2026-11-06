#!/bin/bash
set -e
cd $(dirname $0)
FUZZILLI_ROOT=../../..

# KHÔNG ĐỌC REVISION NỮA, MÀ DÙNG BRANCH NAME
REV="safari-7615.3.12.110-branch"

cp -R $FUZZILLI_ROOT/Targets/JavaScriptCore/Patches .
cp $FUZZILLI_ROOT/Targets/JavaScriptCore/fuzzbuild.sh .

docker build --build-arg rev=$REV -t jsc_builder .

mkdir -p out
docker create --name temp_container jsc_builder

# Tìm file jsc tự động
JSC_PATH=$(docker run --rm jsc_builder find /home/builder/webkit -type f -name 'jsc' 2>/dev/null | head -n 1)
if [ -z "$JSC_PATH" ]; then
    echo "LỖI: Không tìm thấy jsc!"
    exit 1
fi

docker cp temp_container:"$JSC_PATH" out/jsc
docker rm temp_container
rm -r Patches
rm fuzzbuild.sh
