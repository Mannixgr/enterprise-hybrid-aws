# Enterprise Hybrid AWS Environment 
 
 This is a project that I am building to gain a better understanding of cloud computing mixed with a on Site homelab. The goal of the Project is to mimic enterprise infrastructure patterns. The project is supplied entirely as Code, deployed through secure CI/CD pipeline,monitored end to end and connected to the homelab. 

## What this demonstrates 

The goal of this project is to replace manual,click-ops cloud set up with the kind of workflow that you would see a team actually run :

Infrastructure as Code -  a multi AZ AWS VPC and core networking, equipped with Terraform instead of the console, so the entire environment can be reproduced by running one command. 

Secure CI/CD - deployments run through Github Actions using OIDC federation so there are no long lived AWS access keys stored anywhere. 

Monitoring & observability - CloudWatch and CloudTrail wired in from day one for visibility into infrastructure health and account activity. 

Hybrid Networking - the AWS VPC is linked to a real on premises homelab running Proxmox over a site to Site connection so this project expands beyond just a Cloud only sandbox. 

## Architecture 

![Hybrid AWS and homelab architecture diagram](docs/hybridhomelab.drawio.svg)

Multi-AZ VPC Provisioned via Terraform,deployed through GitHub actions Using OIDC, monitored with CloudWatch/CloudTrail and linked to on on prem homelab over a site to site VPN.
 

## Tech Stack 
| Layer | Tool |
|:-------|--------:|
|IAC   |Terraform (1.10+,native S3 state locking)|
|Cloud provider| AWS |
|CI/CD | GitHub Actions(OIDC auth)|
|Monitoring| CloudWatch,CloudTrail|
|Hybrid link| AWS Site to Site VPN <-> Proxmox Homelab|

## Repository Structure
```
.
├── modules/
│   ├── network/       # VPC, subnets, route tables, NAT
│   └── cicd-oidc/       # OIDC provider + IAM role for GitHub Actions. 
├── environments/
│   ├── dev/            # Environment-specific tfvars and backend config
│   └── bootstrap/      # OIDC provider + IAM role, applied manually once
├── .github/
│   └── workflows/     # CI/CD pipelines (plan on PR, apply on merge)
└── README.md
```

## SetUp 
Deployment Automation is completed. When a PR is opened touching `environments/dev/` or `modules/network/`-> GitHub Actions runs `terraform plan` automatically via OIDC so changes can be reviewed. Once the PR is merged to `main`, GitHub Actions runs `terraform apply` automatically which means nobody has to run terraform by hand and no long lived AWS credentials are required in the process. 
## Roadmap
- [x] Repo scaffolded with module structure
- [x] AWS account Hygiene - MFA,billing alerts,CloudTrail 
- [x] Terraform Remote state backend (S3 native locking)
- [x]  Multi-AZ VPC module 
- [x]  GitHub Actions OIDC Pipeline (Plan on PR,apply on merge)
- [ ] Site to Site VPN link to homelab 
- [ ]  CloudWatch dashboard + alarms 

## Status 
In Progress. This README will be updated as I complete the project.
## License 
MIT


