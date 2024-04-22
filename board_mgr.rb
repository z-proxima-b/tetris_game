require 'Raylib'
require_relative './raylib_include.rb'

require_relative 'config'
require_relative 'canvas'
require_relative 'coordinate'
require_relative 'timer.rb'
require_relative 'drop_timer.rb'
require_relative 'tetromino_mgr'

class Grid
  attr_accessor :rows

  def occupied?(row, column)
    # ALL cells in the invisible area above the board
    # i.e. row < 0, are empty by default
    row >= 0 && value_non_empty_?(@rows[row][column]) 
  end

  def get_solid_rows
    Config.all_rows.select { |i| i if row_solid_?(i) }
  end

  def fill_row!(which, value)
    fill_row_!(which, value)
  end

  def fill_these_cells!(cells, type)
    cells.each { |c| @rows[c.row][c.column] = type } 
  end

  def shift_rows_down_by_one(from, to)
    # downto implies that from > to
    (from).downto(to) { |row| 
      # copy this row to row below
      copy_row_(row+1, row) 
    }
  end

  def print
    @rows.each.with_index do |row, i|
      puts "#{i} ++++ #{row}"
    end
    puts "\n\n"
  end

  def print_row(i)
    @rows[i].each { |cell| p "#{cell}, " } 
  end

  private
   
  def initialize
    @rows = (Config::BOARD_HEIGHT).times.collect { empty_row_ } 
  end

  def fill_row_!(which, value) 
    @rows[which].fill(value, Config.all_columns)
  end

  def empty_row_
    [].fill(Config::EMPTY, Config.all_columns)
  end

  def copy_row_(dest, src)
    @rows[dest] = @rows[src].map(&:clone)
  end

  def value_non_empty_?(value)
    value != Config::EMPTY
  end

  def row_solid_?(index)
    @rows[index].all? { |c| value_non_empty_?(c) }
  end

end

class Player
  attr_accessor :tile, :preview, :row, :column 

  def respawn
    @tile = @tg.get_next
    @preview = @tg.get_preview
  end

  def board
    @board.rows
  end

  def print_filled_cells(cells, row, column)
    str = cells.collect do |c| 
      "(#{c.row+row}, #{c.column+column}), "
    end 
    puts str
  end

  def lock_tile
    @board.fill_these_cells!(@tile.filled_coords, @tile.type)
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
    @rotated = @tg.get_rotated(@tile)
    @rotated.filled_coords.any? { |c|
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
    @completed_rows = @board.get_solid_rows
  end

  def scored? 
    @completed_rows.empty? == false
  end

  def flash_once(colour)
    @completed_rows.each { |cr| 
      @board.fill_row!(cr, colour) 
    }
  end

  def clear_rows
    @completed_rows.each do |cr|
      @board.fill_row!(cr, Config::EMPTY)
      @board.shift_rows_down_by_one(cr-1, 0)
    end
  end

  private

  def initialize 
    @tg = TileGenerator.new
    @board = Grid.new
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
  def handle_input
    case @state
    when Config::NAVIGATE
      if IsKeyPressed(KEY_P) then
        toggle_pause_
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
        toggle_pause_
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
      @droptimer.update
      if @droptimer.timeout?
        if @player.illegal_down? 
          @player.lock_tile
          @player.destroy_tile
          set_next_state_(Config::CALCULATE_SCORE)
        else
          @player.move_down
        end
        @droptimer.reset
      end
    when Config::CALCULATE_SCORE
      if @player.scored? then
        set_next_state_(Config::FLASH_ROWS)
      else
        set_next_state_(Config::RESPAWN)
      end
    when Config::FLASH_ROWS
      if flashing_complete_?
        set_next_state_(Config::CLEAR_ROWS)
      else
        do_one_flash_animation_frame_
      end
    when Config::CLEAR_ROWS
      @player.clear_rows
      set_next_state_(Config::RESPAWN)
    end

  end

  def render
    @canvas.begin_paint

    @canvas.render_board(@player.board)
    @canvas.render_tile(@player.tile)
    @canvas.render_preview(@player.preview)
    @canvas.render_score(3)
    @canvas.render_lines(3)

    if @state == Config::GAME_OVER then 
      @canvas.render_game_over
    end

    @canvas.end_paint
  end

  def cleanup
    @canvas.close
  end

  def transition
    if @next_state != @state then
      @state = @next_state
      enter_state_
    end
  end

  private

  attr_accessor :flash_colour

  def initialize
    @state = Config::RESPAWN
    @next_state = @state 
    @canvas = Canvas.new
    @player = Player.new
    @droptimer = DropTimer.new(1) 
    @flashtimer = Timer.new(Config::ONE_FLASH_DURATION)
    @time_spent_flashing = 0
    @flash_colour = Config::FLASH_ON
  end

  def toggle_pause_
    @state == Config::PAUSED ? resume_ : pause_
  end

  def set_next_state_(new_state)
    @next_state = new_state
  end

  def enter_state_
    case @state
    when Config::RESPAWN
      @player.respawn 
      reset_flash_
    when Config::NAVIGATE
      @droptimer.normal_speed!
    when Config::HARD_DROP
      @droptimer.high_speed!
    when Config::CALCULATE_SCORE
      @player.calculate_score
    when Config::FLASH_ROWS
      @canvas.play_sparkle
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

  ###############################################
  # Flash animation control functions
  ###############################################
  def reset_flash_
    @time_spent_flashing = 0
    @flash_colour = Config::FLASH_ON
  end

  def do_one_flash_animation_frame_
    @flashtimer.update  
    if @flashtimer.timeout?
      @player.flash_once(flash_colour)
      increase_time_spent_flashing_
      toggle_flash_colour_
      @flashtimer.reset
    end
  end

  def toggle_flash_colour_
    if @flash_colour == Config::FLASH_ON 
      @flash_colour = Config::FLASH_OFF
    else
      @flash_colour = Config::FLASH_ON 
    end
  end

  def flashing_complete_? 
    @time_spent_flashing >= Config::TOTAL_FLASH_DURATION
  end

  def increase_time_spent_flashing_
    @time_spent_flashing += Config::ONE_FLASH_DURATION
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
  game.cleanup
end
