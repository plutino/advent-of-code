def convert(str)
  str.split("\n").map { |r| r.strip.split(/\s+/).map(&:to_i) }
end

def p1(sheet_str)
  convert(sheet_str).map { |r| r.max - r.min }.inject(0) { |s, v| s + v }
end

def p2(sheet_str)
  convert(sheet_str).map do |r|
    res = 0
    r.each_with_index do |v1, idx1|
      r.each_with_index do |v2, idx2|
        next if idx1 == idx2
        if v1 % v2 == 0
          res = v1 / v2
          break
        end
      end
      break unless res.zero?
    end
    res
  end.inject(0) { |s, v| s + v }
end
