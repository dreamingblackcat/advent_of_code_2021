require 'minitest/autorun'
require_relative './hydro_thermal_vents_solution.rb'

describe PointRange do
  it 'enumerates points on a given range (horizontal)' do
    point_range = PointRange.new(Point.new(5, 9), Point.new(0, 9))

    expected_points = [
      Point.new(0, 9),
      Point.new(1, 9),
      Point.new(2, 9),
      Point.new(3, 9),
      Point.new(4, 9),
      Point.new(5, 9),
    ]

    assert_equal(expected_points, point_range.points,
      "Should give correct points")
  end

  it 'enumerates points on a given range (vertical)' do
    point_range = PointRange.new(Point.new(7, 0), Point.new(7, 4))

    expected_points = [
      Point.new(7, 0),
      Point.new(7, 1),
      Point.new(7, 2),
      Point.new(7, 3),
      Point.new(7, 4),
    ]

    assert_equal(expected_points, point_range.points,
      "Should give correct points")
  end

  it 'enumerates points on a given range (upper diagonal)' do
    point_range = PointRange.new(Point.new(9, 7), Point.new(7, 9))

    expected_points = [
      Point.new(7, 9),
      Point.new(8, 8),
      Point.new(9, 7),
    ]

    assert_equal(expected_points, point_range.points,
      "Should give correct points")
  end

  it 'enumerates points on a given range (lower diagonal)' do
    point_range = PointRange.new(Point.new(5, 1), Point.new(7, 3))

    expected_points = [
      Point.new(5, 1),
      Point.new(6, 2),
      Point.new(7, 3),
    ]

    assert_equal(expected_points, point_range.points,
      "Should give correct points")
  end
end


describe 'ThermalVentDetector' do
  it 'can mark a point range.' do
    horizonal_line_vent = PointRange.new(Point.new(0,9), Point.new(5,9))
    detector = ThermalVentDetector.new
    detector.add_thermal_vent(horizonal_line_vent)

    assert_equal(6, detector.marked_points.length,
      "Should mark all 6 points")
  end

  it 'can differentiate overlapping points.' do
    horizonal_line_vent = PointRange.new(Point.new(0,9), Point.new(5,9))
    vertical_line_vent  = PointRange.new(Point.new(0,7), Point.new(0,9))
    detector = ThermalVentDetector.new
    detector.add_thermal_vent(horizonal_line_vent)
    detector.add_thermal_vent(vertical_line_vent)

    assert_equal(8, detector.marked_points.length,
      "Should only have 8 marked points neglecting an overlap.")
  end

  it 'can determine total number of dangerous points marked so far.' do
    horizonal_line_vent = PointRange.new(Point.new(0,9), Point.new(5,9))
    vertical_line_vent  = PointRange.new(Point.new(0,7), Point.new(0,9))
    another_overlapping_vent  = PointRange.new(Point.new(0,5), Point.new(0,9))

    detector = ThermalVentDetector.new
    detector.add_thermal_vent(horizonal_line_vent)
    detector.add_thermal_vent(vertical_line_vent)
    detector.add_thermal_vent(vertical_line_vent)

    assert_equal(3, detector.dangerous_points.length,
      "Should only have 3 dangerours points.")
  end
end

describe 'ThermalVentReport' do
  before do
    @input = File.readlines('./sample_test_input.txt', chomp: true)
  end

  it 'parses a given thermal vent report file correctly.' do
    report = ThermalVentReport.new('sample_test_input.txt')

    assert_equal(10, report.point_ranges.length,
      "Should have parsed 10 point ranges.")
  end

  it 'can find dangerous points' do
    report = ThermalVentReport.new('sample_test_input.txt')

    assert_equal(12, report.dangerous_points.length,
      "Should have detected 5 dangerous points.")
  end
end
