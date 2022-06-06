module "firewall" {
  source = "../.."

  config_bucket_name   = "fortigate-config"
  create_config_bucket = true
  enable_auto_config   = true
  external_subnet_id   = "subnet-01234567890"
  instance_type        = "t3.large"
  internal_subnet_id   = "subnet-01234567891"
  load_default_config  = true
  vpc_id               = "vpc-01234567890"
}
