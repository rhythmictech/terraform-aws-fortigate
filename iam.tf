data "aws_iam_policy_document" "assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  name_prefix        = var.name
  assume_role_policy = data.aws_iam_policy_document.assume.json
  tags               = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_iam_policy_document" "bucket_access" {
  statement {
    actions   = ["s3:GetObject"]
    effect    = "Allow"
    resources = ["arn:aws:s3:::${var.config_bucket_name}/*"]
  }
}

resource "aws_iam_policy" "bucket_access" {
  count       = var.enable_auto_config && var.create_config_bucket_iam_policy ? 1 : 0
  name_prefix = var.name
  policy      = data.aws_iam_policy_document.bucket_access.json
}

resource "aws_iam_role_policy_attachment" "bucket_access" {
  count      = var.enable_auto_config && var.create_config_bucket_iam_policy ? 1 : 0
  role       = aws_iam_role.this.id
  policy_arn = aws_iam_policy.bucket_access[0].arn
}

resource "aws_iam_role_policy_attachment" "sdn_access" {
  count      = var.enable_sdn_access ? 1 : 0
  role       = aws_iam_role.this.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_iam_instance_profile" "this" {
  name_prefix = var.name
  role        = aws_iam_role.this.name
}
