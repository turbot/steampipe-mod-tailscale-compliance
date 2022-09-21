select
  -- Required Columns
  id as resource,
  case
    when key_expiry_disabled then 'alarm'
    else 'ok'
  end as status,
  case
    when key_expiry_disabled then 'Key expiration is disabled.'
    else 'Keys expiration is enabled.'
  end as reason,
  -- Additional Dimensions
  name,
  user
from
  tailscale_device;
