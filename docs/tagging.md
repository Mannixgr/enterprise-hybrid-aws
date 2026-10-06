# Cost Optimizer Lab
## Tagging Standard


Project Owner : Mannix Graham 

Status: In Progress 

Last Update -  2026-10-06

AWS tags are a way to get a better breakdown on cost data. It allows you to get the cost based on users, services and projects. If tags are not added then the cost optimizer could say "ec2 cost was $40" but it would not tell you the cost of something like dev network NAT gateway.  So tagging all products will give you a better break down of cost. 

| Key | Example | Where it's set | Why Optimizer would need it| Allowed Values | 
|:-------|:--------|:--------|:--------|:--------|
|Project | enterprise-hybrid-aws| provider default_tags | Top level cost grouping|enterprise-hybrid-aws
| Environment| dev| provider default_tags| Will treat the dev env differently than prod| dev, bootstrap, prod 
| Owner| Mannix| provider default_tags| Who get the recommendation| Mannix
| ManagedBy| terraform |provider default_tags| Tells IaC resources from hand made ones. Hand made resoruces can not be fixed with a plan|terraform, manual
|Purpose| network/ waste-lab| module-level, required | Which workload does it belong to| network 
| ExpiresOn| 2026-10-31| module-level, optional| A free waste detector: anything past the expiry date is waste by the definition.|YYYY-MM-DD

## Rules

1. **Required tags.** Every resource must have `Project`, `Environment`, `Owner`,
   `ManagedBy`, and `Purpose`. `ExpiresOn` is optional, but required for anything
   in `waste-lab`.
2. **Naming.** Keys use PascalCase (`ExpiresOn`). Values use lowercase-kebab
   (`waste-lab`). Tags are case-sensitive: `dev` and `Dev` count as two
   different environments in Cost Explorer. Exception: Owner uses the person's name as written (e.g., Mannix)
3. **Allowed values only.** Use only the values listed in the table. To add a
   new value, update this document first, in a PR.
4. **Where tags are set.**
   - `Project`, `Environment`, `Owner`, `ManagedBy` → provider `default_tags` only.
   - `Purpose`, `ExpiresOn` → module or resource level only.
   - Never set the same key in both places.
5. **Hand-made resources.** Anything created in the console must be tagged by
   hand with `ManagedBy = manual`, or imported into Terraform. Untagged resources
   are treated as findings by the cost optimizer.
6. **Expiry.** A resource past its `ExpiresOn` date is considered waste and may
   be destroyed without further notice.
7. **Cost allocation.** Every required key must be activated as a cost
   allocation tag in Billing once it exists on a resource.
8. **Changes to this standard** go through a pull request, like code.
