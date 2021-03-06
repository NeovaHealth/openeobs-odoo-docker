FROM 298801546701.dkr.ecr.eu-west-1.amazonaws.com/odoo_base

ARG ODOO_BRANCH

RUN set -x; \
    useradd -ms /bin/bash odoo \
    && mkdir -p /opt/nh /opt/odoo /tmp/odoo /var/lib/odoo \
    && chown -R odoo /opt/nh /var/lib/odoo \
    && virtualenv /opt/nh/venv --system-site-packages \
    && curl -o /tmp/odoo.tar.gz -SL https://github.com/odoo/odoo/archive/$ODOO_BRANCH.tar.gz \
    && tar -xf /tmp/odoo.tar.gz -C /tmp/odoo \
    && mv /tmp/odoo/odoo-$ODOO_BRANCH/* /opt/odoo \
    && cd /opt/odoo/ \
    && /opt/nh/venv/bin/pip install -r requirements.txt

COPY ./liveobs_requirements.txt /opt/nh/
RUN /opt/nh/venv/bin/pip install -r /opt/nh/liveobs_requirements.txt \
    && cd /opt/odoo/ \
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
