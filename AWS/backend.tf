terraform {
  backend "s3" {
    bucket = "tfdbdevaws"
    key    = "dev/dev.tf.state"
    region = "us-east-1"
  }
}
