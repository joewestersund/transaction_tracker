class SummariesController < ApplicationController

  def by_account
    at = get_averaging_time
    has_null_column = current_user.transactions.where("account_id IS NULL").count > 0
    column_names = current_user.accounts.select("id as column_id, account_name as column_name").order(:order_in_list).all
    row_names = current_user.transactions.select("#{at}").group(group_by).order(order_by)
    data = current_user.transactions.select("#{at}, sum(amount) as amount_sum, account_id as column_id").group("account_id, #{group_by}")
    create_summary_table(row_names,column_names,has_null_column,data)
  end

  def by_category
    at = get_averaging_time
    has_null_column = current_user.transactions.where("transaction_category_id IS NULL").count > 0
    column_names = current_user.transaction_categories.select("id as column_id, name as column_name").order(:order_in_list).all
    row_names = current_user.transactions.select("#{at}").group(group_by).order(order_by)
    data = current_user.transactions.select("#{at}, sum(amount) as amount_sum, transaction_category_id as column_id").group("transaction_category_id, #{group_by}")
    create_summary_table(row_names,column_names,has_null_column,data)
  end

private
  def get_averaging_time
    at = params[:averaging_time]
    if at == "year"
      "year, null as month, null as day"
    elsif at == "month"
      "year, month, null as day"
    else
      "year, month, day"
    end
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


  def create_summary_table(row_names, column_names, has_null_column, data)
    row_count = row_names.each.count
    column_count = column_names.each.count + (has_null_column ? 1 : 0)
    st = SummaryTable.new(row_count, column_count)
    rows_hash = {}
    columns_hash = {}

    index=0
    row_names.each do |r|
      row_name = get_row_name(r.year, r.month, r.day)
      rows_hash[row_name] = index
      st.row_headers[index].text = row_name
      index += 1
    end

    index=0
    column_names.each do |c|
      columns_hash[c.column_id] = index
      st.column_headers[index].text = c.column_name
      index += 1
    end

    if has_null_column
      columns_hash[0] = index
      st.column_headers[index].text = "[none]"
    end

    data.each do |d|
      row = rows_hash[get_row_name(d.year, d.month, d.day)]
      col_id = nil_to_zero(d.column_id)
      column = columns_hash[col_id]
      st.cells[row][column].text = d.amount_sum
    end

    @table = st
  end

  def get_row_name(year, month, day)
    "#{(month.to_s + '/') if month.present?}#{(day.to_s + '/') if day.present?}#{year}"
  end

end
