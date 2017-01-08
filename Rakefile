require 'open3'
require 'fileutils'
require 'securerandom'

desc "Inserts a Disqus identifier"
def insert_disqus_id(draft_name)
    puts "## Creating Disqus id for #{draft_name}"
    uuid = SecureRandom.uuid
    contents = File.open(draft_name) do |f| f.read.gsub(/disqus_identifier:.+/, "disqus_identifier: " + uuid) end
    IO.write(draft_name, contents)
end

desc "Renames a single draft filename with timestamp"
def update_draft_filename_with_timestamp(draft_name, time)
    puts "## Rename #{draft_name} using timestamp"
    timestamp = time.strftime("%Y-%m-%d-")
    new_filename = timestamp + draft_name
    File.rename(draft_name, new_filename)
    return new_filename
end

desc "Updates a single draft's internal timestamp"
def update_single_draft_timestamp(draft_name, time)
    puts "## Update timestamp for: " + draft_name
    timestamp = time.strftime("'%Y-%m-%dT%H:%M:%S.%LZ'")
    contents = File.open(draft_name) do |f| f.read.gsub(/date:.+/, "date: " + timestamp) end
    IO.write(draft_name, contents)
end

desc "Update internal timestamp for all drafts"
def update_all_drafts_timestamp
    puts "## Publishing all drafts"
    Dir.glob("*.md").each do |draft|
       update_single_draft_timestamp(draft, Time.now)
    end
end

desc "Publishes a single draft from the drafts folder to the posts folder"
def publish_single_draft(draft_name)
    puts "## Publishing #{draft_name}"

    # create timestamp
    time = Time.now

    # use this to update the internal timestamp in post
    update_single_draft_timestamp(draft_name, time)

    # use this to modify the file name
    new_filename = update_draft_filename_with_timestamp(draft_name, time)

    # move new file to posts folder
    puts "## Moving #{new_filename} to posts folder"
    FileUtils.mv(new_filename, "../_posts/#{new_filename}")
end

desc "Publishes all drafts in the draft folder to the posts folder"
def publish_all_drafts
    puts "## Publishing all drafts"
    Dir.glob("*.md").each do |draft|
       publish_single_draft(draft)
    end
end

desc "Build site with drafts"
task :build do
    puts "## Entering drafts directory"
    Dir.chdir("_drafts/")
    update_all_drafts_timestamp()

    puts "## Entering root directory"
    Dir.chdir("../")

    puts "## Building site including drafts"
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
    draft_name = args[:draft_name].to_s.strip
    puts "## Create draft blog post"
    draft_dir = "_drafts"
    Dir.mkdir(draft_dir) unless File.exists?(draft_dir)
    if draft_name.empty?
        puts "Draft name cannot be empty."
        puts "Syntax: rake draft[\"<draft_name>\"]"
    else
        filename = draft_name.downcase.gsub(/\s/,"-")+".md"
        outfile = "_drafts/" + filename

        # copy over template post
        contents = File.open("_post-template.md") do |f| f.read.gsub(/title:.+/, "title: " + draft_name) end
        IO.write(outfile, contents)

        # Update permissions mode
        File.chmod(0664, outfile)

        # create uuid for disqus
        insert_disqus_id(outfile)

        puts "## #{filename} created successfully."
    end
end

desc "Publish draft blog post"
task :publish_draft, [:draft_name] do |t, args|
    draft_name = args[:draft_name].to_s.strip
    draft_dir = "_drafts"
    Dir.chdir(draft_dir)
    if draft_name.to_s.strip.empty?
        publish_all_drafts()
    else
       publish_single_draft(draft_name)
    end
    Dir.chdir("../")
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
