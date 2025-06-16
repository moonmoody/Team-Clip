variable "pjtName" {
  type        = string
  description = "프로젝트 이름은?: "
}

variable "region" {
  type        = string
}

variable "subId" {
  type        = list(any)
}

variable "sgAlbId" {
  type        = string
}

variable "vpcId" {
  type        = string
}

variable "instanceId" {
  type        = list(any)
}
