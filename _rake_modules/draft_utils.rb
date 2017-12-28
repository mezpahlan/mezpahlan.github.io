require 'fileutils'
require 'securerandom'

module DraftUtils

    # Creates a draft given an identifier
    def self.create_draft(draft_name)
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
        insert_disqus_id(outfile)

        # create timestamps for posts
        update_single_draft_timestamp(outfile, Time.now)

        # create image asset folders pre-emtively
        create_image_folder(outfile)

        puts "## #{filename} created successfully."
    end

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

        # clean unused image folder
        clean_unused_image_folder(new_filename)
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

    # Creates an image folder given a blog post
    def self.create_image_folder(draft_name)
        image_dir = File.open(draft_name) do |f| f.read.match(/date:\s'([^T]+)T/) {|m| "assets/images/" + m[1].gsub(/-/,"/") + draft_name.gsub(/_drafts|\.md/,"")} end
        FileUtils.makedirs(image_dir)
        puts "## Created image directory  #{image_dir} for post"
    end

    # Cleans up an image directory if no images have been unused
    def self.clean_unused_image_folder(draft_name)
        image_dir = "../assets/images/" + draft_name.sub(/-/, "/").sub(/-/, "/").sub(/-/, "/").sub(/\.md/, "")
        puts "## Attempting to clean #{image_dir}"
        recursive_delete_if_empty(image_dir)
    end

    def self.recursive_delete_if_empty(dir_name)
        if Dir["#{dir_name}/*"].empty?
            FileUtils.remove_dir(dir_name)
            # try again on the parent directory
            recursive_delete_if_empty(File.expand_path("..", dir_name))
        end
    end

    class << self
        private :update_draft_filename_with_timestamp
        private :insert_disqus_id
        private :update_single_draft_timestamp
        private :create_image_folder
        private :clean_unused_image_folder
        private :recursive_delete_if_empty
    end

end
