# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class FlashContentExtension < Radiant::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/flash_content"
  
  # define_routes do |map|
  #   map.connect 'admin/flash_content/:action', :controller => 'admin/flash_content'
  # end
  
  def activate
    # admin.tabs.add "Flash Content", "/admin/flash_content", :after => "Layouts", :visibility => [:all]
  end
  
  def deactivate
    # admin.tabs.remove "Flash Content"
  end
  
end