module JeykllUtils

    # Builds site including any drafts
    def self.buid_site_with_drafts
        puts "## Building site including drafts"
        `bundle exec jekyll build --drafts`
    end

    # Builds site
    def self.build_site
        puts "## Building site"
        `bundle exec jekyll build`
    end

    # Serve site including any drafts
    def self.serve_site_with_drafts
        puts "## Serving site including drafts"
        exec("bundle exec jekyll serve --drafts")
    end

    # Serve site
    def self.serve_site
        puts "## Serving site"
        exec("bundle exec jekyll serve")
    end

    class << self

    end

end
