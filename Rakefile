require "rubygems"
require "bundler/setup"
require "jekyll"

desc "Generate blog files"
task :generate do
  puts "\## Building blog using Jekyll"
  status = Jekyll::Site.new(Jekyll.configuration({
    "source"      => ".",
    "destination" => "_site"
  })).process
  puts status ? "Success" : "Failed"
end

desc "Deploy _site/ to master branch"
task :publish do
  puts "\n## Ensure we are in sources branch to begin"
  status = system("git checkout sources")
  puts status ? "Success" : "Failed"

  puts "\n## Deleting master branch"
  status = system("git branch -D master")
  puts status ? "Success" : "Failed"

  puts "\n## Creating new master branch and switching to it"
  status = system("git checkout -b master")
  puts status ? "Success" : "Failed"

  puts "\n## Forcing the _site subdirectory to be project root"
  status = system("git filter-branch --subdirectory-filter _site/ -f")
  puts status ? "Success" : "Failed"

  puts "\n## Switching back to source branch"
  status = system("git checkout sources")
  puts status ? "Success" : "Failed"

  puts "\n## Pushing all branches to origin"
  status = system("git push --all origin")
  puts status ? "Success" : "Failed"
end
