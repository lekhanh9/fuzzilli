#!/bin/bash

set -e

cd $(dirname $0)
FUZZILLI_ROOT=../../..

# Setup build context
REV=$(cat $FUZZILLI_ROOT/Targets/JavaScriptCore/REVISION)
cp -R $FUZZILLI_ROOT/Targets/JavaScriptCore/Patches .
cp $FUZZILLI_ROOT/Targets/JavaScriptCore/fuzzbuild.sh .

# Fetch the source code, apply patches, and compile the engine
docker build --build-arg rev=$REV -t jsc_builder .

# Copy build products
mkdir -p out
docker create --name temp_container jsc_builder

# --- FIX: Tự động dò tìm đường dẫn thực tế của file jsc ---
echo "Đang tìm file jsc trong container..."
JSC_PATH=$(docker run --rm jsc_builder find / -type f -name 'jsc' 2>/dev/null | grep -E 'WebKitBuild|Fuzzilli' | head -n 1)
if [ -z "$JSC_PATH" ]; then
    JSC_PATH=$(docker run --rm jsc_builder find / -type f -name 'jsc' 2>/dev/null | head -n 1)
fi

if [ -z "$JSC_PATH" ]; then
    echo "LỖI: Không tìm thấy file jsc trong container!"
    exit 1
fi

echo "Tìm thấy jsc tại: $JSC_PATH"
docker cp temp_container:"$JSC_PATH" out/jsc
# --------------------------------------------------------

docker rm temp_container

# Clean up
rm -r Patches
rm fuzzbuild.sh
