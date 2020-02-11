# terraform-helm-chart
Run terraform on kubernetes

## Description

The helm chart deploys everything necessary to manage a terraform workspace on kubernetes:

* a persistent volume hosting the workspace
* an idle pod running the official terraform docker image
* create and configure the backend (only GCS currently supported)

And comes with a wrapper script that does the following:

* uploads your configuration to the pod
* invokes terraform on the pod

### Backend configuration

The chart can be instructed to create a backend as well as initialize it, carrying out the following steps:

1. Creates the backend if it doesn't exist already.
2. Adds a configuration file to the workspace, `backend.tf` specifying the backend type (a [requirement](https://www.terraform.io/docs/backends/config.html) of terraform).
3. Runs the `terraform init` command with the backend configuration to complete the backend initialization process.

So far only the GCS backend is supported.

### Wrapper script

A wrapper script, `./terraform-wrapper.sh`, invokes terraform on kubernetes like so:

1. Uploads your local terraform configuration to the workspace pod
2. Invokes terraform on the pod with the provided arguments, e.g. to run a plan:

```bash
cd <your_local_workspace_dir>
./terraform-wrapper.sh plan
```

## TODO

- [ ] RBAC

## Configuration

| Parameter | Description | Default |
|-|-|-|
| `image` | `terraform` image repository | `hashicorp/terraform` |
| `imageTag` | `terraform` image tag | `0.12.20` |
| `persistence.enabled` | Persist workspace after pod dies | true |
| `persistence.size` | Size of persistent volume claim | 1Gi |
| `persistence.accessMode` | ReadWriteOnce or ReadWriteMany | ReadWriteOnce |
| `persistence.existingClaim` | Name of existing persistent volume | `nil` |
| `backend.create` | Create backend | false |
| `backend.type` | Backend Type | `nil` |
| `backend.config` | Backend configuration options | {} |
| `gcs.image` | Image for `gcs` backend | `gcr.io/google.com/cloudsdktool/cloud-sdk` |
| `gcs.imageTag` | Image tag for `gcs` backend | `279.0.0-alpine` |
| `gcs.script` | Script for `gcs` backend | See `values.yaml` |
| `gcs.project` | Project in which to create backend bucket | `nil` |
| `google.serviceAccountKey` | Contents of GCP Service Account key |  `nil` |
| `google.serviceAccountSecret` | Existing secret containing GCP Service Account key |  `nil` |
