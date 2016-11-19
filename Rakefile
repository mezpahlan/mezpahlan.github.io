require 'open3'

desc "Update timestamp for drafts"
task :update_draft_timestamp do
    puts "Move into the draft directory"
    Dir.chdir("_drafts/")

    Dir.glob("*.md").each do |draft|
        puts "Update timestamp for: " + draft
        outfile = draft
        time = Time.now
        timestamp = time.strftime("'%Y-%m-%dT%H:%M:%S.%LZ'")
        contents = File.open(draft) do |f| f.read.gsub(/date:.+/, "date: " + timestamp) end
        IO.write(outfile, contents)
    end

    puts "Move into the root directory"
    Dir.chdir("../")
end

desc "Build site with drafts"
task :build do
    puts "## Building site using Jekyll including drafts"
    Rake::Task["update_draft_timestamp"].execute

    stdout, stderr, status = Open3.capture3("bundle exec jekyll build --drafts")
    exit_code = /exit (\d+)/.match(status.to_s)[1].to_i
    if exit_code == 0 && !stdout.nil?
        puts "Success"
    elsif exit_code > 0 && !stderr.nil?
        abort stderr
    end
end

desc "Serve site"
task :serve do
    Rake::Task["build"].execute
    puts "Listening on 127.0.0.1:4000"
    puts "Press Ctrl + C to stop"
    Open3.capture3("bundle exec jekyll serve --drafts")
end

desc "Create draft blog post"
task :draft, [:draft_name] do |t, args|
    puts "## Create draft blog"
    draft_dir = "_drafts"
    Dir.mkdir(draft_dir) unless File.exists?(draft_dir)
    if args[:draft_name].to_s.strip.empty?
        puts "Draft name cannot be empty."
        puts "Syntax: rake draft[\"<draft_name>\"]"
    else
        filename = args[:draft_name].to_s.strip.downcase.gsub(/\s/,"-")+".md"
        outfile = "_drafts/" + filename
        contents = File.open("_post-template.md") do |f| f.read.gsub(/title:.+/, "title: " + args[:draft_name]) end
        IO.write(outfile, contents)
        File.chmod(0664, outfile)
        puts "## " + filename + " created successfully."
    end
end

desc "Generate blog files"
task :generate do
    puts "## Building site using Jekyll"
    stdout, stderr, status = Open3.capture3("bundle exec jekyll build")
    exit_code = /exit (\d+)/.match(status.to_s)[1].to_i
    if exit_code == 0 && !stdout.nil?
        puts "Success"
    elsif exit_code > 0 && !stderr.nil?
        abort stderr
    end
end

desc "Build and deploy site"
task :deploy do
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

    Rake::Task["generate"].execute

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
