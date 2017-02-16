require 'fileutils'
require 'securerandom'

module DraftUtils

    # Inserts a Disqus identifier
    def self.insert_disqus_id(draft_name)
        puts "## Creating Disqus id for #{draft_name}"
        uuid = SecureRandom.uuid
        contents = File.open(draft_name) do |f| f.read.gsub(/disqus_identifier:.+/, "disqus_identifier: " + uuid) end
        IO.write(draft_name, contents)
    end

    # Updates a single draft's internal timestamp
    def self.update_single_draft_timestamp(draft_name, time)
        puts "## Update timestamp for: #{draft_name}"
        timestamp = time.strftime("'%Y-%m-%dT%H:%M:%S.%LZ'")
        contents = File.open(draft_name) do |f| f.read.gsub(/date:.+/, "date: " + timestamp) end
        IO.write(draft_name, contents)
    end

    # Publishes a single draft from the drafts folder to the posts folder
    def self.publish_single_draft(draft_name)
        puts "## Publishing #{draft_name}"

        # modify the file name with the timestamp from post
        new_filename = update_draft_filename_with_timestamp(draft_name)

        # move new file to posts folder
        puts "## Moving #{new_filename} to posts folder"
        FileUtils.mv(new_filename, "../_posts/#{new_filename}")
    end

    # Renames a single draft filename with timestamp
    def self.update_draft_filename_with_timestamp(draft_name)
        # Read date property in draft
        file_timestamp_prefix = File.open(draft_name) do |f| f.read.match(/date:\s'([^T]+)T/) {|m| m[1] + "-"} end

        puts "## Rename #{draft_name} using timestamp"
        new_filename = file_timestamp_prefix + draft_name
        File.rename(draft_name, new_filename)
        return new_filename
    end

    class << self
        private :update_draft_filename_with_timestamp
    end

end
