select
  -- Required Columns
  tailnet_name as resource,
  case
    when authorized = true then 'ok'
    else 'alarm'
  case
    when authorized = true then 'Device is authorized.'
    else 'Device is not authorized.'
  end as reason,
  -- Additional Dimensions
  title,
  user
from
  tailscale_device;
