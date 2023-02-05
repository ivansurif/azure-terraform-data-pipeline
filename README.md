Terraform Deployment Template
===

## Repo setup instructions

1. Create these secrets in your repo:
- `ARM_CLIENT_ID`
- `ARM_CLIENT_SECRET`
- `ARM_SUBSCRIPTION_ID`
- `ARM_TENANT_ID`
- `ARM_ACCESS_KEY` => See explanation below

2. Make sure that your `GH Actions` workflow permissions are permissive: _Settings > Actions > Workflow permissions >_ 
select `Read & Write permissions`

## Before using this repo

These resources need to be created:

###1. An Azure Tenant used to store resources, not necessarily the same one where AAD lives

- An Azure **Tenant** is required. It's ID needs to be set in GitHub Secret `ARM_TENANT_ID`.

- A **Subscription** needs to exist in the Azure Tenant prior to executing this code. 
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

<mark>This App Registration needs to be set as Owner of the Subscription in order to be able to manage resources.</mark>

MAKE SURE TO SET AS WORKING DIRECTORY THE PLACE WHERE TF FILES ARE
SCOTT'S MATRIX IS USEFUL WHEN WORKING WITH MULTIPLE FOLDERS
CURRENT WF FILE DOES NOT SUPPORT MULTI TIERING BECAUSE IT CAN ONLY WORK WITH A SINGLE FOLDER