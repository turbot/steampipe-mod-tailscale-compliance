locals {
  cis_v140_1_common_tags = merge(local.cis_v140_common_tags, {
    cis_section_id = "1"
  })
}

locals {
  cis_v140_1_1_common_tags = merge(local.cis_v140_1_common_tags, {
    cis_section_id = "1.1"
  })
}

benchmark "cis_v140_1" {
  title         = "1 Account and Authentication"
  documentation = file("./cis_v140/docs/cis_v140_1.md")
  children = [
    benchmark.cis_v140_1_1,
    control.cis_v140_1_2,
    control.cis_v140_1_3,
    control.cis_v140_1_4,
    control.cis_v140_1_5,
    control.cis_v140_1_6
  ]

  tags = merge(local.cis_v140_1_common_tags, {
    type    = "Benchmark"
    service = "Azure/ActiveDirectory"
  })
}

benchmark "cis_v140_1_1" {
  title         = "1.1 Azure Active Directory"
  documentation = file("./cis_v140/docs/cis_v140_1_1.md")
  children = [
    control.cis_v140_1_1_1,
    control.cis_v140_1_1_2,
    control.cis_v140_1_1_3,
    control.cis_v140_1_1_4,
    control.cis_v140_1_1_5,
    control.cis_v140_1_1_6,
    control.cis_v140_1_1_7,
    control.cis_v140_1_1_8,
    control.cis_v140_1_1_9,
    control.cis_v140_1_1_10,
    control.cis_v140_1_1_11,
    control.cis_v140_1_1_12,
    control.cis_v140_1_1_13,
    control.cis_v140_1_1_14,
    control.cis_v140_1_1_15,
    control.cis_v140_1_1_16
  ]

  tags = merge(local.cis_v140_1_1_common_tags, {
    type    = "Benchmark"
    service = "Azure/ActiveDirectory"
  })
}

control "cis_v140_1_1_1" {
  title         = "1.1.1 Ensure multifactor authentication is enabled for all users in administrative roles"
  description   = "Enable multifactor authentication for all users who are members of administrative roles in the Microsoft 365 tenant."
  sql           = query.ad_admin_user_mfa_enabled.sql
  documentation = file("./cis_v140/docs/cis_v140_1_1_1.md")

  tags = merge(local.cis_v140_1_1_common_tags, {
    cis_item_id = "1.1.1"
    cis_level   = "1"
    cis_type    = "automated"
    license     = "E3"
    service     = "Azure/ActiveDirectory"
  })
}