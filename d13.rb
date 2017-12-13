def parse_data(file)
  File.open(file).each_line.map { |ln| ln.strip.split(':').map(&:to_i) }
end

def severity(data)
  data.inject(0) do |s, d|
    d[0] % (2 * (d[1] - 1)) == 0 ? s + d[0] * d[1] : s
  end
end

def p1(data)
  severity(data)
end

def safe?(data, delay)
  !data.any? { |d| (d[0] + delay) % (2 * (d[1] - 1)) == 0 }
end

def p2(data)
  delay = 0
  delay += 1 until safe?(data, delay)
  delay
end
