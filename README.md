# Newebpay::Client (開發中)

`newebpay-client` 是串接藍新金流 API 的 Ruby gem。

目前狀態為`開發中`，請優先使用別的 newebpay 相關 gem 來達到您的需求(比如文末的參考資料)。

## 對應藍新金流 API 版本 MPG 2.0，文件版本號 NDNF-1.0.6
- https://www.newebpay.com/website/Page/download_file?name=Online%20Payment-Foreground%20Scenario%20API%20Specification_NDNF-1.0.6.pdf

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'newebpay-client'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install newebpay-client

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pct/newebpay-client.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).


## TODO
- 一堆
- 
- 
- 
- 


## 參考資料

此套件寫法參考了 github 上面 ruby, php, .net 等相關的 newebpay/spgateway 套件，以及感謝 ChatGPT 的 ruby gem 撰寫教學

感謝這些相關套件：
- 5xTraining/newebpay-turbo (最主要架構與程式碼，從這邊 clone 與改寫)
- cellvinchung/newebpay-rails
- lumir1031/newebpay_demo
- calvertyang/spgateway
- 5xRuby/spgateway-rails
- ZneuRay/spgateway_rails
