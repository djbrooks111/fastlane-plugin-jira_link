require 'jira-ruby'
require 'fastlane/action'
require_relative '../helper/jira_link_helper'

module Fastlane
  module Actions
    class JiraLinkAction < Action
      def self.run(params)
        site            = params[:url]
        auth_type       = :basic
        context_path    = params[:context_path]
        username        = params[:username]
        password        = params[:password]
        inward_issue    = params[:inward_issue]
        outward_issue   = params[:outward_issue]
        link_type       = params[:link_type]

        options = {
            site: site,
            context_path: context_path,
            auth_type: auth_type,
            username: username,
            password: password
        }

        client = JIRA::Client.new(options)
        link = client.Issuelink.build
        link.save(
          {
              type: { name: link_type },
              inwardIssue: { key: inward_issue },
              outwardIssue: { key: outward_issue }
          }
        )
      end

      def self.description
        "This plugin allows you to link two tickets together in JIRA"
      end

      def self.authors
        ["djbrooks111"]
      end

      def self.return_value
      end

      def self.details
        "This plugin allows you to link two tickets together in JIRA"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :url,
                                      env_name: "FL_JIRA_SITE",
                                      description: "URL for Jira instance",
                                       verify_block: proc do |value|
                                         UI.user_error!("No url for Jira given, pass using `url: 'url'`") if value.to_s.length == 0
                                       end),
          FastlaneCore::ConfigItem.new(key: :context_path,
                                      env_name: "FL_JIRA_CONTEXT_PATH",
                                      description: "Appends to the url (ex: \"/jira\")",
                                      optional: true,
                                      default_value: ""),
          FastlaneCore::ConfigItem.new(key: :username,
                                       env_name: "FL_JIRA_USERNAME",
                                       description: "Username for JIRA instance",
                                       verify_block: proc do |value|
                                         UI.user_error!("No username") if value.to_s.length == 0
                                       end),
          FastlaneCore::ConfigItem.new(key: :password,
                                       env_name: "FL_JIRA_PASSWORD",
                                       description: "Password for Jira",
                                       sensitive: true,
                                       verify_block: proc do |value|
                                                       UI.user_error!("No password") if value.to_s.length == 0
                                                     end),
          FastlaneCore::ConfigItem.new(key: :inward_issue,
                                       env_name: "JIRA_INWARD_ISSUE",
                                       description: "Inward Issue for Jira",
                                       sensitive: true,
                                       verify_block: proc do |value|
                                                       UI.user_error!("No inward issue") if value.to_s.length == 0
                                                     end),
          FastlaneCore::ConfigItem.new(key: :outward_issue,
                                       env_name: "JIRA_OUTWARD_ISSUE",
                                       description: "Outward Issue for Jira",
                                       sensitive: true,
                                       verify_block: proc do |value|
                                                       UI.user_error!("No outward issue") if value.to_s.length == 0
                                                     end),
          FastlaneCore::ConfigItem.new(key: :link_type,
                                       env_name: "JIRA_LINK_TYPE",
                                       description: "Issue Link Type for Jira",
                                       sensitive: true,
                                       verify_block: proc do |value|
                                                       UI.user_error!("No link type") if value.to_s.length == 0
                                                     end)

        ]
      end

      def self.is_supported?(platform)
        true
      end

      def self.example_code
        [
          'jira(
            url: "https://bugs.yourdomain.com",
            username: "Your username",
            password: "Your password",
            inwardIssue: "Ticket ID, i.e. IOS-1",
            outwardIssue: "Ticket ID, i.e. IOS-2"
            link_type: "blocks"
          )',
          'jira(
            url: "https://yourserverdomain.com",
            context_path: "/jira",
            username: "Your username",
            password: "Your password",
            inwardIssue: "Ticket ID, i.e. IOS-1",
            outwardIssue: "Ticket ID, i.e. IOS-2"
            link_type: "blocks"
          )'
        ]
      end

      def self.category
        :misc
      end
    end
  end
end
