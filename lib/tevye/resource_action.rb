class Tevye::ActionError < Exception; end
class Tevye::ResourceAction
  extend Tevye::Resource
  
  def initialize(site_id=nil, content_type_id=nil)
    @site_id = site_id
    @content_type_id = content_type_id
  end

  def scope
    if site.respond_to? resources_name
      site.send resources_name
    else
      raise Tevye::ActionError.new("no known scope")
    end
  end

  def method_missing(meth, *args, &block)
    if scope.respond_to?(meth)
      scope.send(meth, *args, &block)
    else
      raise Tevye::ActionError.new("method not found: #{meth}")
    end
  end
  
  protected

  def site
    raise Tevye::ActionError.new("called site without specifying id") if @site_id.nil?
    @site ||= Tevye::Finder::Sites.new.find(@site_id)
  end
  
  def content_type
    raise Tevye::ActionError.new("called content_type without specifying id") if @content_type_id.nil?
    @content_type ||= Tevye::Finder::ContentTypes.new(@site_id).find(@content_type_id)
  end
end