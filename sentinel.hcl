policy "require-tags" {
  source            = "./require-tags.sentinel"
  enforcement_level = "soft-mandatory"
}

policy "block-public-s3" {
  source            = "./block-public-s3.sentinel"
  enforcement_level = "hard-mandatory"
}
