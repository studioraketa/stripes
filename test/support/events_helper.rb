module Stripes
  module EventsHelper
    def build_event(event_type, event_target)
      Stripes::Event.new(
        'id' => SecureRandom.uuid,
        'type' => event_type,
        'data' => {
          'object' => { 'id' => event_target.identifier }
        }
      )
    end
  end
end
