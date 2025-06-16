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

variable "sgWebId" {
  type        = string
}

variable "natGwId" {
  type        = string
}