output "sgWebId" {
  value       = aws_security_group.tf_sg_web.id
  # depends_on  = []
}

output "sgAlbId" {
  value       = aws_security_group.tf_sg_alb.id
  # depends_on  = []
}
