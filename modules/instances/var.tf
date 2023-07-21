variable "name-pvt" {}
variable "name-pub" {}
variable "pub-ami" {
  type = string
}
variable "pvt-ami" {
  type = string
}
variable "pub-ins_type" {
  type = string
}
variable "pvt-ins_type" {
  type = string
}

variable "ec2_key_name" {
  type = string
}

variable "ec2_pvt-keyname" {
  type = string

}
variable "public-subnet" {}
variable "private-subnet" {}
variable "demovpc" {}
variable "role-name" {
  
}