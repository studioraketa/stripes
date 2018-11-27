module Stripes
  module SourcesHelper
    def create_source(source_params: {}, payment_params: {})
      order = Factory.create(:order)
      payment = Factory.create(:payment, payment_params.merge(purchase_order: order))
      Factory.create(:source, source_params.merge(payment: payment))
    end
  end
end
