class Puzzle

  def initialize(n)
    @n = n
    @count = 0
  end

  def possible_moves(queen_positions)
    (0...@n).to_a.reject do |pos|
      already_included = queen_positions.include?(pos)
      threatened_diag = false
      queen_positions.each_with_index do |qpos, index|
        threatened_diag ||= queen_positions.length - index == (pos - qpos).abs
      end
      already_included || threatened_diag
    end
  end

  def render(queen_positions)
    queen_positions.each do |qpos|
      puts " ." * qpos + " Q" + " ." * (@n - qpos - 1)
    end
    @count += 1
    puts "-" * (@n * 2) << "   Solution #: #{@count}\n\n"
  end

  def dfs(queen_positions)
    render (queen_positions) if queen_positions.length == @n

    possible_moves(queen_positions).each do |move|
      dfs(queen_positions.dup << move)
    end
  end

  def solve
    dfs([])
  end
end
