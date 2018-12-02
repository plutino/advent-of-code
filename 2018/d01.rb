# https://adventofcode.com/2018/day/1

require 'set'

def p1(data)
  data.inject(0, :+)
end

def p2(data)
  current_freq = 0
  freq_set = Set.new [0]
  while true
    data.each do |jump|
      current_freq += jump
      return current_freq if freq_set.include?(current_freq)
      freq_set << current_freq
    end
  end
end
