def convert(str)
  str.scan(/\d/).map(&:to_i)
end

def p1(list_str)
  convert(list_str).each_with_index.inject(0) do |s, (v, idx)|
    v == list[idx + 1 == list.size ? 0 : idx + 1] ? s + v : s
  end
end

def p2(list_str)
  convert(list_str).each_with_index.inject(0) do |s, (v, idx)|
    v == list[(idx + list.size / 2) % list.size] ? s + v : s
  end
end
