require 'Raylib'
require_relative './raylib_include.rb'
require_relative 'config'
require_relative 'coordinate'

class Canvas

  def initialize
    InitWindow(1280, 850, "Testing painting block shapes")
    SetTargetFPS(60)
  end

  def begin_paint
    BeginDrawing()
    ClearBackground(RAYWHITE)
  end

  def end_paint
    EndDrawing()
  end

  def render_tile(type, cell_coords, row, column) 
    rgb_val = Config.get_rgb(type)  
    cell_coords.each do |c| 
      DrawRectangle(screen_x_(column+c.column),
                    screen_y_(row+c.row),
                    Config::CELL_WIDTH,
                    Config::CELL_HEIGHT,
                    rgb_val)
    end
  end

  def render_board(grid)
    x = Config::BOARD_X
    y = Config::BOARD_Y

    grid.each_with_index do |row, i|
      row.each_with_index do |column, j|
        DrawRectangle(screen_x_(j),
                      screen_y_(i),
                      Config::CELL_WIDTH,
                      Config::CELL_HEIGHT,
                      Config.get_rgb(grid[i][j]))
      end
    end
  end

  def screen_x_(column)
    Config::BOARD_X + ((Config::CELL_WIDTH+Config::CELL_GAP) * column) 
  end

  def screen_y_(row)
    Config::BOARD_Y + ((Config::CELL_HEIGHT+Config::CELL_GAP) * row) 
  end
end

