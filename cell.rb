require_relative 'canvas.rb'

class Cell

  def to_shape 
    Shape.new(Shape::RECT, x, y,
              width, height,
              description)
  end

  def fill(tetrum)
    @description = tetrum
  end

  def clear
    @description = Canvas::EMPTY 
  end

  private

  attr_accessor :x, :y, :width, :height, :description

  def initialize(x, y, width, height) 
    @x = x
    @y = y
    @width = width
    @height = height
    @description = Canvas::EMPTY
  end
end


