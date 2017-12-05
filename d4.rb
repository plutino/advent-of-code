def convert(str)
  str.split("\n").map { |r| r.strip.split(/\s+/) }
end

def p1(dict_str)
  convert(dict_str).select { |p| p.uniq == p }.count
end

def p2(dict_str)
  convert(dict_str).select do |p|
    sorted = p.map { |w| w.chars.sort.join }
    sorted.uniq == sorted
  end.count
end
