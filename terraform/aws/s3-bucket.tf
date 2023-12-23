resource "aws_s3_bucket" "memes" {
    bucket = "${var.project}-memes-bucket"
    force_destroy = true
    versioning {
        enabled = true
    }

    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
            }
        }
    }
}

# resource "aws_s3_bucket" "memes" {
#   bucket = "my-unique-bucket-name"  # Replace with your unique bucket name
#   acl    = "public-read"            # This makes the bucket publicly readable

# #   website {
# #     index_document = "index.html"  # Specify the index document
# #   }
# }


resource "aws_s3_bucket_object" "my_app" {
  bucket = aws_s3_bucket.memes.bucket
  key    = "api.zip"
  source = "./templates/api.zip"  # Path to your ZIP file on your local machine
  etag   = filemd5("./templates/api.zip")
}
