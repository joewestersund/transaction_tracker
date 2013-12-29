json.array!(@account_balances) do |account_balance|
  json.extract! account_balance, :id, :account_id, :balance_date, :balance
  json.url account_balance_url(account_balance, format: :json)
end
