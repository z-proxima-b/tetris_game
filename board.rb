require_relative '.\shape.rb'

class Board

  NUMCOLUMNS = 10
  NUMROWS = 20
  ROWSRANGE = 0..NUMROWS-1
  COLUMNSRANGE = 0..NUMCOLUMNS-1
  CELL_W = 24
  GRID_LINE = 2 

  attr_accessor :shapes

  def fill_row(row, description)
    cells.each do |columns|
      columns[index] = description
    end
  end

  private

  def initialize(x, y)
    @x = x
    @y = y
    @cells = Array.new(NUMCOLUMNS) { Array.new(NUMROWS) } 
    @cells.each do { |c| 
      xpos = column*(CELL_W+GRID_LINE)
      ypos = row*(CELL_W+GRID_LINE)
      c = GameDefines::EMPTY_CELL 
      @shapes << Shape.new(Shape::RECT, x+xpos, y+ypos, 
                           CELL_W, CELL_W, c)
    end
  end
end


