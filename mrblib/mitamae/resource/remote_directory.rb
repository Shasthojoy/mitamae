module MItamae
  module Resource
    class RemoteDirectory < Base
      define_attribute :action, default: :create
      define_attribute :path, type: String, default_name: true
      define_attribute :source, type: String, required: true
      define_attribute :mode, type: String
      define_attribute :owner, type: String
      define_attribute :group, type: String

      self.available_actions = [:create, :delete]
    end
  end
end
