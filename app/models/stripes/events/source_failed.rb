module Stripes
  module Events
    module SourceFailed
      class << self
        def call(event)
          raise 'Wrong event type' unless event.type == 'source.failed'

          source = ::Stripes::Source.find_by!(identifier: event.obj_id)

          if source.pending?
            fail_source(source, event)
          else
            log_event(source, event)
          end
        end

        private

        def fail_source(source, event)
          ActiveRecord::Base.transaction do
            source.status = :failed
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
