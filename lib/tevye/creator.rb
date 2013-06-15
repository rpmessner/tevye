class Tevye::CreatorError < Exception; end
class Tevye::Creator < Tevye::ResourceAction
  def create(attributes)
    scope.build(attributes) do |model|
      yield model if block_given?
    end.tap(&:save!)
  end
end