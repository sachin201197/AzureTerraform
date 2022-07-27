terraform {
  required_version = ">= 0.12"
  required_providers {
    azurerm = ">= 1.0"
  }

}

provider "azurerm" {
  features {}
  subscription_id = "ea64af76-a4f5-4f32-ab7b-e81431e3657b"
}
