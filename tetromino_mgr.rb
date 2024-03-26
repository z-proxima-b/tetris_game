require 'config'

class TetrominoMgr 
  CURRENT = 0
  NEXT = 1

  attr_accessor :current_row, :current_column

  def current_filled_cells
    @data[current_type_][current_orientation_]
  end

  def move_down
    @current_row+=1
    puts "MOVED DOWN!"
  end

  def respawn
    set_random_type_for_(CURRENT)
    set_starting_orientation_for_(CURRENT)
    set_start_coords_
    make_grid_(CURRENT)

    set_random_type_for_(NEXT)
    set_starting_orientation_for_(NEXT)
    make_grid_(NEXT)
  end

  def rotate
    set_next_orientation_
    make_grid_(CURRENT)
  end

  def current_tetromino_grid 
    @grid[CURRENT]
  end

  def next_tetromino_grid 
    @grid[NEXT]
  end

  def current_type
    @type[CURRENT]
  end

  def next_type
    @type[NEXT]
  end

  def current_rightmost_column
    right_col_
  end

  def current_leftmost_column
    left_col_ 
  end

  def current_bottom_row 
    bottom_
  end

  private

  def initialize
    # For each Tetromino type, create an array of 4 "rotates". 
    # Each rotate is an array of 4 Coordinate objects. 
    # Each member Coordinate is a filled cell in a 3 x 3, or 4 x 4
    # grid.
    # ============================================
    # Coordinate data appears as: [ROW, COLUMN]
    # ============================================
    @data = []

    @data << []
    
    # Z ##########################
    @data << [
      [[0,1],[1,0],[1,1],[2,0]],
      [[0,0],[0,1],[1,1],[1,2]],
      [[0,2],[1,1],[1,2],[2,1]],
      [[1,0],[1,1],[2,1],[2,2]]
    ]

    # S ##########################
    @data << [
      [[0,1], [1,1], [1,2], [2,2]],
      [[1,1], [1,2], [2,0], [2,1]],
      [[0,1], [1,0], [1,1], [2,1]],
      [[0,1], [0,2], [1,0], [1,1]] 
    ]

    # T ##########################
    @data << [
      [[0,1], [1,1], [1,2], [2,1]],
      [[1,0], [1,1], [1,2], [2,1]],
      [[0,1], [1,0], [1,1], [2,1]],
      [[0,1], [1,0], [1,1], [1,2]] 
    ]

    # I ##########################
    @data << [
      [[0,1], [1,1], [2,1], [3,1]],
      [[1,0], [1,1], [1,2], [1,3]],
      [[0,2], [1,2], [2,2], [2,3]],
      [[2,0], [2,1], [2,2], [3,2]] 
    ]

    # Box ########################
    @data << [
      [[0,0], [0,1], [1,0], [1,1]],
      [[0,0], [0,1], [1,0], [1,1]],
      [[0,0], [0,1], [1,0], [1,1]],
      [[0,0], [0,1], [1,0], [1,1]]
    ]

    # L ##########################
    @data << [
      [[0,0], [0,1], [1,1], [2,1]],
      [[0,2], [1,0], [1,1], [1,2]],
      [[0,1], [1,1], [2,1], [2,2]],
      [[1,0], [1,1], [1,2], [2,0]]
    ]

    # R ##########################
    @data << [
      [[0,1], [0,2], [1,1], [2,1]],
      [[1,0], [1,1], [1,2], [2,2]],
      [[0,1], [1,1], [2,0], [2,1]],
      [[0,0], [1,0], [1,1], [1,2]]
    ]
   
    SetRandomSeed(Time.now.to_i)
    
    @orient = Array.new(2, 0)
    @type = Array.new(2, Config::EMPTY)
    @grid = Array.new(2, [])

    respawn
  end

  def current_type_
    @type[CURRENT]
  end

  def current_orientation_
    @orient[CURRENT]
  end
  
  def set_start_coords_
    @current_row = 0
    @current_column = 7
  end

  def make_grid_(which)
    #puts "make_grid #{which} **** #{@type[which]} * * * * "
    @grid[which] = get_shape_grid(@type[which], @orient[which]) 
  end

  def get_empty_grid(type)
    three_x_three = []
    four_x_four = [Config::S, Config::Z, Config::T,  
                   Config::B, Config::L, Config::R,
                   Config::I]

    case type 
    when *three_x_three
      [[0,0,0],[0,0,0],[0,0,0]]
    when *four_x_four 
      [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]
    else
      throw ArgumentError
    end
  end

  def get_shape_grid(type, orient) 
    dest_grid = get_empty_grid(type)
    #puts "type = #{type} orient = #{orient}"
    #puts "empty grid = #{dest_grid}"
    #puts "data = #{@data[type][orient]}"
    @data[type][orient].each do |c|
      #puts "coord: #{c}"
      dest_grid[c.first][c.last] = type 
    end
    dest_grid
  end

  def print_grid(g)
    g.each do |row|
      #puts "#{row}" 
    end
    #puts "\n"
  end

  def set_random_type_for_(which)
    @type[which] = random_shape_
  end

  def set_starting_orientation_for_(which)
    case which
    when CURRENT
      @orient[CURRENT] = 0 
    when NEXT
      @orient[NEXT] = 1 
    end
  end

  def random_shape_
    GetRandomValue(Config::FIRST_SHAPE, Config::LAST_SHAPE)
  end
  
  def set_next_orientation_
    cycle_current_orientation_ unless @type[CURRENT] == Config::B
  end

  def cycle_current_orientation_
    @orient[CURRENT] + 1 == 4 ? @orient[CURRENT] = 0 : @orient[CURRENT] += 1
  end

  def left_col_
    @grid[CURRENT].collect { |r| r.first }
  end

  def right_col_
    @grid[CURRENT].collect { |r| r.last }
  end

  def bottom_
    @grid[CURRENT].last
  end
end

  
