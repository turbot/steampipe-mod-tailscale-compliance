locals {
  tailscale_common_tags = merge(local.tailscale_compliance__common_tags, {
    tailscale = "true"
    // tailscale_version = "v0.1"
  })
}

variable "api_key_id" {
  type        = string
  description = "API Key ID for the tailnet key."
  default     = "kFXfcN2CNTRL"
}

benchmark "Tailscale" {
  title       = "Tailscale Best Practices"
  description = "Tailscale has many security features you can use to increase your network security. This page provides best practices for using these features to harden your Tailscale deployment."

  children = [
    control.tailscale_1,
    control.tailscale_2,
    control.tailscale_3,
    control.tailscale_4,
    control.tailscale_5,
    control.tailscale_6,
    control.tailscale_7,
    control.tailscale_8,
    control.tailscale_9
  ]

  tags = merge(local.tailscale_common_tags, {
    type = "Benchmark"
  })
}

control "upgrade_clients_in_timely_manner" {
  title       = "Upgrade Tailscale clients in a timely manner"
  description = "Upgrade Tailscale clients regularly, in a timely manner. Tailscale frequently introduces new features and patches existing versions, including security patches."
  sql         = query.tailscale_upgrade_clients_in_timely_manner.sql
}

// steampipe check control.tailscale_2 --var 'api_key_id'="kFXfcN2CNTRL"
control "remove_unused_api_key_ids" {
  title       = "Remove unused API keys"
  description = "Regularly remove API keys that are no longer needed for your network.This prevents leaked keys being used to add unauthorized users or devices to your network."
  // sql         = query.tailscale_remove_unused_api_key_ids.sql
  sql = <<-EOT
    select
    -- Required Columns
     id as resource,
    case
      when expires < now() then 'alarm'
      else 'ok'
    end as status,
    case
      when expires < now() then 'Unused API key is present.'
      else 'Unused API key is not present.'
    end as reason,
    -- Additional Dimensions
      id,
      key
    from
      tailscale_tailnet_key
    where
      id = $1
  EOT

  param "api_key_id" {
    default = var.api_key_id
  }
}

control "use_check_mode" {
  title       = "Use check mode for tailscale SSH"
  description = "Verify high-risk Tailscale SSH connections with check mode."
  sql         = query.tailscale_use_check_mode.sql
}

control "enable_device_authorization" {
  title       = "Enable device authorization"
  description = "New devices can be manually reviewed and approved by an Admin before they can join the network. This can be used to ensure only trusted devices, such as workplace-managed laptops and phones, can access a network."
  sql         = query.tailscale_enable_device_authorization.sql
}

control "use_groups_acl" {
  title       = "Use groups in ACLs"
  description = "Use tags to manage devices. Tags allows to define access to devices based on purpose, rather than based on owner. ."
  sql         = query.tailscale_use_groups_acl.sql
}

control "assign_admin_roles" {
  title       = "Assign admin roles"
  description = "Assign user roles for managing Tailscale as appropriate, based on job function and for separation of duties. Tailscale provides multiple user roles that restrict who can modify your tailnet’s configurations."
  sql         = query.tailscale_assign_admin_roles.sql
}

control "key_set_to_expire" {
  title       = "Customize key expiration"
  description = "Require users to rotate keys by re-authenticating their devices to the network regularly. Devices connect to your tailnet using a public key which expires automatically after a period of time, forcing keys to rotate."
  sql         = query.tailscale_key_set_to_expire.sql
}

control "protect_network_boundary" {
  title       = "Protect your network boundary"
  description = "Restrict access to your private network, e.g., using a firewall. Tailscale allows you to easily connect your devices no matter their local area network, and ensures that traffic between your devices is end-to-end encrypted."
  sql         = query.tailscale_protect_network_boundary.sql
}

control "use_tags_acl" {
  title       = "Use tags in ACLs"
  description = "Use tags to manage devices. Using tags allows you to define access to devices based on purpose, rather than based on owner."
  sql         = query.tailscale_use_tags_acl.sql
}
