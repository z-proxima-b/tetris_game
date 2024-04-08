require 'Raylib'
require_relative './raylib_include.rb'

# create the timer by passing in a lifetime 
# in seconds (float) 
class DropTimer

  def done?
    @lifeleft < 0
  end

  def update
    @lifeleft -= (GetFrameTime() * @speed)
  end

  def reset
    @lifeleft = @lifetime
  end

  def normal_speed!
    @speed = 1 
  end

  def high_speed!
    @speed = 300 
  end

  private

  def initialize(lifetime)
    @lifetime = lifetime
    normal_speed! 
    reset
  end

end
