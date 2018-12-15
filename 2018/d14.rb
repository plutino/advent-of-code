# https://adventofcode.com/2018/day/14

class ScoreBoard
  def initialize(first, second)
    @scores = [first, second]
    @elves = [0, 1]
  end

  def ten_after(total)
    create while @scores.size < total + 10
    @scores[total, 10].reduce('') { |sum, score| sum << score.to_s }
  end

  def count_before(sum)
    length = sum.size
    create while @scores.size < length
    current_sum = @scores[0, length].reduce(0) { |sum, score| sum * 10 + score }
    cur = length

    sum_i = sum.to_i
    mod = 10 ** (length - 1)

    loop do
      while current_sum != sum_i && cur < @scores.size
        current_sum %= mod
        current_sum = current_sum * 10 + @scores[cur]
        cur += 1
      end
      break if current_sum == sum_i
      create
    end
    cur - length
  end

  private

  def create
    sum = @scores[@elves.first] + @scores[@elves.last]
    if sum < 10
      @scores << sum
    else
      sum.divmod(10).each { |s| @scores << s }
    end
    move(0, @scores[@elves.first] + 1)
    move(1, @scores[@elves.last] + 1)
  end

  def move(elf, steps)
    tentative = @elves[elf] + steps
    tentative -= @scores.size while tentative >= @scores.size
    @elves[elf] = tentative
  end
end

def p1(input)
  ScoreBoard.new(3, 7).ten_after(input)
end

def p2(input)
  ScoreBoard.new(3, 7).count_before(input)
end


# Input: 290431
