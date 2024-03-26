require 'Raylib'
require_relative './board_mgr.rb'
require_relative './canvas.rb'
require_relative './shape.rb'
require_relative './tetromino_mgr.rb'

class RenderMgr 
  def update(board, tetro_cur, row, col, tetro_next)
    update_board_shapes_(board)
    update_cur_tetro_shapes_(tetro_cur, row, col)
    update_next_shapes_(tetro_next)
  end

  def paint
    @canvas.begin_paint
    @canvas.render(@board_shapes.flatten)
    @canvas.render(@tetromino_shapes.flatten)
    @canvas.render(@next_shapes.flatten)
    @canvas.render(@next_tetromino_shapes.flatten)
    #@canvas.render(@lines_shapes.flatten)
    #@canvas.render(@score_shapes.flatten)
    @canvas.end_paint
  end

  private 

  def initialize
    @canvas = Canvas.new
    create_board_shapes_
    create_tetromino_shapes_
    create_next_shapes_
    create_next_tetromino_shapes_ 
    #create_score_shapes_
    #create_lines_shapes_
  end

  def create_board_shapes_
    make_a_board_full_of_walls_
    hollow_out_the_board_playing_area_
  end

  def create_tetromino_shapes_
    make_an_empty_4x4_tetromino_offscreen_
  end

  def make_a_board_full_of_walls_
    colour = Config.get_colour(Config::WALL)
    @board_shapes = 0.upto(Config::TRUE_BOARD_HEIGHT-1).collect do |i|
      0.upto(Config::TRUE_BOARD_WIDTH-1).collect do |j|
        Shape.new(Shape::RECT,
          logical2screen_x_(j, Config::BOARD_X),
          logical2screen_y_(i, Config::BOARD_Y),
          Config::CELL_SIZE,
          Config::CELL_SIZE,
          colour) 
       end
     end
  end 

  def hollow_out_the_board_playing_area_
    first_col = Config::WALL_WIDTH
    first_row = Config::WALL_WIDTH
    last_col = Config::WALL_WIDTH+Config::BOARD_WIDTH 
    last_row = Config::WALL_WIDTH+Config::BOARD_HEIGHT

    colour = Config.get_colour(Config::EMPTY)
    
    (first_row..last_row-1).each do |i| 
      (first_col..last_col-1).each do |j|
        @board_shapes[i][j].colour = colour 
      end 
    end
  end

  def print_board_shapes_
    puts "PRINT BOARD SHAPES!!"
    
    0.upto(Config::TRUE_BOARD_HEIGHT-1) do |i|
      0.upto(Config::TRUE_BOARD_WIDTH-1) do |j|
        p @board_shapes[i][j]
      end
    end    
  end

  def create_next_shapes_
    @next_shapes = []

    # -- title
    @next_shapes << Shape.new(Shape::TEXT,
                     Config::HUD_X,
                     Config::NEXT_TITLE_Y,
                     Config::NEXT_TITLE_WIDTH, Config::HUD_FONTSIZE,
                     Config.get_colour(Config::HUD_BORDER), "next:")
    # -- box 
    @next_shapes << Shape.new(Shape::ROUNDED_RECT,
                     Config::NEXT_BOX_TLX, 
                     Config::NEXT_BOX_TLY, 
                     Config::NEXT_BOX_WIDTH, Config::NEXT_BOX_HEIGHT,
                     Config.get_colour(Config::HUD_BORDER))
    # -- next tetrom 
  end

  def create_next_tetromino_shapes_ 
    @next_tetromino_shapes = Config::RANGE_4x4.collect do |i|
      Config::RANGE_4x4.collect do |j|
        Shape.new(Shape::RECT,
          logical2screen_x_(j, Config::NEXT_TETROM_TLX), 
          logical2screen_y_(i, Config::NEXT_TETROM_TLY),
          Config::CELL_SIZE,
          Config::CELL_SIZE,
          Config::Red) 
       end
     end
  end
     
  def make_an_empty_4x4_tetromino_offscreen_
    colour = Config.get_colour(Config::EMPTY)

    @tetromino_shapes = Config::RANGE_4x4.collect do |i|
      Config::RANGE_4x4.collect do |j|
        Shape.new(Shape::RECT,
          logical2screen_x_(j, 0),
          logical2screen_y_(i, 0),
          Config::CELL_SIZE,
          Config::CELL_SIZE,
          colour) 
       end
     end
  end

  def logical2screen_y_(row, offs)
     row*(Config::CELL_SIZE+Config::CELL_GAP) + offs
  end

  def logical2screen_x_(col, offs)
    col*(Config::CELL_SIZE+Config::CELL_GAP) + offs
  end

  def update_board_shapes_(grid)
    offs = Config::WALL_WIDTH 
   
    grid.each_with_index do |row, i| 
      row.each_with_index do |cell, j|
        colour = Config.get_colour(cell)
        @board_shapes[i+offs][j+offs].colour = colour
      end 
    end
  end

  def update_next_shapes_(grid)
    grid.each_with_index do |row, i| 
      row.each_with_index do |cell, j|
        colour = Config.get_colour(cell)
        @next_tetromino_shapes[i][j].colour = colour
      end 
    end
  end

  def update_cur_tetro_shapes_(grid, row_index, col_index)
    grid.each_with_index do |row, i| 
      row.each_with_index do |cell, j|
        colour = Config.get_colour(cell)
        @tetromino_shapes[i][j].colour = colour
        @tetromino_shapes[i][j].y = logical2screen_y_(i+row_index, Config::BOARD_Y)
        @tetromino_shapes[i][j].x = logical2screen_x_(j+col_index, Config::BOARD_X)
      end 
    end
  end

  def print_board_shapes_
    @board_shapes.each do |row|
      row.each do |s| print s end
      print "\n"
    end
  end
end

def collision_down?(player, board)
  r = player.current_row+1
  c = player.current_column
  player.current_filled_cells.any? { |coord| 
    board.collision?(r+coord[0], c+coord[1])
  } 
end 

if __FILE__ == $PROGRAM_NAME
  rm = RenderMgr.new
  tm = TetrominoMgr.new 
  b = Board.new
  playing_area = b.get_playing_area

  until WindowShouldClose()
    if IsKeyPressed(KEY_UP) then
      tm.rotate 
    end 

    if IsKeyPressed(KEY_DOWN) && !collision_down?(tm, b) then 
      tm.move_down
    end
    
    rm.update(playing_area, tm.current_tetromino_grid, tm.current_row,
              tm.current_column, tm.next_tetromino_grid)
    rm.paint
  end

  CloseWindow()
end
