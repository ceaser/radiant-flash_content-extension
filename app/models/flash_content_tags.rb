module FlashContentTags
  include Radiant::Taggable

  class TagError < StandardError; end

  tag "flash_content" do |tag|
    tag.expand
  end
  
  desc %{
    Includes the javascript required for all flash content tags. Usually this tag is included in between the head tag in the layout.

    This tag is required before any other flash_content tags will work.

    *Usage:*
    <pre><code><r:flash_content:include /></code></pre>
  }
  tag 'flash_content:include' do |tag|
    %{<script type="text/javascript" src="/javascripts/flash_content/swfobject.js"></script>}
  end

  desc %{
    Render a Adobe flash file. optionally you can also include alternative content.

    *Usage:*
<pre><code>
<r:flash_content:link width="300" height="120" [id="myId"] [alternative_part="alternative"] [version="9.0.0"]>
  /assets/1/test.swf
</r:flash_content:link>
</code></pre>

    *Usage with the Paperclipped extension "assets:url" tag*
<pre><code>
<r:flash_content:link width="300" height="120">
  <r:assets:url title="test" />
</<r:flash_content:link>
</code></pre>
  }
  tag 'flash_content:link' do |tag|
    %w(width height).each do |param|
      raise TagError, "`flash_content:link' tag must contain a `#{param}' attribute." unless tag.attr[param]
    end

    url               = tag.expand.strip
    alternative_part  = tag.attr["alternative_part"]
    version           = tag.attr["version"]           || Radiant::Config["flash_content.required_version"]
    container_id      = tag.attr["id"]                || "flash_#{rand.to_s[3..25]}"

    parameters = {}
    parameters["width"]  = tag.attr["width"]
    parameters["height"] = tag.attr["height"]
    parameters_string    = parameters.map {|k,v| "#{k}='#{v}'"}.join(" ")

    alternative_content = tag.locals.page.render_part(alternative_part) unless alternative_part.nil?
<<-EOL
<script type="text/javascript">
//<![CDATA[
  swfobject.registerObject("#{container_id}", "#{version}");
//]]>
</script>
<object id="#{container_id}" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" #{parameters_string}>
  <param name="movie" value="#{url}" />
  <!--[if !IE]>-->
  <object type="application/x-shockwave-flash" data="#{url}" #{parameters_string}>
  <!--<![endif]-->
  #{alternative_content}
  <!--[if !IE]>-->
  </object>
  <!--<![endif]-->
</object>
EOL
  end
end
