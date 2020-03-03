FROM ubuntu:19.04
 
COPY conf/openvassd.conf /usr/local/etc/openvas/openvassd.conf
COPY script/entrypoint.sh /entrypoint.sh

ENV DEBIAN_FRONTEND=noninteractive \
    GSE_PASSWORD=admin \
    HOSTNAME=gs \
    SRC_DIR=gse-git \
    SRC_PATH=/root/${SRC_DIR} \
    PGUSERNAME=root


RUN apt-get update ;\
    apt-get install apt-utils software-properties-common --no-install-recommends -yq ;\
    apt-get dist-upgrade -yq ;\
    apt-get install alien \
        cmake \
        pkg-config \
        libglib2.0-dev \
        libgpgme11-dev \
        uuid-dev \
        libssh-gcrypt-dev \
        libhiredis-dev \
        gcc \
        libgnutls28-dev \
        libpcap-dev \
        libgpgme-dev \
        bison \
        libksba-dev \
        libsnmp-dev \
        libgcrypt20-dev \
        redis-server \
        libsqlite3-dev \
        libical-dev \
        gnutls-bin \
        doxygen \
        nmap \
        libmicrohttpd-dev \
        libxml2-dev \
        apt-transport-https \
        sqlfairy \
        xmltoman \
        xsltproc \
        gcc-mingw-w64 \
        perl-base \
        heimdal-dev \
        libpopt-dev \
        graphviz \
        nodejs \
        rpm \
        nsis \
        wget \
        sshpass \
        socat \
        snmp \
        postgresql \
        postgresql-contrib \
        postgresql-server-dev-all \
        libpq-dev \
        git \
        libldap2-dev \
        libfreeradius-dev \
        sudo \
        curl \
        python-polib \
        rsync \
        gettext \
        xmlstarlet \
        zip \
        gnupg \
        -yq ;\
    apt-get install texlive-latex-extra --no-install-recommends -yq ;\
    apt-get install texlive-fonts-recommended -yq

RUN curl --silent --show-error https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - ;\
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list ;\
    apt-get update ;\
    apt-get install yarn -yq ;\
    apt-get clean ;\
    rm -rf /var/lib/apt/lists/*

RUN mkdir ${SRC_PATH} -p ;\
    cd ${SRC_PATH} ;\
    git clone -b gvm-libs-10.0 --single-branch  https://github.com/greenbone/gvm-libs.git ;\
    git clone -b openvas-scanner-6.0 --single-branch https://github.com/greenbone/openvas.git ;\
    git clone -b gvmd-8.0 --single-branch https://github.com/greenbone/gvmd.git ;\
    git clone -b gsa-8.0 --single-branch https://github.com/greenbone/gsa.git ;\
    git clone -b master --single-branch https://github.com/greenbone/openvas-smb.git ;\
    git clone -b ospd-1.3 --single-branch https://github.com/greenbone/ospd.git

RUN  cd ${SRC_PATH}/gvm-libs ;\
    mkdir build ;\
    cd build ;\
    cmake .. ;\
    make ;\
    make doc-full ;\
    make install ;\
    cd ${SRC_PATH}

RUN  cd ${SRC_PATH}/openvas-smb ;\
    mkdir build ;\
    cd build/ ;\
    cmake .. ;\
    make ;\
    make install ;\
    cd ${SRC_PATH}

RUN  cd ${SRC_PATH}/openvas ;\
    mkdir build ;\
    cd build/ ;\
    cmake .. ;\
    make ;\
    make doc-full ;\
    make install ;\
    cd ${SRC_PATH}

COPY conf/redis.config /etc/redis/redis.conf

RUN service redis-server restart

RUN greenbone-nvt-sync 

RUN cd ${SRC_PATH}/gvmd ;\
    mkdir build ;\
    cd build/ ;\
    cmake -DBACKEND=POSTGRESQL .. ;\
    make ;\
    make doc-full ;\
    make install ;\
    cd ${SRC_PATH}

RUN ldconfig

RUN cd ${SRC_PATH}/gsa ;\
    mkdir build ;\
    cd build/ ;\
    cmake .. ;\
    make ;\
    make doc-full ;\
    make install ;\
    cd ${SRC_PATH}

#Install ssmtp, cron and nano as cron default editor
RUN curl --silent --show-error -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - ;\
    apt-get update && apt-get install -y \
    ssmtp \
    nano \
	cron ;\
    apt-get clean

COPY script/update.sh /update.sh
COPY conf/ssmtp.conf /etc/ssmtp/ssmtp.conf

#cron update CERT; SCAP; NVTs database
RUN chmod +x update.sh ;\
    echo "0 12 * * SUN /update.sh > /var/log/cron.log 2>&1" >> /etc/cron.d/gvm-cron ;\
    chmod 0644 /etc/cron.d/gvm-cron ;\
    touch /var/log/cron.log ;\
    crontab /etc/cron.d/gvm-cron

RUN rm  /root/${SRC_PATH}/ -rf

CMD /entrypoint.sh
EXPOSE 80 443 9391
