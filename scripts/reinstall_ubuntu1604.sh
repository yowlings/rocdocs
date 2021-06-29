#!/usr/bin/env bash
# install must-install softwares
sudo apt install vim ssh htop git tmux tree terminator -y

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
sudo add-apt-repository 'deb https://typora.io/linux ./' -y
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
sudo apt install ros-kinetic-desktop-full  -y


# use cpp code file license header
cd ~/Downloads
wget https://raw.githubusercontent.com/yowlings/robot-tools/master/license-droid.txt
sudo cp license-droid.txt /opt/qtcreator_ros/
sudo apt install python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential -y
sudo apt install python-rosdep -y
sudo echo "151.101.64.133   raw.githubusercontent.com" >> /etc/hosts

sudo rosdep init
rosdep update

# install qt-creator-ros plugin with qtcreator
cd ~/Downloads
wget https://qtcreator-ros.datasys.swri.edu/downloads/installers/xenial/qtcreator-ros-xenial-latest-online-installer.run
chmod +x qtcreator-ros-xenial-latest-online-installer.run 
sudo mkdir /opt/qtcreator_ros
sudo ./qtcreator-ros-xenial-latest-online-installer.run

# install systemback
sudo add-apt-repository "deb http://ppa.launchpad.net/nemh/systemback/ubuntu xenial main" -y
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 382003C2C8B7B4AB813E915B14E4942973C62A1B
sudo apt update
sudo apt install systemback -y

# setup ros .bashrc for ros master and hostname
echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc
echo "export ROS_MASTER_URI=http://localhost:11311" >> ~/.bashrc
echo "export ROS_HOSTNAME=localhost" >> ~/.bashrc


# generate ssh key
cd
ssh-keygen 
cat .ssh/id_rsa.pub 


mkdir -p ~/catkin_ws/src
git clone https://github.com/DroidAITech/ROS-Academy-for-Beginners.git
git clone -b kinetic-devel https://github.com/DroidAITech/xbot.git


sudo sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
wget http://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -
sudo apt-get update
sudo apt-get install gazebo7 -y

cd ~/catkin_ws
rosdep install --from-paths src --ignore-src --rosdistro=kinetic -y
catkin_make
