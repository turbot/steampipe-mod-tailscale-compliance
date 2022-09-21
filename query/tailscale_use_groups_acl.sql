select
  -- Required Columns
  tailnet_name as resource,
  case
    when jsonb_array_length(acl_groups) > 1 then 'ok'
    else 'alarm'
  end as status,
  case
    when jsonb_array_length(acl_groups) > 1 then 'Tailnet use acl groups.'
    else 'Tailnet does not use acl groups.'
  end as reason,
  -- Additional Dimensions
  dns_preferences
from
  tailscale_tailnet;


select
  distinct(tableProps.props)
from (
  select
    jsonb_object_keys(acl_groups) as props
  from
    tailscale_tailnet
) as tableProps

select count(*) from tableProps;




with cnt as (
  select
    distinct(tableProps.props)
  from(
  select
    jsonb_object_keys(acl_groups) as props
  from
    tailscale_tailnet
    ) as tableProps
)

select count(*) from cnt;

select
  -- Required Columns
  t.tenant_id as resource,
  case
    when a.count > 0 then 'ok'
    else 'alarm'
  end as status,
  case
    when a.count > 0 then 'Audit log search is enabled.'
    else 'Audit log search is disabled.'
  end as reason,
  -- Additional Dimensions
  t.tenant_id
from
  tenant_list as t
  left join audit_count as a on t.tenant_id = a.tenant_id;

