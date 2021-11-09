Cognite - SKF Cenit - Terraform
===

The purpose of this repository is to configure the infrastructure for the Cognite SKF Cenit project. The project uses a separate Github Organisation, `cognite-skf-cenit` and Azure AD and Subscription, `SKF Cenit By Cognite` and `Azure Companion Project - SKF Cenit` respectively.

## Structure

A Github Actions Workflow automates the Terraform Plan and Apply. And directory containing a `.tf` file is considered a Terraform Workspace, and the action will attempt to provide a Plan for that workspace.

As a default, all Terraform workspaces should be under the `terraform` folder and then are organised by provider, ie. `azure` and `github`.

A `project_vars` workspace exists in the `terraform` directory. This is used to provide output to both providers, when necessary.

## Deployment Notes

It is not possible to create state in one PR that is referenced for the first time in the same PR. ie You can't do staggered Plan and Apply. You can however make changes to multiple workspaces at the same time, as long as they don't rely on the other.

The `plan` stage will provide the intended infra changes as a comment in the PR comments thread. Read this carefully before proceeding.

The `apply` stage requires an approval from one of the configured approvers.

Having successfully applied the infra changes, the changes can be approved and merged into the `main` branch.
