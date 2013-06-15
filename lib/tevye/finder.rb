class Tevye::Finder < Tevye::ResourceAction
  def find(id)
    result = scope.where(id: id).first
    raise Mongoid::Errors::DocumentNotFound.new(Tevye::Finder, {}) if result.nil?
    result
  end
end