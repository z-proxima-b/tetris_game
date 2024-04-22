require 'Raylib'
require_relative './raylib_include.rb'
require_relative 'config'
require_relative 'coordinate'

class Canvas

  def initialize
    InitWindow(Config::SCREEN_WIDTH, Config::SCREEN_HEIGHT, "My Tetris Game")
    InitAudioDevice()
    @music = LoadMusicStream("resources/chirpy.mp3")
    PlayMusicStream(@music)

    SetTargetFPS(60)
    @background = LoadTexture("resources/bkg.png")
    @font = LoadFont("resources/GamePlayed-vYL7.ttf")
    @sparkle = LoadSound("resources/sparkle.wav")
  end

  def close
    UnloadMusicStream(@music)
    CloseAudioDevice()
    CloseWindow()
  end

  def play_sparkle
    PlaySound(@sparkle)
  end

  def begin_paint
    BeginDrawing()
    UpdateMusicStream(@music)
    ClearBackground(Config.get_rgb(Config::EMPTY))
    #DrawTexture(@background, 0, 0, RAYWHITE)
  end

  def end_paint
    EndDrawing()
  end

  def render_game_over
     DrawRectangle(200, 200, 400, 150, RAYWHITE)
  end


  def render_tile(tile) 
    tile.filled_coords.each do |c| 
      if visible?(c.row) then draw_cell_(c.row, c.column, tile.type,
                                         Config::CELL_WIDTH,
                                         Config::BOARD_X, Config::BOARD_Y) end 
    end
  end

  def render_preview(tile) 
    x_offs = 0
    # x_offs = (Config::PREVIEW_BOX_WIDTH - (tile.width*Config::PREVIEW_CELL_WIDTH) - ((tile.width-1)*Config::PREVIEW_CELL_GAP))/2
    y_offs = (Config::PREVIEW_BOX_HEIGHT - (tile.height*Config::PREVIEW_CELL_HEIGHT) - ((tile.height-1)*Config::PREVIEW_CELL_GAP))/2 
    tile.filled_coords.each do |c| 
      draw_cell_(c.row, c.column, tile.type, Config::PREVIEW_CELL_WIDTH, Config::BOX_X+x_offs, Config::PREVIEW_Y+y_offs)
    end 
 end

  def render_score(value) 
    DrawTextEx(@font, "SCORE", Vector2.create(Config::BOX_X, Config::PREVIEW_Y+300), 20.0, 1.2, RAYWHITE)
   end

  def render_lines(value) 
    DrawTextEx(@font, "LINES", Vector2.create(Config::BOX_X, Config::PREVIEW_Y+400), 20.0, 1.2, RAYWHITE)
  end

  def render_time(value)
  end

  def render_board(rows)
    draw_board_box_
    Config.all_rows.each do |i| 
      draw_cell_digit_(i, -1, i)
      Config.all_columns.each do |j|
        draw_cell_(i, j, rows[i][j], Config::CELL_WIDTH, Config::BOARD_X, Config::BOARD_Y)
        draw_cell_digit_(-1, j, j)
      end
    end
  end

  def draw_cell_(row, column, type, cell_width, x_offs = 0, y_offs = 0)
    w = cell_width 
    h = cell_width 
    colour = Config.get_rgb(type)
    DrawRectangle(getx_(column, w) + x_offs, gety_(row, h) + y_offs, w, h, colour)
  end

  def draw_cell_digit_(row, column, value)
    h = Config::CELL_HEIGHT-4
    DrawText(value.to_s, getx_(column), gety_(row), h-4, BLACK)
  end

  def draw_box_(x, y, width, height)
    r = Rectangle.create(x, y, width, height)
    DrawRectangleRoundedLines(r, 0.2, 10, 4.0, Config.get_rgb(Config::BOARD_EDGE))
  end

  def draw_board_box_
    x = Config::BOARD_X-6
    y = Config::BOARD_Y
    
    DrawRectangle(x, y, 
      4, Config::BOARD_HEIGHT_PHYSICAL, 
      Config.get_rgb(Config::BOARD_EDGE))

    DrawRectangle(x+Config::BOARD_WIDTH_PHYSICAL+6, y,
      4, Config::BOARD_HEIGHT_PHYSICAL,
      Config.get_rgb(Config::BOARD_EDGE))
    
    DrawRectangle(x, y+Config::BOARD_HEIGHT_PHYSICAL, 
      Config::BOARD_WIDTH_PHYSICAL+10, 4, 
      Config.get_rgb(Config::BOARD_EDGE))

    DrawRectangle(Config::BOARD_X, Config::BOARD_Y,
                  Config::BOARD_WIDTH_PHYSICAL, 
                  Config::BOARD_HEIGHT_PHYSICAL,
                  Config.get_rgb(Config::EMPTY))
  end

  def getx_(column, cell_width=Config::CELL_WIDTH)
    (cell_width+Config::CELL_GAP) * column 
  end

  def gety_(row, cell_height=Config::CELL_WIDTH)
    (cell_height+Config::CELL_GAP) * row 
  end

  def visible?(row)
    row > -1
  end

end

