## HOWTO SOLVE THIS?
#RUN sysctl -w net.core.somaxconn=1024 ;\
#    sysctl vm.overcommit_memory=1 ;\
#    echo "net.core.somaxconn=1024"  >> /etc/sysctl.conf ;\
#    echo "vm.overcommit_memory=1" >> /etc/sysctl.conf 


# HOW TO SOLVE THIS:.
# RUN sudo -u postgres sh ;\
#    createuser -DRS root ;\  
#    createdb -O root gvmd ;\
#    psql gvmd ;\
#    create role dba with superuser noinherit; ;\
#    grant dba to root; ;\
#    create extension "uuid-ossp"; ;\
#    \q ;\
#    exit 


#RUN mkdir -p /var/run/redis && \
#    wget -q --no-check-certificate \
#    https://svn.wald.intevation.org/svn/openvas/branches/tools-attic/openvas-check-setup \
#      -O /openvas-check-setup && \
#    chmod +x /openvas-check-setup && \
#    sed -i 's/DAEMON_ARGS=""/DAEMON_ARGS="-a 0.0.0.0"/' /etc/init.d/openvas-manager && \
#   sed -i 's/DAEMON_ARGS=""/DAEMON_ARGS="--mlisten 127.0.0.1 -m 9390 --gnutls-priorities=SECURE128:-AES-128-CBC:-CAMELLIA-128-CBC:-VERS-SSL3.0:-VERS-TLS1.0"/' /etc/init.d/openvas-gsa && \
#    sed -i '/^\[ -n "$HTTP_STS_MAX_AGE" \]/a[ -n "$PUBLIC_HOSTNAME" ] && DAEMON_ARGS="$DAEMON_ARGS --allow-header-host=$PUBLIC_HOSTNAME"' /etc/init.d/openvas-gsa && \
#    sed -i 's/PORT_NUMBER=4000/PORT_NUMBER=443/' /etc/default/openvas-gsa && \
#    greenbone-nvt-sync > /dev/null && \
#    greenbone-scapdata-sync > /dev/null && \
#    greenbone-certdata-sync > /dev/null && \
#    BUILD=true /start && \
#   service openvas-scanner stop && \
#    service openvas-manager stop && \
#    service openvas-gsa stop && \
#    service redis-server stop



#RUN wget -q https://github.com/Arachni/arachni/releases/download/v1.5.1/arachni-1.5.1-0.5.12-linux-x86_64.tar.gz && \
#    tar -zxf arachni-1.5.1-0.5.12-linux-x86_64.tar.gz && \
#    mv arachni-1.5.1-0.5.12 /opt/arachni && \
#    ln -s /opt/arachni/bin/* /usr/local/bin/ && \
#    rm -rf arachni*