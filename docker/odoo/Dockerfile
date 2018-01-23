FROM 298801546701.dkr.ecr.eu-west-1.amazonaws.com/odoo_base

RUN set -x; \
    useradd -ms /bin/bash odoo \
    && mkdir -p /opt/nh /opt/odoo /tmp/odoo /var/lib/odoo \
    && chown -R odoo /opt/nh /var/lib/odoo \
    && virtualenv /opt/nh/venv --system-site-packages \
    && curl -o /tmp/odoo.tar.gz -SL https://github.com/bjss/odoo/archive/liveobs_updated-to-latest-upstream-8.0.tar.gz \
    && tar -xf /tmp/odoo.tar.gz -C /tmp/odoo \
    && mv /tmp/odoo/odoo-liveobs_updated-to-latest-upstream-8.0/* /opt/odoo \
    && cd /opt/odoo/ \
    && /opt/nh/venv/bin/pip install -r requirements.txt \
    && /opt/nh/venv/bin/pip install coverage==4.4.1 \
    && /opt/nh/venv/bin/python setup.py install

# Copy entrypoint script and Odoo configuration file
COPY ./entrypoint.sh /
COPY ./openerp-server.conf /etc/odoo/server.cfg
RUN chown odoo /etc/odoo/server.cfg

# Expose Odoo services
EXPOSE 8069 8071

# Set the default config file
ENV OPENERP_SERVER /etc/odoo/server.cfg
ENV COVERAGE_FILE /opt/nh/.coverage

# Set default user when running the container
USER odoo

ENTRYPOINT ["/entrypoint.sh"]
CMD ["openerp-server"]
