class Conway
  def self.random(n=10)
    game = Conway.new(n)

    (n*n).times do
      x = rand(n).round
      y = rand(n).round
      game[x, y] = rand > 0.125
    end

    game
  end

  def initialize(n=10)
    @size = n
    @grid = Array.new(@size) { Array.new(@size) { false } }
  end

  def run
    while true
      print_grid
      evolve!
      sleep(0.1)
    end
  end

  def acorn_at(x, y)
    self[x+1, y  ] = true
    self[x+3, y+1] = true
    self[x,   y+2] = true
    self[x+1, y+2] = true
    self[x+4, y+2] = true
    self[x+5, y+2] = true
    self[x+6, y+2] = true

    self
  end

  def glider_at(x, y)
    self[x+1, y  ] = true
    self[x+2, y+1] = true
    self[x,   y+2] = true
    self[x+1, y+2] = true
    self[x+2, y+2] = true

    self
  end

  def evolve!
    # Any live cell with fewer than two live neighbours dies, as if caused by under-population.
    # Any live cell with two or three live neighbours lives on to the next generation.
    # Any live cell with more than three live neighbours dies, as if by overcrowding.
    # Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.

    @grid = @grid.each_with_index.map { |row, y|
      row.each_with_index.map { |is_alive, x|
        neighbors = count_neighbors(x, y)

        if is_alive
          if neighbors < 2 || neighbors > 3
            false
          else
            true
          end
        else
          if neighbors == 3
            true
          else
            false
          end
        end
      }
    }
  end

  def count_neighbors(x, y)
    [self[x-1, y-1], self[x, y-1], self[x+1, y-1],
     self[x-1, y],                 self[x+1, y],
     self[x-1, y+1], self[x, y+1], self[x+1, y+1]].count { |is_alive| is_alive }
  end

  def [](x, y)
    # if x >= 0 && y >=0 && x < @size && y < @size
    #   @grid[y][x]
    # else
    #   true
    # end

    if x < 0
      x = @size - 1
    elsif x >= @size
      x = 0
    end

    if y < 0
      y = @size - 1
    elsif y >= @size
      y = 0
    end

    @grid[y][x]
  end

  def []=(x, y, value)
    # if x >= 0 && y >=0 && x < @size && y < @size
    #   @grid[y][x] = value
    # end
    if x >= 0 && y >=0 && x < @size && y < @size
      @grid[y][x] = value
    end
  end

  def print_grid
    puts @grid.map { |row|
      row.map { |is_alive|
        is_alive ? '*' : ' '
      }.join(' ')
    }.join("\n")
    puts Array.new(@size) { '-' } * '='
  end
end

Conway.random(29).glider_at(1, 1).run
# Conway.new(49).acorn_at(20, 20).run
# Conway.new(81).run


