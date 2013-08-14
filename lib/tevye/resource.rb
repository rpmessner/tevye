module Tevye::Resource
  def resources_name(name)
    @__resources_name__ = name
    self.class_eval do
      def resource_variable
        self.instance_variable_get(:"@#{resource_name}")
      end
      
      def resource_variable=(value)
        self.instance_variable_set :"@#{resource_name}", value
      end

      def resources_variable
        self.instance_variable_get(:"@#{resources_name}")
      end

      def resources_variable=(value)
        self.instance_variable_set :"@#{resources_name}", value
      end

      def resource_name
        resources_name.singularize
      end
      
      def resources_name
        resource_class_var.to_s
      end
      
      private
      
      def resource_class_var
        self.class.instance_variable_get "@__resources_name__"
      end
    end
  end 
end