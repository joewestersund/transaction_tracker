json.array!(@transfers) do |transfer|
  json.extract! transfer, :id, :user_id, :from_account_id, :to_account_id, :transfer_date, :amount, :description
  json.url transfer_url(transfer, format: :json)
end
