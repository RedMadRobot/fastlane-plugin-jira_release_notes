# coding: utf-8

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/jira_release_notes/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-jira_release_notes'
  spec.version       = Fastlane::JiraReleaseNotes::VERSION
  spec.author        = 'Alexander Ignition'
  spec.email         = 'izh.sever@gmail.com'

  spec.summary       = 'Release notes from JIRA for version'
  spec.homepage      = "https://github.com/RedMadRobot/fastlane-plugin-jira_release_notes"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  # Don't add a dependency to fastlane or fastlane_re
  # since this would cause a circular dependency

  spec.add_dependency 'jira-ruby', '~> 2.2.0'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'fastlane', '>= 2.49.0'
end
