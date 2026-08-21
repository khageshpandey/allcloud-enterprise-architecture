resource "aws_ec2_transit_gateway_vpc_attachment" "spoke_attachment" {
  transit_gateway_id                              = var.transit_gateway_id
  vpc_id                                          = var.spoke_vpc_id
  subnet_ids                                      = var.transit_subnet_ids
  transit_gateway_default_route_table_propagation = false
  transit_gateway_default_route_table_association = false

  tags = merge(var.common_tags, {
    Name = "${var.environment}-tgw-attachment"
  })
}

resource "aws_ec2_transit_gateway_route_table_association" "spoke_association" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.spoke_attachment.id
  transit_gateway_route_table_id = var.spoke_tgw_route_table_id
}