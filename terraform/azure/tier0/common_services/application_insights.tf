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
    name                    = "sendtojoel"
    email_address           = "joel.sirefelt@cognite.com"
    use_common_alert_schema = true
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert" "function-poz-dev" {
  name                = "function-poz-dev"
  location            = azurerm_resource_group.common.location
  resource_group_name = azurerm_resource_group.common.name

  action {
    action_group = [
      azurerm_monitor_action_group.action_group.id
    ]
  }
  data_source_id = azurerm_application_insights.insights.id
  description    = "Exception threshold reached"
  enabled        = true
  # Count all requests with server error result code grouped into 5-minute bins
  query       = <<-QUERY
  traces
  | where message contains "Successfully uploaded datapoints to CDF"
  | where timestamp > ago(10min)
  | where cloud_RoleName =~ 'skfcenit-integrations-Poz-dev' and operation_Name  =~ 'update_datapoints'
  QUERY
  severity    = 1
  frequency   = 10
  time_window = 10
  trigger {
    operator  = "LessThan"
    threshold = 1
  }
}
