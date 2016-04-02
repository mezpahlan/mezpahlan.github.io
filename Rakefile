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
    system "git push origin master --force"

    Dir.chdir pwd
  end
end
