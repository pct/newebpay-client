RSpec.describe 'Newebpay::Period::AlterStatus 定期定額訂單更改狀態' do
  it "* 更改定期定額訂單狀態為暫停" do
    trade = Newebpay::Period::AlterStatus.new(
      order_number: 'SUB_20230304140012_7EF5',
      period_no: '23030414083817190',
      alter_type: 'suspend'
    )

    data = trade.request!
    res = Newebpay::Period::Response.new(data)

    # 成功或是 PER10074 需要藍新打開，先都判定為成功
    expect(res.success? || res.status == 'PER10074').to eq(true)
  end

  it "* 更改定期定額訂單狀態為重新啟用" do
    trade = Newebpay::Period::AlterStatus.new(
      order_number: 'SUB_20230304140012_7EF5',
      period_no: '23030414083817190',
      alter_type: 'restart'
    )

    data = trade.request!
    res = Newebpay::Period::Response.new(data)

    # 成功或是 PER10074 需要藍新打開，先都判定為成功
    expect(res.success? || res.status == 'PER10074').to eq(true)
  end
end
