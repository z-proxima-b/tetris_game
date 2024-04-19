require 'Raylib'
require_relative './raylib_include.rb'
require_relative './timer.rb'

class FlashTimer < Time

  def timeout?
    @lifeleft < 0
  end

  def update
    @lifeleft -= (GetFrameTime() * @speed)
  end

  def reset
    @lifeleft = @lifetime
  end

  private

  def initialize(lifetime)
    @speed = 1
    @lifetime = lifetime
    reset
  end

end
