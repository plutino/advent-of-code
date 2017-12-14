def reverse_circular_subarray(array, from, length)
  (0..((length/2).to_i - 1)).each do |idx|
    idx1 = (from + idx) % array.size;
    idx2 = (from + length - 1 - idx) % array.size;
    array[idx1], array[idx2] = array[idx2], array[idx1]
  end
end

def knot_hash(input)
  rope = (0..255).to_a
  cur = 0
  skip = 0
  lengths = input.bytes.to_a + [17, 31, 73, 47, 23]

  64.times do
    lengths.each do |length|
      reverse_circular_subarray(rope, cur, length)
      cur += length + skip
      cur %= 256
      skip += 1
    end
  end

  final_str = ''
  (0..15).each do |idx|
    densed = rope[16 * idx .. 16 * idx + 15].reduce(:^)
    final_str << ("%02x" % densed)
  end
  final_str
end

def p1(key)
  (0..127).inject(0) do |sum, idx|
    sum + knot_hash("#{key}-#{idx}").hex.to_s(2).count('1')
  end
end

def build_map(key)
  (0..127).inject([]) do |data, idx|
    data << knot_hash("#{key}-#{idx}").hex.to_s(2).rjust(128, '0').chars.map { |d| d == '1' }
  end
end

def purge_group(row, col, map)
  return unless row >= 0 && col >= 0 && row < 128 && col < 128 && map[row][col];
  map[row][col] = false
  purge_group(row, col + 1, map)
  purge_group(row, col - 1, map)
  purge_group(row + 1, col, map)
  purge_group(row - 1, col, map)
end

def p2(key)
  map = build_map(key)

  group_ct = 0
  (0..127).each do |row|
    (0..127).each do |col|
      next unless map[row][col]
      purge_group(row, col, map)
      group_ct += 1
    end
  end
  group_ct
end
