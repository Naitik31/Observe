# Observe

A self-hosted observability stack on AWS EKS. It provisions the cloud infrastructure with Terraform and deploys [OpenObserve](https://openobserve.ai/) plus a [Vector](https://vector.dev/) load generator to Kubernetes, so you can see logs and metrics flowing end-to-end.



THe above can be accessed using below url 

http://a3c8a5fc6362e42c3a055a49f41a90cb-686451945.ap-south-1.elb.amazonaws.com:5080/
 


## What's inside

```
Observe/
├── terraform_modules/   # AWS infra: VPC, IAM roles, EKS cluster
└── k8/                  # Kubernetes manifests: OpenObserve, Vector, dashboards
```

## How it works

1. **Terraform** creates a VPC, IAM roles, and an EKS cluster on AWS.
2. **OpenObserve** runs as a StatefulSet in the `observability` namespace, storing logs and metrics on a `gp3` EBS volume.
3. **Vector** runs as a load generator — it fakes application logs (JSON + Apache-style) and StatsD metrics, then ships them into OpenObserve over HTTP.
4. **Dashboards** (`k8/dashboards/*.json`) can be imported into OpenObserve to visualize the incoming logs and metrics.

```
Vector (logs/metrics) ──▶ OpenObserve (storage + UI) ◀── Dashboards
        ▲
   EKS cluster (Terraform: VPC + IAM + EKS)
```

## Prerequisites

- AWS account + credentials
- Terraform >= 1.x
- `kubectl` and `aws` CLI
- An EBS CSI driver installed on the cluster (for the `gp3` StorageClass)

## Deploy

**1. Provision the infrastructure**

```bash
cd terraform_modules
terraform init
terraform apply
```

Fill in `aws_region`, `access_key`/`secret_key` (or use your AWS profile), and adjust `terraform.tfvars` as needed.

**2. Point kubectl at the new cluster**

```bash
aws eks update-kubeconfig --name k8s-obs --region "aws_region"
```

**3. Deploy the Kubernetes resources**

```bash
cd ../k8
kubectl apply -f namespace.yml
kubectl apply -f storageclass.yml
kubectl apply -f secrets.yml
kubectl apply -f openobserves.yml
kubectl apply -f service.yml
kubectl apply -f config_metric.yml
kubectl apply -f config_vector.yaml
kubectl apply -f deployment.yml
```

**4. Access OpenObserve**

```bash
kubectl get svc openobserve -n observability
```

Open the LoadBalancer address on port `5080` and log in with the credentials from `secrets.yml`.

## Notes

- `secrets.yml` ships with placeholder/demo credentials — replace them before any real use.
- The load generator targets roughly 5 GB/hour of logs and metrics; tune the rate in `config_vector.yaml` and `config_metric.yml`.


By
Naitik Agarwal
