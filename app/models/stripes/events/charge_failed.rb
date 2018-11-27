module Stripes
  module Events
    module ChargeFailed
      class << self
        def call(event)
          raise 'Wrong event type' unless event.type == 'charge.failed'

          charge = ::Stripes::Charge.find_by!(identifier: event.obj_id)

          if charge.pending?
            fail_charge(charge, event)
          else
            log_event(charge, event)
          end
        end

        private

        def fail_charge(charge, event)
          ActiveRecord::Base.transaction do
            charge.status = :failed
            charge.event_log = Array(charge.event_log) << event.to_h
            charge.payment.update!(status: :rejected)
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
