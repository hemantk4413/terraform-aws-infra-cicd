resource "aws_s3_bucket" "demo_bucket" {
  bucket = "my-tf-${var.env}-bucket4413"

  tags = {
    Name        = "my-tf-${var.env}-bucket"
    Environment = var.env
  }
}
