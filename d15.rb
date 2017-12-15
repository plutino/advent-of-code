def next_num(current, factor)
  (current * factor) % 0x7fffffff
end

def next_num2(current, factor, mod)
  next_n = next_num(current, factor)
  next_n = next_num(next_n, factor) while next_n % mod != 0
  next_n
end

def p1(gen_a, gen_b)
  40_000_000.times.inject(0) do |s, _|
    gen_a = next_num(gen_a, 16807)
    gen_b = next_num(gen_b, 48271)
    (gen_a & 0xffff) == (gen_b & 0xffff) ? s + 1 : s
  end
end

# performance improvement (no function calls)
def p1p(gen_a, gen_b)
  match_ct = 0
  40_000_000.times do
    gen_a = gen_a * 16807 % 0x7fffffff
    gen_b = gen_b * 48271 % 0x7fffffff

    match_ct += 1 if (gen_a & 0xffff) == (gen_b & 0xffff)
  end
  match_ct
end

def p2(gen_a, gen_b)
  5_000_000.times.inject(0) do |s, _|
    gen_a = next_num2(gen_a, 16807, 4)
    gen_b = next_num2(gen_b, 48271, 8)
    (gen_a & 0xffff) == (gen_b & 0xffff) ? s + 1 : s
  end
end
