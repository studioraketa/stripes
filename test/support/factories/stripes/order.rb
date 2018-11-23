module Stripes
  module Factories
    module Order
      def self.build(*)
        # The fields in this one come from the dummy application!
        Configuration.order_class.new(uid: SecureRandom.uuid)
      end
    end
  end
end
