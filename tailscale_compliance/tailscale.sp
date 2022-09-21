locals {
  tailscale_common_tags = merge(local.tailscale_compliance__common_tags, {
    tailscale = "true"
    // tailscale_version = "v0.1"
  })
}

benchmark "Tailscale" {
  title       = "Tailscale Best Practices"
  description = "Tailscale has many security features you can use to increase your network security. This page provides best practices for using these features to harden your Tailscale deployment."
  // documentation = file("./tailscale/docs/tailscale.md")

  children = [
    control.tailscale_1,
    control.tailscale_2,
    control.tailscale_3,
    control.tailscale_4,
    control.tailscale_5
  ]

  tags = merge(local.tailscale_common_tags, {
    type = "Benchmark"
  })
}

control "tailscale_1" {
  title       = "1. Ensure multifactor authentication is enabled for all users in administrative roles"
  description = "Enable multifactor authentication for all users who are members of administrative roles in the Microsoft 365 tenant."
  sql         = query.tailscale.sql
  // documentation = file("./cis_v140/docs/cis_v140_1_1_1.md")

  /* tags = merge(local.tailscale_common_tags, {
    cis_item_id = "1."
    cis_level   = "1"
    cis_type    = "automated"
    license     = "E3"
    service     = "Azure/ActiveDirectory"
  }) */
}

control "tailscale_2" {
  title       = "2. Enable MFA in your identity provider"
  description = "Enable multi-factor authentication in your identity provider for authenticating to Tailscale, ideally using a hardware token."
  sql         = query.tailscale.sql
  // documentation = file("./cis_v140/docs/cis_v140_1_1_1.md")
}

control "tailscale_3" {
  title       = "3. Use check mode for tailscale SSH"
  description = "Verify high-risk Tailscale SSH connections with check mode."
  sql         = query.tailscale_use_check_mode.sql
  // documentation = file("./cis_v140/docs/cis_v140_1_1_1.md")
}

control "tailscale_4" {
  title       = "4. "
  description = "Enable multifactor authentication for all users who are members of administrative roles in the Microsoft 365 tenant."
  sql         = query.tailscale.sql
  // documentation = file("./cis_v140/docs/cis_v140_1_1_1.md")
}

control "tailscale_5" {
  title       = "5. "
  description = "Enable multifactor authentication for all users who are members of administrative roles in the Microsoft 365 tenant."
  sql         = query.tailscale.sql
  // documentation = file("./cis_v140/docs/cis_v140_1_1_1.md")
}
