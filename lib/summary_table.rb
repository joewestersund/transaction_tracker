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

  def row_headers
    @row_header_cells
  end

  def cells
    @table_cells
  end

end