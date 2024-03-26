require 'Raylib'
require_relative '.\raylib_include.rb'

NUMCOLUMNS = 10
NUMROWS = 20
ROWSRANGE = 0..NUMROWS-1
COLUMNSRANGE = 0..NUMCOLUMNS-1

class Shape
  type = {:SOLID_RECT => 1,
          :ROUNDED_RECT => 2,
          :TEXT => 3}

  attr_accessor :type, :x, :y, :width, :height, :description, :text

  def initialize(type, x, y, width, height, description, text="")
    @type = type
    @x = x
    @y = y
    @width = width
    @height = height
    @description = description
    @text = text
  end

end

class Config 

  CELL_W = 24
  GRID_LINE = 2 
  BOARD_X = 50
  BOARD_Y = 50
  SCORE_WIDTH = 100
  SCORE_HEIGHT = 50 
  LINES_WIDTH = 100
  NEXT_WIDTH = 100

  Blue = Color.from_u8(30, 75, 200, 255)
  Green = Color.from_u8(30, 200, 34, 255)
  Red = Color.from_u8(200, 0, 34, 255)
  Yellow = Color.from_u8(255, 200, 34, 255)
  Random = Color.from_u8(100, 25, 73, 255)
  Grey = Color.from_u8(30, 30, 30, 255)

  def initialize
  end

end

def get_colour(description)
  colour_config = { :EMPTY => Config::Blue,
                    :FILLED => Config::Red,
                    :SCORE => Config::Green,
                    :BORDER => Config::Blue}
  colour_config[description]
end

class Board
  attr_reader :shapes

  def print_shapes
    COLUMNSRANGE.each do |col|
      ROWSRANGE.each do |row|
        print "#{@shapes[(row*NUMCOLUMNS)+col].description}, "
      end
      print "\n"
    end
  end

  def fill(column, row)
    @shapes[(row*NUMCOLUMNS)+column].description = :FILLED 
  end

  private

  def initialize(x, y)
    @shapes = [] 
    ROWSRANGE.each do |row|
      COLUMNSRANGE.each do |col|
        xoffs = col*(Config::CELL_W+Config::GRID_LINE)
        yoffs = row*(Config::CELL_W+Config::GRID_LINE)
        puts "Rectangle at #{x+xoffs}, #{y+yoffs}"
        @shapes << Shape.new(:SOLID_RECT, x+xoffs, y+yoffs,
                             Config::CELL_W, Config::CELL_W, 
                             :EMPTY)
      end
    end
  end

  def paint
    @shapes.each do |cell| 
        DrawRectangle(cell.x, cell.y, 
                      cell.width, cell.height, 
                      get_colour(cell.description))
      end
  end
end

class Score 
  attr_reader :shapes

  def set(number)
   end

  private

  def initialize
    @shapes = [] 
    xoffs = Config::BOARD_X + ((Config::CELL_W+Config::GRID_LINE)*NUMCOLUMNS)
    yoffs = Config::BOARD_Y
    @shapes << Shape.new(:ROUNDED_RECT, xoffs, yoffs,
                         Config::SCORE_WIDTH, Config::SCORE_HEIGHT, 
                         :BORDER)
    @shapes << Shape.new(:TEXT, xoffs, yoffs+(Config::SCORE_HEIGHT/2),
                         Config::SCORE_WIDTH, Config::SCORE_HEIGHT, 
                           :SCORE, "something")
  end
end

class Next 
  attr_reader :shapes

  private

  def initialize
    @shapes = [] 
    xoffs = Config::BOARD_X + ((Config::CELL_W+Config::GRID_LINE)*NUMCOLUMNS)
    yoffs = Config::BOARD_Y + (Config::SCORE_HEIGHT*1.5)
    @shapes << Shape.new(:ROUNDED_RECT, xoffs, yoffs,
                         Config::NEXT_WIDTH, Config::NEXT_HEIGHT, 
                         :BORDER)

    # all start in the same position, adjust when setting the shape
    @shapes << Shape.new(:SOLID_RECT, Config::NEXT_X, Config::NEXT_Y,
                         Config::CELL_W, Config::CELL_W, 
                         :NEXT)
    @shapes << Shape.new(:SOLID_RECT, Config::NEXT_X, Config::NEXT_Y,
                         Config::CELL_W, Config::CELL_W, 
                         :NEXT)
    @shapes << Shape.new(:SOLID_RECT, Config::NEXT_X, Config::NEXT_Y,
                         Config::CELL_W, Config::CELL_W, 
                         :NEXT)
    @shapes << Shape.new(:SOLID_RECT, Config::NEXT_X, Config::NEXT_Y,
                         Config::CELL_W, Config::CELL_W, 
                         :NEXT)
  end
end


class Canvas

  def set_scene(array_of_drawables)
    @drawables = []
    array_of_drawables.each do |d|
      @drawables << d.shapes
    end
    @drawables = @drawables.flatten
  end

  def paint
    BeginDrawing()
      ClearBackground(RAYWHITE)
      render
    EndDrawing() 
  end

  private

  attr_accessor :drawables

  def initialize
    InitWindow(1280, 720, "Testing painting block shapes")
    SetTargetFPS(60)
  end

  def render
    @drawables.each do |s|
      case s.type
      when :SOLID_RECT
        DrawRectangle(s.x, s.y, 
                      s.width, s.height, 
                      get_colour(s.description))
      when :ROUNDED_RECT
        DrawRectangleRoundedLines(Rectangle.create(s.x, s.y, s.width, s.height), 1.2, 1, 1.2, get_colour(s.description))
      when :TEXT  
        DrawText(s.text, s.x, s.y, 16, get_colour(s.description))
      else
        print "unknown shape!"
      end
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  board = Board.new(Config::BOARD_X, Config::BOARD_Y)
  board.fill(8, 2)

  board.print_shapes

  score = Score.new

  canvas = Canvas.new
  canvas.set_scene([board, score])

  until WindowShouldClose()
    canvas.paint 
  end

  CloseWindow()

end

