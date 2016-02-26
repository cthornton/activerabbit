module ActiveRabbit
  module Configuration
    autoload :Bundle,   'active_rabbit/configuration/bundle'
    autoload :Context,  'active_rabbit/configuration/context'
    autoload :Exchange, 'active_rabbit/configuration/exchange'
    autoload :Sessions, 'active_rabbit/configuration/sessions'
    autoload :Queue,    'active_rabbit/configuration/Queue'
  end
end
