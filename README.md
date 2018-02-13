# LiveObs Odoo Docker
This repo is responsible for building and publishing a vanilla Odoo Docker 
image to our ECR repository which is then built upon to create LiveObs in our 
CI pipeline.

1. `cd docker/odoo`
1. `make build registry=<LIVEOBS_ECS_REGISTRY>`

# LiveObs-specific Python Dependencies
In the Dockerfile you will see that we append our own dependencies to Odoo's 
`requirements.txt` before installing them.