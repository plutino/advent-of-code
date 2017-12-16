def parse_data(file)
  data = []
  File.open(file).readline.strip.split(',').map do |token|
    move = {
      action: token.chars.first
    }
    token = token[1..-1]
    case (move[:action])
    when 's'
      move[:count] = token.to_i
    when 'x'
      move[:pos] = token.split('/').map(&:to_i)
    when 'p'
      move[:partners] = token.split('/')
    end
    data << move
  end
  data
end

def dance(moves, start_line)
  line = start_line
  moves.each do |move|
    case move[:action]
    when 's'
      line = line[-move[:count]..-1] + line[0..(line.size - 1 - move[:count])]
    when 'x'
      line[move[:pos].first], line[move[:pos].last] = line[move[:pos].last], line[move[:pos].first]
    when 'p'
      ia = line.index(move[:partners].first)
      ib = line.index(move[:partners].last)
      line[ia], line[ib] = line[ib], line[ia]
    end
  end
  line
end

def find_loop(moves, start_line)
  line_cache = []
  line = start_line

  until line_cache.include?(line)
    line_cache << line
    line = dance(moves, line)
  end

  start = line_cache.index(line)
  [start, line_cache.size - start, line]
end

def p1(moves, size)
  line = ('a'..(('a'.ord + size - 1).chr)).to_a.join
  dance(moves, line)
end

def p2(moves, size)
  start_line = ('a'..(('a'.ord + size - 1).chr)).to_a.join
  start, period, line = find_loop(moves, start_line)
  ((1_000_000_000 - start) % period).times { line = dance(moves, line) }
  line
end
