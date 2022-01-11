resource "azurerm_application_insights" "insights" {
  name                = "insights-${azurerm_resource_group.common.name}"
  location            = azurerm_resource_group.common.location
  resource_group_name = azurerm_resource_group.common.name
  application_type    = "web"
}


resource "azurerm_monitor_action_group" "action_group" {
  name                = "function-alerts"
  resource_group_name = azurerm_resource_group.common.name
  short_name          = "f-alerts"

  email_receiver {
    name                    = "sendtogooglegroup"
    email_address           = "skf-cenit-alert@cognite.com"
    use_common_alert_schema = true
  }
}