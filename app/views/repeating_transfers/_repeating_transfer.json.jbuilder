json.extract! repeating_transfer, :id, :user_id, :from_account_id, :to_account_id, :amount, :description, :repeat_start_date, :ends_after_num_occurrences, :ends, :after_date, :repeat_period, :repeat_every_x_periods, :repeat_on_x_day_of_period, :last_occurrence_added, :created_at, :updated_at
json.url repeating_transfer_url(repeating_transfer, format: :json)
