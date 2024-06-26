require 'config'
require_relative 'coordinate'

class Tile 
  
  # ===============================================
  # ===============================================
  # Just like a bitmap, tiles are represented 
  # internally as a sequence of "ON bits",
  # within a larger sequence of "OFF bits". 
  # Except the 'bits' are cells within a 4x4 grid.
  # e.g.
  # If we drew a bitmap for the Z tile, it might
  # look like:
  #      >>  1 1 . .  >>
  #      >>  . 1 1 .  >>
  #      >>  . . . .  >>
  #      >>  . . . .  >>
  #
  # And then taking the coordinates of the '1's,
  # we can represent it thus:
  #       [ [0,0], [0,1], [1,1], [1,2] ]
  #
  # Each tile has 4 such sequences, one for each 
  # rotation (north, east, south, west).
  # ===============================================
  # ===============================================
  @@tile_data = 
  [
    [],

    # Z ========================##
    [
      [[0,1],[1,0],[1,1],[2,0]],
      [[0,0],[0,1],[1,1],[1,2]],
      [[0,2],[1,1],[1,2],[2,1]],
      [[1,0],[1,1],[2,1],[2,2]]
    ],
    # S ========================##
    [
      [[0,1], [1,1], [1,2], [2,2]],
      [[1,1], [1,2], [2,0], [2,1]],
      [[0,1], [1,0], [1,1], [2,1]],
      [[0,1], [0,2], [1,0], [1,1]] 
    ],
    # T ========================##
    [
      [[0,1], [1,1], [1,2], [2,1]],
      [[1,0], [1,1], [1,2], [2,1]],
      [[0,1], [1,0], [1,1], [2,1]],
      [[0,1], [1,0], [1,1], [1,2]] 
    ],
    # I ========================##
    [
      [[0,1], [1,1], [2,1], [3,1]],
      [[1,0], [1,1], [1,2], [1,3]],
      [[0,2], [1,2], [2,2], [2,3]],
      [[2,0], [2,1], [2,2], [3,2]] 
    ],
    # Box is special, it looks the
    # same after each rotation. So 
    # it has 4 identical rotations. 
    # Box ======================##
    [
      [[0,0], [0,1], [1,0], [1,1]],
      [[0,0], [0,1], [1,0], [1,1]],
      [[0,0], [0,1], [1,0], [1,1]],
      [[0,0], [0,1], [1,0], [1,1]]
    ],
    # L ========================##
    [
      [[0,0], [0,1], [1,1], [2,1]],
      [[0,2], [1,0], [1,1], [1,2]],
      [[0,1], [1,1], [2,1], [2,2]],
      [[1,0], [1,1], [1,2], [2,0]]
    ],
    # R ========================##
    [
      [[0,1], [0,2], [1,1], [2,1]],
      [[1,0], [1,1], [1,2], [2,2]],
      [[0,1], [1,1], [2,0], [2,1]],
      [[0,0], [1,0], [1,1], [1,2]]
    ]
  ]

  def make_coords_(cell_data, row_offs=0, column_offs=0)
    cell_data.collect { |c| Coordinate.new(c[0]+row_offs, c[1]+column_offs) } 
  end
end

class MovableTile < Tile

  @@start_pos_data = 
  [
    [],

    # Z ========================##
    [0, 4],
    # S ========================##
    [0, 4],
    # T ========================##
    [0, 4],
    # I ========================##
    [0, 5],
    # Box ======================## 
    [0, 3],
    # L ========================##
    [0, 4],
    # R ========================##
    [0, 4]
  ]

  attr_accessor :type, :rote, :filled_coords

  def destroy!
    @filled_coords = []
  end

  def shift_left!
    @column -= 1
    @filled_coords.collect { |c| c.offset(0, -1) }
  end

  def shift_right!
    @column += 1
    @filled_coords.collect { |c| c.offset(0, 1) }
  end

  def shift_down!
    @row += 1
    @filled_coords.collect { |c| c.offset(1, 0) }
  end

  def shift_up!
    @row -= 1
    @filled_coords.collect { |c| c.offset(-1, 0) }
  end

  def rotate!
    @rote + 1 == 4 ? @rote = 0 : @rote += 1
    @filled_coords = make_coords_(@@tile_data[@type][@rote],@row, @column)
  end

  private

  def initialize(type_value, rotation=0)
    @type = type_value 
    @row = @@start_pos_data[@type][0]
    @column = @@start_pos_data[@type][1]
    @filled_coords = make_coords_(@@tile_data[@type][rotation], @row, @column)
    @rote = rotation
  end

end

class PreviewTile < Tile
  attr_accessor :type, :filled_coords, :width, :height

  private

  @@preview_data = 
  [
    [],
    # Z ========================##
    [[0,0],[0,1],[1,1],[1,2]],
    # S ========================##
    [[0,1], [0,2], [1,0], [1,1]],
    # T ========================##
    [[0,0], [0,1], [0,2], [1,1]],
    # I ========================##
    [[0,0], [0,1], [0,2], [0,3]],
    # Box ======================##
    [[0,0], [0,1], [1,0], [1,1]],
    # L ========================##
    [[0,0], [0,1], [0,2], [1,0]],
    # R ========================##
    [[0,0], [1,0], [1,1], [1,2]],
  ]

  @@width_data =
  [
    [],
    # Z ========================##
    3, 
    # S ========================##
    3, 
    # T ========================##
    3, 
    # I ========================##
    4, 
    # Box ======================##
    2, 
    # L ========================##
    3, 
    # R ========================##
    3 
  ]

  @@height_data =
  [
    [],
    # Z ========================##
    2, 
    # S ========================##
    2, 
    # T ========================##
    2, 
    # I ========================##
    1, 
    # Box ======================##
    2, 
    # L ========================##
    2, 
    # R ========================##
    2 
  ]
  def initialize(type_value)
    @type = type_value 
    @filled_coords = make_coords_(@@preview_data[@type])
    @width = @@width_data[@type]
    @height = @@height_data[@type]
  end
end

class TileGenerator

  def get_next
    if @tilestream_.empty? then
      @tilestream_ = random_sequence_ 
    end
    MovableTile.new(@tilestream_.shift)
  end

  def get_rotated(tile)
    new_rotation = (tile.rote + 1 == 4 ? 0 : tile.rote + 1)
    MovableTile.new(tile.type, new_rotation) 
  end

  def get_preview
    if @tilestream_.empty? then
      @tilestream_ = random_sequence_
    end
    PreviewTile.new(@tilestream_.first) 
  end

  private

  def initialize
    SetRandomSeed(Time.now.to_i)
    @tilestream_ = random_sequence_ 
  end

  def random_sequence_ 
    Config::SEQUENCE_LENGTH.times.collect { 
      GetRandomValue(Config::S, Config::R)
    }
  end

end

  
