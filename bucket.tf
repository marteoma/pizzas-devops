resource "aws_s3_bucket" "pizzas-rampup-frontend" {
  bucket  = "pizzas-bucket"
  acl     = "public-read"
  website {
    index_document = "index.html"
    error_document = "index.html"
  }
  tags    = var.tags
}