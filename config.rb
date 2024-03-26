require 'Raylib'
require_relative '.\raylib_include.rb'

class Config
  # ==============================
  # Game State constants 
  # ==============================
  NAVIGATE  = 0
  HARD_DROP = 1
  RESPAWN = 2

  # ==============================
  # Player - Logical Constants 
  # ==============================
  LEFT = 0
  RIGHT = 1
  DOWN = 2
  
  # ==============================
  # Board - Logical Constants 
  # ==============================
  BOARD_HEIGHT = 20
  BOARD_WIDTH = 10

  S = 1
  Z = 2
  T = 3
  I = 4
  B = 5
  L = 6
  R = 7
  MAX_SHAPE = 8
  EMPTY = 0
 
  # ==============================
  # Board Screen Positions 
  # ==============================
  BOARD_X = 150 
  BOARD_Y = 50 
  CELL_WIDTH = CELL_HEIGHT = 25
  CELL_GAP = 2

  class Colour
    attr_accessor :name, :rgb
    def initialize(name, rgb)
      @name = name
      @rgb = rgb
    end
  end

  Blue = Colour.new("BLU ", Color.from_u8(30, 75, 200, 255))
  Green = Colour.new("GRN ", Color.from_u8(30, 200, 34, 255))
  Red = Colour.new("RED ", Color.from_u8(200, 0, 34, 255))
  Yellow = Colour.new("YLW ", Color.from_u8(255, 200, 34, 255))
  Grey = Colour.new("GRY ", Color.from_u8(100, 100, 100, 255))

  TetrisPalette = { EMPTY => Grey,
                    S => Blue, 
                    Z => Green,
                    T => Red, 
                    I => Yellow, 
                    B => Grey,
                    L => Blue,
                    R => Red,
                   }

  def Config.get_rgb(value)
    TetrisPalette[value].rgb
  end

 end
