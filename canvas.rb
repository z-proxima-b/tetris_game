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
    ClearBackground(RAYWHITE)
  end

  def end_paint
    EndDrawing()
  end

  def render_game_over
     DrawRectangle(200, 200, 400, 150, RAYWHITE)
  end


  def render_tile(type, cell_coords) 
    cellw = Config::CELL_WIDTH
    cellh = Config::CELL_HEIGHT
    cell_colour = Config.get_rgb(type)  
    cell_coords.each do |c| 
      if c.row > -1 then 
        DrawRectangle(getx_(c.column), gety_(c.row), cellw, cellh, cell_colour)
      end
    end
  end

  def render_board(grid)
    cellw = Config::CELL_WIDTH
    cellh = Config::CELL_HEIGHT

    grid.each_with_index do |row, i|
      DrawText(i.to_s, getx_(-1), gety_(i), cellh-4, BLACK)
      row.each_with_index do |column, j|
        DrawText(j.to_s, getx_(j), gety_(-1), cellh-4, BLACK)
        cell_colour = Config.get_rgb(grid[i][j])
        DrawRectangle(getx_(j), gety_(i), cellw, cellh, cell_colour)
      end
    end
  end

  def getx_(column)
    Config::BOARD_X + ((Config::CELL_WIDTH+Config::CELL_GAP) * column) 
  end

  def gety_(row)
    Config::BOARD_Y + ((Config::CELL_HEIGHT+Config::CELL_GAP) * row) 
  end
end

