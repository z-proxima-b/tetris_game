def print
    @grid.size.times do |i|
      puts "#{@grid[i]}".gsub(":EMPTY", "0") 
    end
  end

  def get_row(row)
    @grid[row]
  end

  def get_entire_grid
    result = []
    @grid.slice(0, Config::BOARD_HEIGHT).each do |row|
      result << row[4..Config::BOARD_WIDTH+4]
    end
  end

  def get_4_x_4_grid_at(row, col)
    raise ArgumentError unless valid_row?(row) && valid_col?(col)
    col = normalize(col)

    # First select the correct 4 rows from the grid, 
    # then take a slice of 4 items from each row.
    # Pack each slice into an array.
    4.times.collect do |i|
      4.times.collect { |j| @grid[row+i][col+j] }
    end
  end

  def get_3_x_3_grid_at(row, col)
    raise ArgumentError unless valid_row?(row) && valid_col?(col)
    col = normalize(col)

    # First select the correct 3 rows from the grid, 
    # then take a slice of 3 items from each row.
    # Pack each slice into an array.
    3.times.collect do |i|
      3.times.collect { |j| @grid[row+i][col+j] }
    end
  end


  def paste_4_x_4_grid_at(their_grid, row, col)
    raise ArgumentError unless valid_row?(row) && valid_col?(col)
    col = normalize(col)
    
    4.times do |i| 
      4.times do |j|
        # overwite EMPTY cells only
        if @grid[i+row][j+col] == Config::EMPTY 
          @grid[i+row][j+col] = their_grid[i][j]
        end
      end
    end
  end

  def paste_3_x_3_grid_at(their_grid, row, col)
    raise ArgumentError unless valid_row?(row) && valid_col?(col)
    col = normalize(col)
    
    3.times do |i| 
      3.times do |j|
        # overwite EMPTY cells only
        if @grid[i+row][j+col] == Config::EMPTY 
          @grid[i+row][j+col] = their_grid[i][j]
        end
      end
    end
  end

  
  def get_completed_rows
    res = (0..Config::BOARD_HEIGHT).select { |i|
      solid?(i) 
    } 
    res
  end

  def toggle_flash_completed_rows(rows)
    @flash = !@flash
    rows.each do |r|
      @grid[r].fill(4,Config::BOARD_WIDTH) { @flash ? Config::FLASH_ON : Config::FLASH_OFF }
    end
  end

  def clear_completed_rows(arr)
    newgrid = []
    arr.size.times do 
      newgrid << empty_row_with_two_walls
    end

    (0..Config::BOARD_HEIGHT+4).times do  |i|
      newgrid << @grid[i] if !arr.include?(i) 
    end 
    @grid = newgrid
  end

  private

  def initialize
    @flash = false  
    @grid = [] 
    Config::BOARD_HEIGHT.times do 
      @grid << empty_row_with_two_walls
    end

    4.times do
      @grid << solid_floor 
    end
  end

  def normalize(val)
    return val+4 
  end

  def valid_row?(row)
    row < Config::BOARD_HEIGHT && row >= 0 
  end

  def valid_col?(col)
    col < Config::BOARD_WIDTH && col >= 0
  end

  def empty_row_with_two_walls
    row = []
    row.fill(Config::WALL, 0, 4)
    row.fill(Config::EMPTY, 4, Config::BOARD_WIDTH)
    row.fill(Config::WALL, 4+Config::BOARD_WIDTH, 4)
  end

  def solid_floor 
    row = []
    row.fill(Config::WALL, 0, Config::BOARD_WIDTH+8)
  end

  def solid?(row)
    @grid[row][4,Config::BOARD_WIDTH].all? do |cell|
      Config.valid_tetromino?(cell) 
    end
  end


