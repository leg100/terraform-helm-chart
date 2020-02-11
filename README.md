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
