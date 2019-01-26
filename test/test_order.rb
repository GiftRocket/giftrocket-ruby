require 'minitest/autorun'
require 'webmock/minitest'
require 'giftrocket'

class OrderTest < Minitest::Test
  def test_initialization
    data = {
      "id": "QABSTARTSFSIO",
      "gifts": [{
        "amount": 30,
        "events": {
          "created_at": "2016-11-05T01:00:49.387Z",
          "delivered_at": "2016-11-05T01:02:50.057Z"
        },
        "id": "KF2BL4KDR87M",
        "message": "Thank you for your incredible work this year!",
        "order_id": "QABSTARTSFSIO",
        "recipient": {
          "email": "denise@sales.com",
          "name": "Denise Miller"
        },
        "style_id": "S0Y9RLCM26K2",
        "status": "DELIVERED"
      }],
      "payment": {
        "amount": 30,
        "fees": 2,
        "total": 32,
        "funding_source_id": "LARFAF2423"
      },
      "sender": {
        "email": "james@sales.com",
        "name": "James Fields"
      }
    }.with_indifferent_access

    order = Giftrocket::Order.new(data)
    assert_equal data[:id], order.id
    assert order.gifts[0].is_a?(Giftrocket::Gift)
    assert_equal order.gifts[0].id, 'KF2BL4KDR87M'
    assert order.payment.is_a?(Giftrocket::Payment)
    assert_equal order.payment.funding_source_id, 'LARFAF2423'
    assert order.sender.is_a?(Giftrocket::User)
    assert_equal order.sender.name, "James Fields"
  end

  describe 'requires config' do
    before do
      Giftrocket.configure do |config|
        config[:access_token] = 'abcd'
      end
    end

    def test_list
      response = {
        "orders": [{
          "id": "QABSTARTSFSIO",
          "gifts": [{
            "amount": 30,
            "events": {
              "created_at": "2016-11-05T01:00:49.387Z",
              "delivered_at": "2016-11-05T01:02:50.057Z"
            },
            "id": "KF2BL4KDR87M",
            "message": "Thank you for your incredible work this year!",
            "order_id": "QABSTARTSFSIO",
            "recipient": {
              "email": "denise@sales.com",
              "name": "Denise Miller"
            },
            "style_id": "S0Y9RLCM26K2",
            "status": "DELIVERED"
          }],
          "payment": {
            "amount": 30,
            "fees": 2,
            "total": 32,
            "funding_source_id": "LARFAF2423"
          },
          "sender": {
            "email": "james@sales.com",
            "name": "James Fields"
          }
        }]
      }

      stub_request(:get, 'https://www.giftrocket.com/api/v1/orders').
        with(query: Giftrocket.default_options).
        to_return(
          status: 200,
          body: response.to_json,
          headers: {"Content-Type"=> "application/json"}
        )
      orders = Giftrocket::Order.list
      assert_equal orders.count, 1
    end

    def test_retrieve
      id = "QABSTARTSFSIO"
      response = {
        "order": {
          "id": id,
          "gifts": [{
            "amount": 30,
            "events": {
              "created_at": "2016-11-05T01:00:49.387Z",
              "delivered_at": "2016-11-05T01:02:50.057Z"
            },
            "id": "KF2BL4KDR87M",
            "message": "Thank you for your incredible work this year!",
            "order_id": "QABSTARTSFSIO",
            "recipient": {
              "email": "denise@sales.com",
              "name": "Denise Miller"
            },
            "style_id": "S0Y9RLCM26K2",
            "status": "DELIVERED"
          }],
          "payment": {
            "amount": 30,
            "fees": 2,
            "total": 32,
            "funding_source_id": "LARFAF2423"
          },
          "sender": {
            "email": "james@sales.com",
            "name": "James Fields"
          }
        }
      }

      stub_request(:get, "https://www.giftrocket.com/api/v1/orders/#{id}").
        with(query: Giftrocket.default_options).
        to_return(
          status: 200,
          body: response.to_json,
          headers: {"Content-Type"=> "application/json"}
        )
      order = Giftrocket::Order.retrieve(id)
      assert_equal order.id, id
    end

    def test_creation
      funding_source_id = "LARFAF2423"
      gift_data = [
        {
          "amount": 30,
          "message": "Thank you for your incredible work this year!",
          "recipient": {
            "email": "denise@sales.com",
            "name": "Denise Miller",
            "delivery_method": "EMAIL"
          }
        }
      ]

      data_to_post = {
        funding_source_id: funding_source_id,
        gifts: gift_data,
        external_id: nil,
        organization_id: nil
      }

      response = {
        "order": {
          "id": "QABSTARTSFSIO",
          "gifts": [{
            "amount": 30,
            "events": {
              "created_at": "2016-11-05T01:00:49.387Z",
              "delivered_at": "2016-11-05T01:02:50.057Z"
            },
            "id": "KF2BL4KDR87M",
            "message": "Thank you for your incredible work this year!",
            "order_id": "QABSTARTSFSIO",
            "recipient": {
              "email": "denise@sales.com",
              "name": "Denise Miller"
            },
            "style_id": "S0Y9RLCM26K2",
            "status": "DELIVERED"
          }],
          "payment": {
            "amount": 30,
            "fees": 2,
            "total": 32,
            "funding_source_id": "LARFAF2423"
          },
          "sender": {
            "email": "james@sales.com",
            "name": "James Fields"
          }
        }
      }

      stub_request(:post, "https://www.giftrocket.com/api/v1/orders").
        with(body: data_to_post.merge(Giftrocket.default_options)).
        to_return(
          status: 200,
          body: response.to_json,
          headers: {"Content-Type"=> "application/json"}
        )

      order = Giftrocket::Order.create!(data_to_post)
      assert order.id
    end

  end

end
