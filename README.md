# Newebpay::Client (開發中)

`newebpay-client` 是串接藍新金流 API 的 Ruby gem。

目前狀態為`開發中`，請優先使用別的 newebpay 相關 gem 來達到您的需求(比如文末的參考資料)。

## 藍新金流 API
- [信用卡定期定額 API 1.5 ](https://www.newebpay.com/website/Page/content/download_api)
- [線上交易─幕前支付 API 2.0](https://www.newebpay.com/website/Page/content/download_api)
- [捐款平台 API 1.1](https://donation.newebpay.com/Info/Help_center/download)

## 安裝

Gemfile：

```ruby
gem 'newebpay-client'
```

執行：

```bash
$ bundle install
```

建立 `config/initializers/newebpay.rb`：

```bash
$ rails generate newebpay:install
```

設定 `config/initializers/newebpay.rb`：

```
- config.production_mode # 0: 開發環境 / 1: 正式站，預設為 0
- config.marchant_id # 商店 ID
- config.hash_key
- config.hash_iv
```

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
### 線上交易─幕前支付 
- MPG交易(多功能收款) [NPA-F01] `/MPG/mpg_gateway`
- 單筆交易查詢 [NPA-B02] `/API/QueryTradeInfo`
- 信用卡取消授權 [NPA-B01] `/API/CreditCard/Cancel`
- 信用卡請款/退款、取消請款/取消退款 [NPA-B031 ~ 34] `/API/CreditCard/Close`
- 電子錢包退款 [NPA-B06] `/API/EWallet/refund`

### 信用卡定期定額
- 建立委託 [NPA-B05] `/MPG/period`
- 回應參數-每期授權完成 [NPA-N050]
- 修改委託狀態 [NPA-B051] `/MPG/period/AlterStatus`
- 修改委託內容 [NPA-B052] `/MPG/period/AlterAmt` (可更動委託金額)


### 捐款平台
- 捐款平台


## 註冊藍新帳號
- [正式站] https://www.newebpay.com/
- [測試站] https://cwww.newebpay.com/

## 參考資料

此套件寫法參考了 github 上面 ruby, php, .net 等相關的 newebpay/spgateway 套件細節，以及感謝 ChatGPT 的 ruby gem 撰寫教學

特別感謝這些相關套件：
- [5xTraining/newebpay-turbo](https://github.com/5xTraining/newebpay-turbo) (最主要架構與程式碼，從這邊 clone 與改寫)
- [cellvinchung/newebpay-rails](https://github.com/cellvinchung/newebpay-rails)
- [calvertyang/spgateway](https://github.com/calvertyang/spgateway)
- [ZneuRay/spgateway_rails](https://github.com/ZneuRay/spgateway_rails)

