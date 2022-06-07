Cognite - SKF Cenit - Terraform
===


The purpose of this repository is to configure the infrastructure for the Cognite SKF Cenit project. The project uses a separate Github Organisation, `cognite-skf-cenit` and Azure AD and Subscription, `SKF Cenit By Cognite` and `Azure Companion Project - SKF Cenit` respectively.

## Structure

A Github Actions Workflow automates the Terraform Plan and Apply. And directory containing a `.tf` file is considered a Terraform Workspace, and the action will attempt to provide a Plan for that workspace.

As a default, all Terraform workspaces should be under the `terraform` folder and then are organised by provider, ie. `azure` and `github`.

A `project_vars` workspace exists in the `terraform` directory. This is used to provide output to both providers, when necessary.

The infrastructure built by Terraform is split into two different modules: 

* terraform/azure/tier0/resources builds:
  * Resource Group
  * Storage Account
  * Container Registry
  * Container Instance
  * Key Vault

* terraform/azure/tier1/function_apps builds the Function Apps


## Deployment Notes

It is not possible to create state in one PR that is referenced for the first time in the same PR. ie You can't do staggered Plan and Apply. You can however make changes to multiple workspaces at the same time, as long as they don't rely on the other.

The `plan` stage will provide the intended infra changes as a comment in the PR comments thread. Read this carefully before proceeding.

The `apply` stage requires an approval from one of the configured approvers.

Having successfully applied the infra changes, the changes can be approved and merged into the `main` branch.

## Inviting a new User to the Azure AD Tenant:

1. Create a new branch
1. In `terraform/azure/tier0/guest_users/users.tf` create an invite for the new user by adding them to the `users` set. The format is ` display_name : email_address`
1. Run `terraform fmt --recursive=true` to ensure formatting is correct
1. Add the changes and create a PR
1. Check the Plan, and have someone on the `infra-team-push` approve and run the Apply
1. If the Apply is successful, have the changes approved and merged to the main branch

## Inviting a User to the Github Org
As a prerequisite to this, the user must be in the Azure AD Tenant, so the previous section should be completed.

1. Create a new branch
1. In `terraform/azure/tier0/iam/github_users.tf` add the previously invited users email to the `github_users` list
1. In `terraform/github/teams/users.tf` add the user to the `github_users` set
1. Run `terraform fmt --recursive=true` to ensure formatting is correct
1. Add the changes and create a PR
1. Check the Plan, and have someone on the `infra-team-push` approve and run the Apply
1. If the Apply is successful, have the changes approved and merged to the main branch
1. Direct the new user to `https://github.com/orgs/cognite-skf-cenit/sso` to complete the authorization process
