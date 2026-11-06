#!/bin/bash
set -e
cd "$(dirname "$0")"

# Lùi 2 cấp từ Cloud/Docker để về gốc repo Fuzzilli
FUZZILLI_ROOT="../../"

# Ép build đúng nhánh của iOS 16.7
REV="safari-7615.3.12.110-branch"

echo "[*] Đang copy Patches và fuzzbuild.sh..."
cp -R $FUZZILLI_ROOT/Targets/JavaScriptCore/Patches .
cp $FUZZILLI_ROOT/Targets/JavaScriptCore/fuzzbuild.sh .

echo "[*] Bắt đầu build Docker image với branch: $REV"
docker build --build-arg rev=$REV -t jsc_builder .

mkdir -p out
docker create --name temp_container jsc_builder

echo "[*] Đang tự động tìm file jsc..."
JSC_PATH=$(docker run --rm jsc_builder find /home/builder/webkit -type f -name 'jsc' 2>/dev/null | head -n 1)
if [ -z "$JSC_PATH" ]; then
    echo "LỖI: Không tìm thấy jsc!"
    exit 1
fi

docker cp temp_container:"$JSC_PATH" out/jsc
docker rm temp_container

echo "[*] Dọn dẹp..."
rm -r Patches
rm fuzzbuild.sh
