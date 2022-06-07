resource "aws_security_group" "internal" {
  name_prefix = "${var.name}-internal"
  description = "FG internal interface"
  tags        = var.tags
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "allow_all_internal" {
  cidr_blocks       = ["0.0.0.0/0"] #tfsec:ignore:AWS006
  description       = "Allow internal access to firewall"
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.internal.id
  to_port           = 0
  type              = "ingress"
}

resource "aws_security_group_rule" "allow_all_out_internal" {
  cidr_blocks       = ["0.0.0.0/0"] #tfsec:ignore:AWS007
  description       = "Allow internal access from firewall"
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.internal.id
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group" "external" {
  name_prefix = "${var.name}-external"
  description = "FG external interface"
  tags        = var.tags
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "allow_fortiguard" {
  cidr_blocks       = ["0.0.0.0/0"] #tfsec:ignore:AWS006
  description       = "Allow FortiGate access"
  from_port         = 541
  protocol          = "tcp"
  security_group_id = aws_security_group.external.id
  to_port           = 541
  type              = "ingress"
}

resource "aws_security_group_rule" "allow_admin_https" {
  cidr_blocks       = var.allowed_admin_cidrs #tfsec:ignore:AWS006
  description       = "Allow administrative access from allowed CIDRs (HTTPS)"
  from_port         = var.https_admin_port
  protocol          = "tcp"
  security_group_id = aws_security_group.external.id
  to_port           = var.https_admin_port
  type              = "ingress"
}

resource "aws_security_group_rule" "allow_admin_ssh" {
  cidr_blocks       = var.allowed_admin_cidrs #tfsec:ignore:AWS006
  description       = "Allow administrative access from allowed CIDRs (SSH)"
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.external.id
  to_port           = 22
  type              = "ingress"
}

resource "aws_security_group_rule" "allow_admin_https_sgs" {
  count = var.allowed_admin_security_group_id != null ? 1 : 0

  description              = "Allow administrative access (HTTPS)"
  from_port                = var.https_admin_port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.external.id
  source_security_group_id = var.allowed_admin_security_group_id
  to_port                  = var.https_admin_port
  type                     = "ingress"
}

resource "aws_security_group_rule" "allow_admin_ssh_sgs" {
  count = var.allowed_admin_security_group_id != null ? 1 : 0

  description              = "Allow administrative access (SSH)"
  from_port                = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.external.id
  source_security_group_id = var.allowed_admin_security_group_id
  to_port                  = 22
  type                     = "ingress"
}

resource "aws_security_group_rule" "allow_all_out_external" {
  cidr_blocks       = ["0.0.0.0/0"] #tfsec:ignore:AWS007
  description       = "Allow outbound egress for firewall"
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.external.id
  to_port           = 0
  type              = "egress"
}

resource "aws_route53_record" "this" {
  count   = var.create_route53_address ? 1 : 0
  name    = var.route53_address
  records = [aws_eip.this.public_ip]
  ttl     = "60"
  type    = "A"
  zone_id = var.route53_zone_id
}
