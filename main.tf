data "aws_caller_identity" "current" {
}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

data "aws_ami" "byol" {
  most_recent = true
  owners      = ["679593333241"]

  filter {
    name   = "name"
    values = ["FortiGate-VM64-AWS build*"]
  }
}

data "aws_ami" "ondemand" {
  most_recent = true
  owners      = ["679593333241"]

  filter {
    name   = "name"
    values = ["FortiGate-VM64-AWSONDEMAND*"]
  }
}

data "aws_region" "current" {}

locals {
  latest_ami = var.use_byol ? data.aws_ami.byol.id : data.aws_ami.ondemand.id
  ami        = coalesce(var.override_ami, local.latest_ami)
  userdata   = templatefile("${path.module}/userdata.tpl",
    {
      bucket      = var.config_bucket_name
      region      = var.config_bucket_region == "" ? data.aws_region.current.name : var.config_bucket_region
      license     = var.use_byol ? var.config_bucket_license_file : ""
      config_file = var.config_bucket_config_file
    }
  )
}

module "fortigate_password" {
  source           = "git::https://github.com/rhythmictech/terraform-aws-secretsmanager-random-secret?ref=v1.1.1"
  create_secret    = var.load_default_config
  name_prefix      = var.name
  description      = "${var.name} admin password"
  length           = 20
  override_special = "@#$%^*()-=_+[]{};<>?,./"
  tags             = var.tags
}

module "keypair" {
  source  = "rhythmictech/secretsmanager-keypair/aws"
  version = "0.0.4"

  name_prefix = var.name
  description = "${var.name} SSH keypair"
  tags        = var.tags
}

resource "aws_instance" "this" {
  ami                  = local.ami
  ebs_optimized        = true
  iam_instance_profile = aws_iam_instance_profile.this.name
  instance_type        = var.instance_type
  key_name             = module.keypair.key_name
  source_dest_check    = false
  subnet_id            = var.internal_subnet_id
  tags = merge(
    var.tags, {
      "Name" = var.name
  })
  user_data              = var.enable_auto_config ? local.userdata : ""
  vpc_security_group_ids = [aws_security_group.internal.id]

  depends_on = [aws_s3_bucket_object.default_config]

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [ami, user_data]
  }
}

resource "aws_network_interface" "outbound" {
  subnet_id         = var.external_subnet_id
  security_groups   = [aws_security_group.external.id]
  source_dest_check = false
  tags              = var.tags

  attachment {
    device_index = 1
    instance     = aws_instance.this.id
  }
}

resource "aws_eip" "this" {
  vpc  = true
  tags = var.tags
}

resource "aws_eip_association" "this" {
  allocation_id        = aws_eip.this.id
  network_interface_id = aws_network_interface.outbound.id
}
