module Stripes
  module ChargesHelper
    def create_charge
      order = Factory.create(:order)
      payment = Factory.create(:payment, purchase_order: order)
      Factory.create(:charge, payment: payment)
    end
  end
end
