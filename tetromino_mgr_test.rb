require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use!

require_relative 'config'
require_relative 'tetromino_mgr'

class TetrominoMgrTest < Minitest::Test
  def test_grid_exists_on_creation
    assert_equal false, TetrominoMgr.new.current_tetromino_grid.empty?
  end

  def test_next_exists_on_creation
    assert_equal false, TetrominoMgr.new.next_tetromino_grid.empty?
  end

  def test_grid_rotate
    t = TetrominoMgr.new
    g = t.current_tetromino_grid
    t.rotate 
    if t.current_type != Config::B
      assert_equal g.first, t.get_right_column 
    else
      assert_equal g, t.current_tetromino_grid
    end
  end

  def test_get_left_column
    t = TetrominoMgr.new
    g = t.current_tetromino_grid
    left = []
    g.each { |row| left << row.first } 
    assert_equal left, t.current_leftmost_column
  end

  def test_get_right_column
    t = TetrominoMgr.new
    g = t.current_tetromino_grid
    right = []
    g.each { |row| right << row.last } 
    assert_equal right, t.current_rightmost_column
  end

  def test_get_bottom
    t = TetrominoMgr.new
    g = t.current_tetromino_grid
    bottom = g.last 
    assert_equal bottom, t.current_bottom_row
  end

end
