module "naming" {
  source  = "codectl/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dev"]
}

module "regions" {
  source  = "codectl/locations/azure"
  version = "~> 1.0"

  location = {
    primary = "westeurope"
  }
}

module "rg" {
  source  = "codectl/rg/azure"
  version = "~> 1.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = module.regions.location.primary.name
    }
  }
}

module "dns" {
  source  = "codectl/pdns/azure"
  version = "~> 1.0"

  resource_group_name = module.rg.groups.demo.name

  zones = {
    public = {
      globex = {
        name    = "globex.com"
        records = local.records
        soa_record = {
          email         = "hostmaster.globex.com"
          ttl           = 3600
          expire_time   = 2419200
          retry_time    = 600
          minimum_ttl   = 300
          refresh_time  = 3600
          serial_number = 2024102901
          tags = {
            environment = "production"
          }
        }
      }
    }
  }
}
