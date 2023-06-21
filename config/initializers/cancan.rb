require_dependency 'cancan/model_adapters/active_record_4_adapter'

if defined?(CanCan)
  class Object
    def metaclass
      class << self; self; end
    end
  end

  module CanCan
    module ModelAdapters
      class ActiveRecord4Adapter < ActiveRecordAdapter
        @@friendly_support = {}

        def self.find(model_class, id)
          klass =
            if model_class.metaclass.ancestors.include?(ActiveRecord::Associations::CollectionProxy)
              model_class.klass
            else
              model_class
            end
          @@friendly_support[klass] ||= klass.metaclass.ancestors.include?(FriendlyId)
          @@friendly_support[klass] == true ? model_class.friendly.find(id) : model_class.find(id)
        end
      end
    end
  end
end
