#!/bin/bash
# build.sh -- hmc-chroot/Build
#	Script to build yum dependencies under a CentOS6 LXD 
#	container on Ubuntu


START=$(lxc launch images:centos/6/amd64) && CONT=$(echo $START | head -1 | awk '{print $2}'); echo "Container name is $CONT"
