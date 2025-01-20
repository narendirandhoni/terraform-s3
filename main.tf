resource "aws_s3_bucket" "s3_resume" {
  bucket = var.bucket_name

  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "resume_public_access" {
  bucket = aws_s3_bucket.s3_resume.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "resume_bucket_ownership" {
  bucket = aws_s3_bucket.s3_resume.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "resume_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.resume_bucket_ownership,
    aws_s3_bucket_public_access_block.resume_public_access,
  ]

  bucket = aws_s3_bucket.s3_resume.id
  acl    = "public-read"
}

resource "aws_s3_object" "indexfile" {
  bucket = aws_s3_bucket.s3_resume.id
  key    = "index.html"
  source = "index.html"
  etag = filemd5("index.html")
  content_type = "text/html"
}

resource "aws_s3_object" "errorfile" {
  bucket = aws_s3_bucket.s3_resume.id
  key    = "error.html"
  source = "error.html"
  etag = filemd5("error.html")
  content_type = "text/html"
}

resource "aws_s3_object" "profilepic" {
  bucket = aws_s3_bucket.s3_resume.id
  key    = "profile.JPG"
  source = "profile.JPG"
  etag = filemd5("profile.JPG")
  content_type  = "image/jpeg"
}

resource "aws_s3_bucket_policy" "resume_bucket_policy" {
  bucket = aws_s3_bucket.s3_resume.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = "s3:GetObject"
        Resource = "${aws_s3_bucket.s3_resume.arn}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_website_configuration" "resume_website_configuration" {
  bucket = aws_s3_bucket.s3_resume.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  depends_on = [ aws_s3_bucket_acl.resume_acl ]
}