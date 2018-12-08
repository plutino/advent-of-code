# https://adventofcode.com/2018/day/8

class Node
  attr_accessor :children, :meta_data

  def initialize
    @meta_data = []
    @children = []
  end

  def meta_sum
    sum(@meta_data)
  end
end

class Tree
  def initialize(data)
    @root = Node.new
    read_node(@root, data.dup)
  end

  def meta_sum
    calc_sum(@root)
  end

  def value
    calc_value(@root)
  end

  private

  def read_node(node, data)
    child_count = data.shift
    meta_count = data.shift
    child_count.times do
      child = Node.new
      node.children << child
      read_node(child, data)
    end
    meta_count.times { node.meta_data << data.shift }
  end

  def calc_sum(node)
    sum(node.children.map { |child| calc_sum(child) }) + node.meta_sum
  end

  def calc_value(node)
    return node.meta_sum if node.children.empty?
    valid_child_idx = node.meta_data.select { |d| d > 0 && d <= node.children.count }
                                    .map { |d| d - 1 }
    children_values = {}
    valid_child_idx.uniq.each do |child_idx|
      children_values[child_idx] = calc_value(node.children[child_idx])
    end
    sum(valid_child_idx.map { |child_idx| children_values[child_idx] })
  end
end

def sum(d)
  d.inject(0, :+)
end

def parse_data(file)
  Tree.new File.read(file).chomp.split.map(&:to_i)
end

def p1(tree)
  tree.meta_sum
end

def p2(tree)
  tree.value
end
