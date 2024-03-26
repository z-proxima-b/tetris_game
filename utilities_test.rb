require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use!

require_relative 'utilities'

class UtilitiesTest < Minitest::Test

  def setup
    @board = [ [9, 9, 9, 9, 9, 9, 9, 9, 9, 9],
               [5, 8, 8, 8, 8, 8, 2, 8, 8, 8],
               [4, 7, 7, 7, 7, 7, 3, 7, 7, 7],
               [3, 5, 5, 5, 5, 5, 4, 5, 5, 5], 
               [2, 4, 4, 4, 4, 4, 4, 4, 4, 4]]
  end

  def test_get_rightmost_column
    grid = [[3, 4, 6],
            [6, 8, 2],
            [2, 8, 1]]
    assert_equal [6, 2, 1], Utilities.rightmost(grid)
  end

  def test_get_leftmost_column
    grid = [[3, 4, 6],
            [6, 8, 2],
            [2, 8, 1]]
    assert_equal [3, 6, 2], Utilities.leftmost(grid)
  end

  def test_get_bottom
    grid = [[3, 4, 6],
            [6, 8, 2],
            [2, 8, 1]]
    assert_equal [2, 8, 1], Utilities.bottom(grid)
  end

  def test_get_target_column_right
    res = [2, 3, 4, 4]
    assert_equal res, Utilities.target_right_column(@board, 1, 2, 4)
  end

  def test_get_target_column_left
    res = [5, 4, 3, 2]
    assert_equal res, Utilities.target_left_column(@board, 1, 1, 4)
  end

  def test_get_target_row_underneath
    res = [5, 5, 5]
    assert_equal res, Utilities.target_row_underneath(@board, 0, 2, 3)
  end

end


