namespace :radiant do
  namespace :extensions do
    namespace :flash_content do
      
      desc "Runs the migration of the Flash Content extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          FlashContentExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          FlashContentExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Flash Content to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        Dir[FlashContentExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(FlashContentExtension.root, '')
          directory = File.dirname(path)
          puts "Copying #{path}..."
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end  
    end
  end
end
