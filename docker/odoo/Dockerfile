FROM 226360623493.dkr.ecr.eu-west-1.amazonaws.com/odoo_base

RUN set -x; \
    useradd -ms /bin/bash odoo \
    && mkdir -p /opt/nh /opt/odoo /tmp/odoo /var/lib/odoo \
    && chown -R odoo /opt/nh /var/lib/odoo \
    && virtualenv /opt/nh/venv --system-site-packages \
    && curl -o /tmp/odoo.tar.gz -SL https://github.com/bjss/odoo/archive/liveobs_1.10.0.tar.gz \
    && tar -xf /tmp/odoo.tar.gz -C /tmp/odoo \
    && mv /tmp/odoo/odoo-liveobs_1.10.0/* /opt/odoo \
    && cd /opt/odoo/ \
    && /opt/nh/venv/bin/pip install -r requirements.txt \
    && /opt/nh/venv/bin/python setup.py install

# Copy entrypoint script and Odoo configuration file
COPY ./entrypoint.sh /
COPY ./openerp-server.conf /etc/odoo/server.cfg
RUN chown odoo /etc/odoo/server.cfg

# Mount /var/lib/odoo to allow restoring filestore and /mnt/extra-addons for users addons
# RUN mkdir -p /mnt/extra-addons \
#         && chown -R odoo /mnt/extra-addons
# VOLUME ["/var/lib/odoo", "/mnt/extra-addons"]

# Expose Odoo services
EXPOSE 8069 8071

# Set the default config file
ENV OPENERP_SERVER /etc/odoo/server.cfg

# Set default user when running the container
USER odoo

ENTRYPOINT ["/entrypoint.sh"]
CMD ["openerp-server"]
