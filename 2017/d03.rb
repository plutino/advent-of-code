def p1a(n)
  # determine which rectangle the number is on, identified by the lenghth of the edge
  rect = 1
  rect += 2 while rect * rect <= n

  # next determine offset of the number in the rect from center point on the edge
  offset_in_edge = (n - (rect - 2) * (rect - 2) - 1) % (rect -1)
  offset_from_center = ((rect - 1) / 2 - 1) - offset_in_edge
  offset_from_center = - offset_from_center if offset_from_center < 0

  offset_from_center + (rect - 1) / 2
end

# p1b projects a 1-d index to a 2-d index, centered at 1 -> (0, 0)
# the projection method can then be used by p2
def project(n)
  return [0, 0] if n == 1
  # r is now the distance of the rectangle from center
  r = 0
  r += 1 while (2 * r + 1) * (2 * r + 1) < n

  # last 1-d index in previous rectangle
  idx_1 = (2 * r - 1) * (2 * r - 1)

  # edge index
  e = (n - idx_1 - 1) / (2 * r)

  # edge offset from center
  o = (n - idx_1 - 1) % (2 * r) - (r - 1)

  case e
  when 0
    [r, o]
  when 1
    [-o, r]
  when 2
    [-r, -o]
  when 3
    [o, -r]
  end
end

def p1b(n)
  x, y = project(n)
  x.abs + y.abs
end

def p2(n)
  # store values in a hash keyed by 2-d index
  values = {}

  current_value = 1
  idx = 1
  values[[0, 0]] = current_value

  while current_value < n do
    idx += 1
    x, y = project(idx)
    src_idx = [[x-1, y-1], [x, y-1], [x+1, y-1],
               [x-1, y], [x+1, y],
               [x-1, y+1], [x, y+1], [x+1, y+1]]
    current_value = src_idx.map { |i| values[i] || 0 }.inject(0) { |s, v| s+v }
    values[[x, y]] = current_value
  end
  current_value
end
