## v1.0.0 [2024-10-22]

This mod now requires [Powerpipe](https://powerpipe.io). [Steampipe](https://steampipe.io) users should check the [migration guide](https://powerpipe.io/blog/migrating-from-steampipe).

## v0.3 [2024-03-06]

_Powerpipe_

[Powerpipe](https://powerpipe.io) is now the preferred way to run this mod!  [Migrating from Steampipe →](https://powerpipe.io/blog/migrating-from-steampipe)

All v0.x versions of this mod will work in both Steampipe and Powerpipe, but v1.0.0 onwards will be in Powerpipe format only.

_Enhancements_

- Focus documentation on Powerpipe commands.
- Show how to combine Powerpipe mods with Steampipe plugins.

## v0.2 [2023-11-03]

_Breaking changes_

- Updated the plugin dependency section of the mod to use `min_version` instead of `version`. ([#9](https://github.com/turbot/steampipe-mod-tailscale-compliance/pull/9))

_Bug fixes_

- Fixed dashboard localhost URLs in README and index doc. ([#5](https://github.com/turbot/steampipe-mod-tailscale-compliance/pull/5))

## v0.1 [2022-10-07]

_What's new?_

Added: Tailscale Security Best Practices benchmark (`steampipe check benchmark.security_best_practices`)
