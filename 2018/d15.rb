require 'set'

class Location
  include Comparable

  class << self
    attr_reader :pool

    def at(x_or_loc, y = nil)
      loc = y.nil? ? x_or_loc : 1000 * y + x_or_loc
      @pool ||= {}
      @pool[loc] ||= Location.new(loc)
    end
  end

  attr :loc

  def initialize(loc)
    @loc = loc
  end

  def hash
    @loc.hash
  end

  def <=> (other)
    @loc <=> other.loc
  end

  def inspect
    @loc
  end

  def to_s
    @loc.to_s
  end

  def neighbors
    Enumerator.new do |y|
      y << Location.at(@loc - 1000)
      y << Location.at(@loc - 1)
      y << Location.at(@loc + 1)
      y << Location.at(@loc + 1000)
    end
  end
end

class Character
  attr_accessor :loc
  attr_reader :hp, :kind

  def initialize(kind, loc)
    @kind = kind
    @loc = loc
    @hp = 200
  end

  def to_s
    "#{loc}#{kind}#{hp}"
  end

  def inspect
    to_s
  end

  def defend
    @hp -= 3
  end

  def enemy?(ch)
    @kind != ch.kind
  end

  def dead?
    @hp <= 0
  end
end

class Battle
  attr_reader :field, :characters

  def initialize(file)
    @field = {}
    @characters = []
    parse(file)
  end

  def show
    @h.times do |y|
      @w.times do |x|
        ch = @field[Location.at(x, y)]
        symbol = '#'
        if ch == :empty
          symbol = '.'
        elsif ch.is_a?(Character)
          symbol = ch.kind
        end
        print symbol
      end
      print "\n"
    end
    puts @characters.map{ |ch| "#{ch.loc.inspect}#{ch.kind}#{ch.hp}"}.inspect
  end

  def play
    round_count = 0
    loop do
      puts "ROUND #{round_count}"
      break if play_round
      round_count += 1
    end
    left_hp = @characters.map(&:hp).inject(0, :+)
    puts "#{round_count} -- #{left_hp}"
    left_hp * round_count
  end

  # return true if finished
  def play_round
    @characters.sort_by!(&:loc)
    #show
    @characters.each do |ch|
      return true if finished?
      play_turn_for(ch)
    end
    @characters.delete_if(&:dead?)
    false
  end

  def finished?
    @characters.map(&:kind).uniq.size == 1
  end

  def play_turn_for(character)
    #puts character
    return if character.dead?
    return if attack(character)

    path_cache = {}
    paths = path_lookup(character, character.loc, [], path_cache)
    return if paths.empty?

    shortest_path = nil
    paths.each do |enemy, path|
      if shortest_path.nil?
        shortest_path = path
      else
        if path.size < shortest_path.size ||
          (path.size == shortest_path.size && path.last < shortest_path.last)
          shortest_path = path
        end
      end
    end

    move(character, shortest_path[1])
    attack(character)
  end

  def path_lookup(character, loc, current_path, path_cache)
    #spacer = '  ' * current_path.size
    #puts "#{spacer}#{loc.inspect} - Path: #{current_path.inspect}"
    #puts "#{spacer}#{loc.inspect} - Cache: #{path_cache.inspect}"

    return {} if @field[loc].nil? || current_path.include?(loc)

    paths = {}
    if path_cache[loc]
      paths = path_cache[loc]
    elsif @field[loc].is_a?(Character) && @field[loc] != character
      paths = character.enemy?(@field[loc]) ? { @field[loc] => [] } : {}
      path_cache[loc] = paths
    else
      current_path << loc
      cache = true
      loc.neighbors.each do |next_loc|
        paths_to_add = path_lookup(character, next_loc, current_path.dup, path_cache)
        paths_to_add.each do |ch, path|
          new_path = [loc] + path
          paths[ch] = new_path if paths[ch].nil? || new_path.size < paths[ch].size
        end
      end
      path_cache[loc] = paths
    end

    #puts "#{spacer}#{loc.inspect} - Returns: #{paths}"
    return paths
  end

  def move(character, loc)
    old_loc = character.loc
    character.loc = loc
    @field[old_loc] = :empty
    @field[character.loc] = character
  end

  def attack(character)
    loc = character.loc
    target = nil
    loc.neighbors.each do |neighbor|
      ch = @field[neighbor]
      if ch.is_a?(Character) && character.enemy?(ch)
        target = ch if target.nil? || ch.hp < target.hp
      end
    end
    if target
      target.defend
      if target.dead?
        @field[target.loc] = :empty
        #@characters.delete(target)
      end
      true
    else
      false
    end
  end

  def parse(file)
    lines = File.readlines(file)
    lines.each_with_index do |ln, y|
      ln.chomp.chars.each_with_index do |cell, x|
        loc = Location.at(x, y)
        case cell
        when '.'
          @field[loc] = :empty
        when 'G', 'E'
          character = Character.new(cell, loc)
          @characters << character
          @field[loc] = character
        end
      end
    end
    @w = lines.first.chomp.size
    @h = lines.size
  end
end
