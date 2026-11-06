FROM swift:nightly-noble

ENV DEBIAN_FRONTEND=noninteractive
ENV SHELL=bash

RUN apt-get update && apt-get install -y git cmake ninja-build clang ruby python3-dev libicu-dev
RUN apt-get reinstall -y libicu-dev
RUN useradd -m builder

# KÉO ĐÚNG NHÁNH 7615 (Chỉ lấy depth=1 cho nhanh)
RUN git clone --branch safari-7615.3.12.110-branch --depth 1 https://github.com/WebKit/WebKit.git /home/builder/webkit
WORKDIR /home/builder/webkit

# Đã clone đúng nhánh rồi, không cần checkout theo ARG nữa
ADD Patches Patches
RUN for i in `ls Patches`; do patch -p1 < Patches/$i; done
ADD fuzzbuild.sh fuzzbuild.sh
RUN ./fuzzbuild.sh
# (Giữ nguyên phần ADD Patches và fuzzbuild.sh bên dưới như file cũ của mày nhé)
