require 'Raylib'
require_relative './raylib_include.rb'

require_relative 'config'
require_relative 'canvas'
require_relative 'coordinate'
require_relative 'drop_timer.rb'
require_relative 'flash_timer.rb'
require_relative 'tetromino_mgr'

class Board
  attr_accessor :grid

  def lock_tile!(type, cells)
    cells.each { |c| @grid[c.row][c.column] = type } 
  end

  def occupied?(row, column)
    # ALL cells in the invisible area above the board
    # i.e. row < 0, are empty by default
    row >= 0 && @grid[row][column] != Config::EMPTY
  end

  def print
    @grid.each.with_index do |row, i|
      puts "#{i} ++++ #{row}"
    end
    puts "\n\n"
  end

  def print_row(i)
    @grid[i].each do |c|
      p "#{c}, " 
    end
    puts "\n\n"
  end

  # reverse the result, because we use 
  # this bottom to top 
  def get_completed_rows
    @grid.each_index.select { |i| i if row_complete?(i) }.reverse
  end

  def row_complete?(index)
    @grid[index].all? { |c| c != Config::EMPTY }
  end

  def fill_row!(which, value) 
    (0..Config::BOARD_WIDTH-1).each {|i| @grid[which][i] = value }
  end

  def clear_rows!(arr)
    @grid.reverse.each_index { |i|
      if arr.include?(i) then 
        fill_row!(i, Config::EMPTY)
        shuffle_down_(i-1, 0)
      end
    }
  end

  private
   
  def initialize
    @grid = (Config::BOARD_HEIGHT).times.collect { empty_row_ } 
  end

  def shuffle_down_(first, last)
    # working from bottom to top,
    # copy row i to the row immediately below (i+1) 
    (first).downto(last) { |i| @grid[i+1] = @grid[i].map(&:clone) } 
  end 

  def empty_row_
    [].fill(Config::EMPTY, 0, Config::BOARD_WIDTH)
  end

end

class Player
  attr_accessor :row, :column, :board 

  def init_flash
    @flash = Config::FLASH_ON
    @num_flashes = 0
  end

  def flash_complete? 
    @num_flashes >= Config::FLASH_DURATION
  end

  def respawn
    @tile = @tg.get_next
  end

  def type
    @tile.type
  end

  def filled_coords
    @tile.filled_coords
  end

  def print_filled_cells(cells, row, column)
    str = cells.collect do |c| 
      "(#{c.row+row}, #{c.column+column}), "
    end 
    puts str
  end

  def lock_tile
    @board.lock_tile!(@tile.type, @tile.filled_coords)
  end

  def destroy_tile
    @tile.destroy!
  end

  def move_left
    @tile.shift_left! 
  end

  def move_right
    @tile.shift_right!
  end

  def move_down
    @tile.shift_down!
  end

  def shift_tile_out_of_collision
    while illegal_respawn?
      @tile.shift_up! 
    end
  end

  def rotate
    @tile.rotate!
  end

  def illegal_left?
    @tile.filled_coords.any? { |c| 
      outside_board_left_?(c.column-1) || collision_?(c.row, c.column-1) 
    }
  end

  def illegal_right?
    @tile.filled_coords.any? { |c| 
      outside_board_right_?(c.column+1) || collision_?(c.row, c.column+1) 
    }
  end

  def illegal_down?
    @tile.filled_coords.any? { |c| 
      outside_board_below_?(c.row+1) || collision_?(c.row+1, c.column) 
    }
  end

  def illegal_rotate? 
    check_cells = @tile.get_rotated_coords
    check_cells.any? { |c|
      outside_board_below_?(c.row) ||
      outside_board_left_?(c.column) ||
      outside_board_right_?(c.column) ||
      collision_?(c.row, c.column) 
    } 
  end
  
  def illegal_respawn?
    @tile.filled_coords.any? { |c| collision_?(c.row, c.column) } 
  end

  def calculate_score
    @completed_rows = @board.get_completed_rows
  end

  def scored? 
    @completed_rows.empty? == false
  end

  def flash
    toggle_flash_
    colour_rows_
    increment_flash_
  end

  def colour_rows_
    @completed_rows.each { |i| @board.fill_row!(i, @flash) }
  end

  def toggle_flash_
    @flash == Config::FLASH_ON ? @flash = Config::FLASH_OFF : @flash = Config::FLASH_ON 
  end

  def increment_flash_
    @num_flashes += Config::FLASH_SPEED
  end

  def clear_rows
    @board.clear_rows!(@completed_rows) 
  end

  private

  def initialize 
    @tg = TileGenerator.new
    @board = Board.new
    @completed_rows = []
    respawn
  end

  def outside_board_below_?(row)
    row > Config::BOARD_HEIGHT-1
  end

  def outside_board_left_?(column)  
    column < 0
  end

  def outside_board_right_?(column) 
    column > Config::BOARD_WIDTH-1 
  end

  def collision_?(row, column)
    @board.occupied?(row, column)
  end

