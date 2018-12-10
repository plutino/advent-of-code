# https://adventofcode.com/2018/day/10

# This algorithm find the local minimum of the vertical spread of the points after it's
# smaller than a certain value: MAX_VERTICAL_SPREAD

MAX_VERTICAL_SPREAD = 20

class Point
  attr_reader :x, :y

  def initialize(x, y, vx, vy)
    @x = x
    @y = y
    @vx = vx
    @vy = vy
  end

  def advance
    @x += @vx
    @y += @vy
  end

  def step_back
    @x -= @vx
    @y -= @vy
  end
end

class Canvas
  def initialize points
    @points = points
    @timer = 0
  end

  def evolve
    spread = calc_spread
    previous_spread = spread + 1
    until spread < MAX_VERTICAL_SPREAD && spread > previous_spread
      advance
      previous_spread = spread
      spread = calc_spread
    end
    step_back
  end

  def show
    puts "Total time: #{@timer}"
    puts ""
    xrange = @points.map(&:x).minmax
    yrange = @points.map(&:y).minmax
    (yrange.first .. yrange.last).each do |y|
      (xrange.first .. xrange.last).each do |x|
        print(symbol_at(x, y))
      end
      print "\n"
    end
  end

  private

  def advance
    @points.each(&:advance)
    @timer += 1
  end

  def step_back
    @points.each(&:step_back)
    @timer -= 1
  end

  def calc_spread
    spread = @points.map(&:y).minmax
    spread.last - spread.first
  end

  def symbol_at(x, y)
    (@points.any? { |p| p.x == x && p.y == y }) ? '*' : ' '
  end
end


def parse_data file
  points = File.readlines(file).map do |ln|
    match = /< *([0-9-]+), *([0-9-]+)>.+< *([0-9-]+), *([0-9-]+)>/.match(ln)
    Point.new(*(match[1..-1].map(&:to_i)))
  end

  Canvas.new points
end

def p1(canvas)
  canvas.evolve
  canvas.show
end

alias p2 p1
