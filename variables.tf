variable "allowed_admin_cidrs" {
  default     = ["0.0.0.0/0"]
  description = "Public CIDRs that will be able to access the FortiGate admin ports"
  type        = list(string)
}

variable "allowed_admin_security_group_id" {
  default     = ""
  description = "Security group allowed to access admininstrative ports"
  type        = string
}

variable "enable_sdn_access" {
  default     = false
  description = "Enable FortiGate SDN access to AWS resources"
  type        = bool
}

variable "external_subnet_id" {
  description = "Subnet ID to use for public interface"
  type        = string
}

variable "https_admin_port" {
  default     = 443
  description = "HTTPS port for administrative access"
  type        = number
}

variable "instance_type" {
  type    = string
  default = "m5.large"
}

variable "internal_subnet_id" {
  description = "Subnet ID to use for internal interface"
  type        = string
}

variable "name" {
  default     = "fortigate"
  description = "Name of this Fortigate instance"
  type        = string
}

variable "override_ami" {
  default     = ""
  description = "Specify to force a specific AMI"
  type        = string
}

variable "tags" {
  default     = {}
  description = "Tags to apply to supported resources (don't include name tag)"
  type        = map(string)
}

variable "use_byol" {
  default     = false
  description = "Use BYOL license (as opposed to on demand pricing)"
  type        = bool
}

variable "vpc_id" {
  description = "VPC to create resources in"
  type        = string
}

########################################
# Auto Config Settings
########################################
variable "create_config_bucket" {
  default     = false
  description = "Create a bucket for configuration auto loading"
  type        = bool
}

variable "config_bucket_name" {
  default     = ""
  description = "Name of config bucket. If `create_config_bucket = true`, a bucket with this name will be created."
  type        = string
}

variable "config_bucket_config_file" {
  default     = "fortigate.conf"
  description = "Name of the configuration file in the S3 bucket"
  type        = string
}

variable "config_bucket_license_file" {
  default     = ""
  description = "Name of the license file (leave blank if using on demand)"
  type        = string
}

variable "config_bucket_region" {
  default     = ""
  description = "Region that the S3 bucket is in. Required when the bucket is not created by this module."
  type        = string
}

variable "create_config_bucket_iam_policy" {
  default     = true
  description = "Attach an IAM policy granting the FortiGate instance read access to all objects in the bucket."
  type        = bool
}

variable "enable_auto_config" {
  default     = false
  description = "Enable auto configuration"
  type        = bool
}

variable "load_default_config" {
  default     = false
  description = "Place a default configuration file in the config bucket with the specified name"
  type        = bool
}

########################################
# Route 53 Settings
########################################
variable "create_route53_address" {
  default     = false
  description = "Associate a Route53 entry to the public EIP"
  type        = bool
}

variable "route53_address" {
  default     = ""
  description = "Route 53 address (do not include full domain)"
  type        = string
}

variable "route53_zone_id" {
  default = ""
  type    = string
}
