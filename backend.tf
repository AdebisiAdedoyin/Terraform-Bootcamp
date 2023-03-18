resource "aws_s3_bucket" "first-bucket" {
  bucket = var.my-first
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name = "My terraform-bucket"

  }
server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.mykey.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_dynamodb_table" "tflock" {
  name = "terraform-lock"
  hash_key = "LockID"
  read_capacity = 1
  write_capacity = 1
  attribute {
     name = "LockID"
     type = "S"
   }
  tags = {
    Name = "terraform lock table"
   }
   lifecycle {
   prevent_destroy = false
  }
 }

resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}
