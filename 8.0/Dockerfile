FROM 226360623493.dkr.ecr.eu-west-1.amazonaws.com/odoo_base

RUN set -x; \
    useradd -ms /bin/bash odoo

RUN set -x; \
    mkdir /opt/nh \
    && chown -R odoo /opt/nh \
    && virtualenv /opt/nh/venv \
    && /opt/nh/venv/bin/pip install https://github.com/bjss/odoo/archive/liveobs_1.10.0.tar.gz

# Copy entrypoint script and Odoo configuration file
COPY ./entrypoint.sh /
COPY ./openerp-server.conf /etc/odoo/server.cfg
RUN chown odoo /etc/odoo/server.cfg

# Mount /var/lib/odoo to allow restoring filestore and /mnt/extra-addons for users addons
RUN mkdir -p /mnt/extra-addons \
        && chown -R odoo /mnt/extra-addons
VOLUME ["/var/lib/odoo", "/mnt/extra-addons"]

RUN chown -R odoo /var/lib/odoo

# Expose Odoo services
EXPOSE 8069 8071

# Set the default config file
ENV OPENERP_SERVER /etc/odoo/server.cfg

# Set default user when running the container
USER odoo

ENTRYPOINT ["/entrypoint.sh"]
CMD ["openerp-server"]
