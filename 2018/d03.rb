# https://adventofcode.com/2018/day/3

class FabricCell
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end
end

class Fabric
  attr_reader :used, :reused

  def initialize
    @used = Set.new
    @reused = Set.new
  end

  def mark_reused!(cell)
    if used?(cell)
      @reused << serialize(cell)
    else
      @used << serialize(cell)
    end
  end

  def mark_used!(cell)
    @used << serialize(cell)
  end

  def used?(cell)
    @used.include?(serialize(cell))
  end

  private

  def serialize(cell)
    100000 * cell.x + cell.y
  end
end

class Cloth
  attr_reader :id, :x, :y, :w, :h

  def initialize(id, x, y, width, height)
    @id = id
    @x = x
    @y = y
    @w = width
    @h = height
  end

  def for_each_cell
    w.times do |widx|
      h.times do |hidx|
        yield FabricCell.new(x + widx, y + hidx)
      end
    end
  end

  def overlaped_with?(cloth)
    cloth.x < x + w && x < cloth.x + cloth.w &&
    cloth.y < y + h && y < cloth.y + cloth.h
  end

  def used_in?(fabric)
    for_each_cell do |cell|
      return true if fabric.used?(cell)
    end
    false
  end

  def mark_used_in!(fabric)
    for_each_cell { |cell| fabric.mark_used! cell }
  end
end

def parse_data lines
  input_re = /^#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/
  lines.map do |line|
    match = input_re.match(line)
    Cloth.new(*(match[1..5].map(&:to_i)))
  end
end

def p1(clothes)
  fabric = Fabric.new
  clothes.each do |cloth|
    cloth.for_each_cell { |cell| fabric.mark_reused!(cell) }
  end
  fabric.reused.count
end

def p2(clothes)
  fabric = Fabric.new
  cleared_cloth_ids = Set.new
  clothes.each do |cloth|
    cleared_cloth_ids.each do |cleared|
      cleared_cloth_ids.delete(cleared) if cloth.overlaped_with?(clothes[cleared - 1])
    end

    cleared_cloth_ids << cloth.id unless cloth.used_in?(fabric)
    cloth.mark_used_in! fabric
  end
  cleared_cloth_ids
end
