FROM scratch

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
ARG ARG_USER_ID=\${ARG_USER_ID}
ARG ARG_GROUP_ID=\${ARG_GROUP_ID}
RUN if ! getent group \${ARG_GROUP_ID} &> /dev/null; then groupadd -g \${ARG_GROUP_ID} development; fi \\
 && useradd -u \${ARG_USER_ID} -g \${ARG_GROUP_ID} -G 100,27,33 -m -d /home/development -s /bin/bash development \\
 && echo 'development:development' | chpasswd

USER \${ARG_USER_ID}:\${ARG_GROUP_ID}

# endless loop to keep container alive
CMD ["tail", "-f", "/dev/null"]
