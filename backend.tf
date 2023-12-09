terraform {
  backend "s3" {
    bucket = "infra-gbrother"
    key    = "gbrother-tfstates"
    region = "ap-northeast-2"
  }
}
