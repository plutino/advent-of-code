# https://adventofcode.com/2018/day/11

class Grid
  def initialize serial_no
    @cells = Array.new(300*300)
    calc_power(serial_no)
  end

  def max_3x3_panel
    max_score = -81
    max_index = []
    (1..298).each do |y|
      (1..298).each do |x|
        score = score_at(x, y)
        if (score > max_score)
          max_score = score
          max_index = [x, y]
        end
      end
    end
    max_index
  end

  def max_panel
    grid_cache = @cells.dup
    row_cache = @cells.dup
    col_cache = @cells.dup
    max_score = 9
    max_index = []
    (2..300).each do |sz|
      (1..(301 - sz)).each do |y|
        (1..(301 - sz)).each do |x|
          row_cache[serialize(x, y + sz - 1)] += @cells[serialize(x + sz - 1, y + sz - 1)]
          col_cache[serialize(x + sz - 1, y)] += @cells[serialize(x + sz - 1, y + sz - 2)] if sz > 2
          grid_cache[serialize(x, y)] += (
            row_cache[serialize(x, y + sz - 1)] + col_cache[serialize(x + sz - 1, y)]
          )
          score = grid_cache[serialize(x, y)]
          if (score > max_score)
            max_score = score
            max_index = [x, y, sz]
          end
        end
      end
    end
    max_index
  end

  private

  def calc_power(serial_no)
    (1..300).each do |y|
      (1..300).each do |x|
        @cells[serialize(x, y)] = power_for(x, y, serial_no)
      end
    end
  end

  def score_at(x, y)
    sum((y...(y + 3)).map { |sy| sum(@cells[serialize(x, sy), 3]) })
  end
end

def power_for(x, y, serial_no)
  id = 10 + x
  pre = id * ((id * y + serial_no))
  ((pre % 1000) / 100).to_i - 5
end

def sum(list)
  list.inject(0, :+)
end

def serialize(x, y)
  (y - 1) * 300 + x - 1
end

def p1(serial_no)
  Grid.new(serial_no).max_3x3_panel
end

def p2(serial_no)
  Grid.new(serial_no).max_panel
end

# Input: 4455
