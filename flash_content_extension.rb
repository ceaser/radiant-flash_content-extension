# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class FlashContentExtension < Radiant::Extension
  version "0.1"
  description "Adds tags to make it easier to embed Adobe Flash content"
  url "http://github.com/ceaser/radiant-flash_content-extension"
  
  # define_routes do |map|
  #   map.connect 'admin/flash_content/:action', :controller => 'admin/flash_content'
  # end
  
  def activate
    begin
      return if ActiveRecord::Migrator.current_version == 0
    rescue
      return
    end

    Page.send :include, FlashContentTags

    Radiant::Config["flash_content.required_version"] = "9.0.0" if Radiant::Config["flash_content.required_version"].nil?
  end
  
  def deactivate
    # admin.tabs.remove "Flash Content"
  end
  
end