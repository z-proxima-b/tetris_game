require 'Raylib'
require_relative './raylib_include.rb'
require_relative 'config'
require_relative 'coordinate'

class Canvas

  def initialize
    InitWindow(1280, 850, "My Tetris Game")
    SetTargetFPS(60)
  end

  def begin_paint
    BeginDrawing()
    ClearBackground(DARKBROWN)
  end

  def end_paint
    EndDrawing()
  end

  def render_game_over
     DrawRectangle(200, 200, 400, 150, RAYWHITE)
  end


  def render_tile(type, cell_coords) 
    cell_coords.each do |c| 
      if visible?(c.row) then draw_cell_(c.row, c.column, type) end 
    end
  end

  def render_board(rows)
    Config.all_rows.each do |i| 
      draw_cell_digit_(i, -1, i)
      Config.all_columns.each do |j|
        draw_cell_(i, j, rows[i][j])
        draw_cell_digit_(-1, j, j)
      end
    end
  end

  def draw_cell_(row, column, type)
    w = Config::CELL_WIDTH
    h = Config::CELL_HEIGHT
    colour = Config.get_rgb(type)
    DrawRectangle(getx_(column), gety_(row), w, h, colour)
  end

  def draw_cell_digit_(row, column, value)
    h = Config::CELL_HEIGHT-4
    DrawText(value.to_s, getx_(column), gety_(row), h-4, BLACK)
  end

  def getx_(column)
    Config::BOARD_X + ((Config::CELL_WIDTH+Config::CELL_GAP) * column) 
  end

  def gety_(row)
    Config::BOARD_Y + ((Config::CELL_HEIGHT+Config::CELL_GAP) * row) 
  end

  def visible?(row)
    row > -1
  end
end

