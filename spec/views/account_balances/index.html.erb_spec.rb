require 'spec_helper'

describe "account_balances/index" do
  before(:each) do
    assign(:account_balances, [
      stub_model(AccountBalance,
        :account_id => 1,
        :balance => "9.99"
      ),
      stub_model(AccountBalance,
        :account_id => 1,
        :balance => "9.99"
      )
    ])
  end

  it "renders a list of account_balances" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
  end
end
