module Stripes
  module Events
    module SourceCanceled
      class << self
        def call(event)
          raise 'Wrong event type' unless event.type == 'source.canceled'

          source = ::Stripes::Source.find_by!(identifier: event.obj_id)

          ActiveRecord::Base.transaction do
            source.status = :canceled
            source.event_log = Array(source.event_log) << event.to_h
            source.payment.update!(status: :rejected)
            source.save!
          end
        end
      end
    end
  end
end
