select
  -- Required Columns
  tailnet_name as resource,
  case
    when users ?| array['group:admin','group:itadmin','group:networkadmin','group:auditor'] then 'ok'
    else 'alarm'
  end as status,
  case
    when users ?| array['group:admin','group:itadmin','group:networkadmin','group:auditor'] then 'Admin roles assigned.'
    else 'Admin roles not assigned.'
  end as reason,
  -- Additional Dimensions
  source,
  users
from
  tailscale_acl_ssh;
