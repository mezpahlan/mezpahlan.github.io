require 'open3'

desc "Generate blog files"
task :generate do
  puts "## Building blog using Jekyll"
  status = system("jekyll build")
  puts status ? "Success" : "Failed"
end

# TODO: better error checking
desc "Build and deploy site"
task :publish do

    puts "Check for any unpushed changes in source branch"
    stdout, stderr, status = Open3.capture3("git rev-list --count origin/source..HEAD")
    if status && !stdout.nil? && stdout.to_i > 0
        puts "Push changes to sources branch"
        stdout, stderr, status = Open3.capture3("git push origin source")
        puts status ? "Success" : "Failure"
    elsif status && !stdout.nil?
        puts "Local and Remote branch in sync"
    elsif status && !stderr.nil?
        puts stderr
    end

    puts "## Get the latest commit from source branch"
    last_commit, stderr, status = Open3.capture3("git rev-parse --short HEAD")
    puts last_commit ? "Success" : "Failure"

    if status
        puts "Last commit in local source branch was #{last_commit}"
    end

    puts "## Building site using Jekyll"
    stdout, stderr, status = Open3.capture3("jekyll build")
    puts status ? "Success" : "Failure"

    puts "Move into the local master branch"
    Dir.chdir("_site/")

    # TODO: check that we are using the correct branch at this level we should be in `master`

    puts "Stage all the changes in local master branch"
    stdout, stderr, status = Open3.capture3("git add -A")
    puts status ? "Success" : "Failure"

    puts "Commit changes in local master branch"
    stdout, stderr, status = Open3.capture3("git commit -m \"Site auto built upto and including revision #{last_commit}\"")
    puts status ? "Success" : "Failure"

    puts "Push changes to master branch"
    stdout, stderr, status = Open3.capture3("git push origin master")
    puts status ? "Success" : "Failure"

    puts "Move to local source branch"
    Dir.chdir("../")

    puts "Successfully built and pushed to GitHub."
end
