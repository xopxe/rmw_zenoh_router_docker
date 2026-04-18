#!/bin/bash

echo "Starting zenoh_start.sh"

source /opt/ros/jazzy/setup.bash

#export RUST_LOG=zenoh=info,zenoh_transport=debug
exec ros2 run rmw_zenoh_cpp rmw_zenohd
