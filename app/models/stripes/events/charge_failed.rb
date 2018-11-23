module Stripes
  module Events
    module ChargeFailed
      class << self
        def call(event)
          raise 'Wrong event type' unless event.type == 'charge.failed'

          charge = ::Stripes::Charge.find_by!(identifier: event.obj_id)

          ActiveRecord::Base.transaction do
            charge.status = :failed
            charge.event_log = Array(charge.event_log) << event.to_h
            charge.payment.update!(status: :rejected)
            charge.save!
          end
        end
      end
    end
  end
end
