module ActiveRecord::Turntable
  class Shard
    module Connections; end

    DEFAULT_CONFIG = {
      "connection" => (defined?(ActiveRecord::Turntable::RackupFramework) ? ActiveRecord::Turntable::RackupFramework.env : "development")
    }.with_indifferent_access

    attr_reader :name

    def initialize(shard_spec)
      @config = DEFAULT_CONFIG.merge(shard_spec)
      @name = @config["connection"]
      ActiveRecord::Base.turntable_connections[name] = connection_pool
    end

    def connection_pool
      connection_klass.connection_pool
    end

    def connection
      connection_pool.connection.tap do |conn|
        conn.turntable_shard_name ||= name
      end
    end

    private

<<<<<<< HEAD
    def connection_klass
      @connection_klass ||= create_connection_class
    end

    def create_connection_class
      if Connections.const_defined?(name.classify)
        klass = Connections.const_get(name.classify)
      else
        klass = Class.new(ActiveRecord::Base)
        Connections.const_set(name.classify, klass)
        klass.abstract_class = true
      end
      klass.remove_connection
      klass.establish_connection ActiveRecord::Base.connection_pool.spec.config[:shards][name].with_indifferent_access
      klass
=======
    def retrieve_connection_pool
      ActiveRecord::Base.turntable_connections[name] ||=
        begin
          config = ActiveRecord::Base.configurations[ActiveRecord::Turntable::RackupFramework.env]["shards"][name]
          raise ArgumentError, "Unknown database config: #{name}, have #{ActiveRecord::Base.configurations.inspect}" unless config
          ActiveRecord::ConnectionAdapters::ConnectionPool.new(spec_for(config))
        end
    end

    def spec_for(config)
      begin
        adapter = config['adapter'] || config[:adapter]
        require "active_record/connection_adapters/#{adapter}_adapter"
      rescue LoadError => e
        raise "Please install the #{adapter} adapter: `gem install activerecord-#{adapter}-adapter` (#{e})"
      end
      adapter_method = "#{adapter}_connection"
      ActiveRecord::Base::ConnectionSpecification.new(config, adapter_method)
>>>>>>> tiepadrino
    end
  end
end
