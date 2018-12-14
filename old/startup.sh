#!/bin/bash

#NFS_MOUNT_OPTIONS=nfsvers=3,sync,rw,exec
#NFS_SERVER=172.31.7.236
#NFS_SHARE=/nfsshare
#NFS_MOUNTPOINT=/nfs

#### CHECK VARIABLES
if [ -z "$NFS_MOUNT_OPTIONS" ]; then
    echo "ERROR: Variable NFS_MOUNT_OPTIONS is null, aborting!"
    exit 78
fi
if [ -z "$NFS_SERVER" ]; then
    echo "ERROR: Variable NFS_SERVER is null, aborting!"
    exit 78
fi
if [ -z "$NFS_SHARE" ]; then
    echo "ERROR: Variable NFS_SHARE is null, aborting!"
    exit 78
fi
if [ -z "$NFS_MOUNTPOINT" ]; then
    echo "ERROR: Variable NFS_MOUNTPOINT is null, aborting!"
    exit 78
fi
####

echo
echo
echo MOUNTING NFS
echo    The server is $NFS_SERVER
echo    The server exported mount $NFS_SHARE is to be local mount point $NFS_MOUNTPOINT
echo    Mount options are $NFS_MOUNT_OPTIONS
echo    The full mount command to be ran is mount -v -t nfs -o $NFS_MOUNT_OPTIONS $NFS_SERVER:$NFS_SHARE $NFS_MOUNTPOINT
echo
echo    creating mountpoint $NFS_MOUNTPOINT
mkdir $NFS_MOUNTPOINT
echo    Issuing mount command
echo
##### TEMPmount -v -t nfs -o $NFS_MOUNT_OPTIONS $NFS_SERVER:$NFS_SHARE $NFS_MOUNTPOINT
echo
mount | grep nfs
echo FINISHED NFS MOUNT
echo
echo
echo STARTING TRACTOR
echo
# Note exec and $@ ensures a docker stop will pass the signal to tractor
exec /opt/pixar/Tractor-2.2/bin/tractor-blade --log=/var/log/blade.log --verbose -L $PORT0 $@
 
