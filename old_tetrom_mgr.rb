require 'Raylib'
require_relative '.\raylib_include.rb'

class Coordinate
  attr_accessor  :col, :row

  def initialize(*args)
    @col, @row = args
  end
end

class CollisionChecker

  # takes an array of 4 filled cells for a tetromino
  # and an array of filled cells for the section of board
  # to check collision for
  # Return true if tetromino collides with a filled 
  # cell of the board. 
  # Return true if tetromino collides with the sides 
  # or floor of the board.
  # False otherwise
  def is_collision(row, col, tetromino, board)
    t_grid = get_4_by_4_grid(tetromino)
    print t_grid

    b_grid = get_4_by_4_grid(board)
    print b_grid
  end

  private

  def initialize
    @board_width = 10
    @board_height = 20
  end

  def get_4_by_4_grid(filled_coords)
    grid = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0] 
    filled_coords.each do |c|
      grid[(c.row*4)+c.col] = 1
    end
    grid
  end

end

class TetrominoMgr
  S_SHAPE = 0
  T_SHAPE = 1

  attr_accessor :tetromino_orientations,
                :current_tetromino_type, :current_orientation, 
                :next_tetromino_type, :next_tetromino_orientation
                

  def respawn
    @current_tetromino_type = next_tetromino_type 
    @current_orientation = 0
    next_tetromino_type = get_random_tetromino_type
  end

  def rotate
    @current_orientation < 3 ? @current_orientation += 1 : @current_orientation = 0 
    print "Current Orientation = #{@current_orientation}"
  end

  def get_current_tetromino_filled_cells
    tetromino_orientations[@current_tetromino_type][@current_orientation] 
  end

  private

  def initialize
    SetRandomSeed(784578784)

    # For each Tetromino type, create an array of 4 "directions". 
    # Each direction is an array of 4 Coordinate objects.
    # A Coordinate represents a filled cell in a 4 x 4 grid.
    @s_tetromino_in_four_directions = []
    [
      [ [0,1],[0,2],[1,0],[1,1] ],
      [ [0,1],[1,1],[1,2],[2,2] ],
      [ [1,1],[1,2],[2,0],[2,1] ],
      [ [0,0],[1,0],[1,1],[2,1] ]
    ].each do |arr| 
      @s_tetromino_in_four_directions << arr.collect { |c| Coordinate.new(*c) }  
    end

    @t_tetromino_in_four_directions = []
    [
      [ [0,1],[1,0],[1,1],[1,2] ],
      [ [0,1],[1,1],[1,2],[2,1] ],
      [ [1,0],[1,1],[1,2],[2,1] ],
      [ [0,1],[1,0],[1,1],[2,1] ]
    ].each do |arr| 
      @t_tetromino_in_four_directions << arr.collect { |c| Coordinate.new(*c) }  

      @tetromino_orientations = []
      tetromino_orientations << @s_tetromino_in_four_directions
      tetromino_orientations << @t_tetromino_in_four_directions

      @next_tetromino_type = get_random_tetromino_type
    end
  end

  def get_random_tetromino_type
    GetRandomValue(S_SHAPE, T_SHAPE)
  end
end


if __FILE__ == $PROGRAM_NAME
  t = TetrominoMgr.new
  t.respawn
  t.rotate
  t.rotate
  t.rotate
  t.rotate
  print t.get_current_tetromino_filled_cells

  [ 1, 1, 0, 0 ]
  [ 1, 1, 0, 0 ]
  [ 1, 1, 0, 0 ]
  [ 1, 1, 0, 0 ]


  [ [0, 0], [1, 0], [0, 1], [1, 1],
    [0, 2], [1, 2], [0, 3], [1, 3] ]

  

  
end
