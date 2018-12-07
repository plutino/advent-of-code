# https://adventofcode.com/2018/day/7

require 'set'

class JobGraph
  def initialize
    @graph = {}
  end

  def empty?
    @graph.empty?
  end

  def add(job, prerequisite)
    @graph[job] ||= Set.new
    @graph[prerequisite] ||= Set.new
    @graph[job] << prerequisite
  end

  def next
    available.first
  end

  def available
    @graph.select{ |k, v| v.empty? }.keys.sort
  end

  def start(*jobs)
    jobs.map { |job| @graph.delete job }
  end

  def finish(*jobs)
    @graph.each { |k, v| v.subtract(jobs) }
  end
end

class Worker
  attr_reader :job

  def initialize
    @counter = 0
  end

  def busy?
    @counter > 0
  end

  def start(job, time_required)
    @job = job
    @counter = time_required
  end

  def proceed
    return :idle if @counter == 0
    @counter -= 1
    return :finished if @counter == 0
    return :busy
  end
end

class ProcessCenter
  attr_reader :clock

  def initialize(nworker)
    @workers = []
    nworker.times { @workers << Worker.new }
    @clock = 0
  end

  def assign(job, time_required)
    w = @workers.find {|w| !w.busy?}
    return false if w.nil?
    w.start(job, time_required)
    true
  end

  def run_until_finish_one()
    finished_workers = []
    while finished_workers.empty? && @workers.any?(&:busy?)
      finished_workers = @workers.select { |w| w.proceed == :finished }
      @clock += 1
    end
    return finished_workers.map(&:job)
  end

  def run_until_finish_all()
    while @workers.any?(&:busy?)
      @workers.map(&:proceed)
      @clock += 1
    end
  end
end

def parse_data lines
  graph = JobGraph.new
  lines.each do |ln|
    tokens = ln.split
    graph.add(tokens[7], tokens[1])
  end
  graph
end

def p1(graph)
  order = []
  while (job = graph.next)
    order << job
    graph.start(job)
    graph.finish(job)
  end
  order.join('');
end

def p2(graph, nworker, penalty)
  center = ProcessCenter.new(nworker)
  while !graph.empty?
    graph.available.each do |job|
      graph.start(job) if center.assign(job, required_time_for(job, penalty))
    end
    jobs_finished = center.run_until_finish_one
    graph.finish(*jobs_finished)
  end
  center.run_until_finish_all
  center.clock
end

def required_time_for(job, penalty)
  job.ord - 'A'.ord + 1 + penalty
end
