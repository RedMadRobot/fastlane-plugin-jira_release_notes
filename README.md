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

```ruby
lane :notes do
  text = jira_release_notes(
    username: "me",
    password: "123", # password or api token
    url:      "https://jira.example.com",
    project:  "OX",
    version:  "0.1",
    status:  "Testable",
    format: "plain"
  )
  puts text
end
```

## Options

```
fastlane action jira_release_notes
```

[How to generate an API Access Token](https://confluence.atlassian.com/cloud/api-tokens-938839638.html)

Key | Description | Env Var | Default
----|-------------|---------|--------
url | URL for Jira instance | FL_JIRA_SITE |
username | Username for Jira instance | FL_JIRA_USERNAME |
password | Password for Jira or api token | FL_JIRA_PASSWORD |
project | Jira project name | FL_JIRA_PROJECT |
version | Jira project version | FL_JIRA_PROJECT_VERSION |
status | Jira project version | FL_JIRA_STATUS |
format | Format text. Plain, html or none | FL_JIRA_RELEASE_NOTES_FORMAT | plain
max_results | Maximum number of issues | FL_JIRA_RELEASE_NOTES_MAX_RESULTS | 50


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
