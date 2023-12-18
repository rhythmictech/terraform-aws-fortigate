resource "aws_s3_bucket" "config" {
  count  = var.create_config_bucket ? 1 : 0
  bucket = var.config_bucket_name
  tags   = var.tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "config" {
  count  = var.create_config_bucket ? 1 : 0
  bucket = aws_s3_bucket.config[0].bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "config" {
  count  = var.create_config_bucket ? 1 : 0
  bucket = aws_s3_bucket.config[0].id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "config" {
  count                   = var.create_config_bucket ? 1 : 0
  bucket                  = aws_s3_bucket.config[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Pull in secret via a data source due to there being a bug in tf
# when attempting to pass the secret in as a template argument
# directly from the module
#data "aws_secretsmanager_secret" "password" {
  #count = var.load_default_config ? 1 : 0
  #arn   = module.fortigate_password.secret_arn
#}

#data "aws_secretsmanager_secret_version" "password" {
  #count     = var.load_default_config ? 1 : 0
  #secret_id = data.aws_secretsmanager_secret.password[0].id
#}

resource "aws_s3_object" "default_config" {
  count  = var.load_default_config ? 1 : 0

  bucket  = var.config_bucket_name
  key     = var.config_bucket_config_file
  content = templatefile("${path.module}/config.tpl",
    {
      # this should work but doesn't due to a tf bug
      https_port = var.https_admin_port
      password   = module.fortigate_password[0].secret
      #password   = data.aws_secretsmanager_secret_version.password[0].secret_string
  })

}
