module "ecr" {
  source = "github.com/terrablocks/aws-ecr.git?ref=" # Always use `ref` to point module to a specific version or hash

  name = "backend"
}
