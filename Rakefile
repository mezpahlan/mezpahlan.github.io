require './_rake_modules/draft_utils'
require './_rake_modules/jekyll_utils'
require './_rake_modules/github_utils'

desc "Serve site"
task :serve do
    JeykllUtils.serve_site_with_drafts()
end

desc "Create draft blog post"
task :draft, [:draft_name] do |t, args|
    draft_name = args[:draft_name].to_s.strip
    if draft_name.empty?
        puts "Draft name cannot be empty."
        puts "Syntax: rake draft[\"<draft_name>\"]"
    else
        DraftUtils.create_draft(draft_name)
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

desc "Build and deploy site"
task :deploy do
    GithubUtils.sync()

    last_commit = GithubUtils.last_commit()

    JeykllUtils.build_site()

    puts "## Move into the local master branch"
    Dir.chdir("_site/")

    GithubUtils.stage_all()

    commit_msg = "Site auto built upto and including revision #{last_commit}"
    GithubUtils.commit(commit_msg)

    branch = "master"
    GithubUtils.push(branch)

    puts "## Move to local source branch"
    Dir.chdir("../")

    puts "## Successfully built and pushed to GitHub."
end
