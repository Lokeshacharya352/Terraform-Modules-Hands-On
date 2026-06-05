# Terraform-Modules-Hands-On

Module 6 — Modules Deep Dive
Why modules exist
Parent vs Child modules
Inputs / Outputs
Module structure
Reusable modules
Registry modules
Versioning
Module design patterns


# WHY MODULES EXIST

Let's start with a real scenario.

Imagine your company has:
'''
Dev
QA
Stage
Prod
'''
Each environment requires:
'''
VPC
Subnets
Security Groups
EC2
'''
Without modules:

dev.tf
qa.tf
stage.tf
prod.tf

Each file:

500 lines

Total:

2000+ lines

Nightmare.

# Real-world Analogy

Think:

Without modules:

Building every car from raw metal.

With modules:

Using reusable engine,
wheels,
doors,
chassis.

Terraform modules are reusable infrastructure components.

# WHAT IS A MODULE?

## A module is simply:

## A collection of Terraform files that performs a specific task.

Example:

VPC Module

Creates:
  VPC
  Subnets
  Route Tables
  IGW

Then reused everywhere.

# IMPORTANT FACT

Everything in Terraform is a module.

Even:

root folder

is actually the:

Root Module

# ROOT MODULE vs CHILD MODULE

### Interview favorite.

Root Module

Current project:

terraform-prod-lab/

main.tf

variables.tf

outputs.tf

This is:

Root Module
Child Module

Example:

modules/

vpc/

main.tf

variables.tf

outputs.tf

Reusable module.

Relationship:
'''
Root Module

     ↓

VPC Module

     ↓

Creates VPC
'''

# VISUAL ARCHITECTURE
 
Current:

main.tf

1000 lines

Target:

root

'''
├── modules

│   ├── vpc

│   ├── ec2

│   └── security-group

└── environments
'''

Production standard.

# FIRST MODULE CREATION

Let's convert your VPC into module.

Create Folder
modules/

└── vpc

Inside:

modules/vpc/
'''
main.tf

variables.tf

outputs.tf
'''

# MODULE VARIABLES

modules/vpc/variables.tf

variable "vpc_cidr" {
 type = string
}

# MODULE RESOURCE

modules/vpc/main.tf

resource "aws_vpc" "main" {

 cidr_block = var.vpc_cidr

 tags = {

   Name = "module-vpc"

 }

}
# MODULE OUTPUT

modules/vpc/outputs.tf

output "vpc_id" {

 value = aws_vpc.main.id

}

# CALLING MODULE

Root module:

module "vpc" {

 source = "./modules/vpc"

 vpc_cidr = "10.0.0.0/16"

}

Terraform:
'''
Root

↓

Calls VPC Module

↓

Creates VPC
'''

# ACCESSING OUTPUTS

Module exposes:

output "vpc_id"

Consume:

module.vpc.vpc_id

Example:

resource "aws_subnet" "public" {

 vpc_id = module.vpc.vpc_id

}

# INTERVIEW QUESTION

### Q: Difference between resource output and module output?

### A: Resource output exposes values from resources. Module output exposes values from a module to its parent module.

# MODULE INPUTS & OUTPUTS

Think:

Module

INPUTS
 ↓
WORK
 ↓
OUTPUTS


# PRODUCTION MODULE STRUCTURE

Most companies use:
'''
modules/

├── vpc

│   ├── main.tf

│   ├── variables.tf

│   ├── outputs.tf

│   └── README.md

├── ec2

├── alb

├── rds

├── eks
'''

# MODULE VERSIONING

Huge interview topic.

Imagine:

VPC Module v1

used by:

20 projects

You modify module.

Everything breaks.

Need versioning.

Example:

module "vpc" {

 source = "git::https://repo.git"

 version = "1.2.0"

}

Or registry:

module "vpc" {

 source = "terraform-aws-modules/vpc/aws"

 version = "5.1.0"

}

Production requirement.

# TERRAFORM REGISTRY

Official reusable modules.

Example:

Terraform Registry

Popular:

VPC
EKS
RDS
ALB
IAM

# BUILDING A PROPER EC2 MODULE

Module:

modules/ec2

Variables:

variable "instance_type" {}

variable "subnet_id" {}

variable "name" {}

Resource:

resource "aws_instance" "this" {

 ami="ami-xxxx"

 instance_type=var.instance_type

 subnet_id=var.subnet_id

 tags={

  Name=var.name

 }

}

Output:

output "instance_id" {

 value=
 aws_instance.this.id

}

Root:

module "app_server" {

 source="./modules/ec2"

 instance_type="t2.micro"

 subnet_id=module.vpc.public_subnet

 name="app"

}
# MODULE DESIGN PATTERNS (3+ YEAR ENGINEER)
## Pattern 1 — One Responsibility

Good:

VPC Module

Creates:

Only network

Bad:

VPC

EC2

RDS

IAM

One giant module.

## Pattern 2 — Generic Modules

Bad:

prod-vpc-module

Good:

vpc-module

Inputs decide behavior.

## Pattern 3 — Output Only Needed Values

Bad:

50 outputs

Good:

vpc_id

subnet_ids

Only what's needed.

## Pattern 4 — Strong Typing

Good:

variable "subnets" {

 type=list(string)

}

Avoid:

type=any
