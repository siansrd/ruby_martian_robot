class Robot 

  def initialize(start_position, grid)
    position = start_position.split(" ")
    @x = position[0].to_i
    @y = position[1].to_i
    @orientation = position[2]
    @prev_x = nil
    @prev_y = nil
    @movements = {
      'N' => ['y', 1],
      'E' => ['x', 1],
      'S' => ['y', -1],
      'W' => ['x', -1]   
    }
    @orientations = ['N', 'E', 'S', 'W'] 
    @grid = grid 
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
      if change[0] == 'x'
        @x += change[1]
      else
        @y += change[1]
      end
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

  def move(instruction)
    store_previous_coords
    if !@grid.has_warning_scent?(@x, @y)
      change_coords(instruction)
      if !on_grid? 
        add_warning_scent(@prev_x, @prev_y)
        return false
      end
      return true
    else 
        change_coords(instruction)
        if !on_grid?
          reinstate_previous_coords 
        end
        return true
    end
  end

  def move_or_orientate(input)
    instructions = input.split("")
    for instruction in instructions do
      if instruction == 'F'
        return if !move(instruction)
      else 
        change_orientation(instruction)
      end
    end
  end

  def add_warning_scent(x, y)
    @grid.dimensions[x][y] = "x"
  end

end