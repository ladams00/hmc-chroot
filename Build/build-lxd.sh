#!/bin/bash
# build-lxd.sh -- hmc-chroot/Build
#	Script to build yum dependencies under a CentOS6 LXD 
#	container on Ubuntu

RAND1=$RANDOM

echo "Launching container.."
START=$(lxc launch images:centos/6/amd64) && \
CONT=$(echo $START | head -1 | awk '{print $2}')
echo "Container name is $CONT"

cat << EOF > prepincont.${RAND1}.sh
#!/bin/bash
echo "Preparing to build yum dependencies.."
echo "Sleeping for 15 seconds to allow for container networking to settle (DHCP, DNS).."
sleep 15
yum update
yum install -y yum-utils
mkdir -p /var/installroot
rpm --root /var/installroot --initdb
yumdownloader centos-release --destdir=/var/tmp
rpm --root /var/installroot -ivh --nodeps /var/tmp/centos-release*rpm
yumdownloader yum --destdir=/var/tmp --resolve --installroot=/var/installroot
ls -l /var/tmp
EOF

echo "Pushing prepincont.${RAND1}.sh to container ${CONT}.."
lxc file push prepincont.${RAND1}.sh ${CONT}/root/
echo "Cleaning up local copy of prepincont.${RAND1}.sh.."
rm prepincont.${RAND1}.sh
echo "Running prepincont.${RAND1}.sh on container ${CONT}.."
lxc exec ${CONT} -- /bin/bash prepincont.${RAND1}.sh
echo "Retrieving list of yum dependencies"
lxc exec ${CONT} -- ls /var/tmp | tee yum.bundle
echo "Removing ${CONT} forcefully.."
lxc delete --force ${CONT}
