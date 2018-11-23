module Stripes
  module Events
    module Dispatcher
      class << self
        EVENTS_HANDLERS = {
          'source.canceled' => Events::SourceCanceled,
          'source.chargeable' => Events::SourceChargeable,
          'source.failed' => Events::SourceFailed,
          'charge.pending' => Events::ChargePending,
          'charge.succeeded' => Events::ChargeSucceeded,
          'charge.failed' => Events::ChargeFailed
        }.freeze

        def call(event)
          event_handler = EVENTS_HANDLERS[event.type]

          if event_handler.blank?
            raise ::Stripes::InvalidParametersError, "Unknown event type #{event.type} for #{event.to_h}"
          end

          event_handler.call(event)
        end
      end
    end
  end
end
