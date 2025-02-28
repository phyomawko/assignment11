
resource "aws_networkfirewall_rule_group" "allow_specific_ip" {
  capacity    = 100
  name        = "allow-specific-ip"
  type        = "STATELESS"
  description = "Allow all traffic from 52.221.106.252 and drop everything else"

  rule_group {
    rules_source {
      stateless_rules_and_custom_actions {
        stateless_rule {
          priority = 1
          rule_definition {
            actions = ["aws:pass"]
            match_attributes {
              source {
                address_definition = var.source_ip
              }
              destination {
                address_definition = aws_subnet.application_subnet.cidr_block
              }
            }
          }
        }
        stateless_rule {
          priority = 2
          rule_definition {
            actions = ["aws:pass"]
            match_attributes {
              source {
                address_definition = aws_subnet.application_subnet.cidr_block
              }
              destination {
                address_definition = var.source_ip
              }
            }
          }
        }
      }
    }
  }

  tags = {
    Name = "allow-specific-ip"
  }
}

# Create firewall policy
resource "aws_networkfirewall_firewall_policy" "fw_policy" {
  name = "firewall-policy"
  
  firewall_policy {
    stateless_default_actions          = ["aws:drop"]
    stateless_fragment_default_actions = ["aws:drop"]
    
    stateless_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.allow_specific_ip.arn
      priority     = 1
    }
  }

  tags = {
    Name = "firewall-policy"
  }
}

# Create the Network Firewall
resource "aws_networkfirewall_firewall" "fw" {
  name                = "network-firewall"
  firewall_policy_arn = aws_networkfirewall_firewall_policy.fw_policy.arn
  vpc_id              = aws_vpc.application_vpc.id
  delete_protection   = false
  subnet_mapping {
    subnet_id = aws_subnet.firewall_subnet.id
  }
  
  tags = {
    Name = "network-firewall"
  }
}

data "aws_networkfirewall_firewall" "fw_data" {
  name     = aws_networkfirewall_firewall.fw.name
  arn      = aws_networkfirewall_firewall.fw.arn
  
  depends_on = [aws_networkfirewall_firewall.fw]
}
