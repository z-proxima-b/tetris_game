  def make_grid_(rotation, dim)
    grid = empty_grid(dim)
    rotation.each do |coord|
      grid[c.first][c.last] = current 
    end
    empty
  end

  def rightmost_column
    @current_size.times.collect { |i| @current_grid[i].last }
  end

  def bottom_row
    @current_grid.last
  end

  def leftmost_column
    @current_size.times.collect { |i| @current_grid[i].first } 
  end

  def respawn
    #@current = Config.random_tetromino 
    #@rotation = 0
    # @current_grid = make_grid(@tetromino_data[@current][@rotation], 3) 
  end

  
end
 
