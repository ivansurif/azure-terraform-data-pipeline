Cognite - SKF Cenit - Terraform
===


The purpose of this repository is to configure the infrastructure for the Cognite SKF Cenit project. 
The project uses a separate Github Organisation, `cognite-skf-cenit` and Azure AD and Subscription, 
`SKF Cenit By Cognite` and `Azure Companion Project - SKF Cenit - SKF Tenant` respectively.

The repository handles the creation, management and destruction of all Azure resources within these subscriptions. 

## Before using this repo

These resources need to be created:

###1. An Azure Tenant used to store resources, not necessarily the same one where AAD lives

- An Azure **Tenant** is required. It's ID needs to be set in GitHub Secret `ARM_TENANT_ID`.

- A **Subscription** needs exist in the Azure Tenant prior to executing this code. 
It's ID needs to be stored in a GitHub Secret called `ARM_SUBSCRIPTION_ID`. 

**Note**: Subscriptions need to have resource providers registered (enabled) in order for these to be used. 
If you attempt to build a resource which provider is not enabled, you will get a `MissingSubscriptionRegistration` error. 
This error is easy to fix, and the message is self explanatory. But you need admin access to the tenant in order to 
enable (register) resource providers (i.e., fixing this error). Sample error below:


`2022-06-30T18:44:03.1472586Z Error: creating Container Registry "cogniteskfcenitregistry" (Resource Group "common-services"): containerregistry.RegistriesClient#Create: Failure sending request: StatusCode=409 -- Original Error: Code="MissingSubscriptionRegistration" Message="The subscription is not registered to use namespace 'Microsoft.ContainerRegistry'. See https://aka.ms/rps-not-found for how to register subscriptions." Details=[{"code":"MissingSubscriptionRegistration","message":"The subscription is not registered to use namespace 'Microsoft.ContainerRegistry'. See https://aka.ms/rps-not-found for how to register subscriptions.","target":"Microsoft.ContainerRegistry"}]`

