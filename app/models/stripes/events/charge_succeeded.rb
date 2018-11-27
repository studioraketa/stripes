module Stripes
  module Events
    module ChargeSucceeded
      class << self
        def call(event)
          raise 'Wrong event type' unless event.type == 'charge.succeeded'

          charge = ::Stripes::Charge.find_by!(identifier: event.obj_id)

          if charge.pending?
            succeed_charge(charge, event)
          else
            log_event(charge, event)
          end
        end

        private

        def succeed_charge(charge, event)
          ActiveRecord::Base.transaction do
            charge.status = :succeeded
            charge.event_log = Array(charge.event_log) << event.to_h
            charge.payment.update!(status: :paid)
            charge.save!
          end
        end

        def log_event(charge, event)
          charge.event_log = Array(charge.event_log) << event.to_h
          charge.save!
        end
      end
    end
  end
end
