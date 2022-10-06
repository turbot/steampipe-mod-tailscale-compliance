// Benchmarks and controls for specific services should override the "service" tag
locals {
  tailscale_compliance_common_tags = {
    category = "Compliance"
    plugin   = "tailscale"
    service  = "Tailscale"
  }
}

mod "tailscale_compliance" {
  # hub metadata
  title         = "Tailscale Compliance"
  description   = "Run individual configuration, compliance and security controls or full compliance benchmarks for Tailscale."
  color         = "#000000"
  documentation = file("./docs/index.md")
  icon          = "/images/mods/turbot/tailscale-compliance.svg"
  categories    = ["tailscale", "compliance", "security"]

  opengraph {
    title       = "Steampipe Mod for Tailscale Compliance"
    description = "Run individual configuration, compliance and security controls or full compliance benchmarks for Tailscale."
    image       = "/images/mods/turbot/tailscale-compliance-social-graphic.png"
  }

  require {
    plugin "tailscale" {
      version = "0.0.4"
    }
  }
}
