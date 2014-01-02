class SummaryTable

  class SummaryCell
    attr_accessor :text, :href
  end

  def initialize(rows,columns)
    @rows = rows
    @columns = columns
    @column_header_cells = Array.new(columns) { SummaryCell.new }
    @row_header_cells = Array.new(rows) { SummaryCell.new }
    @table_cells = Array.new(rows) { Array.new(columns) { SummaryCell.new }}
    @row_has_no_data = Array.new(rows,true)
    @column_has_no_data = Array.new(columns,true)
  end

  def num_rows
    @rows
  end

  def num_columns
    @columns
  end

  def column_headers
    @column_header_cells
  end

  def column_has_no_data(column)
    @column_has_no_data[column]
  end

  def some_columns_have_no_data
    @column_has_no_data.each {|column_no_data| return true if column_no_data}
    false
  end

  def row_has_no_data(row)
    @row_has_no_data[row]
  end

  def some_rows_have_no_data
    @row_has_no_data.each {|row_no_data| return true if row_no_data}
    false
  end

  def text(row,column)
    @table_cells[row][column].text
  end

  def set_text(row, column, text)
    @table_cells[row][column].text = text
    @row_has_no_data[row] = false
    @column_has_no_data[column] = false
  end

  def href(row,column)
    @table_cells[row][column].href
  end

  def set_href(row, column, href)
    @table_cells[row][column].href = href
  end

  def header_text(type, index)
    if type == :row
      @row_header_cells[index].text
    elsif type == :column
      @column_header_cells[index].text
    else
      raise "Type not recognized"
    end
  end

  def set_header_text(type, index, text)
    if type == :row
      @row_header_cells[index].text = text
    elsif type == :column
      @column_header_cells[index].text = text
    else
      raise "Type not recognized"
    end
  end

  def header_href(type, index)
    if type == :row
      @row_header_cells[index].href
    elsif type == :column
      @column_header_cells[index].href
    else
      raise "Type not recognized"
    end
  end

  def set_header_href(type, index, href)
    if type == :row
      @row_header_cells[index].href = href
    elsif type == :column
      @column_header_cells[index].href = href
    else
      raise "Type not recognized"
    end
  end

end