# caf-enterprise-scale Tutorial

This repository contains a sample set of code to simplify learning how to run the [caf-enterprise-scale]() module.

The deployment is broken into 4 stages:

1. Deploy the core Management Group hierarchy, including Policies and Access control (IAM) for governance. Includes an additional `example` Management Group under `landing-zones`.
2. Add the `corp`, `online` and `sap` Management Groups with corresponding Policies and Access control (IAM) settings.
3. Enable deployment of the management resources.
4. Enable deployment of the connectivity resources.

This tutorial can be deployed using 1-3 Subscriptions depending on your preference. This is controlled by specifying values for the `subscription_id_management` and `subscription_id_connectivity` input variables.

Providers are used to map to the Subscription(s), for the following purposes:

| Provider Alias | Set by... | Purpose |
| -------------- | ------- | ------- |
| azurerm | *current context set by `az login` or alternate credential settings* | Used for the core deployment. This includes the Management Group hierarchy, Policies, and Access control (IAM). No resources are deployed to this Subscription unless it is mapped to the other aliases. |
| azurerm.management | `var.subscription_id_management` or *current context* | Used to create the Management resources. |
| azurerm.connectivity | `var.subscription_id_connectivity` or *azurerm.management* | Used to create the Connectivity resources. |

## Stage 1 - Base deployment

To use this module, run the following commands:

> These instructions assume you already have an active login to Azure or have reconfigured the providers using one of the [supported authentication methods](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#authenticating-to-azure).

```shell
# Change directory to home
cd ~

# Clone the repository
git clone https://github.com/krowlandson/caf-enterprise-scale-tutorial.git

# Change directory to the cloned repository
cd caf-enterprise-scale-tutorial

# Initialize the terraform root module
terraform init

# Generate and save a plan using settings from 'deployment_01.tfvars'
terraform plan -var-file='deployment_01.tfvars' -out=tfplan

# Apply the plan (once you have reviewed the changes)
terraform apply tfplan
```

> To target specific Subscriptions for the management or connectivity resources, simply supply values for the `subscription_id_management` and `subscription_id_connectivity` input variables.
> This can be done by setting them in [environment variables](https://www.terraform.io/docs/cli/config/environment-variables.html#tf_var_name), or by adding to the `terraform plan` command using the [`-var 'NAME=VALUE'`](https://www.terraform.io/docs/cli/commands/plan.html#var-39-name-value-39-) method.

Once deployment completes, use the [Azure Portal](https://portal.azure.com/) to see the new Management Group hierarchy in your environment.
Take note of the Policies and Access control (IAM) settings which have been configured.

## Stage 2 - Add landing zones

The next stage is to add the `corp`, `online` and `sap` Management Groups with corresponding Policies and Access control (IAM) settings.
> You can see which code changes are made by comparing the files `deployment_01.tfvars` and `deployment_02.tfvars`.

```shell
# Generate and save a plan using settings from 'deployment_02.tfvars'
terraform plan -var-file='deployment_02.tfvars' -out=tfplan

# Apply the plan (once you have reviewed the changes)
terraform apply tfplan
```

Once deployment completes, use the [Azure Portal](https://portal.azure.com/) to see the additional Management Groups added under the "Landing Zones" Management Group.
Take note that these also include additional Policies and Access control (IAM) settings at each scope.

## Stage 3 - Add management resources

The next stage is to add the management resources.
These are deployed to the Subscription associated with the `azurerm.management` aliased provider.
> You can see which code changes are made by comparing the files `deployment_02.tfvars` and `deployment_03.tfvars`.

```shell
# Generate and save a plan using settings from 'deployment_03.tfvars'
terraform plan -var-file='deployment_03.tfvars' -out=tfplan

# Apply the plan (once you have reviewed the changes)
terraform apply tfplan
```

Once deployment completes, use the [Azure Portal](https://portal.azure.com/) to see the management resources which have been added into the target Subscription.

## Stage 4 - Add connectivity resources

The next stage is to add the connectivity resources.
These are deployed to the Subscription associated with the `azurerm.connectivity` aliased provider.
> You can see which code changes are made by comparing the files `deployment_03.tfvars` and `deployment_04.tfvars`.

```shell
# Generate and save a plan using settings from 'deployment_04.tfvars'
terraform plan -var-file='deployment_04.tfvars' -out=tfplan

# Apply the plan (once you have reviewed the changes)
terraform apply tfplan
```

Once deployment completes, use the [Azure Portal](https://portal.azure.com/) to see the connectivity resources which have been added into the target Subscription.

## Next steps

Review our [examples](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/Examples) on the Wiki, and try making your own changes to the module configuration to see how you can customize your deployment.