class Tevye::DashboardsController < Tevye::BaseController
  respond_to :html
  
  def show
    sites         = Locomotive::Site.all
    content_types = Locomotive::ContentType.all
    memberships   = sites.map(&:memberships).flatten if admin?

    preload_store(:sites, sites)
    preload_store(:content_types, content_types)
    preload_store(:memberships, memberships) if admin?
  end

  private

  def preload_store(key, objects, serialize_with=nil)
    @preloaded    ||= {}
    name            = key.to_s
    serializer      = serialize_with || "Tevye::#{name.singularize.camelize}Serializer".constantize
    serializers     = objects.map {|obj| serializer.new(obj, root: false) }
    key             = name.camelize(:lower)
    @preloaded[key] = MultiJson.dump({ "#{name}" => serializers })
  end
end
