class Coordinate
  attr_accessor :row, :column

  def offset(i, j)
    @row = @row+i
    @column = @column+j 
  end

  def to_s
    "(#{@row}, #{@column}), "
  end

  private

  def initialize(i, j)
    @row = i
    @column = j
  end

end


