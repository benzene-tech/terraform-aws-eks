# EKS

Terraform module to create a EKS cluster instance.

## Usage

```terraform
module "eks" {
  source = "github.com/benzene-tech/terraform-aws-eks?ref=v2.0.0"

  name = "example"
  subnets = ["subnet-01234", "subnet-56789"]
  auto_mode = {
    node_pools = ["system", "general-purpose"]
  }
}
```
