# Confluent Operator playbook

## Requirements

- [minishift](https://github.com/minishift/minishift/releases)
- [helm](https://github.com/helm/helm/releases)
- kubectl

## GCP

### Additional requirements

- [terraform](https://terraform.io)
- gcloud

### 1. Create a GKE cluster

```bash
cd gcp
terraform init
terraform plan
terraform apply
```

### 2. Configure kubectl

```bash
gcloud container clusters get-credentials jeqo-operator --zone europe-west2
```

### 3. Create Namespace

```bash
make kubectl-namespace
```

### 4. Install

```bash
make PROVIDER=gcp install
```

## Minishift

### 1. Download Operator

```bash
make download
```

### 2. When working with Openshift

#### 2.1 Create Openshift local environment (optional)

```bash
make minishift-start
```

#### 2.2. Configure Openshift project

Prefer creating project via Openshift Web UI, as something when creating from CLI project does not appear listed on UI:

Go to <http://[vm ip]:8443>, log with `system:admin`, and create project `confluent-opertor`

or

```bash
make minishift-project
```

### 2.3. Add policies for operator permissions

```bash
make minishift-policy
```

### 2.4. Deploy operator and create cluster

```bash
make install
```

Details from [Cluster definition](./providers/minishift.yml):

- `disableHostPort: true` to avoid port collision
- Resource request definitions smaller than defaults to run properly on one node.

### 2.5. Validate connection

```bash
make c3-port-forward
```

and go to <http://localhost:9021> and log in with `admin/Developer1`

### 2.6. Uninstall cluster

```bash
make unistall
```