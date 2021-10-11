# caf-enterprise-scale Tutorial

## Introduction

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

We recommend using [environment variables](https://www.terraform.io/docs/cli/config/environment-variables.html#tf_var_name) to configure values for `var.subscription_id_management` and `var.subscription_id_connectivity` in your deployment without adding them to the code.

Linux example:
```shell
export TF_VAR_subscription_id_management=00000000-0000-0000-0000-000000000000
export TF_VAR_subscription_id_connectivity=11111111-1111-1111-1111-111111111111
```

Windows example:
```shell
$env:TF_VAR_subscription_id_management = "00000000-0000-0000-0000-000000000000"
$env:TF_VAR_subscription_id_connectivity = "11111111-1111-1111-1111-111111111111"
```

Due to the number of resources being deployed, you may also want to consider increasing the number of resources created in parallel by Terraform.
To do this, simply add `-parallelism=n` to your `apply` or `destroy` command.
This value defaults to `10` and can be increased.
Take care when increasing this value though, as API rate limiting can result in the deployment failing.
In practice, we generally find that setting this value to `50` is optimal.

## Tutorial

### Stage 1 - Base deployment

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

### Stage 2 - Add built-in landing zones

Stage 2 adds the `corp`, `online` and `sap` Management Groups.
These are built-in to the module, and are provided with pre-configured settings for Policies and Access control (IAM).
> You can see which code changes are made by comparing the files `deployment_01.tfvars` and `deployment_02.tfvars`.

```shell
# Generate and save a plan using settings from 'deployment_02.tfvars'
terraform plan -var-file='deployment_02.tfvars' -out=tfplan

# Apply the plan (once you have reviewed the changes)
terraform apply tfplan
```

Once deployment completes, use the [Azure Portal](https://portal.azure.com/) to see the additional Management Groups added under the "Landing Zones" Management Group.
Take note that these also include additional Policies and Access control (IAM) settings at each scope.

### Stage 3 - Add custom landing zones

Stage 3 shows how to add a new `example` Management Group using the built-in `default_empty` archetype definition.
The `default_empty` archetype definition has no Policies or Access control (IAM) settings.
This allows creation of additional Management Groups with inherited settings only.
> You can see which code changes are made by comparing the files `deployment_02.tfvars` and `deployment_03.tfvars`.

```shell
# Generate and save a plan using settings from 'deployment_03.tfvars'
terraform plan -var-file='deployment_03.tfvars' -out=tfplan

# Apply the plan (once you have reviewed the changes)
terraform apply tfplan
```

Once deployment completes, use the [Azure Portal](https://portal.azure.com/) to see the additional Management Groups added under the "Landing Zones" Management Group.
Take note that these also include additional Policies and Access control (IAM) settings at each scope.

### Stage 4 - Add management resources

Stage 4 enables deployment of the management resources using default settings.
These are deployed to the Subscription associated with the `azurerm.management` aliased provider.
> You can see which code changes are made by comparing the files `deployment_03.tfvars` and `deployment_04.tfvars`.

```shell
# Generate and save a plan using settings from 'deployment_04.tfvars'
terraform plan -var-file='deployment_04.tfvars' -out=tfplan

# Apply the plan (once you have reviewed the changes)
terraform apply tfplan
```

Once deployment completes, use the [Azure Portal](https://portal.azure.com/) to see the management resources which have been added into the target Subscription.

### Stage 5 - Add connectivity resources

Stage 5 enables deployment of the connectivity resources using default settings.
These are deployed to the Subscription associated with the `azurerm.connectivity` aliased provider.
> You can see which code changes are made by comparing the files `deployment_04.tfvars` and `deployment_05.tfvars`.

```shell
# Generate and save a plan using settings from 'deployment_05.tfvars'
terraform plan -var-file='deployment_05.tfvars' -out=tfplan

# Apply the plan (once you have reviewed the changes)
terraform apply tfplan
```

Once deployment completes, use the [Azure Portal](https://portal.azure.com/) to see the connectivity resources which have been added into the target Subscription.

## Next steps

Review our [examples](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/Examples) on the Wiki, and try making your own changes to the module configuration to see how you can customize your deployment.

Once you've finished looking through your deployment and experimenting with the other settings, don't forget to clean-up your environment.
To do this, simply run `terraform destroy`
