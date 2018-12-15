# https://adventofcode.com/2018/day/12

class Rules
  def initialize
    @patterns = {}
  end

  def add(pattern, result)
    @patterns[pattern] = result
  end

  def apply(pattern)
    @patterns[pattern] || '.'
  end
end


class Formation
  def initialize(initial_state, rules)
    @line = initial_state
    @rules = rules
  end

  def evolve(generation)
    line = @line.dup
    convergence_gen = 0
    offset = pad(line)
    generation.times do |gen|
      next_line = '..'
      (0..(line.size - 5)).each do |idx|
        next_line << @rules.apply(line[idx, 5])
      end
      offset += pad(next_line)
      break if line == next_line
      line = next_line
      convergence_gen = gen
    end

    pot_count = 0
    total_count = 0

    line.chars.each_with_index do |pot, idx|
      if pot == '#'
        pot_count += 1
        total_count += idx - offset
      end
    end

    if convergence_gen < generation - 2
      total_count += pot_count * (generation - convergence_gen - 2)
    end
    total_count
  end

  private

  # make sure that beginning and ending have 4 dots and return how many char are padded
  # at the beginning
  def pad(line)
    idx = line.rindex('#')
    if line.size - idx < 5
      line << '.' * (5 + idx - line.size)
    end
    idx = line.index('#')
    if idx < 4
      line.prepend '.' * (4 - idx)
    else
      line[0, idx - 4] = ''
    end
    4 - idx
  end
end

def parse_data(file)
  rules = Rules.new
  initial_state = ''
  File.open(file, 'r') do |f|
    initial_state = f.readline.chomp
    f.each_line { |ln| rules.add(*(ln.chomp.split(' => '))) }
  end
  Formation.new(initial_state, rules)
end

def p1(file)
  formation = parse_data(file)
  formation.evolve 20
end

def p2(file)
  formation = parse_data(file)
  formation.evolve 50_000_000_000
end
