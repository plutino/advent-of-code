def parse_data(file)
  data = []
  File.open(file).each_line do |ln|
    data << ln.chomp.chars
  end
  data
end

def process(data)
  row = 0
  col = data.first.index('|')
  dir = :d

  caught_string =''
  step_ct = 0

  loop do
    until data[row][col] == '+' || data[row][col] == ' ' do
      caught_string << data[row][col] if data[row][col] >= 'A' && data[row][col] <= 'Z'

      case dir
      when :d
        row += 1
      when :u
        row -= 1
      when :l
        col -= 1
      when :r
        col += 1
      end
      step_ct += 1
    end

    break if data[row][col] == ' '

    case dir
    when :d, :u
      if data[row][col + 1].nil? || data[row][col + 1] == ' '
        col -= 1
        dir = :l
      else
        col += 1
        dir = :r
      end
    when :l, :r
      if data[row + 1].nil? || data[row + 1][col] == ' '
        row -= 1
        dir = :u
      else
        row += 1
        dir = :d
      end
    end
    step_ct += 1
  end
  [caught_string, step_ct]
end
