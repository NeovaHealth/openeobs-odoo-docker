#!/usr/bin/make
REGION = $(shell echo ${registry} | awk -F. '{print $$4}')
ODOO_BRANCH = 8.0

all: build test publish

clean:
	@echo -n "Checking for registry setting ... "
	@test -n "${registry}" || (echo "no registry setting" && exit 1)
	@echo OK
	docker rmi ${registry}/odoo:${ODOO_BRANCH} || true
	docker rmi ${registry}/odoo:latest || true
	docker rmi odoo:${ODOO_BRANCH} || true

login:
	@echo -n "Checking for registry setting ... "
	@test -n "${registry}" || (echo "no registry setting" && exit 1)
	@echo OK
	@echo -n "Logging into ECR..."
	@`aws ecr get-login --no-include-email --region "${REGION}"`

build: clean login
	docker build --pull --no-cache \
		-t ${registry}/odoo:${ODOO_BRANCH} \
		--build-arg ODOO_BRANCH=${ODOO_BRANCH} .
	docker tag ${registry}/odoo:${ODOO_BRANCH} odoo:${ODOO_BRANCH}
	@cd ..

test:
	@docker build -t odoo-rspec:${ODOO_BRANCH} -f Dockerfile-rspec .
	@bundle install
	ODOO_BRANCH=${ODOO_BRANCH} bundle exec rake spec
	@rm -rf vendor
	@docker rmi odoo-rspec:${ODOO_BRANCH}

publish: login
	@echo -n "Checking for registry setting ... "
	@test -n "${registry}" || (echo "no registry setting" && exit 1)
	@echo OK
	@docker tag ${registry}/odoo:${ODOO_BRANCH} ${registry}/odoo:latest
	@docker push ${registry}/odoo:${ODOO_BRANCH}
	@docker push ${registry}/odoo:latest

.PHONY: clean login build test publish add_requirements
