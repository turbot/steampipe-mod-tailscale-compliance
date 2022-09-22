select
  -- Required Columns
    tailnet_name as resource,
  case
    when tag is not null then 'ok'
    else 'alarm'
  end as status,
  case
    when tag is not null then 'Tailnet use acl tags.'
    else 'Tailnet does not use acl tags.'
  end as reason,
  -- Additional Dimensions
  dns_preferences
from
  tailscale_tailnet;
