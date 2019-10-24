ARG UBUNTU_VERSION=${UBUNTU_VERSION}
FROM ubuntu:${UBUNTU_VERSION}

# ensure the mountpoint exists
RUN mkdir -p /mnt/data

# user creation
ARG USER_ID=${USER_ID}
ARG GROUP_ID=${GROUP_ID}
RUN if ! getent group ${GROUP_ID} &> /dev/null; then groupadd -g ${GROUP_ID} development; fi \
 && useradd -u ${USER_ID} -g ${GROUP_ID} -G 100,27 -m -d /home/development -s /bin/bash development \
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

# install development dependencies
RUN apt-get update \
 && apt-get install --no-install-recommends --no-install-suggests -y composer nodejs npm git zip unzip php-zip php-curl \
 && npm update -g npm -v

# install administrative tools
RUN apt-get update \
 && apt-get install --no-install-recommends --no-install-suggests -y sudo lnav htop

# install sshd
RUN apt-get update \
 && apt-get install --no-install-recommends --no-install-suggests -y openssh-server \
 && mkdir -p /var/run/sshd \
 && sed "s@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g" -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
