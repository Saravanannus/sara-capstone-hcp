resource "aws_s3_bucket" "name2" {
  bucket = "grp1-hcp-terraform-bucket-prod"
}

resource "aws_s3_bucket" "name3" {
  bucket = "grp1-hcp-terraform-bucket-prod-2"
}
resource "aws_s3_bucket" "name4" {
  bucket = "grp1-hcp-terraform-bucket-prod-4"
}