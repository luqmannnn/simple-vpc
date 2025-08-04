variable "vpc_name" {
  description = "The VPC Name to use"
  type        = string
  default     = "ce11-tf-vpc"
}

variable "run_number" {
  description = "Run number to append to the VPC name"
  type        = string
}