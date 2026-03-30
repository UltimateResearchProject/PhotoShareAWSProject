locals {
  project = "photoshare"
  env     = "dev"

  name_prefix = "${local.project}-${local.env}"

  common_tags = {
    Project = local.project
    Env     = local.env
  }
}