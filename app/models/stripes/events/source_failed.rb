module Stripes
  module Events
    module SourceFailed
      class << self
        def call(event)
          raise 'Wrong event type' unless event.type == 'source.failed'

          source = ::Stripes::Source.find_by!(identifier: event.obj_id)

          ActiveRecord::Base.transaction do
            source.status = :failed
            source.event_log = Array(source.event_log) << event.to_h
            source.payment.update!(status: :rejected)
            source.save!
          end
        end
      end
    end
  end
end
