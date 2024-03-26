require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use!

require_relative 'config'

class ConfigTest < Minitest::Test
  def test_correct_range_for_validate_function
    #skip 
    assert_equal false, Config.valid_tetromino?(Config::MAX_SHAPE) 
    assert_equal false, Config.valid_tetromino?(0)
    assert_equal false, Config.valid_tetromino?(100)
    assert_equal true, Config.valid_tetromino?(Config::S) 
    assert_equal true, Config.valid_tetromino?(Config::R) 
  end

end


