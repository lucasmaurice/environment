#!/bin/bash
#
# This install automatically ROS and workspace for work on SARA
#
# @author:        Lucas Maurice
# @organisation:  Walking Machine
# @date:          29/04/2018

# Prepare ROS installation
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
sudo apt update

# Install ROS and dependencies
sudo apt install -y ros-kinetic-desktop-full
sudo apt install -y python-rosinstall python-rosinstall-generator python-wstool build-essential
sudo apt install -y ros-kinetic-ros-control ros-kinetic-hardware-interface ros-kinetic-moveit
#roscontrol hardwareinterface movit-commander

# Initialise ROS
sudo rosdep init
rosdep update

# Prepare workspace
source /opt/ros/kinetic/setup.bash
mkdir ~/sara_ws/src/ -p
cd ~/sara_ws
catkin_make

# Write sources in bashrc
echo "# FOR ROS" >> ~/.bashrc
echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc
echo "source ~/sara_ws/devel/setup.bash" >> ~/.bashrc

# Write sources in zshrc
echo "# FOR ROS" >> ~/.zshrc
echo "source /opt/ros/kinetic/setup.zsh" >> ~/.zshrc
echo "source ~/sara_ws/devel/setup.zsh" >> ~/.zshrc
