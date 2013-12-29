require 'spec_helper'

describe "account_balances/edit" do
  before(:each) do
    @account_balance = assign(:account_balance, stub_model(AccountBalance,
      :account_id => 1,
      :balance => "9.99"
    ))
  end

  it "renders the edit account_balance form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", account_balance_path(@account_balance), "post" do
      assert_select "input#account_balance_account_id[name=?]", "account_balance[account_id]"
      assert_select "input#account_balance_balance[name=?]", "account_balance[balance]"
    end
  end
end
