# EKS

Terraform module to create a EKS cluster instance.

## Usage

```terraform
module "eks" {
  source = "github.com/benzene-tech/terraform-aws-eks?ref=v1.1.2"

  name_prefix = "example"
  vpc_id      = "vpc-12345"
  node_groups = {
    example = {
      subnet_type = private
      scaling     = {
        desired_size = 1
        max_size     = 2
        min_size     = 1
      }
    }
  }
}
```
