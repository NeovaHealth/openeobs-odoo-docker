FROM debian:jessie
MAINTAINER Odoo S.A. <info@odoo.com>

# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
RUN set -x; \
        apt-get update \
        && apt-get install -y --no-install-recommends \
            ca-certificates \
            curl \
            node-less \
            node-clean-css \
            python-gevent \
            python-pip \
            python-pyinotify \
            python-renderpm \
            virtualenv \
            python-support \
            libpq-dev \
            gcc \
            python-dev \
            libxml2-dev \
            libxslt1-dev \
            libldap2-dev \
            libsasl2-dev \
        && curl -o wkhtmltox.deb -SL http://nightly.odoo.com/extra/wkhtmltox-0.12.1.2_linux-jessie-amd64.deb \
        && echo '40e8b906de658a2221b15e4e8cd82565a47d7ee8 wkhtmltox.deb' | sha1sum -c - \
        && dpkg --force-depends -i wkhtmltox.deb \
        && apt-get -y install -f --no-install-recommends \
        && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false npm \
        && rm -rf /var/lib/apt/lists/* wkhtmltox.deb \
        && pip install psycogreen==1.0


# Install Odoo
# ENV ODOO_VERSION 8.0
# ENV ODOO_RELEASE 20170207
# RUN set -x; \
#         curl -o odoo.deb -SL http://nightly.odoo.com/${ODOO_VERSION}/nightly/deb/odoo_${ODOO_VERSION}.${ODOO_RELEASE}_all.deb \
#         && echo 'cd8c1dc9d2ddf5a538381eed85871a2e343ec8ae odoo.deb' | sha1sum -c - \
#         && dpkg --force-depends -i odoo.deb \
#         && dpkg -c odoo.deb > /opt/odoo_files.txt \
#         && apt-get update \
#         && apt-get -y install -f --no-install-recommends \
#         && rm -rf /var/lib/apt/lists/* odoo.deb
RUN set -x; \
    mkdir /opt/nh \
    && mkdir /opt/odoo \
    && mkdir /tmp/odoo \
    && virtualenv /opt/nh/venv \
    && curl -o /tmp/odoo.tar.gz -SL https://github.com/bjss/odoo/archive/liveobs_1.10.0.tar.gz \
    && tar -xf /tmp/odoo.tar.gz -C /tmp/odoo \
    && mv /tmp/odoo/odoo-liveobs_1.10.0/* /opt/odoo
#    && source /opt/nh/venv/bin/activate \
RUN /opt/nh/venv/bin/pip install -r /opt/odoo/requirements.txt
RUN /opt/nh/venv/bin/python /opt/odoo/setup.py install

# Copy entrypoint script and Odoo configuration file
COPY ./entrypoint.sh /
COPY ./openerp-server.conf /etc/odoo/server.cfg
RUN chown odoo /etc/odoo/server.cfg

# Mount /var/lib/odoo to allow restoring filestore and /mnt/extra-addons for users addons
RUN mkdir -p /mnt/extra-addons \
        && chown -R odoo /mnt/extra-addons
VOLUME ["/var/lib/odoo", "/mnt/extra-addons"]

# Expose Odoo services
EXPOSE 8069 8071

# Set the default config file
ENV OPENERP_SERVER /etc/odoo/openerp-server.conf

# Set default user when running the container
USER odoo

ENTRYPOINT ["/entrypoint.sh"]
CMD ["openerp-server"]
