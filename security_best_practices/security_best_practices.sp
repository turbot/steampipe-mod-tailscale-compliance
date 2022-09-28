locals {
  tailscale_common_tags = merge(local.tailscale_compliance__common_tags, {
    tailscale = "true"
  })
}

variable "api_key_id" {
  // type        = array
  description = "API Key ID for the tailnet key."
  default     = ["kFXfcN2CNTRL" , "kFXfcN2CNTRJ"]
}

benchmark "security_best_practices" {
  title       = "Tailscale Security Best Practices"
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
  description = "Using groups allows identities to be controlled based on job function. If someone leaves an organization or changes roles, you can adjust the group membership rather than update all of their ACLs."
  sql = <<-EOT
    select
      tailnet_name as resource,
      case
        when acl_groups is not null then 'ok'
        else 'alarm'
      end as status,
      case
        when acl_groups is not null then tailnet_name || ' uses ACL group.'
        else tailnet_name || ' does not use ACL group.'
      end as reason
    from
      tailscale_tailnet;
  EOT
}

control "tailscale_tailnet_acl_tags_used" {
  title       = "Use tags in ACLs"
  description = "Use tags to manage devices. Using tags allows you to define access to devices based on purpose, rather than based on owner."
  sql = <<-EOT
    select
      tailnet_name as resource,
      case
        when acl_tag_owners is not null then 'ok'
        else 'alarm'
      end as status,
      case
        when acl_tag_owners is not null then tailnet_name || ' uses ACL tags.'
        else tailnet_name || ' does not use ACL tags.'
      end as reason
    from
      tailscale_tailnet;
  EOT
}

control "tailscale_acl_ssh_admin_roles_assigned" {
  title       = "Assign admin roles"
  description = "Assign user roles for managing Tailscale as appropriate, based on job function and for separation of duties. Tailscale provides multiple user roles that restrict who can modify your tailnet's configurations."
  sql  = <<-EOT
    select
      tailnet_name as resource,
      case
        when users ?| array['group:admin','group:itadmin','group:networkadmin','group:auditor'] then 'ok'
        else 'alarm'
      end as status,
      case
        when users ?| array['group:admin','group:itadmin','group:networkadmin','group:auditor'] then tailnet_name || ' has admin roles assigned.'
        else tailnet_name || ' does not have admin roles assigned.'
      end as reason
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
      end as reason
    from
      tailscale_acl_ssh;
  EOT
}

control "tailscale_device_authorization_enabled" {
  title       = "Enable device authorization"
  description = "New devices can be manually reviewed and approved by an Admin before they can join the network. This can be used to ensure only trusted devices, such as workplace-managed laptops and phones, can access a network."
  sql = <<-EOT
    select
      id as resource,
      case
        when authorized = true then 'ok'
        else 'alarm'
      end as status,
      case
        when authorized = true then name || ' is authorized.'
        else name || ' is not authorized.'
      end as reason,
      tailnet_name
    from
      tailscale_device;
  EOT
}

control "tailscale_device_key_expire" {
  title       = "Customize key expiration"
  description = "Require users to rotate keys by re-authenticating their devices to the network regularly. Devices connect to your tailnet using a public key which expires automatically after a period of time, forcing keys to rotate."
  sql = <<-EOT
    select
      id as resource,
      case
        when key_expiry_disabled then 'alarm'
        else 'ok'
      end as status,
      case
        when key_expiry_disabled then name || ' has key expiration disabled.'
        else name || ' has key expiration enabled.'
      end as reason,
      tailnet_name
    from
      tailscale_device;
  EOT
}

control "tailscale_device_network_boundary_protected" {
  title       = "Protect your network boundary"
  description = "Restrict access to your private network, e.g., using a firewall. Tailscale allows you to easily connect your devices no matter their local area network, and ensures that traffic between your devices is end-to-end encrypted."
  sql = <<-EOT
    select
      id as resource,
      case
        when blocks_incoming_connections then 'ok'
        else 'alarm'
      end as status,
      case
        when blocks_incoming_connections then name || ' access restricted to private network.'
        else name || ' access not restricted to private network.'
      end as reason,
      tailnet_name
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
        when expires < now() then title || ' is unused.'
        else title || ' does not have unused API key.'
      end as reason,
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
  sql  = <<-EOT
    select
      id as resource,
      case
        when not update_available then 'ok'
        else 'alarm'
      end as status,
      case
        when not update_available then name || ' is updated.'
        else name || ' is not updated.'
      end as reason,
      tailnet_name
    from
      tailscale_device;
  EOT
}
