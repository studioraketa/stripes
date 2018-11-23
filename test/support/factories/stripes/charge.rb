module Stripes
  module Factories
    module Charge
      def self.build(params = {})
        defaults = {
          identifier: SecureRandom.uuid,
          status: :pending,
          source_uid: SecureRandom.uuid,
          details: {},
          event_log: []
        }

        ::Stripes::Charge.new defaults.merge(params)
      end
    end
  end
end
