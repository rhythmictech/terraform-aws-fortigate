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

data "template_file" "userdata" {
  template = file("${path.module}/userdata.tpl")
  vars = {
    bucket      = var.config_bucket_name
    region      = var.config_bucket_region == "" ? data.aws_region.current.name : var.config_bucket_region
    license     = var.use_byol ? var.config_bucket_license_file : ""
    config_file = var.config_bucket_config_file
  }
}

locals {
  latest_ami = var.use_byol ? data.aws_ami.byol.id : data.aws_ami.ondemand.id
  ami        = coalesce(var.override_ami, local.latest_ami)
}

module "fortigate_password" {
  count = var.load_default_config ? 1 : 0

  source  = "rhythmictech/secretsmanager-random-secret/aws"
  version = "~> 1.4"

  name_prefix      = var.name
  description      = "${var.name} admin password"
  length           = 20
  override_special = "@#$%^*()-=_+[]{};<>?,./"
  tags             = var.tags
}

module "keypair" {
  count = var.create_keypair ? 1 : 0

  source  = "rhythmictech/secretsmanager-keypair/aws"
  version = "~> 0.0.4"

  name_prefix = var.name
  description = "${var.name} SSH keypair"
  tags        = var.tags
}

resource "aws_instance" "this" {
  ami                    = local.ami
  ebs_optimized          = true
  iam_instance_profile   = aws_iam_instance_profile.this.name
  instance_type          = var.instance_type
  key_name               = try(module.keypair[0].key_name, var.keypair)
  source_dest_check      = false
  subnet_id              = var.internal_subnet_id
  user_data              = var.enable_auto_config ? data.template_file.userdata.rendered : ""
  vpc_security_group_ids = [aws_security_group.internal.id]

  tags = merge(
    var.tags, {
      "Name" = var.name
  })


  lifecycle {
    prevent_destroy = true
    ignore_changes  = [ami, user_data]
  }

  depends_on = [aws_s3_bucket_object.default_config]
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
