select
  -- Required Columns
  id as resource,
  case
    when blocks_incoming_connections then 'alarm'
    else 'ok'
  end as status,
  case
    when blocks_incoming_connections then 'Restricted access to private network.'
    else 'Not restricted access to private network.'
  end as reason,
  -- Additional Dimensions
  name,
  user
from
  tailscale_device;
