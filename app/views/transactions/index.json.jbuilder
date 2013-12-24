json.array!(@transactions) do |transaction|
  json.extract! transaction, :id, :date, :vendor_name, :amount, :description
  json.url transaction_url(transaction, format: :json)
end
