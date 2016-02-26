module ActiveRabbit
  module Configuration
    autoload :Context,  'active_rabbit/configuration/context'
    autoload :Exchange, 'active_rabbit/configuration/exchange'
    autoload :Sessions, 'active_rabbit/configuration/sessions'
    autoload :Bundle,   'active_rabbit/configuration/bundle'
  end
end
