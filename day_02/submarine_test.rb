
require 'minitest/autorun'
require_relative './submarine_solution.rb'

describe Submarine do

  describe "forward command" do
    it 'updates increases the horizontal position' do
      sub = Submarine.new

      sub.process_command('forward', 2)

      assert_equal(2, sub.horizontal_position,
        "Should increase the horizontal_position by 2.")
    end

    it 'updates the depth by aim * forward unit' do
      sub = Submarine.new(aim: 3)

      sub.process_command('forward', 2)

      assert_equal(3 * 2, sub.depth,
        "Should increases depth to 6 (aim * forward units).")
    end

  end

  it 'decreases the aim when up command is given' do
    sub = Submarine.new

    sub.process_command('up', 2)

    assert_equal(-2, sub.aim,
      "Should decrease the aim by 2.")
  end

  it 'increases the aim when down command is given' do
    sub = Submarine.new

    sub.process_command('down', 2)

    assert_equal(2, sub.aim,
      "Should increase the aim by 2.")
  end

  it 'gives the position correctly' do
    sub = Submarine.new(depth: 2, horizontal_position: 2, aim: 3)

    assert_equal(4, sub.position,
      "Should give the multiplication of depth and horizonatal position.")
  end

end

###################################

describe SubCommander do
  it 'processes the commands and give the position correctly.' do
    commands = [
      'up 4',
      'forward 2',
      'down 3',
      'forward 3',
    ]
    final_position = SubCommander.process(commands)

    assert_equal(-55, final_position,
      "Should be set to 5 * -11 => -15")
  end
end
