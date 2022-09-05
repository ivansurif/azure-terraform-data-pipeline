resource "azurerm_monitor_scheduled_query_rules_alert" "function-alerts" {
  for_each            = local.alerts
  name                = each.key
  location            = data.terraform_remote_state.common_services.outputs.resource_group_location
  resource_group_name = data.terraform_remote_state.common_services.outputs.resource_group_name

  action {
    action_group = [
      data.terraform_remote_state.common_services.outputs.action_group_id
    ]
  }
  data_source_id = data.terraform_remote_state.common_services.outputs.insights_id
  description    = "Exception threshold reached"
  enabled        = true
  # Count all requests with server error result code grouped into 5-minute bins
  query       = each.value["query"]
  severity    = 1
  frequency   = 10
  time_window = 15
  trigger {
    operator  = "LessThan"
    threshold = 1
  }
}