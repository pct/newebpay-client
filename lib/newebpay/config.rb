# frozen_string_literal: true

module Newebpay
  module Config
    mattr_accessor :options

    OPTIONS = %w[
      ProductionMode
      MerchantID
      HashKey
      HashIV
      RespondType
      Version
      LangType
      TradeLimit
      ExpireDate
      ReturnURL
      NotifyURL
      CustomerURL
      ClientBackURL
      EmailModify
      LoginType
      CREDIT
      ANDROIDPAY
      SAMSUNGPAY
      LINEPAY
      ImageUrl
      InstFlag
      CreditRed
      UNIONPAY
      WEBATM
      VACC
      BankType
      CVS
      BARCODE
      ESUNWALLET
      TAIWANPAY
      CVSCOM
      EZPAY
      EZPWECHAT
      EZPALIPAY
      LgsType
    ].freeze

    # TradeInfo 參數
    MAPPING_TABLE = {
      ProductionMode: 'production_mode', # 此 gem 獨有 (0/1，預設為 0，使用開發環境網址) 
      MerchantID: 'merchant_id', # 商店代號
      HashKey: 'hash_key', # 商店專屬 HashKey
      HashIV: 'hash_iv', # 商店專屬 HashIV
      RespondType: 'respond_type', # 回傳格式 (JSON or String)，目前 gem 僅支援 JSON
      Version: 'version', # 串接程式版本, 目前為 2.0
      LangType: 'lang_type', # 語系，可設定為 en/zh-tw/jp，預設為 zh-tw
      TradeLimit: 'trade_limit', # 交易有效時間(秒數)，介於 60-900 秒，如果設定為 0 或不設定，則為不啟用秒數限制
      ExpireDate: 'expire_date', # 繳費有效期限，預設為 7 天，格式為date('Ymd')，亦即 '20140620'；最大值為 180 天
      ReturnURL: 'return_url', # 交易完成後，返回的網址(需接受 Form POST, port: 80, 443)
      NotifyURL: 'notify_url', # 支付通知網址 (以幕後方式通知交付完成的網址, port: 80, 443)
      CustomerURL: 'customer_url', # 系統取號後，返回的 Form POST 網址
      ClientBackURL: 'client_back_url', # 藍新頁面上的「返回」連結網址
      EmailModify: 'email_modify', # 付款人電子信箱是否開放修改(0/1, 預設為 1 可修改)
      LoginType: 'login_type', # 需登入為藍新金流會員？ (0/1，無預設值
      CREDIT: 'credit', # 信用卡一次付清啟用？ (0/1，預設為 0 不啟用)
      ANDROIDPAY: 'android_pay', # Google Pay (0/1，預設為 0 不啟用)
      SAMSUNGPAY: 'samsung_pay', # Samsung Pay (0/1，預設為 0 不啟用)
      LINEPAY: 'line_pay', # LINE Pay (0/1，預設為 0 不啟用)
      ImageUrl: 'image_url', # LINE Pay 專用圖，84x84 jpg/png
      InstFlag: 'inst_flag', # 信用卡分期付款啟用 (0/1/3/6/12/18/24/30)，預設為 0 不分期
      CreditRed: 'credit_red', # 信用卡紅利啟用(0/1，預設為 0 不啟用) 
      UNIONPAY: 'union_pay', # 銀聯卡啟用 (0/1，預設為 0 不啟用)
      WEBATM: 'web_atm', # WEBATM 啟用 (0/1，預設為 0 不啟用；但金額超過 49,999 時，藍新頁面仍不會出現此選項)
      VACC: 'vacc', # ATM 轉帳啟用 (0/1，預設為 0 不啟用；但金額超過 49,999 時，藍新頁面仍不會出現此選項)
      BankType: 'bank_type', # 指定金融機構，預設為空(支援所有指定銀行)，或是 [BOT,HNCB,FirstBank] (台灣銀行, 華南銀行, 第一銀行) (每日的 00:00:00-01:00:00 為第一銀行例行維護時間)
      CVS: 'cvs', # 超商代碼繳費啟用 (0/1，預設為 0 不啟用)，但若啟用，消費金額須在 30-20000 間，否則藍新頁面仍不會運作
      BARCODE: 'bar_code', # BARCODE (0/1，預設為 0 不啟用)，但若啟用，消費金額須在 20-40000 間，否則藍新頁面仍不會運作
      ESUNWALLET: 'esun_wallet', # 玉山 Wallet 啟用 (0/1，預設為 0 不啟用)
      TAIWANPAY: 'taiwan_pay', # 台灣 Pay 啟用 (0/1，預設為 0 不啟用)，但若啟用，消費金額須在 1-49999 間，否則藍新頁面仍不會運作
      CVSCOM: 'cvscom', # 超商物流啟用 (0/1取貨不付款/2取貨付款/3取貨不付款及取貨付款，預設為 0 不啟用)，且訂單金額不得大於超商之 20000 元限制
      EZPAY: 'ez_pay', # 簡單付電子錢包啟用 (0/1，預設為 0 不啟用)
      EZPWECHAT: 'ezp_wechat', # 簡單付微信支付 (0/1，預設為 0 不啟用)
      EZPALIPAY: 'ezp_ali_pay', # 簡單付支付寶 (0/1，預設為 0 不啟用)
      LgsType: 'lgs_type' # 物流型態 (B2C, C2C)
    }.freeze

    self.options = {}.with_indifferent_access

    OPTIONS.each do |option|
      transfer_option = MAPPING_TABLE[:"#{option}"]
      define_method("#{transfer_option}=") do |value|
        options[option] = value
      end
    end

    def configure
      yield self
    end
  end
end

# 其他應自行變動的 TradeInfo 參數
# - TimeStamp 時間戳記
# - MerchantOrderNo 商店訂單編號
# - Amt 訂單金額
# - ItemDesc 商品資訊
# - Email 付款人電子信箱
# - OrderComment 商店備註
