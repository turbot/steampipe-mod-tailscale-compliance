select
  -- Required Columns
  tailnet_name as name,
  case
    when authorized = true then 'ok'
    else 'alarm'
  end as status,
  case
    when authorized = true then 'Device is authorized'
    else 'Device is not authorized'
  end as reason,
  -- Additional Dimensions
  title,
  user
from
  tailscale_device;