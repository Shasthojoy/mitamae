module MItamae
  module Resource
    AttributeMissingError = Class.new(StandardError)
    InvalidTypeError = Class.new(StandardError)

    class Base
      class << self
        attr_accessor :available_actions
        attr_accessor :defined_attributes

        def inherited(subclass)
          subclass.defined_attributes = self.defined_attributes.dup

          if Plugin::Resource.resource_plugin?(subclass)
            RecipeContext.register_resource(subclass)
          end
        end

        def define_attribute(name, options = {})
          @defined_attributes ||= {}
          @defined_attributes[name.to_sym] = options.dup
        end
      end
      self.defined_attributes = {}

      define_attribute :action, type: [Symbol, Array], required: true
      define_attribute :user, type: String
      define_attribute :cwd, type: String

      attr_accessor :attributes
      attr_accessor :only_if_command
      attr_accessor :not_if_command
      attr_reader :verify_commands
      attr_reader :notifications
      attr_reader :subscriptions
      attr_reader :resource_name
      attr_reader :recipe

      def initialize(resource_name, recipe, variables = {}, &block)
        @recipe = recipe
        @attributes = Hashie::Mash.new
        @resource_name = resource_name
        @verify_commands = []
        @notifications = []
        @subscriptions = []
        if block
          ResourceContext.new(self, variables).instance_exec(&block)
        end
        process_attributes
      end

      def resource_type
        @resource_type ||= self.class.to_s.split("::").last.gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase!
      end

      private

      def process_attributes
        self.class.defined_attributes.each_pair do |key, details|
          @attributes[key] ||= @resource_name if details[:default_name]
          @attributes[key] = details[:default] if details.has_key?(:default) && !@attributes.has_key?(key)

          if details[:required] && !@attributes.has_key?(key)
            raise AttributeMissingError, "'#{key}' attribute is required but it is not set."
          end

          if @attributes[key] && details[:type]
            valid_type = [details[:type]].flatten.any? do |type|
              @attributes[key].is_a?(type)
            end
            unless valid_type
              raise Resource::InvalidTypeError, "#{key} attribute should be #{details[:type]}."
            end
          end
        end
      end
    end
  end
end
