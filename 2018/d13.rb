# https://adventofcode.com/2018/day/13

def serialize(x, y)
  1000 * y + x
end

class Cart
  attr_accessor :dir, :crashed

  def initialize(node, direction)
    @node = node
    @dir = direction
    @next_turn = :left
    @crashed = false
  end

  def step
    @node.move(self)
  end

  def location
    @node.location
  end

  def move
    @node = @node.neighbor(@dir)
  end

  def turn_at_intersection
    case @next_turn
    when :left
      turn(:left)
      @next_turn = :straight
    when :straight
      @next_turn = :right
    when :right
      turn(:right)
      @next_turn = :left
    end
  end

  def turn(dir)
    case dir
    when :left
      case @dir
      when :north
        @dir = :west
      when :west
        @dir = :south
      when :south
        @dir = :east
      when :east
        @dir = :north
      end
    when :right
      case @dir
      when :north
        @dir = :east
      when :east
        @dir = :south
      when :south
        @dir = :west
      when :west
        @dir = :north
      end
    end
  end
end

class NodePool
  def initialize
    @nodes = {}
  end

  def create(x, y, symbol)
    @nodes[serialize(x, y)] = case symbol
                              when '/'
                                TurnNode
                              when '\\'
                                BackTurnNode
                              when '+'
                                CrossNode
                              else
                                Node
                              end.new(x, y, self)
  end

  def at(x, y)
    @nodes[serialize(x, y)]
  end
end

class Node
  def initialize(x, y, pool)
    @x = x
    @y = y
    @pool = pool
  end

  def move(cart)
    cart.move
  end

  def location
    [@x, @y]
  end

  def neighbor(dir)
    case dir
    when :north
      @pool.at(@x, @y - 1)
    when :south
      @pool.at(@x, @y + 1)
    when :west
      @pool.at(@x - 1, @y)
    when :east
      @pool.at(@x + 1, @y)
    end
  end
end

class TurnNode < Node
  def move(cart)
    case cart.dir
    when :east, :west
      cart.turn(:left)
    when :north, :south
      cart.turn(:right)
    end
    super(cart)
  end
end

class BackTurnNode < Node
  def move(cart)
    case cart.dir
    when :east, :west
      cart.turn(:right)
    when :north, :south
      cart.turn(:left)
    end
    super(cart)
  end
end

class CrossNode < Node
  def move(cart)
    cart.turn_at_intersection
    super(cart)
  end
end

class Field
  attr_reader :carts

  def initialize(file)
    @node_pool = NodePool.new
    @carts = []
    load_data(file)
  end

  def first_crash
    loop do
      sort_cart
      @carts.each do |cart|
        cart.step
        return cart.location if crash?
      end
    end
  end

  def last_cart
    loop do
      @carts.delete_if(&:crashed)
      return @carts.first.location if @carts.size == 1
      sort_cart
      @carts.each do |cart|
        next if cart.crashed
        cart.step
        crashed_cart = crashed_with(cart)
        if crashed_cart
          crashed_cart.crashed = true
          cart.crashed = true
        end
      end
    end
  end

  private

  def sort_cart
    @carts.sort_by! { |cart| serialize(*(cart.location)) }
  end

  def crash?
    location_hash = @carts.map { |cart| serialize(*(cart.location))}
    return location_hash.uniq.count != location_hash.count
  end

  def crashed_with(cart)
    @carts.find {|c| c != cart && c.location == cart.location}
  end

  def load_data(file)
    File.readlines(file).each_with_index do |ln, y|
      ln.chars.each_with_index do |symbol, x|
        case symbol
        when '<'
          node = @node_pool.create(x, y, '-')
          @carts << Cart.new(node, :west)
        when '>'
          node = @node_pool.create(x, y, '-')
          @carts << Cart.new(node, :east)
        when '^'
          node = @node_pool.create(x, y, '|')
          @carts << Cart.new(node, :north)
        when 'v'
          node = @node_pool.create(x, y, '|')
          @carts << Cart.new(node, :south)
        else
          @node_pool.create(x, y, symbol)
        end
      end
    end
  end
end

def p1(file)
  Field.new(file).first_crash
end

def p2(file)
  Field.new(file).last_cart
end
