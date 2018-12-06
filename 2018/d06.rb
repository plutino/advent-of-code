#https://adventofcode.com/2018/day/6

require 'set'

class Point
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def serialized
    1000000 * x + y
  end

  def distance_to(p2)
    (x - p2.x).abs + (y - p2.y).abs
  end

  def before
    Point.new(x-1, y)
  end

  def after
    Point.new(x+1, y)
  end

  def above
    Point.new(x, y-1)
  end

  def below
    Point.new(x, y+1)
  end
end

class Ground
  attr_reader :coordinates

  def initialize(coordinates)
    @coordinates = coordinates
    @coordinates.each { |coord| coord.ground = self }

    @x_lo = coordinates.map(&:point).map(&:x).min
    @x_hi = coordinates.map(&:point).map(&:x).max
    @y_lo = coordinates.map(&:point).map(&:y).min
    @y_hi = coordinates.map(&:point).map(&:y).max

    @region = Set.new
  end

  def edge_point?(point)
    point.x == @x_lo || point.x == @x_hi || point.y == @y_lo || point.y == @y_hi
  end

  def edge_points
    Enumerator.new do |enu|
      (@x_lo .. @x_hi).each do |x|
        [@y_lo, @y_hi].each do |y|
          enu << Point.new(x, y)
        end
      end

      [@x_lo, @x_hi].each do |x|
        ((@y_lo + 1) .. (@y_hi - 1)).each do |y|
          enu << Point.new(x, y)
        end
      end
    end
  end

  def points
    Enumerator.new do |enu|
      (@x_lo .. @x_hi).each do |x|
        (@y_lo .. @y_hi).each do |y|
          enu << Point.new(x, y)
        end
      end
    end
  end

  def coord_for(point)
    min_distance = 10000000
    min_coord = nil
    doubled = false
    @coordinates.each do |coord|
      d = coord.point.distance_to(point)
      return coord if d == 0
      if (d < min_distance)
        min_distance = d
        min_coord = coord
        doubled = false
      elsif (d == min_distance)
        doubled = true
      end
    end
    doubled ? nil : min_coord
  end

  def region_within(max_distances)
    find_region(*starting_point(max_distances), max_distances, Set.new) if @region.empty?
    @region
  end

  private

  def distance_to_all(point)
    @coordinates.map{ |coord| coord.point.distance_to(point) }.inject(0, :+)
  end

  def starting_point(max_distances)
    points.each do |point|
      return point if (distance_to_all(point) < max_distances)
    end
  end

  def find_region(point, max_distances, searched)
    return if searched.include?(point.serialized)
    if distance_to_all(point) < max_distances
      @region << point
      searched << point.serialized
      find_region(point.before, max_distances, searched)
      find_region(point.after, max_distances, searched)
      find_region(point.above, max_distances, searched)
      find_region(point.below, max_distances, searched)
    end
  end
end

class Coordinate
  attr_reader :point

  def initialize(point)
    @point = point
    @area = 0
  end

  def ground=(ground)
    @ground = ground.dup
  end

  def mark_infinity
    @area = -1
  end

  def area
    find_area(@point, Set.new) if @area == 0
    @area
  end

  private

  def find_area(point, searched)
    return if searched.include?(point.serialized)
    return if @ground.edge_point?(point)

    if @ground.coord_for(point) == self
      @area += 1
      searched << point.serialized
      find_area(point.before, searched)
      find_area(point.after, searched)
      find_area(point.above, searched)
      find_area(point.below, searched)
    end
  end
end

def parse_data(lines)
  coords = lines.map { |ln| Coordinate.new(Point.new(*(ln.split(',').map(&:to_i)))) }
  Ground.new(coords)
end

def p1 ground
  # if area of a coordinate reaches one edge, it's infinite, finding these first
  ground.edge_points.each do |point|
    coord = ground.coord_for(point)
    coord.mark_infinity if coord
  end

  ground.coordinates.map(&:area).max
end

def p2 ground, max_distances
  ground.region_within(max_distances).size
end
