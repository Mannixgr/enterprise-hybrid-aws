data "aws_region" "current" {}

resource "aws_cloudwatch_dashboard" "nat" {
  count = var.enable_dashboard ? 1 : 0

  dashboard_name = "${var.project_name}-network"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          title  = "NAT traffic (bytes)"
          region = data.aws_region.current.name
          view   = "timeSeries"
          stat   = "Sum"
          period = 300
          metrics = concat(
            [for id in aws_nat_gateway.this[*].id :
            ["AWS/NATGateway", "BytesOutToDestination", "NatGatewayId", id, { label = "Out ${id}" }]],
            [for id in aws_nat_gateway.this[*].id :
            ["AWS/NATGateway", "BytesInFromDestination", "NatGatewayId", id, { label = "In ${id}" }]],
          )
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          title  = "NAT port allocation errors"
          region = data.aws_region.current.name
          view   = "timeSeries"
          stat   = "Sum"
          period = 300
          metrics = [for id in aws_nat_gateway.this[*].id :
          ["AWS/NATGateway", "ErrorPortAllocation", "NatGatewayId", id]]
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6
        properties = {
          title  = "NAT active connections"
          region = data.aws_region.current.name
          view   = "timeSeries"
          stat   = "Maximum"
          period = 300
          metrics = [for id in aws_nat_gateway.this[*].id :
          ["AWS/NATGateway", "ActiveConnectionCount", "NatGatewayId", id]]
        }
      },
    ]
  })
}
