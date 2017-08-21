require('minitest/autorun')
require('minitest/rg')
require_relative('../robot')
require_relative('../grid')


class TestRobot < MiniTest::Test


  def setup
    @grid = Grid.new(5, 3)
    @robot = Robot.new('1 1 E', @grid)
    @robot_2 = Robot.new('1 1 E', @grid)
  end

  def test_return_starting_position
    assert_equal('1 1 E', @robot.get_position)
  end

  def test_get_orientation_index
    assert_equal(1, @robot.get_orientation_index)
  end

  def test_change_orientation_left_E_to_N
    @robot.change_orientation('L')
    assert_equal('1 1 N', @robot.get_position)
  end

  def test_change_orientation_right_E_to_S
    @robot.change_orientation('R')
    assert_equal('1 1 S', @robot.get_position)
  end

  def test_move_forwards_east
    @robot.change_coords
    assert_equal('2 1 E', @robot.get_position)
  end

  def test_turn_and_move_forwards_south
    @robot.change_orientation('R')
    @robot.change_coords
    assert_equal('1 0 S', @robot.get_position)
  end

  def test_take_multiple_instructions
    @robot.move('RF')
    assert_equal('1 0 S', @robot.get_position)
  end

  def test_take_multiple_instructions_full_circle
    @robot.move('RFRFRFRF')
    assert_equal('1 1 E', @robot.get_position)
  end

  def test_on_grid_false
    @robot.move('RFF')
    assert_equal(false, @robot.on_grid?)
  end

  def test_on_grid_true
    assert_equal(true, @robot.on_grid?)
  end

  def test_position_lost_if_moves_off_grid_negative
    @robot.move('RFF')
    assert_equal('LOST', @robot.get_position)
  end

  def test_position_lost_if_moves_off_grid_positive
    @robot.move('FFFF')
    assert_equal('LOST', @robot.get_position)
  end

  def test_position_lost_if_moves_off_grid_by_multiple_positions
    @robot.move('FFFFFFFF')
    assert_equal('LOST', @robot.get_position)
  end

  def test_add_warning_scent_to_grid
    @robot.add_warning_scent(4, 1)
    assert_equal("x", @grid.dimensions[4][1])
  end

  def test_add_warning_scent_when_moved_off_grid_x
    @robot.move('FFFFF')
    assert_equal('x', @grid.dimensions[4][1])
  end

  def test_add_warning_scent_when_moved_off_grid_x
    @robot.move('FFFFF')
    assert_equal('x', @grid.dimensions[4][1])
  end

  def test_add_warning_scent_when_moved_off_grid_y
    @robot.move('RFFF')
    assert_equal('x', @grid.dimensions[1][0])
  end

  def test_add_warning_scent_if_moves_off_grid_by_multiple_positions
    @robot.move('FFFFFFFF')
    assert_equal('x', @grid.dimensions[4][1])
  end

  def test_not_move_off_grid_if_warning_scent
    @robot.move('RFF')
    @robot_2.move('RFF')
    assert_equal( '1 0 S', @robot_2.get_position)
  end


end