output "vpcId" {
  value       = aws_vpc.tf_vpc.id
  # depends_on  = []
}

output "igwId" {
  value       = aws_internet_gateway.tf_gw.id
  # depends_on  = []
}
