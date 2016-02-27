require 'yaml'

module ActiveRabbit::Configuration

  # Specifies a bunch of Bunny configurations
  class SessionLoader < Hash
    alias_method :define, :[]=

    def load_yaml_file!(path_to_yaml, env)
      results = YAML.load_file(path_to_yaml).fetch(env.to_s)
      merge!(results)
    end

    def default
      self['default']
    end

    def to_session(name)
      value = fetch(name.to_s)
      return value if value.is_a?(Bunny::Session)
      Bunny::Session.new(value)
    end
  end
end
