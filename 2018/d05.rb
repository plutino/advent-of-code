# https://adventofcode.com/2018/day/5

def p1 input
  result = []
  input.each_char do |ch|
    if result.empty?
      result << ch
    elsif (ch.ord - result.last.ord).abs == 32
      result.pop
    else
      result << ch
    end
  end
  result.size
end

def p2 input
  ('a'..'z').map { |ch| p1 input.tr(ch, '').tr((ch.ord - 32).chr, '') }.min
end
