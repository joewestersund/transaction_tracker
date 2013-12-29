class SummariesController < ApplicationController

  def by_account
    at = get_averaging_time
    column_names = current_user.transaction_categories.select("id as column_id, name as column_name").order(:order_in_list).all
    row_names = current_user.transactions.select("#{at}").group("#{at}").order("#{at}")
    data = current_user.transactions.select("#{at}, sum(amount) as amount_sum, account_id as column_id").group("account_id, #{at}")
    create_summary_table(row_names,column_names,data)
  end

  def by_category
    at = get_averaging_time
    column_names = current_user.accounts.select("id as column_id, account_name as column_name").order(:order_in_list).all
    row_names = current_user.transactions.select("#{at}").group("#{at}").order("#{at}")
    data = current_user.transactions.select("#{at}, sum(amount) as amount_sum, transaction_category_id as column_id").group("transaction_category_id, #{at}")
    create_summary_table(row_names,column_names,data)
  end

private
  def get_averaging_time
    at = params[:averaging_time]
    if at == "by_year"
      "year, null as month, null as day"
    elsif at == "by_month"
      "year, month, null as day"
    else
      "year, month, day"
    end
  end

  def create_summary_table(row_names, column_names, data)
    row_count = row_names.each.count
    column_count = column_names.each.count
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
      col_id = nil_to_zero(c.column_id)
      columns_hash[col_id] = index
      st.column_headers[index].text = c.column_name
      index += 1
    end

    #st = SummaryTable.new(rows_hash.count, columns_hash.count)

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
