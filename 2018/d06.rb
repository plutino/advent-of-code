require 'set'

def distance(x1, y1, x2, y2)
  (x1 - x2).abs + (y1 - y2).abs
end

def serialize(x, y)
  1000000 * x + y
end

class Ground
  attr_reader :coordinates, :range

  def initialize(coordinates)
    @coordinates = coordinates
    @range = {
      x_lo: coordinates.map(&:x).min,
      x_hi: coordinates.map(&:x).max,
      y_lo: coordinates.map(&:y).min,
      y_hi: coordinates.map(&:y).max,
    }
    @region = Set.new
  end

  def coord_for(x, y)
    min_distance = 10000000
    min_coord = nil
    doubled = false
    @coordinates.each do |coord|
      d = distance(x, y, coord.x, coord.y)
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

  def distance_to_all(x, y)
    @coordinates.map{|coord| distance(x, y, coord.x, coord.y)}.inject(0, :+)
  end

  def starting_point(max_distances)
      (@range[:x_lo]..@range[:x_hi]).each do |x|
        (@range[:y_lo]..@range[:y_hi]).each do |y|
          return [x, y] if (distance_to_all(x, y) < max_distances)
        end
      end
  end

  def find_region(x, y, max_distances, searched)
    return if searched.include?(serialize(x, y))
    if distance_to_all(x, y) < limit
      @region << [x, y]
      searched << serialize(x, y)
      find_region(x-1, y, max_distances, searched)
      find_region(x+1, y, max_distances, searched)
      find_region(x, y-1, max_distances, searched)
      find_region(x, y+1, max_distances, searched)
    end
  end
end

class Coordinate
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
    @area = 0
  end

  def ground=(ground)
    @ground = ground.dup
  end

  def mark_infinity
    @area = -1
  end

  def area
    find_area(x, y, Set.new) if @area == 0
    @area
  end

  private

  def find_area(x, y, searched)
    return if searched.include?(serialize(x, y))
    return if x == @ground.range[:x_lo] || x == @ground.range[:x_hi]
    return if y == @ground.range[:y_lo] || y == @ground.range[:y_hi]

    if @ground.coord_for(x, y) == self
      @area += 1
      searched << serialize(x, y)
      find_area(x-1, y, searched)
      find_area(x+1, y, searched)
      find_area(x, y-1, searched)
      find_area(x, y+1, searched)
    end
  end
end

def parse_data(data)
  data.map {|d| Coordinate.new(d.first, d.last)}
end

def p1 coords
  ground = Ground.new(coords)
  coords.each {|coord| coord.ground = ground}

  # if area of a coordinate reaches one edge, it's infinite, removing them from the list
  (ground.range[:x_lo]..ground.range[:x_hi]).each do |x|
    [ground.range[:y_lo], ground.range[:y_hi]].each do |y|
      coord = ground.coord_for(x, y)
      coord.mark_infinity if coord
    end
  end

  [ground.range[:x_lo], ground.range[:x_hi]].each do |x|
    ((ground.range[:y_lo] + 1)..(ground.range[:y_hi] - 1)).each do |y|
      coord = ground.coord_for(x, y)
      coord.mark_infinity if coord
    end
  end

  coords.map(&:area).max
end

def p2 coords, max_distances
  ground = Ground.new(coords)
  ground.region_within(max_distances).size
end
