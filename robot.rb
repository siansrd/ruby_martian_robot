class Robot 

  def initialize(start_position, grid)
    position = start_position.split(" ")
    @x = position[0].to_i
    @y = position[1].to_i
    @orientation = position[2]
    @grid = grid 
    @movements = {
      'N' => [0, 1],
      'E' => [1, 0],
      'S' => [0, -1],
      'W' => [-1, 0]   
    }
    @orientations = ['N', 'E', 'S', 'W'] 
    @prev_x = nil
    @prev_y = nil
  end

  def get_position
    return "#{@prev_x} #{@prev_y} #{@orientation} LOST" if !on_grid?
    return "#{@x} #{@y} #{@orientation}"
  end

  def on_grid?
    return @x <= @grid.x && @y <= @grid.y && @x >= 0 && @y >= 0
  end

  def get_orientation_index
    return @orientations.index(@orientation)
  end

  def rotate_orientations(direction)
    case direction
    when 'R'
      rotated = @orientations.rotate
    when 'L'
      rotated = @orientations.rotate(-1)
    else 
      rotated = @orientations
    end
    return rotated
  end

  def change_orientation(direction)  
    index = get_orientation_index
    rotated = rotate_orientations(direction)
    @orientation = rotated[index]
  end

  def change_coords(direction)
    change = @movements[@orientation]
    if direction == 'F'
      @x += change[0]
      @y += change[1]  
    end
  end

  def store_previous_coords
    @prev_x = @x
    @prev_y = @y
  end

  def reinstate_previous_coords
    @x = @prev_x
    @y = @prev_y 
  end

  def add_warning_scent(x, y)
    @grid.dimensions[x][y] = "x"
  end

  def move_with_no_warning_scent(instruction)
    change_coords(instruction)
    if !on_grid? 
      add_warning_scent(@prev_x, @prev_y)
      return false
    end
    return true
  end

  def move_with_warning_scent(instruction)
    change_coords(instruction)
    if !on_grid?
      reinstate_previous_coords 
    end
  end

  def move(instruction)
    store_previous_coords
    if !@grid.has_warning_scent?(@x, @y)
      return move_with_no_warning_scent(instruction)  
    else 
      move_with_warning_scent(instruction)  
      return true
    end
  end

  def carry_out_instructions(input)
    instructions = input.split('')
    for instruction in instructions do
      if instruction == 'F'
        return if !move(instruction)
      else 
        change_orientation(instruction)
      end
    end
  end

end