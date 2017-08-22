require('minitest/autorun')
require('minitest/rg')
require_relative('../grid')
require_relative('../robot')

class TestGrid < MiniTest::Test

  def setup
    @grid = Grid.new(5, 3)
    @robot = Robot.new('1 1 E', @grid)
  end

  def test_initialise_grid_x
    assert_equal(6, @grid.dimensions.size)
  end

  def test_initialise_grid_y
    assert_equal(4, @grid.dimensions[4].size)
  end

  def test_warning_scent_false
    assert_equal(false, @grid.has_warning_scent?(1, 1))
  end

  def test_warning_scent_true
    @grid.dimensions[1][1] = 'x'
    assert_equal(true, @grid.has_warning_scent?(1, 1))
  end

end