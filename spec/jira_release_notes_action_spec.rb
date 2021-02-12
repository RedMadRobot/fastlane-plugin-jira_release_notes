describe Fastlane::Actions::JiraReleaseNotesAction do
  before(:each) do
    @username = 'user_name'
    @password = 'pass123'
    @url = 'http://mydomain.atlassian.net:443'
    @project = 'ABC'
    @version = '1.0'
    @status = 'Testable'
  end

  describe 'Release Notes' do
    before(:each) do
      @params = {
        username: @username,
        password: @password,
        url:      @url,
        project:  @project,
        version:  @version
      }
      @options = {
        username:     @username,
        password:     @password,
        site:         @url,
        context_path: '',
        auth_type:    :basic
      }
      @issues = [
        instance_double("Issue", key: "#{@project}-01", summary: 'text 1'),
        instance_double("Issue", key: "#{@project}-02", summary: 'text 2')
      ]
      expect(JIRA::Client).to receive(:new).with(@options).and_call_original
    end

    describe 'Using status' do
      before(:each) do
        @params[:status] = @status
      end

      it 'string status' do
        expect(JIRA::Resource::Issue).to receive(:jql) do |client, query|
          expect(client.options).to include(@options)
          expect(query).to eql("PROJECT = '#{@project}' AND fixVersion = '#{@version}' AND status = '#{@status}'")
        end.and_return(@issues)

        notes = Fastlane::Actions::JiraReleaseNotesAction.run(@params)
        expect(notes).to eql(@issues)
      end
    end

    describe 'Formats of version' do
      before(:each) do
        @params[:format] = 'none'
      end

      it 'string version' do
        expect(JIRA::Resource::Issue).to receive(:jql) do |client, query|
          expect(client.options).to include(@options)
          expect(query).to eql("PROJECT = '#{@project}' AND fixVersion = '#{@version}'")
        end.and_return(@issues)

        notes = Fastlane::Actions::JiraReleaseNotesAction.run(@params)
        expect(notes).to eql(@issues)
      end

      it 'regexp version' do
        versions = [
          instance_double('Version', name: @version),
          instance_double('Version', name: '1.2')
        ]
        project = instance_double('Project', versions: versions)
        @issues << instance_double('Issue', key: "#{@project}-02", summary: 'text 3')
        @params[:version] = /1./

        expect(JIRA::Resource::Project).to receive(:find) do |client, version|
          expect(client.options).to include(@options)
          expect(version).to eql(@project)
        end.and_return(project)

        expect(JIRA::Resource::Issue).to receive(:jql) do |client, query|
          expect(client.options).to include(@options)
          expect(query).to eql("PROJECT = '#{@project}' AND fixVersion in ('#{@version}', '1.2')")
        end.and_return(@issues)

        notes = Fastlane::Actions::JiraReleaseNotesAction.run(@params)
        expect(notes).to eql(@issues)
      end
    end

    describe 'Formats of issues' do
      before(:each) do
        expect(JIRA::Resource::Issue).to receive(:jql).and_return(@issues)
      end

      it 'plain notes' do
        @params[:format] = 'plain'
        notes = Fastlane::Actions::JiraReleaseNotesAction.run(@params)
        expect(notes).to eql([
          "[#{@issues[0].key}] - #{@issues[0].summary}",
          "[#{@issues[1].key}] - #{@issues[1].summary}"
        ].join("\n"))
      end

      it 'html notes' do
        @params[:format] = 'html'
        notes = Fastlane::Actions::JiraReleaseNotesAction.run(@params)
        expect(notes).to eql([
          "[<a href='#{@url}/browse/#{@issues[0].key}'>#{@issues[0].key}</a>] - #{@issues[0].summary}",
          "[<a href='#{@url}/browse/#{@issues[1].key}'>#{@issues[1].key}</a>] - #{@issues[1].summary}"
        ].join("\n"))
      end

      it 'raw notes' do
        @params[:format] = 'none'
        notes = Fastlane::Actions::JiraReleaseNotesAction.run(@params)
        expect(notes).to eql(@issues)
      end
    end
  end

  describe 'Invalid Parameters' do
    it 'raises an error if no username was given' do
      expect do
        result = Fastlane::FastFile.new.parse("lane :test do
          jira_release_notes({
            password: '#{@password}',
            url:      '#{@url}',
            project:  '#{@project}',
            version:  '#{@version}'
          })
        end").runner.execute(:test)
      end.to raise_error "No username"
    end

    it 'raises an error if no password was given' do
      expect do
        result = Fastlane::FastFile.new.parse("lane :test do
          jira_release_notes({
            username: '#{@username}',
            url:      '#{@url}',
            project:  '#{@project}',
            version:  '#{@version}'
          })
        end").runner.execute(:test)
      end.to raise_error "No password"
    end

    it 'raises an error if no url was given' do
      expect do
        result = Fastlane::FastFile.new.parse("lane :test do
          jira_release_notes({
            username: '#{@username}',
            password: '#{@password}',
            project:  '#{@project}',
            version:  '#{@version}'
          })
        end").runner.execute(:test)
      end.to raise_error "No url for Jira given"
    end

    it 'raises an error if no project was given' do
      expect do
        result = Fastlane::FastFile.new.parse("lane :test do
          jira_release_notes({
            username: '#{@username}',
            password: '#{@password}',
            url:      '#{@url}',
            version:  '#{@version}'
          })
        end").runner.execute(:test)
      end.to raise_error "No Jira project name"
    end

    it 'raises an error if no version was given' do
      expect do
        result = Fastlane::FastFile.new.parse("lane :test do
          jira_release_notes({
            username: '#{@username}',
            password: '#{@password}',
            url:      '#{@url}',
            project:  '#{@project}'
          })
        end").runner.execute(:test)
      end.to raise_error "No Jira project version"
    end

    it 'raises an error if invalid version was given' do
      expect do
        result = Fastlane::FastFile.new.parse("lane :test do
          jira_release_notes({
            username: '#{@username}',
            password: '#{@password}',
            url:      '#{@url}',
            project:  '#{@project}',
            version:  1
          })
        end").runner.execute(:test)
      end.to raise_error "'version' value must be a String or Regexp! Found #{1.class} instead."
    end
  end
end
