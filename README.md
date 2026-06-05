# Terraform Modules

## Why Modules Exist

Let's start with a real scenario.

Imagine your company has multiple environments:

- Dev
- QA
- Stage
- Prod

Each environment requires:

- VPC
- Subnets
- Security Groups
- EC2

### Without Modules

```text
dev.tf
qa.tf
stage.tf
prod.tf
```

Each file contains approximately:

```text
500 lines
```

Total:

```text
2000+ lines
```

Result: **Maintenance nightmare.**

---

## Real-World Analogy

### Without Modules

Building every car from raw metal.

### With Modules

Using reusable components:

- Engine
- Wheels
- Doors
- Chassis

Terraform modules are **reusable infrastructure components**.

---

# What Is a Module?

A module is simply:

> A collection of Terraform files that performs a specific task.

### Example: VPC Module

Creates:

- VPC
- Subnets
- Route Tables
- Internet Gateway (IGW)

Then it can be reused across multiple projects and environments.

---

## Important Fact

Everything in Terraform is a module.

Even your current Terraform project folder is considered a:

**Root Module**

---

# Root Module vs Child Module

This is a very common interview question.

## Root Module

Your current Terraform project:

```text
terraform-prod-lab/

├── main.tf
├── variables.tf
└── outputs.tf
```

This entire directory is called the:

**Root Module**

---

## Child Module

Example:

```text
modules/

└── vpc/
    ├── main.tf
    ├── variables.tf
    └── outputs.tf
```

This is a reusable module.

### Relationship

```text
Root Module
    ↓
VPC Module
    ↓
Creates VPC
```

---

# Visual Architecture

### Before

```text
main.tf

1000+ lines
```

### After

```text
root/

├── modules
│   ├── vpc
│   ├── ec2
│   └── security-group
│
└── environments
```

This is a common production-grade structure.

---

# First Module Creation

Let's convert a VPC configuration into a module.

### Create Folder Structure

```text
modules/

└── vpc/
    ├── main.tf
    ├── variables.tf
    └── outputs.tf
```

---

# Module Variables

**modules/vpc/variables.tf**

```hcl
variable "vpc_cidr" {
  type = string
}
```

---

# Module Resource

**modules/vpc/main.tf**

```hcl
resource "aws_vpc" "main" {

  cidr_block = var.vpc_cidr

  tags = {
    Name = "module-vpc"
  }

}
```

---

# Module Output

**modules/vpc/outputs.tf**

```hcl
output "vpc_id" {
  value = aws_vpc.main.id
}
```

---

# Calling a Module

From the Root Module:

```hcl
module "vpc" {

  source = "./modules/vpc"

  vpc_cidr = "10.0.0.0/16"

}
```

Terraform workflow:

```text
Root Module
    ↓
Calls VPC Module
    ↓
Creates VPC
```

---

# Accessing Outputs

Module exposes:

```hcl
output "vpc_id"
```

Consume it using:

```hcl
module.vpc.vpc_id
```

Example:

```hcl
resource "aws_subnet" "public" {

  vpc_id = module.vpc.vpc_id

}
```

---

# Interview Question

## Q: Difference Between Resource Output and Module Output?

### Answer

**Resource Output**

Exposes values from resources.

Example:

```hcl
aws_vpc.main.id
```

**Module Output**

Exposes values from a module to its parent module.

Example:

```hcl
module.vpc.vpc_id
```

---

# Module Inputs and Outputs

Think of a module like a function.

```text
INPUTS
   ↓
 MODULE
   ↓
OUTPUTS
```

### Python Example

```python
def create_vpc(cidr):
    return vpc_id
```

### Terraform Equivalent

```hcl
module "vpc" {
  vpc_cidr = "10.0.0.0/16"
}
```

Same concept.

---

# Production Module Structure

Most organizations use something similar to:

```text
modules/

├── vpc
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── README.md
│
├── ec2
├── alb
├── rds
└── eks
```

---

# Module Versioning

A major interview topic.

Imagine:

```text
VPC Module v1
```

Used by:

```text
20 projects
```

You modify the module.

Everything breaks.

Versioning helps prevent this.

### Git Source Example

```hcl
module "vpc" {

  source  = "git::https://repo.git"
  version = "1.2.0"

}
```

### Terraform Registry Example

```hcl
module "vpc" {

  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.0"

}
```

Versioning is a production requirement.

---

# Terraform Registry

Terraform provides an official registry of reusable modules.

Popular modules include:

- VPC
- EKS
- RDS
- ALB
- IAM

---

# Building a Proper EC2 Module

## Module Structure

```text
modules/ec2
```

### Variables

```hcl
variable "instance_type" {}
variable "subnet_id" {}
variable "name" {}
```

### Resource

```hcl
resource "aws_instance" "this" {

  ami           = "ami-xxxx"
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  tags = {
    Name = var.name
  }

}
```

### Output

```hcl
output "instance_id" {
  value = aws_instance.this.id
}
```

### Root Module Usage

```hcl
module "app_server" {

  source = "./modules/ec2"

  instance_type = "t2.micro"
  subnet_id     = module.vpc.public_subnet
  name          = "app"

}
```

---

# Module Design Patterns (3+ Year Engineer Level)

## Pattern 1 — Single Responsibility

### Good

VPC Module creates only:

- VPC
- Subnets
- Route Tables
- Internet Gateway

### Bad

One giant module creates:

- VPC
- EC2
- RDS
- IAM

Keep modules focused.

---

## Pattern 2 — Generic Modules

### Bad

```text
prod-vpc-module
```

### Good

```text
vpc-module
```

Use inputs to control behavior instead of creating environment-specific modules.

---

## Pattern 3 — Output Only What Is Needed

### Bad

```text
50 outputs
```

### Good

```text
vpc_id
subnet_ids
```

Expose only necessary values.

---

## Pattern 4 — Strong Typing

### Good

```hcl
variable "subnets" {
  type = list(string)
}
```

### Avoid

```hcl
type = any
```

Use explicit types whenever possible.

---

# Key Takeaways

✅ Modules improve reusability

✅ Reduce code duplication

✅ Simplify maintenance

✅ Make infrastructure scalable

✅ Enable standardization across environments

✅ Follow single-responsibility design

✅ Use versioning in production

✅ Expose only necessary outputs

✅ Prefer strong typing over `any`

Terraform modules are the foundation of scalable and maintainable Infrastructure as Code (IaC).
