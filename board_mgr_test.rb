require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use!

require_relative 'board_mgr'
require_relative 'config'

class BoardMgrTest < Minitest::Test
  def test_new_board
    skip
    b = Board.new 
    b.print
  end

  def test_lock_tile
    filled_cells = [[0,2], [1,2], [2,2], [3,2]].collect do |arr|
      Coordinate.new(*arr) 
    end

    type = 4
    row = 10
    column = 7

    b = Board.new
    # tm = TileGenerator.new
    # tile = tm.get_next
    b.lock_tile(type, filled_cells, row, column)

    b.print
  end
end


