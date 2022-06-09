resource "azurerm_application_insights" "insights" {
  name                = "insights-${azurerm_resource_group.common.name}"
  location            = azurerm_resource_group.common.location
  resource_group_name = azurerm_resource_group.common.name
  application_type    = "web"
}


resource "azurerm_application_insights" "insights_files_upload_dev" {
  name                = "insights-${element(local.resource_group_names_files_upload, 0)}"
  location            = azurerm_resource_group.common.location
  resource_group_name = azurerm_resource_group.common.name
  application_type    = "web"
}

resource "azurerm_application_insights" "insights_files_upload_test" {
  name                = "insights-${element(local.resource_group_names_files_upload, 1)}"
  location            = azurerm_resource_group.common.location
  resource_group_name = azurerm_resource_group.common.name
  application_type    = "web"
}

resource "azurerm_application_insights" "insights_files_upload_prod" {
  name                = "insights-${element(local.resource_group_names_files_upload, 2)}"
  location            = azurerm_resource_group.common.location
  resource_group_name = azurerm_resource_group.common.name
  application_type    = "web"
}


resource "azurerm_monitor_action_group" "action_group" {
  name                = "function-alerts"
  resource_group_name = azurerm_resource_group.common.name
  short_name          = "f-alerts"

  email_receiver {
    name                    = "davidmendez"
    email_address           = "david.mendez@skf.com"
    use_common_alert_schema = true
  }

  email_receiver {
    name                    = "sendtoivan"
    email_address           = "ivan.surif@cognite.com"
    use_common_alert_schema = true
  }

  email_receiver {
    name                    = "leandrotorrent"
    email_address           = "leandro.torrent@skf.com"
    use_common_alert_schema = true
  }
}

resource "azurerm_monitor_action_group" "action_group_files_upload_dev" {
  name                = "function-alerts-${element(local.resource_group_names_files_upload, 0)}"
  resource_group_name = azurerm_resource_group.common.name
  short_name          = "alert-fu-dev"

  email_receiver {
    name                    = "sendtoivan"
    email_address           = "ivan.surif@cognite.com"
    use_common_alert_schema = true
  }
}

resource "azurerm_monitor_action_group" "action_group_files_upload_test" {
  name                = "function-alerts-${element(local.resource_group_names_files_upload, 1)}"
  resource_group_name = azurerm_resource_group.common.name
  short_name          = "alert-fu-tst"

  email_receiver {
    name                    = "sendtoivan"
    email_address           = "ivan.surif@cognite.com"
    use_common_alert_schema = true
  }
}

resource "azurerm_monitor_action_group" "action_group_files_upload_prod" {
  name                = "function-alerts-${element(local.resource_group_names_files_upload, 2)}"
  resource_group_name = azurerm_resource_group.common.name
  short_name          = "alert-fu-prd"

  email_receiver {
    name                    = "sendtoivan"
    email_address           = "ivan.surif@cognite.com"
    use_common_alert_schema = true
  }
}
