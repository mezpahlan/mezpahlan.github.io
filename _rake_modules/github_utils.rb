require 'open3'

module GithubUtils

    # Sync local and remote repos
    def self.sync
        puts "## Check for any unpushed changes in source branch"
        stdout, stderr, status = Open3.capture3("git rev-list --count origin/source..HEAD")
        exit_code = /exit (\d+)/.match(status.to_s)[1].to_i
        if exit_code == 0 && !stdout.nil? && stdout.to_i > 0
            branch = "source"
            push(branch)
        elsif exit_code == 0 && !stdout.nil? && stdout.to_i == 0
            puts "## Local and Remote branch in sync"
        elsif exit_code > 0 && !stderr.nil?
            abort stderr
        end
    end

    # Get the last commit hash
    def self.last_commit
        puts "## Get the latest commit from source branch"
        last_commit, stderr, status = Open3.capture3("git rev-parse --short HEAD")
        exit_code = /exit (\d+)/.match(status.to_s)[1].to_i
        if exit_code == 0 && !last_commit.nil?
            puts "## Last commit in local source branch was #{last_commit}"
        elsif exit_code > 0 && !stderr.nil?
            abort stderr
        end
        :last_commit
    end

    # Push changes to Github, if any
    def self.push(branch)
        puts "## Push changes to #{branch} branch"
        `git push origin #{branch}`
    end

    # Commit files with a message
    def self.commit(commit_msg)
        puts "## Commit changes in local master branch"
        `git commit -m \"#{commit_msg}\"`
    end

    # Stage all files in index
    def self.stage_all
        puts "## Stage all the changes in index"
        `git add -A`
    end

    class << self
    end
end
