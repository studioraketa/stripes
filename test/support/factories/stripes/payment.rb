module Stripes
  module Factories
    module Payment
      def self.build(params = {})
        defaults = {
          payment_type: :card,
          status: :pending,
          amount: 1000,
          currency: 'eur',
          log: []
        }

        ::Stripes::Payment.new defaults.merge(params)
      end
    end
  end
end
