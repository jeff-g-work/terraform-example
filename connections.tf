terraform {
  backend "gcs" {
    bucket     = "tenx-tf-state-staging"
    prefix     = "services/state"
    region     = "asia-southeast1"
  }
}
