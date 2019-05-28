require 'active_support/lazy_load_hooks'
require 'active_support/core_ext/hash/indifferent_access'

module ActiveRecord::Turntable
  class Config
    include Singleton

    def self.[](key)
      instance[key]
    end

    def [](key)
      self.class.load!(ActiveRecord::Base.turntable_config_file) unless @config
      @config[key]
    end

<<<<<<< HEAD
    def self.load!(config_file = ActiveRecord::Base.turntable_config_file, env = (defined?(Rails) ? Rails.env : 'development'))
=======
    def self.load!(config_file, env = (defined?(ActiveRecord::Turntable::RackupFramework) ? ActiveRecord::Turntable::RackupFramework.env : 'development')) # FIXME
>>>>>>> tiepadrino
      instance.load!(config_file, env)
    end

    def load!(config_file, env)
      @config = YAML.load(ERB.new(IO.read(config_file)).result).with_indifferent_access[env]
      ActiveSupport.run_load_hooks(:turntable_config_loaded, ActiveRecord::Base)
    end
  end
end
