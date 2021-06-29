#!/usr/bin/env bash
# install must-install softwares
apt update
apt install curl zsh net-tools lsb-core inetutils-ping vim ssh htop git tmux tree -y

# install oh-my-zsh, may be failed
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
mv zshrc /root/.zshrc

# install ros
sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
apt update
apt install ros-melodic-ros-base -y
# sudo rosdep init
# rosdep update
echo "ZSH_THEME='af-magic'" >> /root/.zshrc
echo "
# User configuration
# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
## git commands
alias gc='git clone'
alias gr='git reset --hard'
alias gs='git status'
alias gb='git branch'
alias gl='git log'

## tar 
alias tx='tar -xzvf'
alias tc='tar -cvzf'
## ssh
### wp server in 192.168.8.18
alias sz='ssh -oPort=7002 zdwp@39.105.40.54'
### wp server in 192.168.9.19
alias sw='ssh -oPort=7001 wp@39.105.40.54'
### roc thinkpad
alias sr='ssh -oPort=7003 roc@39.105.40.54'
### droid aliyun server
alias szd='ssh root@droid'
### server robot of all firefly
alias sx='ssh firefly@10.0.1.1'
" >> /root/.zshrc
# setup ros .zshrc for ros master and hostname
echo "source /opt/ros/melodic/setup.zsh" >> /root/.zshrc
echo "export ROS_MASTER_URI=http://localhost:11311" >> /root/.zshrc
echo "export ROS_HOSTNAME=localhost" >> /root/.zshrc

# generate ssh key
cd
ssh-keygen 
cat .ssh/id_rsa.pub 