end

class Game
  def toggle_pause
    @state == Config::PAUSED ? resume_ : pause_
  end

  def handle_input
    case @state
    when Config::NAVIGATE
      if IsKeyPressed(KEY_P) then
        toggle_pause
      end
      if IsKeyPressed(KEY_LEFT) then
        @player.move_left unless @player.illegal_left?
      end
      if IsKeyPressed(KEY_RIGHT) then
        @player.move_right unless @player.illegal_right?
      end
      if IsKeyPressed(KEY_UP) then
        @player.rotate unless @player.illegal_rotate?
      end
      if IsKeyPressed(KEY_SPACE) then 
        set_next_state_(Config::HARD_DROP)
      end 
    when Config::PAUSED
      if IsKeyPressed(KEY_P) then
        toggle_pause
      end
    end
  end

  def update
    case @state
    when Config::RESPAWN
      if @player.illegal_respawn? 
        @player.shift_tile_out_of_collision
        set_next_state_(Config::GAME_OVER)
      else
        set_next_state_(Config::NAVIGATE)
      end
    when Config::NAVIGATE, Config::HARD_DROP
      @timer.update
      if @timer.done?
        if @player.illegal_down? 
          @player.lock_tile
          @player.destroy_tile
          set_next_state_(Config::CALCULATE_SCORE)
        else
          @player.move_down
        end
        @timer.reset
      end
    when Config::CALCULATE_SCORE
      if @player.scored? then
        set_next_state_(Config::FLASH_ROWS)
      else
        set_next_state_(Config::RESPAWN)
      end
    when Config::FLASH_ROWS
      @flash_timer.update  
      if @flash_timer.done?
        @player.flash
        @flash_timer.reset
      else 
        if @player.flash_complete?
          set_next_state_(Config::CLEAR_ROWS)
        end
      end
    when Config::CLEAR_ROWS
      @player.clear_rows
      set_next_state_(Config::RESPAWN)
    end

  end

  def render
    @canvas.begin_paint

    @canvas.render_board(@player.board.grid)
    if @state == Config::GAME_OVER then 
      @canvas.render_tile(@player.type, @player.filled_coords)
      @canvas.render_game_over
    else
      @canvas.render_tile(@player.type, @player.filled_coords)
    end

    @canvas.end_paint
  end
 
  def transition
    if @next_state != @state then
      @state = @next_state
      enter_state_
    end
  end

  private

  def initialize
    @state = Config::RESPAWN
    @next_state = @state 
    @canvas = Canvas.new
    @player = Player.new
    @timer = DropTimer.new(1) 
    @flash_timer = FlashTimer.new(Config::FLASH_SPEED)
  end

  def set_next_state_(new_state)
    @next_state = new_state
  end

  def enter_state_
    case @state
    when Config::RESPAWN
      @player.respawn 
      @player.init_flash
    when Config::NAVIGATE
      @timer.normal_speed!
    when Config::HARD_DROP
      @timer.high_speed!
    when Config::CALCULATE_SCORE
      @player.calculate_score
    end 
  end

  def resume_
    @next_state = @prev_state 
    @prev_state = Config::PAUSED
    # 3.times do puts "\n * R E S U M E!! =============" end
  end

  def pause_
    @prev_state = @state
    @next_state = Config::PAUSED
    # 3.times do puts "\n * P A U S E!! =============" end
  end

end

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  until WindowShouldClose()
    game.handle_input
    game.update
    game.render
    game.transition
  end
end
