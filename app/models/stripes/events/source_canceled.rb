module Stripes
  module Events
    module SourceCanceled
      class << self
        def call(event)
          raise 'Wrong event type' unless event.type == 'source.canceled'

          source = ::Stripes::Source.find_by!(identifier: event.obj_id)

          if source.pending?
            cancel_source(source, event)
          else
            log_event(source, event)
          end
        end

        private

        def cancel_source(source, event)
          ActiveRecord::Base.transaction do
            source.status = :canceled
            source.event_log = Array(source.event_log) << event.to_h
            source.payment.update!(status: :rejected)
            source.save!
          end
        end

        def log_event(source, event)
          source.event_log = Array(source.event_log) << event.to_h
          source.save!
        end
      end
    end
  end
end
