# frozen_string_literal: true

Newebpay.configure do |config|
  # ========
  # 必要參數
  # ========

  # (0/1 使用藍新正式站與否，預設為 0 測試站)
  config.production_mode = 0

  # Puts your MerchantID/HashKey/HashIV in environment variable
  # 商店代號
  config.merchant_id = nil 

  # 串接金鑰
  config.hash_key = nil 
  config.hash_iv = nil

  # 回傳格式 (此 gem 僅支援 JSON，不能設定)
  # config.respond_type = 'JSON'

  # Newebpay api version
  # config.version = '2.0' # 目前不使用此一設定值，由 gem 決定，原因是藍新整個 API 有很多不同 version, 先不給 user 設定(以免 user 要設定每支 api version)

  # 0 = No login required for newebpay, 1 = Must login to newebpay
  config.login_type = 0

  # ========
  # 其他參數
  # ========

  # The default language is zh-tw, you can also change it to en or jp
  # config.lang_type = ''

  # Accept integer format only, 0 means not enabled, maximum seconds is 900, minimum is 60
  # config.trade_limit  = 0

  # Paydeadline, accept varchar format only, maximum accepted 180 days
  # config.expire_date = ''

  # The URL returned when payment is completed, method: :post
  # config.return_url = ''

  # The URL ending payment information by asynchronous, method: :post
  # config.notify_url = ''

  # The URL of the numbering system, method: :post
  # config.customer_url = ''

  # Return button URL on the newebpay page
  # config.client_back_url = ''

  # Email open for modification or not, 0 means not enabled, 1 means enabled
  # config.email_modify = 0

  # Credit card lump sum, 0 means not enabled, 1 means enabled
  # config.credit = 0

  # Android Pay, 0 means not enabled, 1 means enabled
  # config.android_pay = 0

  # Samsung Pay, 0 means not enabled, 1 means enabled
  # config.samsung_pay = 0

  # LINEPAY, 0 means not enabled, 1 means enabled
  # config.line_pay  = 0

  # LINEPAY Product image URL, only accept varchar
  # config.image_url = ''

  # Credit card pay in installments, only accept varchar, 1 means open all options, 0 means not enabled, example: '3,6,12' means open 3 & 6 & 12 installments etc.
  # config.inst_flag = '0'

  # Credit card bonus, 0 means not enabled, 1 means enabled
  # config.credit_red = 0

  # UNIONPAY, 0 means not enabled, 1 means enabled
  # config.union_pay = 0

  # WEBATM, 0 means not enabled, 1 means enabled, maximum amount is 50,000 NTD
  # config.web_atm = 0

  # Transfer money, 0 means not enabled, 1 means enabled, maximum amount is 50,000 NTD
  # config.vacc = 0

  # Financial institutions can be designated, example: 'BOT,Taishin' etc.
  # config.bank_type = ''

  # Supermarket codes payment, 0 means not enabled, 1 means enabled, maximum amount is 20,000 NTD, minimum amount is 30 NTD
  # config.cvs = 0

  # Supermarket barcode payment, 0 means not enabled, 1 means enabled, maximum amount is 40,000 NTD, minimum amount is 20 NTD
  # config.bar_code = 0

  # Esum Wallet, 0 means not enabled, 1 means enabled
  # config.esun_wallet = 0

  # Taiwan pay, 0 means not enabled, 1 means enabled
  # config.taiwan_pay = 0

  # Logistics Activation, 1 means Pickup without payment, 2 means Pickup with payment, 3 means both
  # config.cvscom = 0

  # EZPay, 0 means not enabled, 1 means enabled
  # config.ez_pay = 0

  # EZWechat Pay, 0 means not enabled, 1 means enabled
  # config.ezp_wechat = 0

  # EZPali Pay, 0 means not enabled, 1 means enabled
  # config.ezp_ali_pay  = 0

  # Logistics Type, only accpet varchar, 'B2C' and 'C2C'
  # config.lgs_type = ''
end
