#!/bin/bash
set -e
source /opt/agiros/loong/setup.bash
exec agiros launch /ros2_ws/ros2_launch.py
