require 'Raylib'
require_relative '.\raylib_include.rb'

class Config
  # ==============================
  # Game State constants 
  # ==============================
  NAVIGATE  = 0
  HARD_DROP = 1
  RESPAWN = 2
  PAUSED = 3
  CALCULATE_SCORE = 4
  FLASH_ROWS = 5
  CLEAR_ROWS = 6
  GAME_OVER = 7

  # ==============================
  # Player - Logical Constants 
  # ==============================
  LEFT = 0
  RIGHT = 1
  DOWN = 2
  ROTATE = 3
  
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
  MAX_TILE = 8
  EMPTY = 0

  FLASH_ON = 9
  FLASH_OFF = 10

  BOARD_EDGE = 11

  SEQUENCE_LENGTH = 5

  # ==============================
  # Screen Dimensions 
  # ==============================
  SCREEN_WIDTH = 620
  SCREEN_HEIGHT = 620
  
  # ==============================
  # Board Screen Positions 
  # ==============================
  CELL_WIDTH = CELL_HEIGHT = 24
  CELL_GAP = 2
  RIGHT_SPACE = 24 
  BOARD_WIDTH_PHYSICAL = (CELL_WIDTH+CELL_GAP)*BOARD_WIDTH
  BOARD_HEIGHT_PHYSICAL = (CELL_HEIGHT+CELL_GAP)*BOARD_HEIGHT
  BOARD_X = (SCREEN_WIDTH - BOARD_WIDTH_PHYSICAL)/2 
  BOARD_Y = 50 
  BOX_X = BOARD_X + BOARD_WIDTH_PHYSICAL + RIGHT_SPACE 

  def Config.all_rows
    (0..BOARD_HEIGHT-1)
  end

  def Config.all_columns
    (0..BOARD_WIDTH-1)
  end
  
  # ==============================
  # Flashing Rows Constants 
  # ==============================
  ONE_FLASH_DURATION = 0.1  # seconds
  TOTAL_FLASH_DURATION = 1.0 # seconds

  # ==============================
  # Preview Constants 
  # ==============================
  PREVIEW_CELL_WIDTH = 18 
  PREVIEW_CELL_GAP = 1
  PREVIEW_CELL_HEIGHT = 18 
  PREVIEW_X = BOX_X
  PREVIEW_Y = BOARD_Y + CELL_HEIGHT 
  PREVIEW_BOX_WIDTH = PREVIEW_CELL_WIDTH*4 
  PREVIEW_BOX_HEIGHT = PREVIEW_CELL_HEIGHT*4

  # ==============================
  # Colour wrapper 
  # ==============================
  class Colour
    attr_accessor :name, :rgb
    def initialize(name, rgb)
      @name = name
      @rgb = rgb
    end
  end

  # ==============================
  # Colour definitions 
  # ==============================
  Blue = Colour.new("BLU ", Color.from_u8(30, 75, 200, 255))
  Green = Colour.new("GRN ", Color.from_u8(30, 200, 34, 255))
  Red = Colour.new("RED ", Color.from_u8(200, 0, 34, 255))
  Yellow = Colour.new("YLW ", Color.from_u8(255, 200, 34, 255))
  Grey = Colour.new("GRY ", Color.from_u8(20, 33, 61, 255))
  Cyan = Colour.new("CYN", Color.from_u8(0, 255, 255, 255))
  Magenta = Colour.new("MAG", Color.from_u8(255, 0, 255, 255))
  Orange = Colour.new("ORA", Color.from_u8(255, 165, 0, 255))
  Pink = Colour.new("PINK", SKYBLUE) 
  Lime = Colour.new("LIME", GOLD)
  DarkBrown = Colour.new("DBR", Color.from_u8(76, 63, 47, 255))
  PaleBlue = Colour.new("PLB", Color.from_u8(144, 224, 239, 255))
  # ==============================
  # Palette
  # ==============================
  TetrisPalette = { EMPTY => Grey,
                    S => Blue, 
                    Z => Green,
                    T => Red, 
                    I => Yellow, 
                    B => Cyan,
                    L => Magenta,
                    R => Orange,
                    FLASH_OFF => Pink,
                    FLASH_ON => Lime,
                    BOARD_EDGE => PaleBlue 
                   }

  def Config.get_rgb(value)
    TetrisPalette[value].rgb
  end


 end
