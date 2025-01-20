variable "bucket_name" {
  type = string  
  default = "narendiran-resume-2024-bucket"
}

variable "tags" {
  type = map(string)  
  default = {
    Name        = "narendiran-resume-2024-bucket"
    Environment = "Dev"
    created_through  = "terraform"
  }
}