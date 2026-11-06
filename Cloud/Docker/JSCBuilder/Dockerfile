FROM swift:nightly-noble

ENV DEBIAN_FRONTEND=noninteractive
ENV SHELL=bash

RUN apt-get update && apt-get install -y git cmake ninja-build clang ruby python3-dev libicu-dev
RUN apt-get reinstall -y libicu-dev
RUN useradd -m builder

# CLONE ĐÚNG BRANCH 7615
RUN git clone --branch safari-7615.3.12.110-branch --depth 1 https://github.com/WebKit/WebKit.git /home/builder/webkit
WORKDIR /home/builder/webkit

# Bỏ qua checkout vì đã clone đúng branch rồi
# (Xóa hoặc comment dòng ARG rev và git checkout)

ADD Patches Patches
RUN for i in `ls Patches`; do patch -p1 < Patches/$i; done
ADD fuzzbuild.sh fuzzbuild.sh
RUN ./fuzzbuild.sh
