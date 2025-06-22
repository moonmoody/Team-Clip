locals {
  multiRegion = {
    "ap-northeast-2" : "172.16.0.0/16",
    "ap-southeast-2" : "172.17.0.0/16"
  }
}


variable "pjtName" {
  type        = string
  description = "프로젝트 이름?: "
  default     = "clip"
}

variable "region" {
  type = string
  #   default     = keys(local.multiRegion)[0]
  default     = "ap-northeast-2"
  description = "사용할 리전?[ap-northeast-2 / ap-southeast-2]: "
}