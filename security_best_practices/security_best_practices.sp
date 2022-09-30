variable "api_key_ids" {
  type        = list(string)
  default     = ["fakeapikey1", "fakeapikey2"]
  description = "API Key ID for the tailnet key."
}

benchmark "security_best_practices" {
  title         = "Tailscale Security Best Practices"
  description   = "Tailscale has many security features you can use to increase your network security. This benchmark provides best practices for using these features to harden your Tailscale deployment."
  documentation = file("./security_best_practices/docs/security_best_practices.md")
  children = [
    control.security_best_practices_acl_ssh_admin_roles_assigned,
    control.security_best_practices_acl_ssh_check_mode_enabled,
    control.security_best_practices_device_authorization_enabled,
    control.security_best_practices_device_key_expire,
    control.security_best_practices_device_network_boundary_protected,
    control.security_best_practices_device_upgrade_clients_in_timely_manner,
    control.security_best_practices_tailnet_acl_groups_used,
    control.security_best_practices_tailnet_acl_tags_used
  ]

  tags = merge(local.tailscale_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "security_best_practices_acl_ssh_admin_roles_assigned" {
  title       = "Assign Admin roles"
  description = "Assign user roles for managing Tailscale as appropriate, based on job function and for separation of duties. Tailscale provides multiple user roles that restrict who can modify your tailnet's configurations."
  sql = <<-EOT
    with tailnet_all_roles as (
      select
        tailnet_name,
        jsonb_array_elements(users) as all_roles
      from
        tailscale_acl_ssh
      group by
        tailnet_name,
        users
    ), aggregate_roles as (
      select
        tailnet_name,
        jsonb_agg(all_roles) as role_agg
      from
        tailnet_all_roles
      group by
        tailnet_name
    )
    select
      t.tailnet_name as resource,
      case
        when
          role_agg ?| array['group:admin']
          and role_agg ?| array['group:itadmin']
          and role_agg ?| array['group:networkadmin']
          and role_agg ?| array['group:auditor'] then 'ok'
        else 'alarm'
      end as status,
      case
        when
          role_agg ?| array['group:admin']
          and role_agg ?| array['group:itadmin']
          and role_agg ?| array['group:networkadmin']
          and role_agg ?| array['group:auditor'] then t.tailnet_name || ' has Admin, Network Admin, IT Admin, and Auditor roles assigned.'
        else t.tailnet_name || ' does not have ' ||
          concat_ws(', ',
          case when not (role_agg ?| array['group:admin'])::boolean then 'Admin' end,
          case when not (role_agg ?| array['group:itadmin'])::boolean then 'IT Admin' end,
          case when not (role_agg ?| array['group:networkadmin'])::boolean then 'Network Admin' end,
          case when not (role_agg ?| array['group:auditor'])::boolean then 'Auditor' end) || ' role assigned.'
      end as reason,
      t.tailnet_name
    from
      tailscale_tailnet as t
      left join aggregate_roles as r on t.tailnet_name = r.tailnet_name;
  EOT
}

control "security_best_practices_acl_ssh_check_mode_enabled" {
  title       = "Use check mode for Tailscale SSH"
  description = "Verify high-risk Tailscale SSH connections with check mode."
  sql = <<-EOT
    with tailscale_users as (
      select
        tailnet_name
      from
        tailscale_acl_ssh
      where
        users ?| array['root'] and action = 'check' and check_period is not null
      group by
        tailnet_name
    )
    select
      t.tailnet_name as resource,
      case
        when tu.tailnet_name is not null then 'ok'
        else 'alarm'
      end as status,
      case
        when tu.tailnet_name is not null then t.tailnet_name || ' SSH connections for root have check mode enabled.'
        else t.tailnet_name || ' SSH connections for root have check mode disabled.'
      end as reason,
      t.tailnet_name
    from
      tailscale_tailnet as t
      left join tailscale_users as tu on t.tailnet_name = tu.tailnet_name;
  EOT
}

control "security_best_practices_device_authorization_enabled" {
  title       = "Enable device authorization"
  description = "New devices can be manually reviewed and approved by an Admin before they can join the network. This can be used to ensure only trusted devices, such as workplace-managed laptops and phones, can access a network."
  sql = <<-EOT
    select
      id as resource,
      case
        when authorized then 'ok'
        else 'alarm'
      end as status,
      case
        when authorized then name || ' is authorized.'
        else name || ' is unauthorized.'
      end as reason,
      tailnet_name
    from
      tailscale_device;
  EOT
}

control "security_best_practices_device_key_expire" {
  title       = "Customize node key expiration"
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

control "security_best_practices_device_network_boundary_protected" {
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

control "security_best_practices_device_upgrade_clients_in_timely_manner" {
  title       = "Upgrade Tailscale clients in a timely manner"
  description = "Upgrade Tailscale clients regularly, in a timely manner. Tailscale frequently introduces new features and patches existing versions, including security patches."
  sql = <<-EOT
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

control "security_best_practices_tailnet_acl_groups_used" {
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
      end as reason,
      tailnet_name
    from
      tailscale_tailnet;
  EOT
}

control "security_best_practices_tailnet_acl_tags_used" {
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
      end as reason,
      tailnet_name
    from
      tailscale_tailnet;
  EOT
}
