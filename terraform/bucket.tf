resource "aws_s3_bucket" "my_bucket" {
  bucket = "sctp-ce11-tfstate"
  force_destroy = true
}
