select
  -- Required Columns
  id as resource,
  case
    when expires < now() then 'alarm'
    else 'ok'
  end as status,
  case
    when expires < now() then 'Unused API key is present.'
    else 'Unused API key is not present.'
  end as reason,
  -- Additional Dimensions
  id,
  key
from
  tailscale_tailnet_key
where
  id = 'kFXfcN2CNTRL'
