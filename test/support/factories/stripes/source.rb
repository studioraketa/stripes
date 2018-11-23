module Stripes
  module Factories
    module Source
      def self.build(params = {})
        defaults = {
          identifier: SecureRandom.uuid,
          status: :pending,
          source_type: 'sofort',
          details: {},
          event_log: []
        }

        ::Stripes::Source.new defaults.merge(params)
      end
    end
  end
end
