variable "vpc" {

}


variable "subnet1" {


}
variable "subnet2" {


}
variable "subnet3" {


}
variable "subnet4" {


}







variable "my_public_ip" {

}

variable "my_ami" {

}

variable "my_instance_type" {

}

variable "ssh_public_key" {

}

variable "web_port" {
  type = number
}

variable "ingress_ports" {
  description = "Ingress ports list"
  type        = list(number)

}
