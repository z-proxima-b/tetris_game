require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use!

require_relative 'collision_checker'

class CollisionCheckerTest < Minitest::Test

  def test_no_collision_with_empty_edge_3x3
    #skip 
    first = [2, 0, 0]
    second = [0, 0, 0]
    assert_equal false, CollisionChecker.collision?(first, second) 
  end

  def test_no_collision_with_one_cell_3x3
    #skip 
    first = [2, 0, 0]
    second = [0, 1, 0]
    assert_equal false, CollisionChecker.collision?(first, second)
  end

  def test_collision_with_full_edge_3x3
    #skip 
    first = [2, 0, 0]
    second = [1, 1, 1]
    assert_equal true, CollisionChecker.collision?(first, second)
  end

end



