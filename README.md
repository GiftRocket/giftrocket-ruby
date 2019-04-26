# GiftRocket Gift Card Ruby API

- [Documentation](https://www.giftrocket.com/docs)
- [Product information](https://www.giftrocket.com/rewards)
- [Get an API Key](https://www.giftrocket.com/rewards/auth/signup)

Installation
------------

`$ gem install 'giftrocket_ruby'`

or, add to your Gemfile

```ruby
source 'https://rubygems.org'
gem 'giftrocket_ruby'
```

Usage
-----

```ruby
require 'giftrocket'

# Configure with your sandbox / production token.
Giftrocket.configure do |config|
  config[:access_token] = '[YOUR_API_KEY]'
  config[:base_api_uri] = 'https://testflight.giftrocket.com/api/v1/'
end

funding_sources = Giftrocket::FundingSource.list
campaigns = Giftrocket::Campaign.list
orders = Giftrocket::Order.list # blank at first.
gifts = Giftrocket::Gift.list # blank at first.

#
# Generate an order.
#

# Campaigns are created within the dashboard by team admins.
# They define the catalog and presentation (style) of your reward.
# API requests can always override these settings
# within the specific gift object by specifying the catalog, message, style_id, etc.
campaign_id = campaigns.first.id

# The funding source you select is how you are charged for the order.
funding_source_id = funding_sources.first.id

# Optionally pass a unique external_id for each order create call
# to guarantee that your order is idempotent and not executed multiple times.
external_id = "[OPTIONAL_EXTERNAL_ID]"

# An array data representing the gifts you'd like to send.
order_data = {
  external_id: external_id,
  funding_source_id: funding_source_id,
  campaign_id: campaign_id,
  gifts: [
    {
      "amount": 25,
      "recipient": {
        "email": "sam@yourdomain.com",
        "name": "Sam Stevens"
      }
    }
  ]
}

# Submit the order to GiftRocket.
order = Giftrocket::Order.create!(order_data)

# Retrieve the order and gift.
Giftrocket::Order.retrieve(order.id)
Giftrocket::Gift.retrieve(order.gifts.first.id)
```

Contributing
------------
The gem is maintained by GiftRocket engineers, but all are welcome to contribute.
Feel free to open an issue, submit a PR, or post a question.
