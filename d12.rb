require 'set'

def parse_data(file)
  data = {}
  File.open(file).each_line do |ln|
    key, childrens = ln.strip.split('<->')
    kids = childrens.split(',').map(&:to_i)
    data[key.to_i] = kids
  end
  data
end

def purge_group(root, map)
  map.delete(root).each do |child|
    purge_group(child, map) unless map[child].nil?
  end
end

def p1(data)
  original_count = data.count
  purge_group(0, data)
  original_count - data.count
end

def p2(data)
  group_ct = 0
  while !data.empty?
    purge_group(data.keys.first, data)
    group_ct += 1
  end
  group_ct
end
