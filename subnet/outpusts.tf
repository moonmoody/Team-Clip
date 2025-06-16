output "subId" {
  value       = [
    for item in local.subnetId : item
  ]
  # value       = [
  #   aws_subnet.tf_sn["172.16.1.0/24"].id,
  #   aws_subnet.tf_sn["172.16.2.0/24"].id,
  #   aws_subnet.tf_sn["172.16.3.0/24"].id,
  #   aws_subnet.tf_sn["172.16.4.0/24"].id
  # ]
  
  
  # depends_on  = []
}
