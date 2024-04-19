require 'Raylib'
require_relative './raylib_include.rb'
require_relative './timer.rb'

class DropTimer < Timer
  def normal_speed!
    @speed = 1 
  end

  def high_speed!
    @speed = 300 
  end

end
