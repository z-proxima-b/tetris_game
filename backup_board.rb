def solid_row
    row = []
    row.fill(Config::WALL, 0, Config::BOARD_WIDTH+8)
  end

  def solid?(row)
    @grid[row][Config::WALL_WIDTH,Config::BOARD_WIDTH].all? do |cell|
      Config.valid_tetromino?(cell) 
    end
  end

  def validate_(row, col)
    raise ArgumentError unless valid_row?(row) && valid_col?(col)
  end

  def subgrid_(width, row, col)
    # First select the relevant rows from the grid, 
    # then take a slice of items from each one.
    # Pack each slice into an array.
    range_of_rows_(row, width).map do |relevant_row|
      relevant_row.slice(col, width)
    end
  end

  def range_of_rows_(from, count)
    @grid.slice(from, count)
  end

    def get_grid_at(gridsize, row, col)
     validate_(row, col)
     col = normalize_(col)
     subgrid_(gridsize, row, col)
 end

def get_entire_grid
    @grid
  end

  def get_playing_area
    @grid.slice(Config::WALL_WIDTH, Config::BOARD_HEIGHT).collect do |row|
      row.slice(Config::WALL_WIDTH, Config::BOARD_WIDTH)
    end
  end

  def get_playable_row(index)
    @grid[index].slice(Config::WALL_WIDTH, Config::BOARD_WIDTH)
  end


  def set_grid_at(filled_cells, type, y_offs, x_offs)
    filled_cells.each { |c|
      i = c[0]
      j = c[1]
      @grid[y_offs+i][x_offs+j] = type }
  end

  def get_column_right_of_player(row, col, tetrumwidth)
    @grid.slice(row, tetrumwidth).collect do |boardrow|
      puts "#{col+tetrumwidth}"
      boardrow[col+tetrumwidth]
    end
  end    

  def get_column_left_of_player(row, col, tetrumwidth)
    @grid.slice(row, tetrumwidth).collect do |boardrow|
      puts "#{col-1}"
      boardrow[col-1]
    end
  end    

  def get_column_underneath_player(row, col, tetrumwidth)
    @grid[row+tetrumwidth].slice(col,tetrumwidth) 
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
      @grid[r].fill(Config::WALL_WIDTH,Config::BOARD_WIDTH) { @flash ? Config::FLASH_ON : Config::FLASH_OFF }
    end
  end

  def clear_completed_rows(arr)
    newgrid = []
    arr.each do 
      newgrid << empty_row_with_two_walls
    end

    (0..Config::BOARD_HEIGHT+Config::WALL_WIDTH).each do  |i|
      newgrid << @grid[i] if !arr.include?(i) 
    end 
    @grid = newgrid
  end

  def collision?(row, column)
    puts "@grid[#{row}][#{column}] == #{@grid[row][column]}" 
    (row > Config::WALL_WIDTH-1) && @grid[row][column] != Config::EMPTY
  end


  def get_entire_grid
    @grid
  end

  def get_playing_area
    @grid.slice(Config::WALL_WIDTH, Config::BOARD_HEIGHT).collect do |row|
      row.slice(Config::WALL_WIDTH, Config::BOARD_WIDTH)
    end
  end

  def get_playable_row(index)
    @grid[index].slice(Config::WALL_WIDTH, Config::BOARD_WIDTH)
  end


  def set_grid_at(filled_cells, type, y_offs, x_offs)
    filled_cells.each { |c|
      i = c[0]
      j = c[1]
      @grid[y_offs+i][x_offs+j] = type }
  end

  def get_column_right_of_player(row, col, tetrumwidth)
    @grid.slice(row, tetrumwidth).collect do |boardrow|
      puts "#{col+tetrumwidth}"
      boardrow[col+tetrumwidth]
    end
  end    

  def get_column_left_of_player(row, col, tetrumwidth)
    @grid.slice(row, tetrumwidth).collect do |boardrow|
      puts "#{col-1}"
      boardrow[col-1]
    end
  end    

  def get_column_underneath_player(row, col, tetrumwidth)
    @grid[row+tetrumwidth].slice(col,tetrumwidth) 
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
      @grid[r].fill(Config::WALL_WIDTH,Config::BOARD_WIDTH) { @flash ? Config::FLASH_ON : Config::FLASH_OFF }
    end
  end

  def clear_completed_rows(arr)
    newgrid = []
    arr.each do 
      newgrid << empty_row_with_two_walls
    end

    (0..Config::BOARD_HEIGHT+Config::WALL_WIDTH).each do  |i|
      newgrid << @grid[i] if !arr.include?(i) 
    end 
    @grid = newgrid
  end

  def collision?(row, column)
    puts "@grid[#{row}][#{column}] == #{@grid[row][column]}" 
    (row > Config::WALL_WIDTH-1) && @grid[row][column] != Config::EMPTY
  end


  def get_entire_grid
    @grid
  end

  def get_playing_area
    @grid.slice(Config::WALL_WIDTH, Config::BOARD_HEIGHT).collect do |row|
      row.slice(Config::WALL_WIDTH, Config::BOARD_WIDTH)
    end
  end

  def get_playable_row(index)
    @grid[index].slice(Config::WALL_WIDTH, Config::BOARD_WIDTH)
  end


  def set_grid_at(filled_cells, type, y_offs, x_offs)
    filled_cells.each { |c|
      i = c[0]
      j = c[1]
      @grid[y_offs+i][x_offs+j] = type }
  end

  def get_column_right_of_player(row, col, tetrumwidth)
    @grid.slice(row, tetrumwidth).collect do |boardrow|
      puts "#{col+tetrumwidth}"
      boardrow[col+tetrumwidth]
    end
  end    

  def get_column_left_of_player(row, col, tetrumwidth)
    @grid.slice(row, tetrumwidth).collect do |boardrow|
      puts "#{col-1}"
      boardrow[col-1]
    end
  end    

  def get_column_underneath_player(row, col, tetrumwidth)
    @grid[row+tetrumwidth].slice(col,tetrumwidth) 
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
      @grid[r].fill(Config::WALL_WIDTH,Config::BOARD_WIDTH) { @flash ? Config::FLASH_ON : Config::FLASH_OFF }
    end
  end

  def clear_completed_rows(arr)
    newgrid = []
    arr.each do 
      newgrid << empty_row_with_two_walls
    end

    (0..Config::BOARD_HEIGHT+Config::WALL_WIDTH).each do  |i|
      newgrid << @grid[i] if !arr.include?(i) 
    end 
    @grid = newgrid
  end

  def collision?(row, column)
    puts "@grid[#{row}][#{column}] == #{@grid[row][column]}" 
    (row > Config::WALL_WIDTH-1) && @grid[row][column] != Config::EMPTY
  end

