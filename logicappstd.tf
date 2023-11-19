resource "azurerm_app_service_plan" "appsp" {
  name                = "uksamrlgappsvcpln01"
  location            = azurerm_resource_group.tfrg.location
  resource_group_name = azurerm_resource_group.tfrg.name
  kind                = "elastic"


  sku {
    tier = "WorkflowStandard"
    size = "WS1"
  }
  depends_on = [ azurerm_resource_group.tfrg ]
}

resource "azurerm_logic_app_standard" "lgappstd" {
  name                       = "uksamrlgapp02"
  location                   = azurerm_resource_group.tfrg.location
  resource_group_name        = azurerm_resource_group.tfrg.name
  app_service_plan_id        = azurerm_app_service_plan.appsp.id
  storage_account_name       = azurerm_storage_account.uksstr.name
  storage_account_access_key = azurerm_storage_account.uksstr.primary_access_key

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME"     = "node"
    "WEBSITE_NODE_DEFAULT_VERSION" = "~18"

 }
 depends_on = [ azurerm_storage_account.uksstr ]
}