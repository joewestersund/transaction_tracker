class BalanceChecksController < ApplicationController

  def check_balance

  end

  private
    def search_params
      params.permit(:account_id, :start_date, :end_date)
    end

end
