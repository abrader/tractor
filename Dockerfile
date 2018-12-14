# TRACTOR BLADE CONTAINER BY JOSHB @ MESOSPHERE
# Built using docker build --squash, therefore we don't need to worry about
#   compacting commands to reduce Docker image layer size


# TODO: MAKE TRACTORBASE IMAGE SEPARATE FROM THIS, MAKE RENDERMAN IMAGE FROM IT


FROM centos:7.5.1804

ENV TERM xterm
ENV CONTAINER docker
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

#### INSTALL BASICS THAT EVERYBODY NEEDS
RUN yum install -y \ 
epel-release \ 
yum-tools \
man \
less \
curl \
ca-certificates \
deltarpm \
tcping
RUN yum makecache
####

#### INSTALL UTILITIES JOSH LIKES TO USE
RUN yum install -y \ 
which \
nano \
expect \
wget \
ftp \
jq \
openssh-clients \
net-tools \
traceroute \
iproute \
bind-utils \
unzip \
zip \
git \
autofs \
nfs-utils \
bzip2
####

#### INSTALL WHAT THE VFX REFERENCE PLATFORM (CY2019) PROJECT NEEDS
## PER www.vfxplatform.com
## TODO: Ask pixar if any of this is needed or desired at this stage


# PYTHON 2.7.latest
# Installing first so other packages later will detect it
# Is built with UCS-4
#RUN yum install -y python27 python-pip
#RUN pip install --upgrade pip
#

# GCC 6.3.1
#RUN yum install -y centos-release-scl
#RUN yum install -y devtoolset-6-gcc-6.3.1-3.1.el7
#RUN yum install -y devtoolset-6
#RUN scl enable devtoolset-6 bash
# TODO: Verify with Pixar this is correct, since it includes older gcc
#RUN yum groupinstall -y "Development Tools"
#

# GLIBC 2.17
## already part of centos 7    yum install -y glibc-2.17-222.el7 
#

# QT 5
### doesnt do latest version yum install -y qt5-qtbase
#

# PyQT
# correct version?
#RUN pip install --index-url=https://download.qt.io/official_releases/QtForPython/ pyside2

# PySide
# appears to be installed by PyQt above?
#

# NumPy
#RUN pip install numpy==1.14.6
#

# OpenEXR
# appears to be only source code, how to install?
# http://www.openexr.com/downloads.html

# Ptex
# How to install on centos?
# https://repology.org/metapackage/ptex/packages

# OpenSubdiv
# How to install on centos? Does it need to be compiled?
# http://graphics.pixar.com/opensubdiv/docs/cmake_build.html

# OpenVDB
# Only ver 5 is available
# curl -o /tmp/openvdb.zip -flO http://www.openvdb.org/download/openvdb_5_2_0_library.zip
# cat /tmp/openvdb/INSTALL
#

# Alembic
# http://www.alembic.io/

# FBX
# Where to download from?

# OpenColorIO
# http://opencolorio.org/downloads.html

# ACES
# Where to download from?

# Boost
# Where to download from?

# Intel TBB
# https://www.threadingbuildingblocks.org/

# Intel MKL
# https://software.intel.com/en-us/mkl

# C++ API/SDK C++14
# I assume I'm not to download any package, this is instead to specify 
# how to compile?

#### END OF VFX REFERENCE PLATFORM 


#### JAVA 1.8
# yum install -y java-1.8.0-openjdk-headless
# RUN java -version
## Verify this is the right version
#ENV JAVA_VERSION 8u181
## need to add env vars in app definition such as java_args 
## note, use: java -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap
## https://dzone.com/articles/running-a-jvm-in-a-container-without-getting-kille
#### 


#### SETUP USERS
# Since tractor is in a container, and this is a POC project, we aren't concerned about user account rights
RUN useradd tractor
RUN usermod -a -G wheel tractor
# centos is a default user account for sub processes
RUN useradd centos
RUN usermod -a -G wheel centos
####

#### SUDO
# Doing things like mount commands can require sudo
RUN yum install -y sudo
# A slightly modified sudoers file was made for NFS mounting and such
ADD sudoers /etc/sudoers
# Adds config to avoid the first time sudo lecure when used in a script
ADD privacy /etc/sudoers.d/privacy
####

#### TRACTOR v2.2 (1715407)
ADD Tractor-2.2_1715407-linuxRHEL6_gcc44icc150.x86_64.rpm /tmp
RUN rpm -ivh /tmp/Tractor-2.2_1715407-linuxRHEL6_gcc44icc150.x86_64.rpm
RUN rm /tmp/Tractor-2.2_1715407-linuxRHEL6_gcc44icc150.x86_64.rpm
####

### RENDERMAN v21.6
ADD RenderManProServer-21.6_1803412-linuxRHEL6_gcc44icc150.x86_64.rpm /tmp
RUN rpm -ivh /tmp/RenderManProServer-21.6_1803412-linuxRHEL6_gcc44icc150.x86_64.rpm
####

### RENDERMAN v21.7
ADD RenderManProServer-21.7_1837774-linuxRHEL6_gcc44icc150.x86_64.rpm /tmp
RUN rpm -ivh /tmp/RenderManProServer-21.7_1837774-linuxRHEL6_gcc44icc150.x86_64.rpm
RUN rm /tmp/RenderManProServer-21.7_1837774-linuxRHEL6_gcc44icc150.x86_64.rpm
####

#### THE ENV VARS ARE NOT USED since the container orchestrator will inject the path and RMANTREE
# which allows the same container to be used for multiple tractor versions to demo the usefulness of containers. 
# However in production a container for each version of renderman is likely and we'd need to install the 
# previous versions of maya and katana
#ENV RMANTREE=/opt/pixar/RenderManProServer-21.7
#ENV PATH=$RMANTREE/bin:$PATH
####

#### RENDERMAN FOR MAYA 2018 v21.7
ADD RenderManForMaya-maya2018-21.7_1837774-linuxRHEL6_gcc44icc150.x86_64.rpm /tmp
RUN rpm -ivh /tmp/RenderManForMaya-maya2018-21.7_1837774-linuxRHEL6_gcc44icc150.x86_64.rpm
RUN rm /tmp/RenderManForMaya-maya2018-21.7_1837774-linuxRHEL6_gcc44icc150.x86_64.rpm
# TODO: is this installed correctly? https://rmanwiki.pixar.com/display/RFM/Installation+of+RenderMan+for+Maya
####

#### RENDERMAN FOR KATANA 3.0 v21.7
ADD RenderManForKatana-katana3.0-21.7_1837774-linuxRHEL6_gcc44icc150.x86_64.rpm /tmp
RUN rpm -ivh /tmp/RenderManForKatana-katana3.0-21.7_1837774-linuxRHEL6_gcc44icc150.x86_64.rpm
RUN rm /tmp/RenderManForKatana-katana3.0-21.7_1837774-linuxRHEL6_gcc44icc150.x86_64.rpm
####


#### TEMP, TO REMOVE
# To simplify things for the POC
##RUN chmod -R 777 /opt/pixar
####

#### MISC CLEANUP
# Clear out /tmp's rpm files
RUN rm -rf /tmp/*.rpm
# Clean up yum
# not using while developing this container: RUN yum clean all
# not using while developing this container: RUN rm -rf /var/cache/yum
####
