require 'minitest/autorun'
require 'webmock/minitest'
require 'giftrocket'

class StyleTest < Minitest::Test
  def test_initialization
    data = {
      "id": "ABCD23424",
      "card": {
        "url": "https://giftrocket.imgix.net/[asset_path]/thank_you_tree.jpg"
      }
    }.with_indifferent_access
    style = Giftrocket::Style.new(data)
    assert_equal data[:id], style.id
    assert_equal data[:card], style.card
    assert_equal data[:card][:url], style.url
  end

  describe 'requires config' do
    before do
      Giftrocket.configure do |config|
        config[:access_token] = 'abcd'
      end
    end

    def test_list
      response = {
        "styles": [
          {
            "id": "ABCD23424",
            "card": {
              "url": "https://giftrocket.imgix.net/[asset_path]/thank_you_tree.jpg"
            }
          }
        ]
      }

      stub_request(:get, 'https://www.giftrocket.com/api/v1/styles').
        with(query: Giftrocket.default_options).
        to_return(
          status: 200,
          body: response.to_json,
          headers: {"Content-Type"=> "application/json"}
        )
      styles = Giftrocket::Style.list
      assert_equal styles.count, 1
    end
  end
end
