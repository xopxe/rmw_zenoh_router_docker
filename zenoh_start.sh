#!/bin/bash

echo "Starting zenoh_start.sh"

source /opt/ros/jazzy/setup.bash

exec ros2 run rmw_zenoh_cpp rmw_zenohd
