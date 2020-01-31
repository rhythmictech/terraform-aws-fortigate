output "eip_fortigate" {
  description = "Elastic IP address of firewall"
  value       = aws_eip.this.public_ip
}

output "instance_fortigate" {
  description = "Fortigate Instance ID"
  value       = aws_instance.this.id
}

output "instance_fortigate_primary_network_interface_id" {
  description = "Primary ENI ID (attach route tables to this)"
  value       = aws_instance.this.primary_network_interface_id
}

output "keypair_key_name" {
  description = "Instance keypair name"
  value       = module.keypair.key_name
}

output "s3_bucket_config" {
  description = "S3 bucket holding configuration"
  value       = var.create_config_bucket ? aws_s3_bucket.config[0].bucket : ""
}

output "secretsmanager_secret_arn" {
  description = "FortiGate admin password secret"
  value       = var.load_default_config ? module.fortigate_password[0].secret_arn : ""
}

output "security_group_external" {
  description = "Security group for external access"
  value       = aws_security_group.external.id
}

output "security_group_internal" {
  description = "Security group for internal access"
  value       = aws_security_group.internal.id
}
