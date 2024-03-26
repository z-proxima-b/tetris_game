require 'Raylib'
require_relative './raylib_include.rb'

require_relative 'config'
require_relative 'canvas'
require_relative 'coordinate'
require_relative 'drop_timer.rb'

class Board
  attr_accessor :grid

  def lock_tile(type, cells, row, column)
    cells.each { |c| @grid[row+c.row][column+c.column] = type } 
  end

  def print
    @grid.each.with_index do |row, i|
      puts "#{i} ++++ #{row}"
    end
    puts "\n\n"
  end

  private
    
  def initialize
    @grid = [] 
    @grid = (Config::BOARD_HEIGHT+4).times.collect do 
      empty_row_
    end
  end
    
  def empty_row_
    [].fill(Config::EMPTY, 0, Config::BOARD_WIDTH)
  end

end

class Player
  attr_accessor :type, :row, :column, :filled_cells

  def respawn
    @row = 0
    @column = 3
  end

  def initialize(type, filled_cells, row, column) 
    @type = type
    @row = row
    @column = column
    @filled_cells = filled_cells
  end
  
  def invalid_move?(direction) 
    case direction
    when Config::LEFT
      filled_cells.any? do |c|
        (@column-1+c.column < 0)
      end
    when Config::RIGHT
      filled_cells.any? do |c|
        ((@column+1)+c.column > Config::BOARD_WIDTH-1)
      end
    when Config::DOWN
      filled_cells.any? do |c|
        ((@row+1)+c.row > Config::BOARD_HEIGHT-1)
      end
    end
  end

  def move_left
    @column -= 1 
  end

  def move_right
    @column += 1
  end

  def move_down
    @row += 1
  end

end

if __FILE__ == $PROGRAM_NAME
  state = Config::RESPAWN

  canvas = Canvas.new
  b = Board.new

  filled_cells = [[0,2], [1,2], [2,2], [3,2]].collect do |arr|
      Coordinate.new(*arr) 
  end

  type = 4
  row = 0
  column = 3 

  player = Player.new(type, filled_cells, row, column)
  timer = DropTimer.new(1) 

  # b.lock_tile(type, filled_cells, row, column)

  until WindowShouldClose()
    case state
    when Config::RESPAWN
      player.respawn
      state = Config::NAVIGATE
    when Config::NAVIGATE
      timer.normal_speed!
      if IsKeyPressed(KEY_LEFT) then
        player.move_left unless player.invalid_move?(Config::LEFT)
      end

      if IsKeyPressed(KEY_RIGHT) then
        player.move_right unless player.invalid_move?(Config::RIGHT)
      end

      if IsKeyPressed(KEY_SPACE) then 
        state = Config::HARD_DROP
        timer.double_speed!
      end 
   end

    timer.update
    if timer.done?
      if player.invalid_move?(Config::DOWN)
        b.lock_tile(player.type, player.filled_cells, 
                    player.row, player.column)
        state = RESPAWN
      else
        player.move_down
      end
      timer.reset
    end

    canvas.begin_paint
    canvas.render_board(b.grid)
    canvas.render_tile(player.type, player.filled_cells,
                       player.row, player.column)
    canvas.end_paint
  end
end
