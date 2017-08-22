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

  def test_change_orientation__left_east_to_north
    @robot.change_orientation('L')
    assert_equal('1 1 N', @robot.get_position)
  end

  def test_change_orientation__right_east_to_south
    @robot.change_orientation('R')
    assert_equal('1 1 S', @robot.get_position)
  end

  def test_move_forwards__east
    @robot.change_coords('F')
    assert_equal('2 1 E', @robot.get_position)
  end

  def test_turn_and_move__right_east_to_south
    @robot.change_orientation('R')
    @robot.change_coords('F')
    assert_equal('1 0 S', @robot.get_position)
  end

  def test_carry_out_instructions
    @robot.carry_out_instructions('RF')
    assert_equal('1 0 S', @robot.get_position)
  end

  def test_carry_out_instructions__full_circle
    @robot.carry_out_instructions('RFRFRFRF')
    assert_equal('1 1 E', @robot.get_position)
  end

  def test_check_on_grid__false
    @robot.carry_out_instructions('RFF')
    assert_equal(false, @robot.on_grid?)
  end

  def test_check_on_grid__true
    assert_equal(true, @robot.on_grid?)
  end

  def test_position_lost_if_moves_off_grid__negative
    @robot.carry_out_instructions('RFF')
    assert_equal('1 0 S LOST', @robot.get_position)
  end

  def test_position_lost_if_moves_off_grid__positive
    @robot.carry_out_instructions('FFFFF')
    assert_equal('5 1 E LOST', @robot.get_position)
  end

  def test_position_lost_if_moves_off_grid__by_multiple_positions
    @robot.carry_out_instructions('FFFFFFFF')
    assert_equal('5 1 E LOST', @robot.get_position)
  end

  def test_add_warning_scent_to_grid
    @robot.add_warning_scent(4, 1)
    assert_equal("x", @grid.dimensions[4][1])
  end

  def test_add_warning_scent_to_grid__when_moved_off_grid_x
    @robot.carry_out_instructions('FFFFF')
    assert_equal('x', @grid.dimensions[5][1])
  end

  def test_add_warning_scent_to_grid__when_moved_off_grid_y
    @robot.carry_out_instructions('RFFF')
    assert_equal('x', @grid.dimensions[1][0])
  end

  def test_add_warning_scent_to_grid__when_moved_off_grid_by_multiple_positions
    @robot.carry_out_instructions('FFFFFFFF')
    assert_equal('x', @grid.dimensions[5][1])
  end

  def test_not_move_off_grid_if_warning_scent
    @robot.carry_out_instructions('RFF')
    @robot_2.carry_out_instructions('RFF')
    assert_equal( '1 0 S', @robot_2.get_position)
  end

  def test_not_move_off_grid_if_warning_scent_2
    @robot_3.carry_out_instructions('FRRFLLFFRRFLL')
    @robot_4.carry_out_instructions('LLFFFLFLFL')
    assert_equal('3 3 N LOST', @robot_3.get_position)
    assert_equal('2 3 S', @robot_4.get_position)
  end


end