def playable_(row)
    arr.slice(Config::WALL_WIDTH, Config::BOARD_WIDTH)
  end

  def test_set_grid_3
    filled = [[1,1], [1,2], [2,0], [2,1]]
    # [ [ 0, 0, 0]
    # [ [ 0, 1, 1]
    # [ [ 1, 1, 0]
    
    type = Config::S 
    y = 8 
    x = 5 
    b = Board.new

    # y and x are relative to (0, 0) of the entire grid, 
    # including invisible areas.
    # filled is an array of offset coordinates.
    b.set_grid_at(filled, type, y, x)
    b.print
    one = [9, 9, 9, 9, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 9, 9, 9, 9]
    two = [9, 9, 9, 9, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 9, 9, 9, 9]

    assert_equal [one, two], b.get_entire_grid.slice(9, 2)
  end

  def test_set_grid_4
    # skip
    filled = [[0,2], [1,2], [2,2], [3,2]]
    #  [0, 0, 4, 0]
    #  [0, 0, 4, 0]
    #  [0, 0, 4, 0]
    #  [0, 0, 4, 0]

    type = Config::I
    y = 10
    x = 7
    b = Board.new
    b.set_grid_at(filled, type, y, x)
    one = [9, 9, 9, 9, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 9, 9, 9, 9]
    two = [9, 9, 9, 9, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 9, 9, 9, 9]
    thr = [9, 9, 9, 9, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 9, 9, 9, 9]
    fur = [9, 9, 9, 9, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 9, 9, 9, 9]

    assert_equal [one, two, thr, fur], b.get_entire_grid.slice(y, 4)

  end

  def test_collision_true
    # skip
    filled = [[0,2], [1,2], [2,2], [3,2]]
    #  [0, 0, 4, 0]
    #  [0, 0, 4, 0]
    #  [0, 0, 4, 0]
    #  [0, 0, 4, 0]

    type = Config::I
    y = 10
    x = 7
    b = Board.new
    b.set_grid_at(filled, type, y, x)
    one = [9, 9, 9, 9, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 9, 9, 9, 9]
    two = [9, 9, 9, 9, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 9, 9, 9, 9]
    thr = [9, 9, 9, 9, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 9, 9, 9, 9]
    fur = [9, 9, 9, 9, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 9, 9, 9, 9]

    assert_equal [one, two, thr, fur], b.get_entire_grid.slice(y, 4)
  end

  def test_get_playing_area
    filled = [[0,0], [0,1], [0,2], [0,3],
              [1,0], [1,1], [1,2], [1,3],
              [2,0], [2,1], [2,2], [2,3],
              [3,0], [3,1], [3,2], [3,3]]
    type = 3
    b = Board.new
    b.set_grid_at(filled, type, 10, 7)

    filled2 = [[0,0], [0,1],[1,0], [1,1]]
    b.set_grid_at(filled2, 4, 11, 8)

    b.print
    empty_row =  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 
    playable = []
    6.times { playable << empty_row } 
    playable << [0, 0, 0, 3, 3, 3, 3, 0, 0, 0] 
    playable << [0, 0, 0, 3, 4, 4, 3, 0, 0, 0]
    playable << [0, 0, 0, 3, 4, 4, 3, 0, 0, 0]
    playable << [0, 0, 0, 3, 3, 3, 3, 0, 0, 0]
    10.times { playable << empty_row } 

    assert_equal playable, b.get_playing_area

  end

  def test_get_completed_rows_returns_empty_on_a_new_board
    skip
    assert_equal [], Board.new.get_completed_rows
  end

  def test_get_completed_rows_returns_correct_values
    skip
    row = 10
    col = 0 
    b = Board.new
    assert_equal [10,12], b.get_completed_rows
  end

  def test_flash_rows
    skip
    flashed = Array.new(Config::BOARD_WIDTH, Config::FLASH_ON)
    b = Board.new
    flash_these = [10, 4, 2]
    b.toggle_flash_completed_rows(flash_these)
    assert_equal true, flash_these.all? {|i| b.get_playable_row(i) == flashed } 

    flash_off = Array.new(Config::BOARD_WIDTH, Config::FLASH_OFF)
    b.toggle_flash_completed_rows(flash_these)
    assert_equal true, flash_these.all? {|i| b.get_playable_row(i) == flash_off } 
  end

  def test_clear_completed_rows
    skip
    row = 10
    col = 0 
    b = Board.new

    comp = b.get_completed_rows

    #puts " comp = #{comp}"
    b.clear_completed_rows(comp)
    #b.print
    assert_equal true, b.get_playable_row(10).all? { Config::EMPTY } 
  end


