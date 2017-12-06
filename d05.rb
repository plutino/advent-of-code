def p1(maze)
  step = 0
  idx = 0
  while idx < maze.size && idx >= 0 do
    maze[idx] += 1
    idx += maze[idx] - 1
    step += 1
  end
  step
end

def p2(maze)
  step = 0
  idx = 0
  while idx < maze.size && idx >= 0 do
    old_v = maze[idx]
    maze[idx] += maze[idx] >= 3 ? -1 : 1
    idx += old_v
    step += 1
  end
  step
end
