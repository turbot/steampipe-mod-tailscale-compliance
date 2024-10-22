// Benchmarks and controls for specific services should override the "service" tag
locals {
  tailscale_compliance_common_tags = {
    category = "Compliance"
    plugin   = "tailscale"
    service  = "Tailscale"
  }
}
