#provider

provider "aws" {
  region = "us-east-1"
}


#vpc

module "VPC" {
  source            = "./modules/vpc"
  name              = "Yishu"
  CIDR_block        = "10.0.0.0/16"
  public-cidr       = "10.0.0.0/18"
  private-cidr      = "10.0.128.0/18"
  availability_zone = "us-east-1a"
}

#EC2 instance

module "Instances" {

  #EC2 in public subnet
  source        = "./modules/instances"
  name-pub      = "Yishu-pub"
  demovpc       = module.VPC.demovpc
  pub-ami       = "ami-053b0d53c279acc90"
  pub-ins_type  = "t2.micro"
  ec2_key_name  = "key"
  public-subnet = module.VPC.public-subnet


  #EC2 in private subnet
  name-pvt        = "Yishu-pvt"
  pvt-ami         = "ami-053b0d53c279acc90"
  pvt-ins_type    = "t2.micro"
  private-subnet  = module.VPC.private-subnet
  ec2_pvt-keyname = "pvt_key"
  role-name       = module.iam.role-name
}

module "iam" {
  source      = "./modules/iam_role"
  bucket_name = module.s3-Bucket.bucket_name

}
module "s3-Bucket" {
  source                 = "./modules/S3-bucket"
  bucket-name            = "yishu1606"
  origin_access_identity = module.cdn.origin_access_identity
}

module "cdn" {
  source                      = "./modules/cloudfront"
  bucket_regional_domain_name = module.s3-Bucket.bucket_regional_domain_name
  website-endpoint            = module.s3-Bucket.website_endpoint
  bucket_name                 = module.s3-Bucket.bucket_name
}