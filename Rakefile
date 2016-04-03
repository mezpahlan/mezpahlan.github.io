require "rubygems"
require "tmpdir"

require "bundler/setup"
require "jekyll"


# GitHub username/reponame
GITHUB_REPONAME = "mezpahlan/mezpahlan.github.io.git"


desc "Generate blog files"
task :generate do
  Jekyll::Site.new(Jekyll.configuration({
    "source"      => ".",
    "destination" => "_site"
  })).process
end


desc "Generate and publish blog to Github"
task :publish => [:generate] do
  Dir.mktmpdir do |tmp|
    cp_r "_site/.", tmp

    pwd = Dir.pwd
    Dir.chdir tmp

    system "git init"
    system "git add ."
    message = "Auto generated from source branch at #{Time.now}"
    system "git commit -m #{message.inspect}"
    system "git remote add origin https://github.com/#{GITHUB_REPONAME}"
    system "git push origin master"

    Dir.chdir pwd
  end
end

desc "Deploy _site/ to master branch"
task :fancy_publish  => [:generate] do
  puts "\n## Switching back to source branch"
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
