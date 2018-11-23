module Stripes
  class Event
    def initialize(event_hash)
      @event_hash = event_hash
    end

    def obj_id
      object_hash['id']
    end

    def type
      event_hash['type']
    end

    def to_h
      event_hash
    end

    private

    attr_reader :event_hash

    def object_hash
      event_hash.dig('data', 'object')
    end
  end
end
