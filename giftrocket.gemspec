# encoding: utf-8
require File.expand_path('../lib/giftrocket/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = 'giftrocket_ruby'
  spec.version       = Giftrocket::VERSION
  spec.summary       = "Send GiftRocket gift cards programmatically, en masse"
  spec.summary       = 'GiftRocket Gift Card Ruby API SDK'
  spec.licenses      = ['MIT']
  spec.homepage      = 'https://github.com/GiftRocket/giftrocket-ruby'
  spec.summary       = 'GiftRocket Ruby API SDK'
  spec.authors       = ['GiftRocket']
  spec.email         = ['support@giftrocket.com', 'kapil@giftrocket.com']
  spec.files         = Dir['lib/**/*.rb']

  spec.add_runtime_dependency 'activesupport', '>= 3.2'
  spec.add_runtime_dependency 'httparty', '~> 0.14.0'
  spec.add_runtime_dependency 'jwt', '1.5.6'

  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'mocha', '~> 1.1'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'simplecov', '~> 0.10'
  spec.add_development_dependency 'webmock', '~> 1.20'

end
