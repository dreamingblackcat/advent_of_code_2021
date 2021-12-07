Point = Struct.new(:x, :y) do
  def <=>(point2)
    x_comparison = x <=> point2.x

    if x_comparison.zero?
      y <=> point2.y
    else
      x_comparison
    end
  end
end

class PointRange
  def initialize(point1, point2)
    @point1, @point2 = normalize_points([point1, point2])
  end

  def points
    if vertical_line?
      ((@point1.y)..(@point2.y)).map do |y|
        Point.new(@point1.x, y)
      end
    elsif horizontal_line?
      ((@point1.x)..(@point2.x)).map do |x|
        Point.new(x, @point1.y)
      end
    else
      x1 = @point1.x
      x2 = @point2.x
      y1 = @point1.y
      y2 = @point2.y
      points = []
      if lower_diagonal?
        while x1 <= x2 && y1 <= y2 do
          points << Point.new(x1, y1)
          x1 += 1
          y1 += 1
        end
      else
        while x1 <= x2 && y1 >= y2 do
          points << Point.new(x1, y1)
          x1 += 1
          y1 -= 1
        end
      end
      points
    end
  end

  private

  def vertical_line?
    @point1.x == @point2.x
  end

  def horizontal_line?
    @point1.y == @point2.y
  end

  def diagonal_line?
    !vertical_line? && !horizontal_line?
  end

  def lower_diagonal?
    @point1.y < @point2.y
  end

  def upper_diagonal?
    @point1.y > @point2.y
  end

  def normalize_points(points)
    points.sort
  end
end


class ThermalVentDetector
  def initialize
    @hash = {}
  end

  def add_thermal_vent(point_range)
    point_range.points.each do |point|
      current_count = @hash.fetch(point, 0)
      @hash[point] = current_count + 1
    end
  end

  def marked_points
    @hash.keys
  end

  def dangerous_points
    @hash.select {|point, count| count > 1 }.keys
  end
end

class ThermalVentReport
  attr_reader :point_ranges

  def initialize(file_name)
    @report = File.readlines(file_name, chomp: true)
    @thermal_vent_detector = ThermalVentDetector.new
    @point_ranges = @report.map do |point_range_string|
      # point_range_string is of the format '0,5 -> 0,9'
      point_a, point_b = point_range_string.split(' -> ')
      point_range = PointRange.new(
        Point.new(*point_a.split(',').map(&:to_i)),
        Point.new(*point_b.split(',').map(&:to_i)),
      )
      @thermal_vent_detector.add_thermal_vent(point_range)
    end
  end

  def dangerous_points
    @thermal_vent_detector.dangerous_points
  end
end


if __FILE__ == $PROGRAM_NAME
  report = ThermalVentReport.new('./hyrdro_thermal_vents_input.txt')

  puts "Hydro Thermal Vent Report: dangerous points count is #{report.dangerous_points.length}"
end
