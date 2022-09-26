---
repository: "https://github.com/turbot/steampipe-mod-tailscale-compliance"
---

# AWS Tailscale Compliance

Run tagging controls across all your AWS accounts to look for untagged resources, missing tags, resources with too many tags, and more.

<img src="https://raw.githubusercontent.com/turbot/steampipe-mod-aws-tags/main/docs/aws_tags_dashboard.png" width="50%" type="thumbnail"/>
<img src="https://raw.githubusercontent.com/turbot/steampipe-mod-aws-tags/main/docs/aws_tags_untagged_dashboard.png" width="50%" type="thumbnail"/>
<img src="https://raw.githubusercontent.com/turbot/steampipe-mod-aws-tags/main/docs/aws_tags_mod_terminal.png" width="50%" type="thumbnail"/>

## References

[Steampipe](https://steampipe.io) is an open source CLI to instantly query cloud APIs using SQL.

[Steampipe Mods](https://steampipe.io/docs/reference/mod-resources#mod) are collections of `named queries`, and codified `controls` that can be used to test current configuration of your cloud resources against a desired configuration.

## Documentation
<!--
- **[Benchmarks and controls →](https://hub.steampipe.io/mods/turbot/aws_tags/controls)** -->

## Getting started

### Installation

Download and install Steampipe (https://steampipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install steampipe
```

<!-- Install the AWS plugin with [Steampipe](https://steampipe.io):

```sh
steampipe plugin install aws
``` -->

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
window at https://localhost:9194. From here, you can run benchmarks by
selecting one or searching for a specific one.

Instead of running benchmarks in a dashboard, you can also run them within your
terminal with the `steampipe check` command:

Run all benchmarks:

```sh
steampipe check all
```

Run a single benchmark:

```sh
steampipe check benchmark.tailscale
```

Run a specific control:

```sh
steampipe check control.enable_device_authorization
```

Different output formats are also available, for more information please see
[Output Formats](https://steampipe.io/docs/reference/cli/check#output-formats).

### Credentials

<!-- This mod uses the credentials configured in the [Steampipe AWS plugin](https://hub.steampipe.io/plugins/turbot/aws). -->

### Configuration

Several benchmarks have [input variables](https://steampipe.io/docs/using-steampipe/mod-variables) that can be configured to better match your environment and requirements. Each variable has a default defined in its source file, e.g., `controls/limit.sp`, but these can be overriden in several ways:

- Copy and rename the `steampipe.spvars.example` file to `steampipe.spvars`, and then modify the variable values inside that file
- Pass in a value on the command line:
  <!-- ```sh
  <!-- steampipe check benchmark.mandatory --var 'mandatory_tags=["Application", "Environment", "Department", "Owner"]'
  ``` -->
<!-- - Set an environment variable:
  ```sh
  SP_VAR_mandatory_tags='["Application", "Environment", "Department", "Owner"]' steampipe check control.ec2_instance_mandatory
  ``` -->
  - Note: When using environment variables, if the variable is defined in `steampipe.spvars` or passed in through the command line, either of those will take precedence over the environment variable value. For more information on variable definition precedence, please see the link below.

These are only some of the ways you can set variables. For a full list, please see [Passing Input Variables](https://steampipe.io/docs/using-steampipe/mod-variables#passing-input-variables).


## Contributing

If you have an idea for additional controls or just want to help maintain and extend this mod ([or others](https://github.com/topics/steampipe-mod)) we would love you to join the community and start contributing.

- **[Join our Slack community →](https://steampipe.io/community/join)** and hang out with other Mod developers.

Please see the [contribution guidelines](https://github.com/turbot/steampipe/blob/main/CONTRIBUTING.md) and our [code of conduct](https://github.com/turbot/steampipe/blob/main/CODE_OF_CONDUCT.md). All contributions are subject to the [Apache 2.0 open source license](https://github.com/turbot/steampipe-mod-tailscale-compliance/blob/main/LICENSE).

Want to help but not sure where to start? Pick up one of the `help wanted` issues:

- [Steampipe](https://github.com/turbot/steampipe/labels/help%20wanted)
- [Tailscale Compliance Mod](https://github.com/turbot/steampipe-mod-tailscale-compliance/issues)
