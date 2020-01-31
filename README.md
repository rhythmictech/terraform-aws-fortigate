# terraform-aws-fortigate

[![](https://github.com/rhythmictech/terraform-aws-fortigate/workflows/check/badge.svg)](https://github.com/rhythmictech/terraform-aws-fortigate/actions)

Create a FortiGate VM. This module can optionally pre-configure the FortiGate, either using a configuration file supplied by you (in an S3 bucket) or by simply loading a basic config that ensures the firewall is reachable over the assigned Elastic IP. This is useful when you don't have other means of connectivity into the VPC.

## Usage
```
module "firewall" {
  source         = "git::https://github.com/rhythmictech/terraform-aws-fortigate"
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
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| allowed\_admin\_cidrs | Public CIDRs that will be able to access the FortiGate admin ports | list(string) | `[ "0.0.0.0/0" ]` | no |
| allowed\_admin\_security\_group\_id | Security group allowed to access admininstrative ports | string | `""` | no |
| config\_bucket\_config\_file | Name of the configuration file in the S3 bucket | string | `"fortigate.conf"` | no |
| config\_bucket\_license\_file | Name of the license file \(leave blank if using on demand\) | string | `""` | no |
| config\_bucket\_name | Name of config bucket. If `create\_config\_bucket = true`, a bucket with this name will be created. | string | `""` | no |
| config\_bucket\_region | Region that the S3 bucket is in. Required when the bucket is not created by this module. | string | `""` | no |
| create\_config\_bucket | Create a bucket for configuration auto loading | bool | `"false"` | no |
| create\_config\_bucket\_iam\_policy | Attach an IAM policy granting the FortiGate instance read access to all objects in the bucket. | bool | `"true"` | no |
| create\_route53\_address | Associate a Route53 entry to the public EIP | bool | `"false"` | no |
| enable\_auto\_config | Enable auto configuration | bool | `"false"` | no |
| enable\_sdn\_access | Enable FortiGate SDN access to AWS resources | bool | `"false"` | no |
| external\_subnet\_id | Subnet ID to use for public interface | string | n/a | yes |
| https\_admin\_port | HTTPS port for administrative access | number | `"443"` | no |
| instance\_type |  | string | `"m5.large"` | no |
| internal\_subnet\_id | Subnet ID to use for internal interface | string | n/a | yes |
| load\_default\_config | Place a default configuration file in the config bucket with the specified name | bool | `"false"` | no |
| name | Name of this Fortigate instance | string | `"fortigate"` | no |
| override\_ami | Specify to force a specific AMI | string | `""` | no |
| route53\_address | Route 53 address \(do not include full domain\) | string | `""` | no |
| route53\_zone\_id |  | string | `""` | no |
| tags | Tags to apply to supported resources \(don't include name tag\) | map(string) | `{}` | no |
| use\_byol | Use BYOL license \(as opposed to on demand pricing\) | bool | `"false"` | no |
| vpc\_id | VPC to create resources in | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| eip\_fortigate | Elastic IP address of firewall |
| instance\_fortigate | Fortigate Instance ID |
| instance\_fortigate\_primary\_network\_interface\_id | Primary ENI ID \(attach route tables to this\) |
| keypair\_key\_name | Instance keypair name |
| s3\_bucket\_config | S3 bucket holding configuration |
| secretsmanager\_secret\_arn | FortiGate admin password secret |
| security\_group\_external | Security group for external access |
| security\_group\_internal | Security group for internal access |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
