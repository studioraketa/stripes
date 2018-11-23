Dir[Stripes::Engine.root.join('test', 'support', 'factories', 'stripes', '*.rb')].each do |file|
  require file
end

module Stripes
  module Factory
    FACTORIES_MAP = {
      order: ::Stripes::Factories::Order,
      payment: ::Stripes::Factories::Payment,
      source: ::Stripes::Factories::Source,
      charge: ::Stripes::Factories::Charge
    }.freeze

    class << self
      def build(key, params = {})
        factory(key).build(params)
      end

      def create(key, params = {})
        factory(key).build(params).tap(&:save!)
      end

      private

      def factory(key)
        FACTORIES_MAP[key] || raise("Factory #{key} is not defined!")
      end
    end
  end
end
