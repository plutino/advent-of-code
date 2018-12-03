# https://adventofcode.com/2018/day/2

def p1(data)
  counts = data.map { |str| str.chars.group_by(&:itself).map { |k, v| v.size } }
  two_counts = counts.select{ |ct| ct.include?(2) }.size
  three_counts = counts.select{ |ct| ct.include?(3) }.size
  two_counts * three_counts
end

def p2(data)
  chared_data = data.map { |str| str.chars }

  chared_data.each_with_index do |d1, idx|
    chared_data[(idx + 1) .. -1].each do |d2|
      zipped = d1.zip(d2)
      unmatched_count = zipped.select{ |e| e.first != e.last }.count
      if unmatched_count == 1
        return zipped.select{ |e| e.first == e.last }.map(&:first).join('')
      end
    end
  end
end
