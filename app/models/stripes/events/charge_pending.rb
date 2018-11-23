module Stripes
  module Events
    module ChargePending
      class << self
        def call(event)
          raise 'Wrong event type' unless event.type == 'charge.pending'

          charge = ::Stripes::Charge.find_by!(identifier: event.obj_id)

          ActiveRecord::Base.transaction do
            charge.event_log = Array(charge.event_log) << event.to_h
            charge.save!
          end
        end
      end
    end
  end
end
