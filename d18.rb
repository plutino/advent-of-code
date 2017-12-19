def parse_data(file)
  data = []
  File.open(file).each_line do |ln|
    tokens = ln.strip.split(' ')
    data << { op: tokens.first, reg: tokens[1], val: tokens[2] }
  end
  data
end

class Registry
  def initialize(reg_default)
    @default = reg_default
    @registry = {}
    @receive_queue = []
  end

  def fetch(reg_or_val)
    if is_register?(reg_or_val)
      @registry[reg_or_val] ||= @default
    else
      reg_or_val.to_i
    end
  end

  def set(reg, reg_or_val)
    @registry[reg] = fetch(reg_or_val)
  end

  def add(reg, reg_or_val)
    @registry[reg] ||= @default
    @registry[reg] += fetch(reg_or_val)
  end

  def mul(reg, reg_or_val)
    @registry[reg] ||= @default
    @registry[reg] *= fetch(reg_or_val)
  end

  def mod(reg, reg_or_val)
    @registry[reg] ||= @default
    @registry[reg] %= fetch(reg_or_val)
  end

  def queue
    @receive_queue
  end

  def send(reg_or_val, registry)
    registry.queue << fetch(reg_or_val)
  end

  def receive(reg)
    if queue.empty?
      nil
    else
      @registry[reg] = queue.shift
    end
  end

  private

  def is_register?(reg)
    reg >= 'a' && reg <= 'z' || reg >= 'A' && reg <= 'Z'
  end
end

def p1(data)
  registry = Registry.new(0)
  last_sound = nil
  inst_ptr = 0
  while inst_ptr < data.size do
    inst = data[inst_ptr]
    case (inst[:op])
    when 'snd'
      last_sound = registry.fetch(inst[:reg])
    when 'set'
      registry.set(inst[:reg], inst[:val])
    when 'add'
      registry.add(inst[:reg], inst[:val])
    when 'mul'
      registry.mul(inst[:reg], inst[:val])
    when 'mod'
      registry.mod(inst[:reg], inst[:val])
    when 'rcv'
      if registry.fetch(inst[:reg]) != 0
        return last_sound
      end
    when 'jgz'
      if registry.fetch(inst[:reg]) > 0
        inst_ptr += registry.fetch(inst[:val])
        next
      end
    end
    inst_ptr += 1
  end
end

def p2(data)
  registry = [Registry.new(0), Registry.new(1)]

  wait = [false, false]
  inst_ptr = [0, 0]
  sent_ct = [0, 0]

  prog = 0
  until (wait[0] || inst_ptr[0] >= data.size) && (wait[1] || inst_ptr[1] >= data.size)
    inst = data[inst_ptr[prog]]

    case inst[:op]
    when 'snd'
      registry[prog].send(inst[:reg], registry[1 - prog])
      wait[1 - prog] = false
      sent_ct[prog] += 1
    when 'set'
      registry[prog].set(inst[:reg], inst[:val])
    when 'add'
      registry[prog].add(inst[:reg], inst[:val])
    when 'mul'
      registry[prog].mul(inst[:reg], inst[:val])
    when 'mod'
      registry[prog].mod(inst[:reg], inst[:val])
    when 'rcv'
      unless registry[prog].receive(inst[:reg])
        wait[prog] = true
        prog = 1 - prog
        next
      end
    when 'jgz'
      if registry[prog].fetch(inst[:reg]) > 0
        inst_ptr[prog] += registry[prog].fetch(inst[:val])
        next
      end
    end

    inst_ptr[prog] += 1
  end

  sent_ct
end
