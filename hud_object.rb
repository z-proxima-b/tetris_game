require_relative './shape.rb'

class HudObject
  attr_accessor :shapes
  def initialize(x, y, width, height, colour, title)
    @shapes = []
    @shapes << create_title_shape_(title, x, y)
    @shapes << create_border_shape_(x, y, width, height)
  end

  def create_title_shape_(title, x, y, fontsize, colour) 
    Shape.new(Shape::TEXT,
              x, y, 0, fontsize, colour, title) 
  end

  def create_border_shape_(x, y, width, height, colour)
    Shape.new(Shape::ROUNDED_RECT,
              x, y, width, height, colour)
  end

end
