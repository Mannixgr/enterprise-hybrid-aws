terraform { 
    backend "s3"{
        bucket = "mannix-enterprise-hybrid-aws-tfstate"
        key    = "enterprise-hybrid-aws/terraform.tfstate"
        region = "ca-central-1"
        use_lockfile = true 
        encrypt = true 
    }
}
