module Giftrocket
  class Campaign

    attr_accessor :id, :data

    def initialize(attributes)
      self.data = attributes.with_indifferent_access
      self.id = attributes[:id]
    end

    def self.list
      Giftrocket::Request.get(
        'campaigns',
        query: Giftrocket.default_options,
        format: 'json'
      )[:campaigns].map do |org|
        Giftrocket::Campaign.new(org)
      end
    end
  end
end
