class Code
  COLORS = %w(R G B Y O P)

  def initialize(pegs)
    @pegs = pegs.split(//)
  end

  def display
    @pegs.join("")
  end

  attr_reader :pegs

  def self.random
    secret = COLORS.sample(4).join('')

    self.new(secret)
  end

  def exact_matches(other_code)
    matches = 0
    @pegs.each_index do |index|
      matches += 1 if other_code.pegs[index] == @pegs[index]
    end

    matches
  end

  def near_matches(other_code)
    other_code_pegs = other_code.pegs.dup
    sum = 0

    @pegs.each do |peg|
      if other_code_pegs.include?(peg)
        sum += 1
        other_code_pegs.delete_at(other_code_pegs.index(peg))
      end
    end

    sum - exact_matches(other_code)
  end
end

class Game
  def play
    @secret_code = Code.random
    10.times do
      if play_turn
        puts "You Win!!!!!!"
        return
      end
    end
    puts "Sorry, you lost. The secret code was #{@secret_code.display}."
  end

  private

    def get_user_input
      input = nil

      until input =~ /^[RGBYOP]{4}$/
        print "Your move? "
        input = gets.chomp.upcase
      end

      Code.new(input)
    end

    def play_turn
      user_move = get_user_input
      exact_matches = user_move.exact_matches(@secret_code)
      near_matches = user_move.near_matches(@secret_code)
      puts "#{exact_matches} exact matches, #{near_matches} near misses."

      won?(user_move)
    end

    def won?(user_move)
      user_move.exact_matches(@secret_code) == 4
    end
end
