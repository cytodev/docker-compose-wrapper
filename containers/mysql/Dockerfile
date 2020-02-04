ARG ARG_MYSQL_VERSION=${ARG_MYSQL_VERSION}
FROM mysql:${ARG_MYSQL_VERSION}

# copy everything from data to container root
COPY data /

# user creation
ARG ARG_USER_ID=${ARG_USER_ID}
ARG ARG_GROUP_ID=${ARG_GROUP_ID}
RUN if ! getent group ${ARG_GROUP_ID} &> /dev/null; then groupadd -g ${ARG_GROUP_ID} development; fi \
 && useradd -u ${ARG_USER_ID} -g ${ARG_GROUP_ID} -G 100,27,33 -m -d /home/development -s /bin/bash development \
 && echo 'development:development' | chpasswd
