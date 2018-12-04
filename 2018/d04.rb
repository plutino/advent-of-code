# https://adventofcode.com/2018/day/4

class SleepSession
  attr_reader :starts_at, :ends_at

  def initialize(starts_at, ends_at)
    @starts_at = starts_at
    @ends_at = ends_at
  end

  def duration
    @ends_at - @starts_at
  end
end

class Guard
  attr_reader :id

  def initialize guard_id
    @id = guard_id
    @logs = []
  end

  def <<(log)
    @logs << log
  end

  def total_sleep
    @logs.map(&:total_sleep).inject(0, :+)
  end

  def most_often_minute
    @most_often ||= calc_most_often_minute_and_count
    @most_often.last
  end

  def most_often_minute_count
    @most_often ||= calc_most_often_minute_and_count
    @most_often.first
  end

  private

  def calc_most_often_minute_and_count
    minute_counts = Array.new(60, 0)

    @logs.each do |log|
      log.for_each_sleep do |sleep_session|
        (sleep_session.starts_at ... sleep_session.ends_at).each { |min| minute_counts[min] += 1}
      end
    end

    minute_counts.each_with_index.max
  end
end


class DutyLog
  attr_reader :guard_id

  def initialize(guard_id)
    @guard_id = guard_id
    @sleep_sessions = []
  end

  def <<(sleep_session)
    @sleep_sessions << sleep_session
  end

  def for_each_sleep
    @sleep_sessions.each do |sleep_session|
      yield sleep_session
    end
  end

  def total_sleep
    @sleep_sessions.map(&:duration).inject(0, :+)
  end
end

def p1(guards)
  guard = guards.max_by{ |guard_id, guard| guard.total_sleep }.last
  guard.id * guard.most_often_minute
end

def p2(guards)
  guard = guards.max_by{ |id, guard| guard.most_often_minute_count }.last
  guard.id * guard.most_often_minute
end

def parse_data lines
  start_minute = nil
  log = nil
  guards = {}

  lines.sort.each do |ln|
    tokens = ln.split('] ')
    if tokens.last.start_with?('Guard')
      unless log.nil?
        guards[log.guard_id] ||= Guard.new(log.guard_id)
        guards[log.guard_id] << log
      end
      match = /Guard #(\d+) begins/.match(tokens.last)
      log = DutyLog.new(match[1].to_i)
    else
      current_minute = tokens.first[-2..-1].to_i
      if tokens.last.start_with?('wakes')
        log << SleepSession.new(start_minute, current_minute)
      elsif tokens.last.start_with?('falls')
        start_minute = current_minute
      end
    end
  end
  guards[log.guard_id] ||= Guard.new(log.guard_id)
  guards[log.guard_id] << log
  guards
end
