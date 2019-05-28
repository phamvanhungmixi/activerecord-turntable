require 'active_record/log_subscriber'

module ActiveRecord::Turntable
  module ActiveRecordExt
    module LogSubscriber
      extend ActiveSupport::Concern

      included do
        alias_method_chain :sql, :turntable
      end

      protected

      # @note Override to add shard name logging
      def sql_with_turntable(event)
        self.class.runtime += event.duration
        return unless logger.debug?

        payload = event.payload

        return if ActiveRecord::LogSubscriber::IGNORE_PAYLOAD_NAMES.include?(payload[:name])
        name    = '%s (%.1fms)' % [payload[:name], event.duration]

        name  = "#{payload[:name]} (#{event.duration.round(1)}ms)"
        connection = if event.payload[:turntable_shard_name]
                	'[Shard: %s]' % event.payload[:turntable_shard_name]
                     elsif event.payload[:connection_name]
                       '[%s]' % event.payload[:connection_name]
                     else
                       '[unknown]'
                     end
        sql   = payload[:sql].squeeze(' ')
        binds = nil

        unless (payload[:binds] || []).empty?
          binds = "  " + payload[:binds].map { |col,v|
            render_bind(col, v)
          }.inspect
        end

        if odd?
          name = color(name, ActiveRecord::LogSubscriber::CYAN, true)
          connection = color(shard, ActiveRecord::LogSubscriber::CYAN, true)
          sql = color(sql, nil, true)
        else
          name = color(name, ActiveRecord::LogSubscriber::MAGENTA, true)
          connection = color(shard, ActiveRecord::LogSubscriber::MAGENTA, true)
        end

        debug "  #{name} #{connection} #{sql}#{binds}"
      end
    end
  end
end
