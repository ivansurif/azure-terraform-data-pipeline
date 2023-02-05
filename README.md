Terraform Deployment Template
===

## Repo setup instructions

1. Create these secrets in your repo:
- `ARM_CLIENT_ID`
- `ARM_CLIENT_SECRET`
- `ARM_SUBSCRIPTION_ID`
- `ARM_TENANT_ID`

2. Make sure that your `GH Actions` workflow permissions are permissive: _Settings > Actions > Workflow permissions >_ 
select `Read & Write permissions`

## NEXT STEPS

Replace cryptic matrix generator in WF file with a simple Terraform deployment workflow:
https://developer.hashicorp.com/terraform/tutorials/automation/github-actions