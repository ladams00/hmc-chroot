#!/bin/bash
# mkchroot.sh -- hmc-root/mkchroot.sh
#	Script to make chroot on HMC and install yum dependencies

echo "Removing test2 chroot if it exists and re-creating.."
rm -rf /chroot/test2
mkdir -p /chroot/test2/var/lib/rpm
mkdir -p /chroot/test2/tmp
rpm --root /chroot/test2 --initdb
cd /chroot/test2/tmp
echo "Retrieving yum.bundle file.."
curl -O "https://raw.githubusercontent.com/ladams00/hmc-chroot/master/Build/yum.bundle"
echo "Retreiving all yum dependencies.."
while read each; do
	curl -O "${each}"
done < yum.bundle
echo "Installing yum and dependencies.."
rpm --root /chroot/test2 -ivh --nodeps *rpm
