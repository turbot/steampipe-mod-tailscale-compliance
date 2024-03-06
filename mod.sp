mod "tailscale_compliance" {
  # Hub metadata
  title         = "Tailscale Compliance"
  description   = "Run individual configuration, compliance and security controls or full compliance benchmarks for Tailscale."
  color         = "#000000"
  documentation = file("./docs/index.md")
  icon          = "/images/mods/turbot/tailscale-compliance.svg"
  categories    = ["tailscale", "compliance", "security"]

  opengraph {
    title       = "Powerpipe Mod for Tailscale Compliance"
    description = "Run individual configuration, compliance and security controls or full compliance benchmarks for Tailscale."
    image       = "/images/mods/turbot/tailscale-compliance-social-graphic.png"
  }

  require {
    plugin "tailscale" {
      min_version = "0.1.0"
    }
  }
}