**Note**: Terraform erros in GH Actions can by pretty cryptic. 
Therefore [enabling debug logging](https://docs.github.com/en/actions/monitoring-and-troubleshooting-workflows/enabling-debug-logging) 
is very recommendable (and will esure that you catch errors like the one above).

**Note** As explained [here](https://groups.google.com/g/terraform-tool/c/MWSA-_1L9IM/m/IOZffHoXBAAJ), 
_Terraform will only try to manipulate resources that are in the state file (ie they were created by TF in the first place, or they were imported into state). It ignores everything else. Also, `terraform plan` is pretty trustworthy, especially the last line where it details how many resources will be changed, deleted, or created. If those all say zero, then you are in a safe place._


- The following **Resource Groups** need be created manually. </br>
Their names do not need to be updated in this repo: the code in the repo runs assuming these Resource Groups already exist.</br>
No need to create tags when creating the Resource Group:
<mark>[COMPARE THIS LIST WITH ACTUAL RESOURCE GROUPS CREATED IN THE REPO!]<mark>

  - terraform


- A **Storage Account** where Terraform state will be stored also needs to be created prior to using this repo. 
The name of the storage account is referenced (and needs to be updated) in multiple files throughout this repo, 
in field `storage_account_name`. The only thing that needs to be set manually when creating the Storage Account 
in Azure UI is its name. All other variables can be kept with their default values. The Storage account, like 
everything else created either manually or through this repo, need to belong to the aforementioned Resource Group.


- After creating the Storage Account, copy either of its **Access Keys** from the Azure UI. 
Store its value in a **GitHub Repository Secret** named `ARM_ACCESS_KEY`


- Lastly, a **Storage Container** needs to be created within the previously created Storage Account. 
The container shall be named `tfstate`. If choosing a different name, the references to the Storage Container 
within this code need to be updated to match the selected name.


- An **App Registration** needs to be created in Azure Active Directory. Copy and set it's ID in GitHub Secret
 `ARM_CLIENT_ID`. Create a Secret and set its value in GitHub Secret `ARM_CLIENT_SECRET`.


<mark>- Redirect URI (optional)??</mark>

- Back to the Storage Container's **Access Control (IAM)**, grant:
- Owner
- Contributor
- Reader

access to the App Registration

- From Active Directory, Roles and administrators, add the application to the role `Application administrator`.

- From the app registration > API permissions, select 
Microsoft Graph > Application Permissions
User.Invite.All
User.Read.All
User.ReadWrite.All

Then grant all permissions by clicking on "Grant admin consent for [Tenant name] "



That's all. Terraform takes it from there, including the creation of the Storage Container within that Storage Account 
where the Terraform state file will be stored. **No manual changes should be made in Azure UI after this point 
(all changes need to be managed via Terraform)** 


### GitHub
Several secrets need to be set at repo level in order for the workflows to run: they are listed in the GH workflow.


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

Users need to be added to the Key Vault if they are required to handle keys.</br>
For example, several Funtion App environment variables are pulled from Key Vault secrets. 
If these secrets had to be updated, then users with access to the key vault would be the only ones able to make those changes.</br>
These users are added to a group in file <code>terraform/azure/tier0/resources/iam.tf</code>.</br>
That group is then granted access to the Key Vault in <code>terraform/azure/tier0/resources/key_vault.tf</code>

* terraform/azure/tier1/function_apps builds the Function Apps


## Deployment Notes

It is not possible to create state in one PR that is referenced for the first time in the same PR. ie You can't do staggered Plan and Apply. You can however make changes to multiple workspaces at the same time, as long as they don't rely on the other.

The `plan` stage will provide the intended infra changes as a comment in the PR comments thread. Read this carefully before proceeding.

The `apply` stage requires an approval from one of the configured approvers.

Having successfully applied the infra changes, the changes can be approved and merged into the `main` branch.

## Inviting a new User to the Azure Tenant where all resources (except for AAD) live at
⚠️  **Only @cognitedata users can be added to the Cognitedata tenant**
1. Add new user **in this order** to:
   - **terraform/azure/tier0/guest_users/users.tf**
   - (NOT NECESSARY?) terraform/azure/tier0/common_services/iam.tf
   - (NOT NECESSARY?) terraform/azure/tier0/iam/directory_roles.tf
   - (NOT NECESSARY?) terraform/azure/tier0/iam/github_users.tf

2. Add the user as a `Contributor` to the `Azure Companion Project - SKF Cenit` Subscription. 
This needs to be done through the UI in `Subscriptions` > `Azure Companion Project - SKF Cenit` > `Access control (IAM)` by a user with at least `Owner` access to that Subscription.

3. Add the user to `GitHub Enterprise Cloud - Organization` >  `Users and groups` in Active Directory.
This Enterprise Registration acts as the **Service Principal**.

Assigning users to this principal

![alt text](assign users to principal.png)

is done here:
terraform/azure/tier0/iam/github_users.tf
This is not required for accessing Github, it allows users to authenticate against Azure.




## Inviting a new User to the Azure AD Tenant:

⚠️ **This is only applicable if AAD is stored in the same Subscription as the remaining resources, which is not the case
for SKF Cenit project. I leave it documented here because it might become handy at some point**

1. Create a new branch
1. In `terraform/azure/tier0/guest_users/users.tf` create an invite for the new user by adding them to the `users` set. The format is ` display_name : email_address`
1. Run `terraform fmt --recursive=true` to ensure formatting is correct
1. Add the changes and create a PR
1. Check the Plan, and have someone on the `infra-team-push` approve and run the Apply
1. If the Apply is successful, have the changes approved and merged to the main branch

## Inviting a new User to the Github Org

ℹ️ **This still applies even if the AAD Subscription is not the same as the one holding the resources**

As a prerequisite to this, the user must be in the Azure AD Tenant, so the previous section should be completed.

1. Create a new branch
1. In `terraform/azure/tier0/iam/github_users.tf` add the previously invited users email to the `github_users` list
1. In `terraform/github/teams/users.tf` add the user to the `github_users` set
1. Run `terraform fmt --recursive=true` to ensure formatting is correct
1. Add the changes and create a PR
1. Check the Plan, and have someone on the `infra-team-push` approve and run the Apply
1. If the Apply is successful, have the changes approved and merged to the main branch
1. Direct the new user to `https://github.com/orgs/cognite-skf-cenit/sso` to complete the authorization process
