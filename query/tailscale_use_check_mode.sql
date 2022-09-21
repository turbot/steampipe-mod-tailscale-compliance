select
  -- Required Columns
  tailnet_name as resource,
  case
    when action = 'check' and check_period is NOT NULL then 'ok'
    else 'alarm'
  end as status,
  case
    when  action = 'check' and check_period is NOT NULL then 'Check mode is enabled for tailscale SSH.'
    else 'Check mode is disabled for tailscale SSH.'
  end as reason,
  -- Additional Dimensions
  source,
  users
from
  tailscale_acl_ssh;
