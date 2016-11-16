require 'open3'

desc "Generate blog files"
task :generate do
  puts "## Building blog using Jekyll"
  status = system("jekyll build")
  exit_code = /exit (\d+)/.match(status.to_s)[1].to_i
    if exit_code == 0 && !stdout.nil?
        puts "Success"
    elsif exit_code > 0 && !stderr.nil?
        abort stderr
    end
end

desc "Build and deploy site"
task :publish do

    puts "Check for any unpushed changes in source branch"
    stdout, stderr, status = Open3.capture3("git rev-list --count origin/source..HEAD")
    exit_code = /exit (\d+)/.match(status.to_s)[1].to_i
    if exit_code == 0 && !stdout.nil? && stdout.to_i > 0
        puts "Push changes to sources branch"
        stdout, stderr, status = Open3.capture3("git push origin source")
        puts status ? "Success" : "Failure"
    elsif exit_code == 0 && !stdout.nil? && stdout.to_i == 0
        puts "Local and Remote branch in sync"
    elsif exit_code > 0 && !stderr.nil?
        abort stderr
    end

    puts "## Get the latest commit from source branch"
    last_commit, stderr, status = Open3.capture3("git rev-parse --short HEAD")
    exit_code = /exit (\d+)/.match(status.to_s)[1].to_i
    if exit_code == 0 && !stdout.nil?
        puts "Last commit in local source branch was #{last_commit}"
    elsif exit_code > 0 && !stderr.nil?
        abort stderr
    end

    puts "## Building site using Jekyll"
    stdout, stderr, status = Open3.capture3("bundle exec jekyll build")
    exit_code = /exit (\d+)/.match(status.to_s)[1].to_i
    if exit_code == 0 && !stdout.nil?
        puts "Success"
    elsif exit_code > 0 && !stderr.nil?
        abort stderr
    end

    puts "Move into the local master branch"
    Dir.chdir("_site/")

    # TODO: check that we are using the correct branch at this level we should be in `master`

    puts "Stage all the changes in local master branch"
    stdout, stderr, status = Open3.capture3("git add -A")
    exit_code = /exit (\d+)/.match(status.to_s)[1].to_i
    if exit_code == 0 && !stdout.nil?
        puts "Success"
    elsif exit_code > 0 && !stderr.nil?
        abort stderr
    end

    puts "Commit changes in local master branch"
    stdout, stderr, status = Open3.capture3("git commit -m \"Site auto built upto and including revision #{last_commit}\"")
    exit_code = /exit (\d+)/.match(status.to_s)[1].to_i
    if exit_code == 0 && !stdout.nil?
        puts "Success"
    elsif exit_code > 0 && !stderr.nil?
        abort stderr
    end

    puts "Push changes to master branch"
    stdout, stderr, status = Open3.capture3("git push origin master")
    exit_code = /exit (\d+)/.match(status.to_s)[1].to_i
    if exit_code == 0 && !stdout.nil?
        puts "Success"
    elsif exit_code > 0 && !stderr.nil?
        abort stderr
    end

    puts "Move to local source branch"
    Dir.chdir("../")

    puts "Successfully built and pushed to GitHub."
end
