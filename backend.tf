terraform {
  backend "s3" {
    bucket       = "terraform-statefile-with-module-bkt"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
    # key is passed dynamically via -backend-config in CI/CD
  }
}
