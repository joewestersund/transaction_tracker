json.array!(@transaction_categories) do |transaction_category|
  json.extract! transaction_category, :id, :user_name, :name, :is_income, :order_in_list
  json.url transaction_category_url(transaction_category, format: :json)
end
