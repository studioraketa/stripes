module Stripes
  module Events
    module ChargeSucceeded
      class << self
        def call(event)
          raise 'Wrong event type' unless event.type == 'charge.succeeded'

          charge = ::Stripes::Charge.find_by!(identifier: event.obj_id)

          ActiveRecord::Base.transaction do
            charge.status = :succeeded
            charge.event_log = Array(charge.event_log) << event.to_h
            charge.payment.update!(status: :paid)
            charge.save!
          end
        end
      end
    end
  end
end
