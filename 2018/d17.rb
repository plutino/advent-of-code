
class Location
  include Comparable

  class << self
    attr_reader :pool

    def at(x_or_loc, y = nil)
      loc = y.nil? ? x_or_loc : 10_000 * y + x_or_loc
      @pool ||= {}
      @pool[loc] ||= Location.new(loc)
    end
  end

  attr :loc

  def initialize(loc)
    @loc = loc
  end

  def x
    @loc % 10_000
  end

  def y
    @loc / 10_000
  end

  def hash
    @loc.hash
  end

  def <=> (other)
    @loc <=> other.loc
  end

  def inspect
    @loc
  end

  def to_s
    "(#{x}, #{y})"
  end

  def above
    Location.at(@loc - 10_000)
  end

  def bellow
    Location.at(@loc + 10_000)
  end

  def left
    Location.at(@loc - 1)
  end

  def right
    Location.at(@loc + 1)
  end
end

class Solver
  def initialize(clays)
    @clays = clays
    @bottom = clays.max.y
    @reached = Set.new
    @filled = Set.new
  end

  def solve
    drip(Location.at(500, 1))
    (@reached + @filled).count
  end

  def drip(loc0)
    loc = loc0
    until @clays.include?(loc) || @filled.include?(loc)
      @reached << loc
      return if loc.y == @bottom
      loc = loc.bellow
    end

    leaked = false
    while loc != loc0
      loc = loc.above
      layer = [loc]
      loc_h = loc.left
      while !@clays.include?(loc_h) &&
        (@clays.include?(loc_h.bellow) || @filled.include?(loc_h.bellow))
        @reached << loc_h
        layer << loc_h
        loc_h = loc_h.left
        if !@clays.include?(loc_h.bellow) && !@filled.include?(loc_h.bellow)
          @reached << loc_h
          drip(loc_h)
        end
      end

      leaked = true if !@clays.include?(loc_h)

      loc_h = loc.right
      while !@clays.include?(loc_h) &&
        (@clays.include?(loc_h.bellow) || @filled.include?(loc_h.bellow))
        @reached << loc_h
        layer << loc_h
        loc_h = loc_h.right
        if !@clays.include?(loc_h.bellow) && !@filled.include?(loc_h.bellow)
          @reached << loc_h
          drip(loc_h)
        end
      end

      leaked = true if !@clays.include?(loc_h)

      return if leaked
      layer.each { |l| @filled << l }
    end
  end
end

def parse_data(file)
  clays = Set.new
  File.readlines(file).each do |ln|
    data = {}
    ln.chomp.split(', ').each do |tk|
      fds = tk.split('=')
      dim = fds.first
      vals = fds.last.split('..').map(&:to_i)
      data[dim] = vals
    end
    if data['x'].size == 1
      (data['y'].first .. data['y'].last).each { |y| clays << Location.at(data['x'].first, y) }
    else
      (data['x'].first .. data['x'].last).each { |x| clays << Location.at(x, data['y'].first) }
    end
  end
  clays
end
