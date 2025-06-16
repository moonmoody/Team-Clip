output "natGwId" {
  value       = aws_nat_gateway.tf_nat_gw.id
  # sensitive   = true
  # depends_on  = []
}
