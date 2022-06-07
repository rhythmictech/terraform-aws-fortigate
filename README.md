# terraform-aws-fortigate

[![tflint](https://github.com/rhythmictech/terraform-aws-fortigate/workflows/tflint/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-fortigate/actions?query=workflow%3Atflint+event%3Apush+branch%3Amaster)
[![tfsec](https://github.com/rhythmictech/terraform-aws-fortigate/workflows/tfsec/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-fortigate/actions?query=workflow%3Atfsec+event%3Apush+branch%3Amaster)
[![yamllint](https://github.com/rhythmictech/terraform-aws-fortigate/workflows/yamllint/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-fortigate/actions?query=workflow%3Ayamllint+event%3Apush+branch%3Amaster)
[![misspell](https://github.com/rhythmictech/terraform-aws-fortigate/workflows/misspell/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-fortigate/actions?query=workflow%3Amisspell+event%3Apush+branch%3Amaster)
[![pre-commit-check](https://github.com/rhythmictech/terraform-aws-fortigate/workflows/pre-commit-check/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-fortigate/actions?query=workflow%3Apre-commit-check+event%3Apush+branch%3Amaster)
<a href="https://twitter.com/intent/follow?screen_name=RhythmicTech"><img src="https://img.shields.io/twitter/follow/RhythmicTech?style=social&logo=twitter" alt="follow on Twitter"></a>

Create a FortiGate VM. This module can optionally pre-configure the FortiGate, either using a configuration file supplied by you (in an S3 bucket) or by simply loading a basic config that ensures the firewall is reachable over the assigned Elastic IP. This is useful when you don't have other means of connectivity into the VPC.

## Usage
```
module "firewall" {
  source         = "rhythmictech/fortigate/aws"
  config_bucket_name   = "${local.account_id}-${var.region}-fortigate-config"
  create_config_bucket = true
  enable_auto_config   = true
  external_subnet_id   = "subnet-01234567890"
  instance_type        = "t3.large"
  internal_subnet_id   = "subnet-01234567891"
  load_default_config  = true
  vpc_id               = "vpc-01234567890"
}
```

*Warning*: When using the default config bootstrapper, an admin password is set. This password is stored in Secrets Manager but is ultimately pulled into the bootstrap config file stored in S3. This means that it is both in S3 and in the tfstate file unencrypted.

For production use, it is recommended to change the password after provisioning and update Terraform to not attempt to load a default config, which will then cause the temporary secret to be removed from both S3 and Secrets Manager.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.8 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.17.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_fortigate_password"></a> [fortigate\_password](#module\_fortigate\_password) | rhythmictech/secretsmanager-random-secret/aws | ~> 1.4 |
| <a name="module_keypair"></a> [keypair](#module\_keypair) | rhythmictech/secretsmanager-keypair/aws | ~> 0.0.4 |

## Resources

| Name | Type |
|------|------|
| [aws_eip.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_eip_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip_association) | resource |
| [aws_iam_instance_profile.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.bucket_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.bucket_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.sdn_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_network_interface.outbound](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface) | resource |
| [aws_route53_record.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_s3_bucket.config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_object.default_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object) | resource |
| [aws_s3_bucket_public_access_block.config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_security_group.external](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.internal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.allow_admin_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.allow_admin_https_sgs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.allow_admin_ssh](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.allow_admin_ssh_sgs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.allow_all_internal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.allow_all_out_external](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.allow_all_out_internal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.allow_fortiguard](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_ami.byol](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_ami.ondemand](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_iam_policy_document.assume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.bucket_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_secretsmanager_secret.password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |
| [aws_secretsmanager_secret_version.password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_admin_cidrs"></a> [allowed\_admin\_cidrs](#input\_allowed\_admin\_cidrs) | Public CIDRs that will be able to access the FortiGate admin ports | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_allowed_admin_security_group_id"></a> [allowed\_admin\_security\_group\_id](#input\_allowed\_admin\_security\_group\_id) | Security group allowed to access admininstrative ports | `string` | `null` | no |
| <a name="input_ami_account_id"></a> [ami\_account\_id](#input\_ami\_account\_id) | AWS account holding Fortinet AMI (GovCloud uses `874634375141`) | `string` | `"679593333241"` | no |
| <a name="input_ami_byol_filter"></a> [ami\_byol\_filter](#input\_ami\_byol\_filter) | AMI name string for on demand FG AMI | `string` | `"FortiGate-VM64-AWS build*"` | no |
| <a name="input_ami_ondemand_filter"></a> [ami\_ondemand\_filter](#input\_ami\_ondemand\_filter) | AMI name string for on demand FG AMI | `string` | `"FortiGate-VM64-AWSONDEMAND*"` | no |
| <a name="input_config_bucket_config_file"></a> [config\_bucket\_config\_file](#input\_config\_bucket\_config\_file) | Name of the configuration file in the S3 bucket | `string` | `"fortigate.conf"` | no |
| <a name="input_config_bucket_license_file"></a> [config\_bucket\_license\_file](#input\_config\_bucket\_license\_file) | Name of the license file (leave blank if using on demand) | `string` | `""` | no |
| <a name="input_config_bucket_name"></a> [config\_bucket\_name](#input\_config\_bucket\_name) | Name of config bucket. If `create_config_bucket = true`, a bucket with this name will be created. | `string` | `""` | no |
| <a name="input_config_bucket_region"></a> [config\_bucket\_region](#input\_config\_bucket\_region) | Region that the S3 bucket is in. Required when the bucket is not created by this module. | `string` | `""` | no |
| <a name="input_create_config_bucket"></a> [create\_config\_bucket](#input\_create\_config\_bucket) | Create a bucket for configuration auto loading | `bool` | `false` | no |
| <a name="input_create_config_bucket_iam_policy"></a> [create\_config\_bucket\_iam\_policy](#input\_create\_config\_bucket\_iam\_policy) | Attach an IAM policy granting the FortiGate instance read access to all objects in the bucket. | `bool` | `true` | no |
| <a name="input_create_keypair"></a> [create\_keypair](#input\_create\_keypair) | Whether to create a keypair for this instance, which will be stored in Secrets Manager | `bool` | `true` | no |
| <a name="input_create_route53_address"></a> [create\_route53\_address](#input\_create\_route53\_address) | Associate a Route53 entry to the public EIP | `bool` | `false` | no |
| <a name="input_enable_auto_config"></a> [enable\_auto\_config](#input\_enable\_auto\_config) | Enable auto configuration | `bool` | `false` | no |
| <a name="input_enable_sdn_access"></a> [enable\_sdn\_access](#input\_enable\_sdn\_access) | Enable FortiGate SDN access to AWS resources | `bool` | `false` | no |
| <a name="input_external_subnet_id"></a> [external\_subnet\_id](#input\_external\_subnet\_id) | Subnet ID to use for public interface | `string` | n/a | yes |
| <a name="input_https_admin_port"></a> [https\_admin\_port](#input\_https\_admin\_port) | HTTPS port for administrative access | `number` | `443` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type for FG | `string` | `"m5.large"` | no |
| <a name="input_internal_subnet_id"></a> [internal\_subnet\_id](#input\_internal\_subnet\_id) | Subnet ID to use for internal interface | `string` | n/a | yes |
| <a name="input_keypair"></a> [keypair](#input\_keypair) | Keypair to use for EC2 instance (set to blank to omit a keypair, not used if `create_keypair==true`) | `string` | `null` | no |
| <a name="input_load_default_config"></a> [load\_default\_config](#input\_load\_default\_config) | Place a default configuration file in the config bucket with the specified name | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of this Fortigate instance | `string` | `"fortigate"` | no |
| <a name="input_override_ami"></a> [override\_ami](#input\_override\_ami) | Specify to force a specific AMI | `string` | `""` | no |
| <a name="input_route53_address"></a> [route53\_address](#input\_route53\_address) | Route 53 address (do not include full domain) | `string` | `""` | no |
| <a name="input_route53_zone_id"></a> [route53\_zone\_id](#input\_route53\_zone\_id) | n/a | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to supported resources (don't include name tag) | `map(string)` | `{}` | no |
| <a name="input_use_byol"></a> [use\_byol](#input\_use\_byol) | Use BYOL license (as opposed to on demand pricing) | `bool` | `false` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC to create resources in | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eip_fortigate"></a> [eip\_fortigate](#output\_eip\_fortigate) | Elastic IP address of firewall |
| <a name="output_instance_fortigate"></a> [instance\_fortigate](#output\_instance\_fortigate) | Fortigate Instance ID |
| <a name="output_instance_fortigate_primary_network_interface_id"></a> [instance\_fortigate\_primary\_network\_interface\_id](#output\_instance\_fortigate\_primary\_network\_interface\_id) | Primary ENI ID (attach route tables to this) |
| <a name="output_keypair_key_name"></a> [keypair\_key\_name](#output\_keypair\_key\_name) | Instance keypair name |
| <a name="output_s3_bucket_config"></a> [s3\_bucket\_config](#output\_s3\_bucket\_config) | S3 bucket holding configuration |
| <a name="output_secretsmanager_secret_arn"></a> [secretsmanager\_secret\_arn](#output\_secretsmanager\_secret\_arn) | FortiGate admin password secret |
| <a name="output_security_group_external"></a> [security\_group\_external](#output\_security\_group\_external) | Security group for external access |
| <a name="output_security_group_internal"></a> [security\_group\_internal](#output\_security\_group\_internal) | Security group for internal access |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
