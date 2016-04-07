require 'open3'

desc "Generate blog files"
task :generate do
  puts "## Building blog using Jekyll"
  status = system("jekyll build")
  puts status ? "Success" : "Failed"
end

desc "Build and deploy site"
task :publish do
    puts "## Get the latest commit from source branch"

    # TODO: better error checking
    last_commit, stderr, status = Open3.capture3("git rev-parse --short HEAD")
    puts last_commit ? "Success" : "Failure"

    if status
        puts "Last commit in source branch was #{last_commit}"
    end

    puts "## Building site using Jekyll"
    stdout, stderr, status = Open3.capture3("jekyll build")
    puts status ? "Success" : "Failure"

    puts "Move into the _site directory"
    Dir.chdir("_site/")

    # TODO: check that we are using the correct branch at this level we should be in `master`

    puts "Stage all the changes"
    stdout, stderr, status = Open3.capture3("git add -A")
    puts status ? "Success" : "Failure"

    puts "Commit changes"
    stdout, stderr, status = Open3.capture3("git commit -m \"Auto built upto revision #{last_commit}\"")
    puts status ? "Success" : "Failure"

    puts "Push changes"
    stdout, stderr, status = Open3.capture3("git push origin master")
    puts status ? "Success" : "Failure"

    puts "Move to root folder"
    Dir.chdir("../")

    puts "Successfully built and pushed to GitHub."
end
