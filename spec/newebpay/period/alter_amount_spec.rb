RSpec.describe 'Newebpay::Period::AlterAmount 更改定期定額項目' do
  it "* 可更改價金 AlterAmt" do
    trade = Newebpay::Period::AlterAmount.new(
      order_number: 'SUB_20230304140012_7EF5',
      period_no: 'P230304140837MMwmxN',
      alter_amount: 5000,
      period_type: nil,
      period_point: nil,
      period_times: nil
    )

    data = trade.request!
    res = Newebpay::Period::Response.new(data)

    # 成功或是 PER10074 需要藍新打開，先都判定為成功
    expect(res.success? || res.status == 'PER10074').to eq(true)
  end

  it "* 可更改週期 PeriodType + PeriodPoint" do
    trade = Newebpay::Period::AlterAmount.new(
      order_number: 'SUB_20230304140012_7EF5',
      period_no: 'P230304140837MMwmxN',
      alter_amount: 5000,
      period_type: 'M', # 週期改為月
      period_point: '04', # 配合週期改為月，把日期改為 每月 4 號扣款
      period_times: nil
    )

    data = trade.request!
    res = Newebpay::Period::Response.new(data)

    # 成功或是 PER10074 需要藍新打開，先都判定為成功
    expect(res.success? || res.status == 'PER10074').to eq(true)
  end
  
  it "* 可更改授權期數 PeriodTimes" do
    trade = Newebpay::Period::AlterAmount.new(
      order_number: 'SUB_20230304140012_7EF5',
      period_no: 'P230304140837MMwmxN',
      alter_amount: nil,
      period_type: nil,
      period_point: nil,
      period_times: 12, # 原本 99，改 12
    )

    data = trade.request!
    res = Newebpay::Period::Response.new(data)

    # 成功或是 PER10074 需要藍新打開，先都判定為成功
    expect(res.success? || res.status == 'PER10074').to eq(true)
  end
  
  it "* 最後恢復原樣" do
    trade = Newebpay::Period::AlterAmount.new(
      order_number: 'SUB_20230304140012_7EF5',
      period_no: 'P230304140837MMwmxN',
      alter_amount: 4500,
      period_type: 'Y',
      period_point: '0304',
      period_times: 99
    )

    data = trade.request!
    res = Newebpay::Period::Response.new(data)

    # 成功或是 PER10074 需要藍新打開，先都判定為成功
    expect(res.success? || res.status == 'PER10074').to eq(true)
  end
end
