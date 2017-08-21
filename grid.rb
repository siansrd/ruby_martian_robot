class Grid

  attr_reader :x, :y, :dimensions

  def initialize(x, y)
    @x = x
    @y = y
    @dimensions = Array.new(x){Array.new(y)}
  end

  def has_warning_scent?(x, y)
    return @dimensions[x][y] == 'x'
  end

end