module ActiveRabbit
  module Configuration
    autoload :Context,       'active_rabbit/configuration/context'
    autoload :Exchange,      'active_rabbit/configuration/exchange'
    autoload :SessionLoader, 'active_rabbit/configuration/session_loader'
    autoload :Queue,         'active_rabbit/configuration/Queue'
  end
end
