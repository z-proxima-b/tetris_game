require_relative './config.rb'

class Shape

  attr_accessor :type, :x, :y, :width, :height, :colour, :optional
  RECT = 1
  ROUNDED_RECT = 2
  TEXT = 3

  def initialize(type, x, y, width, height, colour, optional=nil)  
    @type = type
    @x = x
    @y = y
    @width = width
    @height = height
    @colour = colour 
    @optional = optional
  end 

  def to_s 
    @colour.name
  end
end


