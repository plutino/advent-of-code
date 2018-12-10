# https://adventofcode.com/2018/day/9

class Circle
  class Node
    attr_reader :data
    attr_accessor :prev, :next

    def initialize data
      @data = data
      @prev = nil
      @next = nil
    end
  end

  def initialize head_value
    @head = Node.new head_value
    @head.prev = @head
    @head.next = @head
    @cur = @head
  end

  def insert value
    node = Node.new value
    node.prev = @cur.prev
    @cur.prev.next = node
    node.next = @cur
    @cur.prev = node
    @cur = node
  end

  def remove
    @cur.prev.next = @cur.next
    @cur.next.prev = @cur.prev
    tmp = @cur
    @cur = @cur.next
    tmp.data
  end

  def move_forward(steps)
    steps.times { @cur = @cur.next }
  end

  def move_backward(steps)
    steps.times { @cur = @cur.prev }
  end
end

class Player
  attr_reader :score

  def initialize
    @score = 0
  end

  def take(marble)
    @score += marble
  end
end

class Game
  attr_reader :players

  def initialize(player_count)
    @players = player_count.times.map { Player.new }
  end

  def run(last_marble)
    circle = Circle.new 0
    marble = 1
    loop do
      @players.each do |player|
        if (marble % 23 == 0)
          player.take marble
          circle.move_backward 7
          player.take circle.remove
        else
          circle.move_forward 2
          circle.insert marble
        end
        marble += 1
        return if marble > last_marble
      end
    end
  end
end

def p1(n_player, last_marble)
  game = Game.new(n_player)
  game.run(last_marble)
  game.players.map(&:score).max
end

alias p2 p1

# Data: 459 players; last marble is worth 71320 points
