def p1(hops)
  hops += 1
  pool = [0]
  cur = 0
  2017.times do |num|
    hops.times { cur = pool[cur] }
    cur_next = pool[cur]
    pool[cur] = num + 1
    pool << cur_next
  end
  pool[2017]
end

def p2(hops)
  hops += 1
  pool = [0]

  cur = 0
  50_000_000.times do |num|
    hops.times { cur = pool[cur] }
    cur_next = pool[cur]
    pool[cur] = num + 1
    pool << cur_next
  end
  pool[0]
end
