module Stripes
  module ChargesHelper
    def create_charge(charge_params: {}, payment_params: {})
      order = Factory.create(:order)
      payment = Factory.create(:payment, payment_params.merge(purchase_order: order))
      Factory.create(:charge, charge_params.merge(payment: payment))
    end
  end
end
