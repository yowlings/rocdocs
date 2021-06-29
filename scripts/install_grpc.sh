#!/usr/bin/env bash
# 更换cmake版本至3.15以上,grpc要求
cd ~/Downloads
wget https://cmake.org/files/v3.18/cmake-3.18.0-rc1-Linux-x86_64.tar.gz
tar -xzvf cmake-3.18.0-rc1-Linux-x86_64.tar.gz
sudo mv cmake-3.18.0-rc1-Linux-x86_64/ /opt/cmake-3.18.0
sudo ln -sf /opt/cmake-3.18.0/bin/* /usr/bin/

# 编译安装grpc
git clone https://github.com/grpc/grpc.git
cd grpc
git submodule update --init
mkdir build
cd build
cmake ..
make -j4
sudo make install
# 编译cpp测试样例测试是否安装成功
cd ../examples/cpp/helloworld/
mkdir build
cd build
cmake ..
make -j4