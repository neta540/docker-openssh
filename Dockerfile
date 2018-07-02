FROM alpine:3.7
LABEL maintainer="neta540@gmail.com"
RUN apk add --no-cache --virtual build-dependencies \ 
        g++ \ 
        zlib-dev \
        libressl-dev \
        make \
        automake \
        autoconf \
        git && \
    git clone https://github.com/openssh/openssh-portable/ && \
    cd openssh-portable && \
    autoreconf configure.ac && \ 
    ./configure \ 
        --sysconfdir=/etc/ssh \
        --prefix=/usr \
        --sysconfdir=/etc/ssh \
        --libexecdir=/usr/lib/ssh \
        --mandir=/usr/share/man \
        --with-pid-dir=/run \
        --with-mantype=doc \
        --disable-lastlog \
        --disable-strip \
        --disable-wtmp \
        --with-privsep-path=/var/empty \
        --with-xauth=/usr/bin/xauth \
        --with-privsep-user=sshd \
        --with-md5-passwords \
        --with-ssl-engine && \
    make && \
    make install && \
    apk del build-dependencies && \
    rm /etc/ssh/ssh_host_* && cd .. && rm -rf openssh-portable
CMD [ "/usr/sbin/sshd", "-D" ]
