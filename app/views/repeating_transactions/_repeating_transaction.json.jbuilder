json.extract! repeating_transaction, :id, :user_id, :vendor_name, :account_id, :transaction_category_id, :amount, :description, :repeat_start_date, :ends_after_num_occurrences, :ends, :after_date, :repeat_period, :repeat_every_x_periods, :repeat_on_x_day_of_period, :created_at, :updated_at
json.url repeating_transaction_url(repeating_transaction, format: :json)
