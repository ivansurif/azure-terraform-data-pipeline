Terraform based Azure Deployment
===

## Repo setup

1. Create these **secrets** in your repo:
- `ARM_CLIENT_SECRET`
- `ARM_ACCESS_KEY` => See explanation below

2. Make sure that your `GH Actions` workflow permissions are permissive: _Settings > Actions > Workflow permissions >_ 
select `Read & Write permissions`

## Azure Setup

- An Azure **Tenant** is required. It's ID needs to be set in GitHub Secret `ARM_TENANT_ID`.


- A **Subscription** needs to exist in the Azure Tenant prior to executing this code. 
It's ID needs to be stored in a GitHub Secret called `ARM_SUBSCRIPTION_ID`.

**Note**: Subscriptions need to have resource providers registered (enabled) in order for these to be used. 
If you attempt to build a resource which provider is not enabled, you will get a `MissingSubscriptionRegistration` error. 
This error is easy to fix, and the message is self explanatory. But you need admin access to the tenant in order to 
enable (register) resource providers (i.e., fixing this error). Sample error below:


`2022-06-30T18:44:03.1472586Z Error: creating Container Registry "REGISTRY_NAME_HERE" (Resource Group "common-services"): containerregistry.RegistriesClient#Create: Failure sending request: StatusCode=409 -- Original Error: Code="MissingSubscriptionRegistration" Message="The subscription is not registered to use namespace 'Microsoft.ContainerRegistry'. See https://aka.ms/rps-not-found for how to register subscriptions." Details=[{"code":"MissingSubscriptionRegistration","message":"The subscription is not registered to use namespace 'Microsoft.ContainerRegistry'. See https://aka.ms/rps-not-found for how to register subscriptions.","target":"Microsoft.ContainerRegistry"}]`

**Note**: Terraform erros in GH Actions can by pretty cryptic. 
Therefore [enabling debug logging](https://docs.github.com/en/actions/monitoring-and-troubleshooting-workflows/enabling-debug-logging) 
is very recommendable (and will esure that you catch errors like the one above).

**Note** As explained [here](https://groups.google.com/g/terraform-tool/c/MWSA-_1L9IM/m/IOZffHoXBAAJ), 
_Terraform will only try to manipulate resources that are in the state file (ie they were created by TF in the first place, or they were imported into state). It ignores everything else. Also, `terraform plan` is pretty trustworthy, especially the last line where it details how many resources will be changed, deleted, or created. If those all say zero, then you are in a safe place._


<br>

### The following resources need to be created <u>_manually_</u>:  
The reason is that in this architecture, Terraform _state file_ is stored in Azure itself.  
So the creation of the storage `account` and `container` where Terraform will be able to create and update the 
state file need to precede the deployment of the resources through this repo.  
Creating those resources will also require the creation of a resource group in Azure. That resource group is not referenced
in this repo. Instead, the storage `account` and `container` names are, in file `provider.tf`:

```
terraform {
  backend "azurerm" {
    storage_account_name = "terra4mstate"
    container_name       = "tfstate"
    key                  = "azure.tier0.common_services"
    # Access Key set as environment variable ARM_ACCESS_KEY
  }
  (...)
```
In the above code, `key` is a parameter used to specify the name of the Terraform state file within the Azure Storage Account. The key parameter can be used to specify a prefix for the state file name or the full path of the state file.

In this case, the key parameter value is set to `azure.tier0.common_services`, which means that the Terraform state file for this configuration will be stored in a container named "tfstate" within the "terra4mstate" storage account with the name "azure.tier0.common_services".

The key parameter is optional, and if it is not specified, Terraform will use a default naming convention to create the state file name.




And, as mentioned in the code comment, repo secret `ARM_ACCESS_KEY` is necessary for the repo to be able to write to that container.


The code in the repo runs assuming these resources exist, and will return an error when deploying if they don't.</br>


- A **Resource Group**


- A **Storage Account**  
After creating the Storage Account, copy either of its **Access Keys** from the Azure UI. 
Store its value in a **GitHub Repository Secret** named `ARM_ACCESS_KEY`


- Lastly, a **Storage Container** needs to be created within the previously created Storage Account. 
The container shall be named `tfstate` for convenience. 


- An **App Registration** needs to be created in Azure Active Directory. Copy and set it's ID in GitHub Secret
 `ARM_CLIENT_ID`. Create a Secret and set its value in GitHub Secret `ARM_CLIENT_SECRET`.  
This App Registration needs to be set as Owner of the Subscription in order to be able to manage resources.

