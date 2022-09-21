select
  -- Required Columns
  tailnet_name as name,
  case
    when update_available = false then 'ok'
    else 'alarm'
  end as status,
  case
    when update_available = false then 'Update is available'
    else 'Update is not available'
  end as reason,
  -- Additional Dimensions
  title,
  user
from
  tailscale_device;