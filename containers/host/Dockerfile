ARG ARG_UBUNTU_VERSION=${ARG_UBUNTU_VERSION}
FROM ubuntu:${ARG_UBUNTU_VERSION}

# copy specific overwrites from container data
COPY containers/host/data /

# this is the only place we can move over the hosts file
COPY shared/etc/hosts /etc/hosts

# initially copy the shared directory but mount it afterwards
COPY shared /shared

# ensure the data mountpoint exists
RUN mkdir -p /mnt/data

# set up shared content links
RUN /shared/usr/local/bin/shared-content-sync

# user creation
ARG ARG_USER_ID=${ARG_USER_ID}
ARG ARG_GROUP_ID=${ARG_GROUP_ID}
RUN if ! getent group ${ARG_GROUP_ID} &> /dev/null; then groupadd -g ${ARG_GROUP_ID} development; fi \
 && useradd -u ${ARG_USER_ID} -g ${ARG_GROUP_ID} -G 100,27 -m -d /home/development -s /bin/bash development \
 && echo 'development:development' | chpasswd

# completely disable IPv6
RUN echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf \
 && echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf \
 && echo "net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf

# fix debconf breaking
ENV DEBIAN_FRONTEND noninteractive

# install default locale
RUN apt-get update \
 && apt-get install --no-install-recommends --no-install-suggests -y locales \
 && rm -rf /var/lib/apt/lists/* \
 && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

# gitting guud
RUN apt-get update \
 && apt-get install -y git git-lfs git-flow zip gpg

# install administrative tools
RUN apt-get update \
 && apt-get install --no-install-recommends --no-install-suggests -y sudo lnav htop iputils-ping peco nano

# install optional dependencies
ARG ARG_HOST_DEPENDENCIES=${ARG_HOST_DEPENDENCIES}
RUN apt-get update \
 && apt-get install -y ${ARG_HOST_DEPENDENCIES}

# endless loop to keep container alive
CMD ["shared-content-sync", "--loop"]
