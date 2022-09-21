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
    control.tailscale_5,
    control.tailscale_6
  ]

  tags = merge(local.tailscale_common_tags, {
    type = "Benchmark"
  })
}

control "tailscale_1" {
  title       = "1. Upgrade Tailscale clients in a timely manner"
  description = "Upgrade Tailscale clients regularly, in a timely manner. Tailscale frequently introduces new features and patches existing versions, including security patches."
  sql         = query.tailscale_upgrade_clients_in_timely_manner.sql
  // documentation = file("./cis_v140/docs/cis_v140_1_1_1.md")

  /*   tags = merge(local.tailscale_common_tags, {
    cis_item_id = "1.1.1"
    cis_level   = "1"
    cis_type    = "automated"
    license     = "E3"
    service     = "Azure/ActiveDirectory"
  }) */
}

control "tailscale_2" {
  title       = "2. Remove unused API keys"
  description = "Regularly remove API keys that are no longer needed for your network.This prevents leaked keys being used to add unauthorized users or devices to your network."
  sql         = query.tailscale_remove_unused_api_keys.sql
  // documentation = file("./cis_v140/docs/cis_v140_1_1_1.md")
}

control "tailscale_3" {
  title       = "3. Use check mode for tailscale SSH"
  description = "Verify high-risk Tailscale SSH connections with check mode."
  sql         = query.tailscale_use_check_mode.sql
  // documentation = file("./cis_v140/docs/cis_v140_1_1_1.md")
}

control "tailscale_4" {
  title       = "4. Enable device authorization"
  description = "New devices can be manually reviewed and approved by an Admin before they can join the network. This can be used to ensure only trusted devices, such as workplace-managed laptops and phones, can access a network."
  sql         = query.tailscale_enable_device_authorization.sql
  // documentation = file("./cis_v140/docs/cis_v140_1_1_1.md")
}

control "tailscale_5" {
  title       = "5. Use groups in ACLs"
  description = "Use tags to manage devices. Tags allows to define access to devices based on purpose, rather than based on owner. ."
  sql         = query.tailscale.sql
  // documentation = file("./cis_v140/docs/cis_v140_1_1_1.md")
}

control "tailscale_6" {
  title       = "6. Assign admin roles."
  description = "Assign user roles for managing Tailscale as appropriate, based on job function and for separation of duties. Tailscale provides multiple user roles that restrict who can modify your tailnet’s configurations."
  sql         = query.tailscale_assign_admin_roles.sql
  // documentation = file("./cis_v140/docs/cis_v140_1_1_1.md")
}

control "tailscale_7" {
  title       = "7. Customize key expiration "
  description = "Require users to rotate keys by re-authenticating their devices to the network regularly. Devices connect to your tailnet using a public key which expires automatically after a period of time, forcing keys to rotate."
  sql         = query.tailscale_key_set_to_expire.sql
  // documentation = file("./cis_v140/docs/cis_v140_1_1_1.md")
}