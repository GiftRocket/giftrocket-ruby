module Giftrocket
  class Order

    attr_accessor :id, :external_id, :gifts, :payment, :sender

    def initialize(attributes)
      attributes = attributes.with_indifferent_access
      self.id = attributes[:id]
      self.external_id = attributes[:external_id]
      self.gifts = attributes[:gifts].map do |gift_attributes|
        Gift.new(gift_attributes)
      end

      self.payment = Giftrocket::Payment.new(attributes[:payment])
      self.sender = Giftrocket::User.new(attributes[:sender])
    end

    def self.create!(data)
      raise Giftrocket::Error.new("funding_source_id required") if data[:funding_source_id] == nil

      response = Giftrocket::Request.post 'orders',
        body: data.merge(Giftrocket.default_options).to_json,
        headers: { 'Content-Type' => 'application/json' }

      Giftrocket::Order.new(response[:order])
    end

    def self.list(filters={})
      Giftrocket::Request.get(
        'orders',
        query: filters.merge(Giftrocket.default_options),
        format: 'json'
      )[:orders].map do |order_attributes|
        Giftrocket::Order.new(order_attributes)
      end
    end

    def self.retrieve(id)
      response = Giftrocket::Request.get "orders/#{id}",
                                         query: Giftrocket.default_options,
                                         format: 'json'

      Giftrocket::Order.new(response[:order])
    end
  end
end
