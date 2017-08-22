require('minitest/autorun')
require('minitest/rg')
require_relative('../robot')
require_relative('../grid')


class TestRobot < MiniTest::Test


  def setup
    @grid = Grid.new(5, 3)
    @robot = Robot.new('1 1 E', @grid)
    @robot_2 = Robot.new('1 1 E', @grid)
    @robot_3 = Robot.new('3 2 N', @grid)
    @robot_4 = Robot.new('0 3 W', @grid)
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
    @robot.change_coords('F')
    assert_equal('2 1 E', @robot.get_position)
  end

  def test_turn_and_move_forwards_south
    @robot.change_orientation('R')
    @robot.change_coords('F')
    assert_equal('1 0 S', @robot.get_position)
  end

  def test_take_multiple_instructions
    @robot.move_or_orientate('RF')
    assert_equal('1 0 S', @robot.get_position)
  end

  def test_take_multiple_instructions_full_circle
    @robot.move_or_orientate('RFRFRFRF')
    assert_equal('1 1 E', @robot.get_position)
  end

  def test_on_grid_false
    @robot.move_or_orientate('RFF')
    assert_equal(false, @robot.on_grid?)
  end

  def test_on_grid_true
    assert_equal(true, @robot.on_grid?)
  end

  def test_position_lost_if_moves_off_grid_negative
    @robot.move_or_orientate('RFF')
    assert_equal('1 0 S LOST', @robot.get_position)
  end

  def test_position_lost_if_moves_off_grid_positive
    @robot.move_or_orientate('FFFFF')
    assert_equal('5 1 E LOST', @robot.get_position)
  end

  def test_position_lost_if_moves_off_grid_by_multiple_positions
    @robot.move_or_orientate('FFFFFFFF')
    assert_equal('5 1 E LOST', @robot.get_position)
  end

  def test_add_warning_scent_to_grid
    @robot.add_warning_scent(4, 1)
    assert_equal("x", @grid.dimensions[4][1])
  end

  def test_add_warning_scent_when_moved_off_grid_x
    @robot.move_or_orientate('FFFFF')
    assert_equal('x', @grid.dimensions[4][1])
  end

  def test_add_warning_scent_when_moved_off_grid_x
    @robot.move_or_orientate('FFFFF')
    assert_equal('x', @grid.dimensions[5][1])
  end

  def test_add_warning_scent_when_moved_off_grid_y
    @robot.move_or_orientate('RFFF')
    assert_equal('x', @grid.dimensions[1][0])
  end

  def test_add_warning_scent_if_moves_off_grid_by_multiple_positions
    @robot.move_or_orientate('FFFFFFFF')
    assert_equal('x', @grid.dimensions[5][1])
  end

  def test_not_move_off_grid_if_warning_scent
    @robot.move_or_orientate('RFF')
    @robot_2.move_or_orientate('RFF')
    assert_equal( '1 0 S', @robot_2.get_position)
  end

  def test_not_move_off_grid_if_warning_scent_2
    @robot_3.move_or_orientate('FRRFLLFFRRFLL')
    @robot_4.move_or_orientate('LLFFFLFLFL')
    assert_equal('3 3 N LOST', @robot_3.get_position)
    assert_equal('2 3 S', @robot_4.get_position)
  end


end