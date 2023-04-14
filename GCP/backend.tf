terraform {
  backend "gcs" {
    bucket = "tfdbgcpdevstate"
    prefix = "dev"
  }
}