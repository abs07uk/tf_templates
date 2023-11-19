resource "azurerm_storage_account" "uksstr" {
  name                     = "uksamrstr03"
  resource_group_name      = local.resource_group_name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  depends_on = [ 
    azurerm_resource_group.tfrg
   ]

  tags = {
    env = "tfenv"
  }
  }

resource "azurerm_storage_container" "uksamrstr02cont01" {
  for_each = toset(["files","data","documents"])
  name = each.key
  storage_account_name = "uksamrstr03"
  container_access_type = "blob"
  depends_on = [ 
    azurerm_storage_account.uksstr
   ]
}

resource "azurerm_storage_blob" "files" {
  for_each = {
    file1 = "C:\\temp\\file1.txt"
    file2 = "C:\\temp\\file2.txt"
    file3 = "C:\\temp\\file3.txt"
  }
  name                   = "${each.key}.txt"
  storage_account_name   = "uksamrstr03"
  storage_container_name = "files"
  type                   = "Block"
  source                 = each.value
  depends_on = [
    azurerm_storage_container.uksamrstr02cont01
   ]
}