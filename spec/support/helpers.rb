module Spec
  module Helpers

    def image_file
      @_image_file ||= FixturedAsset.open('5k.png')
    end
    
    def stylesheet_file
      @_stylesheet_file ||= FixturedAsset.open('main.css')
    end
    
    def javascript_file
      @_javascript_file ||= FixturedAsset.open('application.js')
    end
    
    def json(type)
      name = type.to_s
      object = Kernel.eval type, binding
      serializer = "Tevye::#{name.singularize.camelize}Serializer".constantize
      MultiJson.dump({name.pluralize => [serializer.new(object, root: false)]})
    end

    def create_site
      @site ||= FactoryGirl.create('test site')
    end

    def create_content_type
      attributes = { slug: 'test_type', name: 'Test Type' }
      attributes.merge! site: @site unless @site.nil?
      FactoryGirl.build(:content_type, attributes) do |type|
        type.entries_custom_fields.build label: 'String Field', type: 'string', position: 0
        type.entries_custom_fields.build label: 'Text Field', type: 'text', position: 1
        type.entries_custom_fields.build label: 'File Field', type: 'file', position: 2
        type.entries_custom_fields.build label: 'Date Field', type: 'date', position: 3
        type.entries_custom_fields.build label: 'Boolean Field', type: 'boolean', position: 4
        type.entries_custom_fields.build label: 'Money Field', type: 'money', position: 5
        type.entries_custom_fields.build label: 'Float Field', type: 'float', position: 6
        type.entries_custom_fields.build label: 'Select Field', type: 'select', select_options: [{name: 'one'}], position: 7
      end.tap(&:save!).tap do |type|
        name = type.entries_class_name
        type.entries_custom_fields.build class_name: name, label: 'Has Many Field', position: 8,
                                         type: 'has_many', inverse_of: :belongs_to_field
        type.entries_custom_fields.build class_name: name, label: 'Belongs To Field', position: 9,
                                         type: 'belongs_to', inverse_of: :has_many_field
        type.entries_custom_fields.build class_name: name, label: 'Many To Many Field', position: 10,
                                         type: 'many_to_many', inverse_of: :many_to_many_inverse_field
        type.entries_custom_fields.build class_name: name, label: 'Many To Many Inverse Field', position: 11,
                                         type: 'many_to_many', inverse_of: :many_to_many_field
      end.tap(&:save!).reload
    end
  end
end