# AWS EKS Cluster (Terraform)

Provisions a managed Kubernetes cluster on AWS using EKS, built on the
`terraform-aws-modules/vpc` and `terraform-aws-modules/eks` community modules.

## What this creates

- A VPC with public + private subnets across 3 AZs, NAT gateway, and the
  subnet tags EKS/AWS Load Balancer Controller expect
- An EKS control plane
- Core add-ons: CoreDNS, kube-proxy, VPC CNI, EBS CSI driver
- A managed node group (autoscaling group of worker nodes)
- IAM roles/policies required for the above (handled by the modules)

## Prerequisites

- Terraform >= 1.5
- AWS CLI configured with credentials that have permissions to create
  VPC/EKS/IAM/EC2 resources
- `kubectl` (to interact with the cluster afterward)

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars to taste

terraform init
terraform plan
terraform apply
```

After apply completes:

```bash
aws eks update-kubeconfig --region <aws_region> --name <cluster_name>
kubectl get nodes
```

(Terraform also prints this exact command as the `configure_kubectl` output.)

## Notes / things to decide before production use

- **State storage**: this config uses local state by default. Uncomment the
  `backend "s3"` block in `versions.tf` and point it at a real S3
  bucket + DynamoDB lock table before using this for anything real.
- **Public endpoint**: `cluster_endpoint_public_access = true` in `eks.tf`
  makes the API server reachable from the internet. For production, consider
  setting this to `false` and accessing the cluster via VPN/bastion/private
  endpoint, or restrict `cluster_endpoint_public_access_cidrs`.
- **NAT gateway**: `single_nat_gateway = true` in `vpc.tf` uses one shared NAT
  gateway (cheaper). For high availability, set it to `false` so each AZ gets
  its own.
- **Node capacity**: defaults to on-demand `t3.medium` x2-4. Adjust
  `node_instance_types`, sizes, and `node_capacity_type` (`SPOT` for cost
  savings) in `terraform.tfvars`.
- **Cluster access**: `enable_cluster_creator_admin_permissions = true` grants
  whoever runs `terraform apply` cluster-admin. Review this for team/CI setups.

## Destroying

```bash
terraform destroy
```

This will tear down the node group, cluster, and VPC. Make sure nothing
important is running on the cluster first.
