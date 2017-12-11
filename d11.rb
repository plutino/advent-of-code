def parse_data(file)
  File.open(file) { |f| f.read.strip.split(',') }
end

# cancel opposite moves
def cancel(hist, dir1, dir2)
  return if hist[dir1].zero? || hist[dir2].zero?
  cancelled_ct = [hist[dir1], hist[dir2]].min
  hist[dir1] -= cancelled_ct
  hist[dir2] -= cancelled_ct
end

# convert 2 moves to a single one
def convert(hist, dir1, dir2, dir)
  return if hist[dir1].zero? || hist[dir2].zero?
  convert_ct = [hist[dir1], hist[dir2]].min
  hist[dir] += convert_ct
  hist[dir1] -= convert_ct
  hist[dir2] -= convert_ct
end

# reduce all moves to along one or two directions
def reduce(hist)
  # The convert and cancel order matters!
  convert(hist, 'se', 'sw', 's')
  convert(hist, 'ne', 'nw', 'n')
  cancel(hist, 'ne', 'sw')
  cancel(hist, 'nw', 'se')
  cancel(hist, 'n', 's')

  convert(hist, 'ne', 's', 'se')
  convert(hist, 'nw', 's', 'sw')
  convert(hist, 'se', 'n', 'ne')
  convert(hist, 'sw', 'n', 'nw')

  hist.values.reduce(:+)
end

def p1(data)
  hist = Hash.new(0)
  data.each { |d| hist[d] += 1 }
  reduce(hist)
end

def p2(data)
  hist = Hash.new(0)
  max_dist = 0

  data.each do |d|
    hist[d] += 1
    dist = reduce(hist)
    max_dist = dist if dist > max_dist
  end
  max_dist
end

# Here is an improved version using a cache and doing less reducing
def p2a(data)
  hist = Hash.new(0)
  max_dist = 0
  last_dist = 0

  data.each do |d|
    hist[d] += 1
    dist = if hist[d] == 1
             reduce(hist)
           else
             last_dist + 1
           end
    max_dist = dist if dist > max_dist
    last_dist = dist
  end
  max_dist
end
