module MetaModel
  class MetaModelSerializer < ActiveModel::Serializer

    def _type
      object.type.pluralize
    end

    def initialize *args, &block
      super
      args.first.setup_serializer(self)
    end

    # Return the +attributes+ of +object+ as presented
    # by the serializer.
    def attributes(requested_attrs = nil, reload = false)
      @attributes = nil if reload
      @attributes ||= self.singleton_class._attributes_data.each_with_object({}) do |(key, attr), hash|
        next if attr.excluded?(self)
        next unless requested_attrs.nil? || requested_attrs.include?(key)
        hash[key] = object.send(key)
      end
    end


    def associations(include_tree = DEFAULT_INCLUDE_TREE)
      return unless object

      Enumerator.new do |y|
        self.singleton_class._reflections.each do |reflection|
          next if reflection.excluded?(self)
          key = reflection.options.fetch(:key, reflection.name)
          next unless include_tree.key?(key)
          y.yield reflection.build_association(self, instance_options)
        end
      end
    end
  end
end
