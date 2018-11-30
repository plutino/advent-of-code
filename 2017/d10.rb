def reverse_circular_subarray(array, from, length)
  (0..((length/2).to_i - 1)).each do |idx|
    idx1 = (from + idx) % array.size;
    idx2 = (from + length - 1 - idx) % array.size;
    array[idx1], array[idx2] = array[idx2], array[idx1]
  end
end

def p1(size, lengths)
  rope = (0..(size-1)).to_a
  cur = 0
  skip = 0

  lengths.each do |length|
    reverse_circular_subarray(rope, cur, length)
    cur += length + skip
    cur %= size
    skip += 1
  end
  rope[0] * rope[1]
end

def p2(input)
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
