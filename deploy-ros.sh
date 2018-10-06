#!/bin/bash
#
# This install automatically ROS (kinetic) and workspace for work on SARA
#
# @author:        Lucas Maurice
# @organisation:  Walking Machine
# @date:          14/06/2018

# Prepare ROS installation
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
sudo apt update

# Install ROS and dependencies
sudo apt install -y ros-kinetic-desktop-full
sudo apt install -y python-rosinstall python-rosinstall-generator python-wstool build-essential
sudo apt install -y ros-kinetic-ros-control ros-kinetic-hardware-interface ros-kinetic-moveit ros-kinetic-navigation
sudo apt install -y ffmpeg
sudo apt install -y python-imaging python-imaging-tk python-pip
pip install --upgrade pip
pip install Pillow
python -m pip install --user --upgrade pip
python -m pip install Pillow

# Initialise ROS
sudo rosdep init
rosdep update

# Prepare workspace
source /opt/ros/kinetic/setup.bash
mkdir ~/sara_ws/src/ -p
cd ~/sara_ws/src

# Get wm main repositories
git clone git@github.com:WalkingMachine/sara_msgs.git
git clone git@github.com:WalkingMachine/sara_launch.git
git clone git@github.com:WalkingMachine/sara_behaviors.git
git clone git@github.com:WalkingMachine/wonderland.git
git clone git@github.com:WalkingMachine/wm_object_detection.git
git clone git@github.com:team-vigir/flexbe_behavior_engine.git

# Install Wonderland
cd ~/sara_ws/src/wonderland
./install.sh

# Install Behavior
cd ~/sara_ws/src/sara_behaviors
./install.sh

# Build workspace
cd ~/sara_ws
catkin_make

# Source workspace
source ~/sara_ws/src/sara_launch/sh_files/sararc.sh

# Write sources in bashrc
if !(grep --quiet "# FOR ROS" ~/.bashrc); then
    echo Deploy Source to .bashrc
    echo "# FOR ROS" >> ~/.bashrc
    echo "source ~/sara_ws/src/sara_launch/sh_files/sararc.sh" >> ~/.bashrc
fi

# Write sources in zshrc
if !(grep --quiet "# FOR ROS" ~/.zshrc); then
    echo Deploy Source to .zshrc
    echo "# FOR ROS" >> ~/.zshrc
    echo "source ~/sara_ws/src/sara_launch/sh_files/sararc.sh" >> ~/.zshrc
fi
