#!/usr/bin/env bash
# install must-install softwares
sudo apt install curl zsh vim ssh htop git tmux tree terminator -y
sudo apt install libgflags-dev libgoogle-glog-dev -y

# install oh-my-zsh, may be failed
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
echo "ZSH_THEME='af-magic'" >> ~/.zshrc
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

" >> ~/.zshrc

# install indicator-sysmonitor
sudo add-apt-repository ppa:fossfreedom/indicator-sysmonitor -y
sudo apt-get install indicator-sysmonitor -y

# install chrome
cd ~/Downloads
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb  
sudo dpkg -i google-chrome*
sudo apt-get install -f

# install sublimetext3
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo apt-get install apt-transport-https -y
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update
sudo apt-get install sublime-text -y


# install typora
wget -qO - https://typora.io/linux/public-key.asc | sudo apt-key add -
sudo add-apt-repository 'deb https://typora.io/linux ./'
sudo apt-get update
sudo apt-get install typora -y

# install visual studio code
cd ~/Downloads
wget https://vscode.cdn.azure.cn/stable/5763d909d5f12fe19f215cbfdd29a91c0fa9208a/code_1.45.1-1589445302_amd64.deb
sudo dpkg -i code_1.45.1-1589445302_amd64.deb 

# install ros
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
sudo apt update
sudo apt install ros-melodic-desktop-full -y
mkdir -p ~/catkin_ws/src
sudo apt install python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential -y
sudo apt install python-rosdep
sudo echo "151.101.64.133   raw.githubusercontent.com" >> /etc/hosts
sudo rosdep init
rosdep update
# setup ros .bashrc for ros master and hostname
echo "source /opt/ros/melodic/setup.bash" >> ~/.zshrc
echo "source ~/catkin_ws/devel/setup.bash" >> ~/.zshrc
echo "export ROS_MASTER_URI=http://localhost:11311" >> ~/.zshrc
echo "export ROS_HOSTNAME=localhost" >> ~/.zshrc

# install qt-creator-ros plugin with qtcreator
cd ~/Downloads
wget https://qtcreator-ros.datasys.swri.edu/downloads/installers/bionic/qtcreator-ros-bionic-latest-online-installer.run
chmod +x qtcreator-ros-bionic-latest-online-installer.run 
sudo mkdir /opt/qtcreator_ros
sudo ./qtcreator-ros-bionic-latest-online-installer.run 

# use cpp code file license header
cd ~/Downloads
wget https://raw.githubusercontent.com/yowlings/robot-tools/master/license-droid.txt
sudo cp license-droid.txt /opt/qtcreator_ros/


# install systemback
sudo add-apt-repository "deb http://ppa.launchpad.net/nemh/systemback/ubuntu xenial main" -y
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 382003C2C8B7B4AB813E915B14E4942973C62A1B
sudo apt update
sudo apt install systemback -y


# generate ssh key
cd
ssh-keygen 
cat .ssh/id_rsa.pub 



