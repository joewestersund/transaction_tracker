require 'ostruct'

class ColumnNameAndID
  def column_id
    @column_id
  end

  def column_id=(column_id)
    @column_id = column_id
  end

  def column_name
    @column_name
  end

  def column_name=(column_name)
    @column_name = column_name
  end
end

class SummariesController < ApplicationController
  before_action :signed_in_user

  def by_account
    at = get_averaging_time

    column_names = current_user.accounts.where(get_conditions(:column_names)).select("id as column_id, account_name as column_name").order(:order_in_list).all
    row_names = current_user.transactions.where(get_conditions(:row_names)).select("#{at}").group(group_by).order(order_by)
    data = current_user.transactions.where(get_conditions(:data)).select("#{at}, sum(amount) as amount_sum, account_id as column_id").group("account_id, #{group_by}")

    create_summary_table(row_names,column_names,data,:by_account)
    @user_accounts = current_user.accounts.order('order_in_list').all
  end

  def by_category
    at = get_averaging_time

    column_names = current_user.transaction_categories.where(get_conditions(:column_names)).select("id as column_id, name as column_name").order(:order_in_list).all
    row_names = current_user.transactions.where(get_conditions(:row_names)).select("#{at}").group(group_by).order(order_by)
    data = current_user.transactions.where(get_conditions(:data)).select("#{at}, sum(amount) as amount_sum, transaction_category_id as column_id").group("transaction_category_id, #{group_by}")

    create_summary_table(row_names,column_names,data,:by_category)
    @user_transaction_categories = current_user.transaction_categories.order('order_in_list').all
  end

  def by_transaction_direction
    at = get_averaging_time

    c1 = ColumnNameAndID.new
    c2 = ColumnNameAndID.new
    c3 = ColumnNameAndID.new
    c1.column_id = c1.column_name = "income"
    c2.column_id = c2.column_name = "spending"
    c3.column_id = c3.column_name = "savings"
    column_names = [c1, c2, c3 ]
    row_names = current_user.transactions.where(get_conditions(:row_names)).select("#{at}").group(group_by).order(order_by)
    sql = "select #{at}, sum(income) as income, sum(spending) as spending, (sum(income) - sum(spending)) as savings FROM (select #{at}, case when amount >=0 then amount else 0 end as spending, case when amount < 0 then -1*amount else 0 end as income from transactions where user_id = #{current_user.id}) AS SpendingAndIncome GROUP BY #{group_by}"
    data = ActiveRecord::Base.connection.exec_query(sql).rows

    create_summary_table(row_names,column_names,data,:by_transaction_direction)

  end

  private
    def get_averaging_time
      at = params[:averaging_time]
      if at == "year"
        at_str = "year, null as month, null as day"
      elsif at == "month"
        at_str = "year, month, null as day"
      else
        at = "day"
        at_str = "year, month, day"
      end
      @averaging_time = at
      return at_str
    end

    def group_by
      at = params[:averaging_time]
      if at == "year"
        "year"
      elsif at == "month"
        "year, month"
      else
        "year, month, day"
      end
    end

    def order_by
      "year, month, day" #always this, no matter the averaging time.
    end


    def create_summary_table(row_names, column_names, data, summary_type)
      row_count = row_names.each.count
      column_count = column_names.each.count
      st = SummaryTable.new(row_count, column_count)
      rows_hash = {}
      columns_hash = {}

      index=0
      row_names.each do |r|
        row_name = get_row_name(r.year, r.month, r.day)
        rows_hash[row_name] = index
        st.set_header_text(:row, index, row_name)
        href = transactions_path + get_query_string(r.year, r.month, r.day, summary_type, nil)
        st.set_header_href(:row, index, href)
        index += 1
      end

      index=0
      column_names.each do |c|
        columns_hash[c.column_id] = index
        st.set_header_text(:column,index, c.column_name)
        href = transactions_path + get_query_string(nil, nil, nil, summary_type, c.column_id)
        st.set_header_href(:column, index, href)
        index += 1
      end

      data.each do |d|
        row = rows_hash[get_row_name(d.year, d.month, d.day)]
        col_id = nil_to_zero(d.column_id)
        column = columns_hash[col_id]
        st.set_text(row, column, d.amount_sum)
        href = transactions_path + get_query_string(d.year, d.month, d.day, summary_type, d.column_id)
        st.set_href(row,column,href)
      end

      @table = st
    end

    def create_fixed_column_summary_table(row_names, column_names, data)
      row_count = row_names.each.count
      column_count = column_names.each.count
      st = SummaryTable.new(row_count, column_count)
      rows_hash = {}

      index=0
      row_names.each do |r|
        row_name = get_row_name(r.year, r.month, r.day)
        rows_hash[row_name] = index
        st.set_header_text(:row, index, row_name)
        href = transactions_path + get_query_string(r.year, r.month, r.day, :fixed, nil)
        st.set_header_href(:row, index, href)
        index += 1
      end

      index = 0
      column_names.each do |c|
        columns_hash[c] = index
        st.set_header_text(:column,index, c)
        href = transactions_path + get_query_string(nil, nil, nil, :fixed, c)
        st.set_header_href(:column, index, href)
        index += 1
      end

      #TODO: fix this function
      data.each do |d|
        row = rows_hash[get_row_name(d.year, d.month, d.day)]
        col_id = nil_to_zero(d.column_id)
        column = columns_hash[col_id]
        st.set_text(row, column, d.amount_sum)
        href = transactions_path + get_query_string(d.year, d.month, d.day, summary_type, d.column_id)
        st.set_href(row,column,href)
      end

      @table = st
    end

    def get_query_string(year,month,day,summary_type,column_id)
      qs = []
      qs << "year=#{year}" if year.present?
      qs << "month=#{month}" if month.present?
      qs << "day=#{day}" if day.present?
      qs << "account_id=#{column_id}" if summary_type == :by_account and column_id.present?
      qs << "transaction_category_id=#{column_id}" if summary_type == :by_category and column_id.present?
      if qs.length > 0
        "?" + qs.join("&")
      else
        "" #nil
      end
    end

    def get_row_name(year, month, day)
      "#{(month.to_s + '/') if month.present?}#{(day.to_s + '/') if day.present?}#{year}"
    end

    def search_params(query_type)
      if query_type == :column_names
          params.permit(:account_id, :transaction_category_id)
      else
         params.permit(:month, :day, :year, :account_id, :transaction_category_id)
      end
    end

    def get_conditions(query_type)

      search_terms = Transaction.new(search_params(query_type))

      conditions = {}
      conditions_string = []

      conditions[:month] = search_terms.month if search_terms.month.present?
      conditions_string << "month = :month" if search_terms.month.present?

      conditions[:day] = search_terms.day if search_terms.day.present?
      conditions_string << "day = :day" if search_terms.day.present?

      conditions[:year] = search_terms.year if search_terms.year.present?
      conditions_string << "year = :year" if search_terms.year.present?

      id_field_name = query_type == :column_names ? "id" : "account_id"
      conditions[:account_id] = search_terms.account_id if search_terms.account_id.present?
      conditions_string << "#{id_field_name} = :account_id" if search_terms.account_id.present?

      id_field_name = query_type == :column_names ? "id" : "transaction_category_id"
      conditions[:transaction_category_id] = search_terms.transaction_category_id if search_terms.transaction_category_id.present?
      conditions_string << "#{id_field_name} = :transaction_category_id" if search_terms.transaction_category_id.present?

      return [conditions_string.join(" AND "), conditions]
    end

end
