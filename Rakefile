require 'open3'
require 'fileutils'
require 'securerandom'
require './_rake_modules/draft_utils'

desc "Build site with drafts"
task :build do
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
    exec("bundle exec jekyll serve --drafts")
end

desc "Create draft blog post"
task :draft, [:draft_name] do |t, args|
    draft_name = args[:draft_name].to_s.strip
    if draft_name.empty?
        puts "Draft name cannot be empty."
        puts "Syntax: rake draft[\"<draft_name>\"]"
    else
        filename = draft_name.downcase.gsub(/\s/,"-")+".md"
        draft_dir = "_drafts"
        outfile = File.join(draft_dir, filename)

        puts "## Create draft blog post: #{filename}"

        Dir.mkdir(draft_dir) unless File.exists?(draft_dir)

        # copy over template post
        contents = File.open("_post-template.md") do |f| f.read.gsub(/title:.+/, "title: " + draft_name) end
        IO.write(outfile, contents)

        # Update permissions mode
        File.chmod(0664, outfile)

        # create uuid for disqus
        DraftUtils.insert_disqus_id(outfile)

        # create timestamps for posts
        DraftUtils.update_single_draft_timestamp(outfile, Time.now)

        puts "## #{filename} created successfully."
    end
end

desc "Publish draft blog post"
task :publish_draft, [:draft_name] do |t, args|
    draft_name = args[:draft_name].to_s.strip.downcase.gsub(/\s/,"-")+".md"
    draft_dir = "_drafts"
    Dir.chdir(draft_dir)
    DraftUtils.publish_single_draft(draft_name)
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
        exit_code = /exit (\d+)/.match(status.to_s)[1].to_i
        if exit_code == 0 && !stdout.nil?
            puts "Success"
        elsif exit_code > 0 && !stderr.nil?
            abort stderr
        end
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
