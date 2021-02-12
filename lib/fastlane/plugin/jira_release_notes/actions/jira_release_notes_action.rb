module Fastlane
  module Actions
    class JiraReleaseNotesAction < Action
      def self.run(params)
        Actions.verify_gem!('jira-ruby')
        require 'jira-ruby'

        client = JIRA::Client.new(
          username:     params[:username],
          password:     params[:password],
          site:         params[:url],
          context_path: '',
          auth_type:    :basic
        )

        version = params[:version]
        project = params[:project]
        status = params[:status]
        max_results = params[:max_results].to_i
        issues = []

        UI.message("Fetch issues from JIRA project '#{project}', version '#{version}'")

        begin
          if version.kind_of?(Regexp)
            versions = client.Project.find(project).versions
                             .select { |v| version.match(v.name) }
                             .map { |v| "'#{v.name}'" } .join(', ')
            jql = "PROJECT = '#{project}' AND fixVersion in (#{versions})"
          else
            jql = "PROJECT = '#{project}' AND fixVersion = '#{version}'"
          end
          unless status.nil? or status.empty?
            jql += " AND status = '#{status}'"
          end
          issues = client.Issue.jql(jql,max_results: max_results)

        rescue JIRA::HTTPError => e
          fields = [e.code, e.message]
          fields << e.response.body if e.response.content_type == "application/json"
          UI.user_error!("#{e} #{fields.join(', ')}")
        end

        UI.success("📝  #{issues.count} issues from JIRA project '#{project}', version '#{version}', status '#{status}'")

        case params[:format]
        when "plain"
          Helper::JiraReleaseNotesHelper.plain_format(issues)
        when "html"
          Helper::JiraReleaseNotesHelper.html_format(issues, params[:url])
        else
          issues
        end
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Jira release notes"
      end

      def self.details
        "Fetch release notes for Jira project for version"
      end

      def self.return_value
        "List of issues from jira. Formatted string or class"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :url,
                                       env_name: "FL_JIRA_SITE",
                                       description: "URL for Jira instance",
                                       verify_block: proc do |value|
                                         UI.user_error!("No url for Jira given") if value.to_s.length == 0
                                       end),
          FastlaneCore::ConfigItem.new(key: :username,
                                       env_name: "FL_JIRA_USERNAME",
                                       description: "Username for Jira instance",
                                       verify_block: proc do |value|
                                         UI.user_error!("No username") if value.to_s.length == 0
                                       end),
          FastlaneCore::ConfigItem.new(key: :password,
                                       env_name: "FL_JIRA_PASSWORD",
                                       description: "Password or api token for Jira",
                                       sensitive: true,
                                       verify_block: proc do |value|
                                         UI.user_error!("No password") if value.to_s.length == 0
                                       end),
          FastlaneCore::ConfigItem.new(key: :project,
                                       env_name: "FL_JIRA_PROJECT",
                                       description: "Jira project name",
                                       sensitive: true,
                                       verify_block: proc do |value|
                                         UI.user_error!("No Jira project name") if value.to_s.length == 0
                                       end),
          FastlaneCore::ConfigItem.new(key: :status,
                                       env_name: "FL_JIRA_STATUS",
                                       description: "Jira issue status",
                                       sensitive: true,
                                       default_value: ""),
          FastlaneCore::ConfigItem.new(key: :version,
                                       env_name: "FL_JIRA_PROJECT_VERSION",
                                       description: "Jira project version",
                                       sensitive: true,
                                       is_string: false,
                                       verify_block: proc do |value|
                                         UI.user_error!("'version' value must be a String or Regexp! Found #{value.class} instead.") unless value.kind_of?(String) || value.kind_of?(Regexp)
                                         UI.user_error!("No Jira project version") if value.to_s.length == 0
                                       end),
          FastlaneCore::ConfigItem.new(key: :format,
                                       env_name: "FL_JIRA_RELEASE_NOTES_FORMAT",
                                       description: "Format text. Plain, html or none",
                                       sensitive: true,
                                       default_value: "plain"),
          FastlaneCore::ConfigItem.new(key: :max_results,
                                       env_name: "FL_JIRA_RELEASE_NOTES_MAX_RESULTS",
                                       description: "Maximum number of issues",
                                       default_value: "50")
        ]
      end

      def self.authors
        ["Alexander Ignition"]
      end

      def self.is_supported?(platform)
        true
      end

      def self.example_code
        [
          'notes = jira_release_notes(
            url: "https://bugs.yourdomain.com",
            username: "Your username",
            password: "Your password",
            project: "ABC",
            version: "1.0"
          )
          gym
          crashlytics(notes: notes)',
          'notes = jira_release_notes(
            project: "ABC",
            version: "1.0",
            format: "html"
          )
          gym
          slack(message: notes)'
        ]
      end

      def self.category
        :misc
      end
    end
  end
end
