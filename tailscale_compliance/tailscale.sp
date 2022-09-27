locals {
  tailscale_common_tags = merge(local.tailscale_compliance__common_tags, {
    tailscale = "true"
  })
}

variable "api_key_id" {
  type        = string
  description = "API Key ID for the tailnet key."
  default     = "kFXfcN2CNTRL"
}

benchmark "tailscale" {
  title       = "Tailscale Best Practices"
  description = "Tailscale has many security features you can use to increase your network security. This page provides best practices for using these features to harden your Tailscale deployment."

  children = [
    control.tailscale_tailnet_acl_groups_used,
    control.tailscale_tailnet_acl_tags_used,
    control.tailscale_acl_ssh_admin_roles_assigned,
    control.tailscale_acl_ssh_check_mode_enabled,
    control.tailscale_device_authorization_enabled,
    control.tailscale_device_key_expire,
    control.tailscale_device_network_boundary_protected,
    control.tailscale_tailnet_key_unused,
    control.tailscale_device_upgrade_clients_in_timely_manner
  ]

  tags = merge(local.tailscale_common_tags, {
    type = "Benchmark"
  })
}

control "tailscale_tailnet_acl_groups_used" {
  title       = "Use groups in ACLs"
  description = "Use tags to manage devices. Tags allows to define access to devices based on purpose, rather than based on owner. ."
  sql =<<-EOT
    select
      tailnet_name as resource,
      case
        when acl_groups is not null then 'ok'
        else 'alarm'
      end as status,
      case
        when acl_groups is not null then 'Tailnet use acl groups.'
        else 'Tailnet does not use acl groups.'
      end as reason,
      dns_preferences
    from
      tailscale_tailnet;
  EOT
}

control "tailscale_tailnet_acl_tags_used" {
  title       = "Use tags in ACLs"
  description = "Use tags to manage devices. Using tags allows you to define access to devices based on purpose, rather than based on owner."
  sql =<<-EOT
    select
      tailnet_name as resource,
      case
        when acl_tag_owners is not null then 'ok'
        else 'alarm'
      end as status,
      case
        when acl_tag_owners is not null then 'Tailnet use acl tags.'
        else 'Tailnet does not use acl tags.'
      end as reason,
      dns_preferences
    from
      tailscale_tailnet;
  EOT
}

control "tailscale_acl_ssh_admin_roles_assigned" {
  title       = "Assign admin roles"
  description = "Assign user roles for managing Tailscale as appropriate, based on job function and for separation of duties. Tailscale provides multiple user roles that restrict who can modify your tailnet’s configurations."
  sql  =<<-EOT
    select
      tailnet_name as resource,
      case
        when users ?| array['group:admin','group:itadmin','group:networkadmin','group:auditor'] then 'ok'
        else 'alarm'
      end as status,
      case
        when users ?| array['group:admin','group:itadmin','group:networkadmin','group:auditor'] then 'Admin roles assigned.'
        else 'Admin roles not assigned.'
      end as reason,
      source,
      users
    from
      tailscale_acl_ssh;
  EOT
}

control "tailscale_acl_ssh_check_mode_enabled" {
  title       = "Use check mode for tailscale SSH"
  description = "Verify high-risk Tailscale SSH connections with check mode."
  sql = <<-EOT
    select
      tailnet_name as resource,
      case
        when action = 'check' and check_period is NOT NULL then 'ok'
        else 'alarm'
      end as status,
      case
        when  action = 'check' and check_period is NOT NULL then 'Check mode is enabled for tailscale SSH.'
        else 'Check mode is disabled for tailscale SSH.'
      end as reason,
      source,
      users
    from
      tailscale_acl_ssh;
  EOT
}

control "tailscale_device_authorization_enabled" {
  title       = "Enable device authorization"
  description = "New devices can be manually reviewed and approved by an Admin before they can join the network. This can be used to ensure only trusted devices, such as workplace-managed laptops and phones, can access a network."
  sql =<<-EOT
    select
      tailnet_name as resource,
      case
        when authorized = true then 'ok'
        else 'alarm'
      end as status,
      case
        when authorized = true then 'Device is authorized.'
        else 'Device is not authorized.'
      end as reason,
      title,
      user
    from
      tailscale_device;
  EOT
}

control "tailscale_device_key_expire" {
  title       = "Customize key expiration"
  description = "Require users to rotate keys by re-authenticating their devices to the network regularly. Devices connect to your tailnet using a public key which expires automatically after a period of time, forcing keys to rotate."
  sql =<<-EOT
    select
      id as resource,
      case
        when key_expiry_disabled then 'alarm'
        else 'ok'
      end as status,
      case
        when key_expiry_disabled then 'Key expiration is disabled.'
        else 'Keys expiration is enabled.'
      end as reason,
      name,
      user
    from
      tailscale_device;
  EOT
}

control "tailscale_device_network_boundary_protected" {
  title       = "Protect your network boundary"
  description = "Restrict access to your private network, e.g., using a firewall. Tailscale allows you to easily connect your devices no matter their local area network, and ensures that traffic between your devices is end-to-end encrypted."
  sql =<<-EOT
    select
      id as resource,
      case
        when blocks_incoming_connections then 'alarm'
        else 'ok'
      end as status,
      case
        when blocks_incoming_connections then 'Restricted access to private network.'
        else 'Not restricted access to private network.'
      end as reason,
      name,
      user
    from
      tailscale_device;
EOT
}

control "tailscale_tailnet_key_unused" {
  title       = "Remove unused API keys"
  description = "Regularly remove API keys that are no longer needed for your network.This prevents leaked keys being used to add unauthorized users or devices to your network."
  sql = <<-EOT
    select
      id as resource,
      case
        when expires < now() then 'alarm'
        else 'ok'
      end as status,
      case
        when expires < now() then 'Unused API key is present.'
        else 'Unused API key is not present.'
      end as reason,
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

control "tailscale_device_upgrade_clients_in_timely_manner" {
  title       = "Upgrade Tailscale clients in a timely manner"
  description = "Upgrade Tailscale clients regularly, in a timely manner. Tailscale frequently introduces new features and patches existing versions, including security patches."
  sql  =<<-EOT
    select
      tailnet_name as resource,
      case
        when update_available = false then 'ok'
        else 'alarm'
      end as status,
      case
        when update_available = false then 'Update is available.'
        else 'Update is not available.'
      end as reason,
      title,
      user
    from
      tailscale_device;
  EOT
}
















