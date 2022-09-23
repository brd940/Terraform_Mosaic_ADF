terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "test_terraform_managed_adf"
  location = "eastus2"
}

resource "azurerm_data_factory" "adf" {
  name                = "adf-from-github"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_data_factory_integration_runtime_self_hosted" "shrt" {
  name            = "selfHostedIRmushqmos2dv"
  data_factory_id = azurerm_data_factory.adf.id
}

resource "azurerm_data_factory_linked_custom_service" "mosaicDEV" {
  name                 = "mosaicDEV"
  data_factory_id      = azurerm_data_factory.adf.id
  type                 = "Oracle"
  description          = "Mosaic Dev DB"
  type_properties_json = <<JSON
   {
    "connectionString" : "host=excd-scan.sherwin.com;port=1521;servicename=mosdev;user id=MOSAIC_DATA",
    "encryptedCredential" : "eyJDcmVkZW50aWFsSWQiOiIzMjgyZjE0NC04ZGUxLTRlOTYtOGU0ZS0xZDQ4Njk0YTQ3MzMiLCJWZXJzaW9uIjoiMi4wIiwiQ2xhc3NUeXBlIjoiTWljcm9zb2Z0LkRhdGFQcm94eS5Db3JlLkludGVyU2VydmljZURhdGFDb250cmFjdC5DcmVkZW50aWFsU1UwNkNZMTQifQ=="
  }
  JSON
  integration_runtime {
    name = azurerm_data_factory_integration_runtime_self_hosted.shrt.name
  }
  annotations = []
}