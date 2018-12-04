# jira_release_notes plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-jira_release_notes)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-jira_release_notes`, add it to your project by running:

```bash
fastlane add_plugin jira_release_notes
```

## About jira_release_notes

Release notes from JIRA for version


## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. Try it by cloning the repo, running `fastlane install_plugins` and `bundle exec fastlane test`.


## Options

```
fastlane action jira_release_notes
```

Key | Description | Env Var | Default
----|-------------|---------|--------
url | URL for Jira instance | FL_JIRA_SITE |
username | Username for Jira instance | FL_JIRA_USERNAME |
password | Password for Jira | FL_JIRA_PASSWORD |
project | Jira project name | FL_JIRA_PROJECT |
version | Jira project version | FL_JIRA_PROJECT_VERSION |
format | Format text. Plain, html or none | FL_JIRA_RELEASE_NOTES_FORMAT | plain


## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
