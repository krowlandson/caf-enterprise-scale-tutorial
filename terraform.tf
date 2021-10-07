# We strongly recommend using the required_providers block
# to set the Azure Provider source and version being used.
# Because we implement multiple providers, we must also
# declare the configuration_aliases being used.

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.77.0"
      configuration_aliases = [
        azurerm.management,
        azurerm.connectivity,
      ]
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.7.0"
    }
  }
}
