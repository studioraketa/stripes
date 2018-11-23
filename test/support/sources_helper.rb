module Stripes
  module SourcesHelper
    def create_source
      order = Factory.create(:order)
      payment = Factory.create(:payment, purchase_order: order)
      Factory.create(:source, payment: payment)
    end
  end
end
