#!/usr/bin/make

REGION = $(shell echo ${registry} | awk -F. '{print $$4}')

all: build test publish

clean:
	@echo -n "Checking for registry setting ... "
	@test -n "${registry}" || (echo "no registry setting" && exit 1)
	@echo OK
	docker rmi ${registry}/odoo:${VERSION} || true
	docker rmi ${registry}/odoo:latest || true
	docker rmi odoo:${VERSION} || true

login:
	@echo -n "Checking for registry setting ... "
	@test -n "${registry}" || (echo "no registry setting" && exit 1)
	@echo OK
	@echo -n "Logging into ECR..."
	@`aws ecr get-login --no-include-email --region "${REGION}"`

build: clean login
	docker build --pull --no-cache -t ${registry}/odoo:${VERSION} .
	docker tag ${registry}/odoo:${VERSION} odoo:${VERSION}
	@cd ..

test:
	@echo "FROM ${registry}/odoo:${VERSION}\nCMD /bin/bash" > Dockerfile-rspec
	@docker build -t odoo-rspec:${VERSION} -f Dockerfile-rspec .
	@bundle install
	@bundle exec rake spec
	@rm -rf vendor
	@docker rmi odoo-rspec:${VERSION}

publish: login
	@echo -n "Checking for registry setting ... "
	@test -n "${registry}" || (echo "no registry setting" && exit 1)
	@echo OK
	@docker tag ${registry}/odoo:${VERSION} ${registry}/odoo:latest
	@docker push ${registry}/odoo:${VERSION}
	@docker push ${registry}/odoo:latest

.PHONY: clean login build test publish
