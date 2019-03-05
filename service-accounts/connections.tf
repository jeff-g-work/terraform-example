variable cred {}
provider "google" {
  credentials = "${var.cred}"
  project = "${var.project}"
  region  = "${var.region}"
}


resource "google_service_account" "tf-example" {
  account_id   = "tf-example"
  display_name = "Terraform example"
}

resource "google_service_account_key" "tf-example-credentials" {
  service_account_id = "${google_service_account.tf-example.name}"
}

resource "google_service_account_iam_binding" "tf-example-iam" {
  service_account_id = "${google_service_account.tf-example.name}"
  role               = "roles/iam.serviceAccountUser"

  members = ["serviceAccount:${google_service_account.tf-example.email}"]
}

resource "google_project_iam_binding" "tf-example" {
  role    = "roles/cloudsql.client"
  members = ["serviceAccount:${google_service_account.tf-example.email}"]
}

output "secret-key-name" {
  value = "tf-example-credentials"
}

output "email" {
  value = "${google_service_account.tf-example.email}"
}

resource "kubernetes_secret" "tf-example-credentials" {
  metadata = {
    name = "tf-example-credentials"
  }

  data {
    credentials.json = "${base64decode(google_service_account_key.tf-example-credentials.private_key)}"
  }
}