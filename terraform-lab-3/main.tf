module "network" {

  source                     = "./network"
  vpc_cidr_block             = "10.0.0.0/16"
  allow_all_ipv4_cidr_blocks = "0.0.0.0/0"
  web_subnet_list = [
    "10.0.0.0/24",
    "10.0.2.0/24",
    "10.0.1.0/24",
    "10.0.3.0/24",
  ]
  web_subnet   = "10.0.0.0/24"
  web_subnet_2 = "10.0.2.0/24"
  web_subnet_3 = "10.0.1.0/24"
  web_subnet_4 = "10.0.3.0/24"
  aws_region   = "us-east-1"
  subnet_zone  = "us-east-1a"
  AZS = [

    "us-east-1b",
    "us-east-1c"
  ]
  main_vpc_name = "Main VPC"






}

module "ec2" {
  source = "./ec2"
  my_ami = "ami-0b5eea76982371e91"
  #ami-00874d747dde814fa
  my_instance_type = "t2.micro"
  ssh_public_key   = "~/.ssh/test_rsa.pub"
  web_port         = 80
  ingress_ports = [
    22,
    80,
    8080,

  ]
  my_public_ip = "45.243.201.221"
  vpc          = module.network.vpc_id
  subnet1      = module.network.subnet1_id
  subnet2      = module.network.subnet2_id
  subnet3      = module.network.subnet3_id
  subnet4      = module.network.subnet4_id
  vmid1 = module.ec2.vmid1

}


module "loadbalancers" {


  source         = "./loadbalancers"
  vpc            = module.network.vpc_id
  webid1         = module.network.subnet1_id
  webid2         = module.network.subnet2_id
  webid3         = module.network.subnet3_id
  webid4         = module.network.subnet4_id
  lbarnpublic  = module.loadbalancers.lbarnpublic
  lbarnprivate = module.loadbalancers.lbarnprivate
  vmid1          = module.ec2.vmid1
  vmid2          = module.ec2.vmid2
  vmid3          = module.ec2.vmid3
  vmid4          = module.ec2.vmid4
  public_cidr    = module.ec2.public_cidr
  protocol       = module.ec2.protocol
  port80         = module.ec2.port80


}
