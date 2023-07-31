# Tailscale Compliance Mod for Steampipe

Run individual controls or full compliance benchmarks across all of your Tailscale resources using Steampipe.

Run checks in a dashboard:
![image](https://raw.githubusercontent.com/turbot/steampipe-mod-tailscale-compliance/main/docs/images/tailscale_compliance_security_best_practices_dashboard.png)

Or in a terminal:
![image](https://raw.githubusercontent.com/turbot/steampipe-mod-tailscale-compliance/main/docs/images/tailscale_compliance_security_best_practices_console.png)

Includes support for:
* [Tailscale Security Best Practices](https://hub.steampipe.io/mods/turbot/tailscale_compliance/controls/benchmark.security_best_practices)

## Getting started

### Installation

Download and install Steampipe (https://steampipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install steampipe
```

Install the Tailscale plugin with [Steampipe](https://steampipe.io):

```sh
steampipe plugin install tailscale
```

Clone:

```sh
git clone https://github.com/turbot/steampipe-mod-tailscale-compliance.git
cd steampipe-mod-tailscale-compliance
```

### Usage

Start your dashboard server to get started:

```sh
steampipe dashboard
```

By default, the dashboard interface will then be launched in a new browser
window at http://localhost:9194. From here, you can run benchmarks by
selecting one or searching for a specific one.

Instead of running benchmarks in a dashboard, you can also run them within your
terminal with the `steampipe check` command:

Run all benchmarks:

```sh
steampipe check all
```

Run a single benchmark:

```sh
steampipe check benchmark.security_best_practices
```

Run a specific control:

```sh
steampipe check control.security_best_practices_device_authorization_enabled
```

Different output formats are also available, for more information please see
[Output Formats](https://steampipe.io/docs/reference/cli/check#output-formats).

### Credentials

This mod uses the credentials configured in the [Steampipe Tailscale plugin](https://hub.steampipe.io/plugins/turbot/tailscale).

### Configuration

No extra configuration is required.

## Contributing

If you have an idea for additional controls or just want to help maintain and extend this mod ([or others](https://github.com/topics/steampipe-mod)) we would love you to join the community and start contributing.

- **[Join our Slack community →](https://steampipe.io/community/join)** and hang out with other Mod developers.

Please see the [contribution guidelines](https://github.com/turbot/steampipe/blob/main/CONTRIBUTING.md) and our [code of conduct](https://github.com/turbot/steampipe/blob/main/CODE_OF_CONDUCT.md). All contributions are subject to the [Apache 2.0 open source license](https://github.com/turbot/steampipe-mod-tailscale-compliance/blob/main/LICENSE).

Want to help but not sure where to start? Pick up one of the `help wanted` issues:

- [Steampipe](https://github.com/turbot/steampipe/labels/help%20wanted)
- [Tailscale Compliance Mod](https://github.com/turbot/steampipe-mod-tailscale-compliance/issues)
