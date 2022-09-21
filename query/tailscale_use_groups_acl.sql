select
  -- Required Columns
    tailnet_name as resource,
  case
    when acl_groups is not null then 'ok'
    else 'alarm'
  end as status,
  case
    when acl_groups is not null then 'Tailnet use acl groups.'
    else 'Tailnet does not use acl groups.'
  end as reason,
  -- Additional Dimensions
  dns_preferences
from
  tailscale_tailnet;
