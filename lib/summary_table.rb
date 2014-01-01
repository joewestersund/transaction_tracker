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

  def empty_columns
    column_is_empty_array = Array.new(@columns,true) #set to true by default
    @table_cells.each_index do |row_index|
      @table_cells[row_index].each_index do |column_index|
        if @table_cells[row_index][column_index].text.present?
          column_is_empty_array[column_index] = false
          break
        end
      end
    end
    column_is_empty_array
  end

  def row_headers
    @row_header_cells
  end

  def cells
    @table_cells
  end

end