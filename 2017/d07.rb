def parse_data(file)
  res = {}
  File.open(file, 'r') do |f|
    while (line = f.gets) do
      tokens = line.split('->')
      key, weight = tokens.first.split('(').map(&:strip)
      children = tokens[1]&.split(',')&.map(&:strip) || []
      res[key] = {
        weight: weight.to_i,
        children: children,
      }
    end
    res
  end
end

def p1(data)
  (data.keys - data.map { |k, v| v[:children] }.flatten.uniq).first
end

def weight(root, data)
  return data[root][:weight] if data[root][:children].empty?
  child_weights = data[root][:children].map { |child| weight(child, data) }
  unless child_weights.uniq.size == 1
    puts "#{root} - #{data[root]}"
    data[root][:children].each_with_index do |ch, idx|
      puts "#{ch}(#{data[ch][:weight]}) -- #{child_weights[idx]}"
    end
  end
  child_weights.inject(0){|s, w| s+w} + data[root][:weight]
end

def p2(data)
  weight(p1(data), data)
end
