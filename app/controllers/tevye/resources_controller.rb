class Tevye::ResourcesControllerError < ActionController::ActionControllerError; end
class Tevye::ResourcesController < Tevye::BaseController
  extend Tevye::Resource
  
  respond_to :json
  
  def index
    find_resources
    respond_with_json
  end

  def show
    find_resource
    respond_with_json
  end

  def create
    create_resource
    respond_with_json
  end

  def update
    find_resource
    update_resource
    respond_with_json
  end

  def destroy
    find_resource
    destroy_resource
    respond_with_json destroyed: true
  end

  protected
  
  def respond_with_json(response=nil)
    case  
    when !response.nil?
      render json: MultiJson.dump(response)
    when !resource_variable.nil? 
      render_resource
    when !resources_variable.nil?
      render_resources
    else
      raise Tevye::ResourcesControllerError.new("No valid response type")
    end
  end
  
  def render_resource
    if resource_variable.valid?
      serializer = serializer_class.new(resource_variable, {})
      obj        = serializer.as_json
      render json: MultiJson.dump(obj)
    else
      render json: { errors: errors_json(resource_variable) }, status: 422
    end 
  end
  
  def render_resources
    render json: MultiJson.dump(resources_variable.map do |var|
      serializer_class.new(var, {}).as_json
    end)
  end

  def errors_json(model)
    model.errors.inject({}) do |errors, (field, error)|
      errors.merge(field => [].concat([error]).flatten)
    end
  end
  
  def serializer_class	
    "Tevye::#{resource_name.camelize}Serializer".constantize
  end
  
  def find_params
    params[:id]
  end
  
  def update_params
    params[resource_name.to_sym]
  end
  
  def create_params
    params[resource_name.to_sym]
  end	
  
  def update_resource
    resource_variable.update_attributes(update_params)
  end
  
  def create_resource
    self.resource_variable = creator.create(create_params)
  end
  
  def find_resource
    self.resource_variable = finder.find(find_params)
  end 

  def find_resources
    self.resources_variable = finder.all
  end 
  
  def destroy_resource
    resource_variable.destroy
  end

  def required_params
    (self.class.instance_variable_get(:@required_params) || []).map do |param|
      params[param.to_sym]
    end
  end
  
  def self.required_params(*params)
    @required_params = params
  end
  
  def finder
    @finder ||= 
      "Tevye::Finder::#{resources_name.camelize}".constantize.send(:new, *required_params)
  end

  def creator
    @creator ||=
      "Tevye::Creator::#{resources_name.camelize}".constantize.send(:new, *required_params)
  end
end