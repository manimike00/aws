data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = ""
    key    = ""
    region = ""
  }
}