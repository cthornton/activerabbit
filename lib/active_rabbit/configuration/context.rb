module ActiveRabbit::Configuration
  class Context
    attr_reader :parent_context

    attr_reader :default_options

    attr_reader :child_contexes

    attr_reader :namespace_name

    attr_reader :config_values

    def initialize(namespace_name = nil, parent_context = nil, default_options = {})
      @parent_context = parent_context
      @default_options = default_options
      @child_contexes = {}
      @config_values = {}
      @namespace_name = normalize_name(namespace_name) if namespace_name
      if parent_context && parent_context.namespace_name && !parent_context.namespace_name.empty?
        @namespace_name = "#{parent_context.namespace_name}.#{@namespace_name}"
        @default_options = parent_context.default_options.merge!(default_options)
      end
      @default_options = default_default_options.merge(@default_options)
    end

    def default_default_options
      {
        session: :default
      }
    end

    def qualify_name(name)
      name = normalize_name(name)
      if namespace_name && !namespace_name.empty?
        "#{namespace_name}.#{name}"
      else
        name
      end
    end

    def normalize_name(name)
      if name.is_a?(Symbol)
        name.to_s.gsub('_', '-')
      elsif name.is_a?(String)
        name
      else
        raise ArgumentError, "Expected String or Symbol, got #{name.class.name}"
      end
    end

    def add_config_value(unqualified_name, value)
      config_values[qualify_name(unqualified_name)] = value
    end

    def effective_options(options = {})
      default_options.merge(options)
    end

    def parent_context?
      !parent_context.nil?
    end

    def defaults(options = {})
      default_options.merge!(options)
    end

    def namespace(name, default_options = {}, &block)
      raise ArgumentError, 'block not given' unless block_given?
      name = normalize_name(name)
      context = self.class.new(name, self, default_options)
      context.configure(&block)
      child_contexes[name] = context
    end

    # Given a fully qualified value, i.e. "some.namespace.some-value",
    # returns that value, or nil
    def search_values(fully_qualified_name)
      search_pieces(normalize_name(fully_qualified_name).split('.'))
    end

    def search_values!(fully_qualified_name)
      search_values(fully_qualified_name) || raise(ArgumentError, "Unknown value '#{fully_qualified_name}'")
    end

    def search_pieces(fully_qualified_name_array)
      # Last item
      if !fully_qualified_name_array.any?
        return nil
      elsif fully_qualified_name_array.size == 1
        item = fully_qualified_name_array[0]
        return config_values[item]
      else
        search = fully_qualified_name_array.shift
        if(context =  child_contexes[search])
          return context.search_pieces(fully_qualified_name_array)
        else
          return null
        end
      end
    end

    def configure(&block)
      instance_eval(&block)
    end
    alias_method :draw, :configure

    def flatten_contexes
      all_contexes = [this]
      child_contexes.values.each do |child|
        all_contexes.concat(child.flatten_contexes)
      end
      all_contexes
    end

    def all_values
      values = config_values.dup
      child_contexes.values.each do |child|
        values.merge!(child.all_values)
      end
      values
    end
  end
end
