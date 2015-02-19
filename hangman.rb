class Game
  def initialize(player1 = ComputerPlayer.new, player2 = HumanPlayer.new)
    @players = [player1, player2]
  end

  def play_turn(guesser, thinker)
    loop do
      response = thinker.check_guess(guesser.guess)
      puts response.to_s
      if response.won?
        puts "#{guesser.name} won!"
        break
      end
      guesser.handle_guess_response(response)
    end
  end

  def play
    turns = 0
    loop do
      guesser = @players[turns % 2]
      thinker = @players[(turns + 1) % 2]
      length = guesser.receive_length(thinker.pick_secret_word)
      puts "_" * length
      play_turn(guesser, thinker)
      turns += 1
    end
  end
end

class Response < Array
  def to_s
    self.map { |letter| letter ? letter : "_" }.join("")
  end

  def won?
    self.all? { |letter| letter }
  end
end

class ComputerPlayer
  attr_accessor :name

  def initialize(name = "The Computer")
    @dictionary = File.readlines("dictionary.txt").map(&:chomp)
    @name = name
  end

  # Thinker Role:

  def pick_secret_word
    @secret_word = @dictionary.sample.split(//)
    @response = Response.new(@secret_word.length)

    @secret_word.length
  end

  def check_guess(guess)
    @secret_word.each_index do |index|
      @response[index] = guess if @secret_word[index] == guess
    end

    @response
  end

  # Guesser Role:

  def receive_length(length)
    @guessed_letters = []
    @secret_length = length
    @pruned_dictionary = @dictionary.select { |word| word.length == length}
    length
  end

  def frequency_hash(dictionary)
    frequency_hash = Hash.new(0)
    dictionary.each do |word|
      word.chars.each do |char|
        frequency_hash[char] += 1
      end
    end

    frequency_hash
  end

  def guess
    f_hash = frequency_hash(@pruned_dictionary)
    @guessed_letters.each do |letter|
      f_hash.delete(letter)
    end
    guess = f_hash.max_by{ |l, freq| freq }[0]
    @guessed_letters << guess
    guess
  end

  def handle_guess_response(response)
    @pruned_dictionary = @pruned_dictionary.select do |word|
      word.chars.each_index.all? do |index|
        word.chars[index] == response[index] || response[index].nil?
      end
    end
  end
end

class HumanPlayer
  attr_accessor :name

  def initialize(name="You")
    @name = name
  end

  # Thinker role:
  def pick_secret_word
    print "How long is your secret word? "
    length = gets.chomp.to_i

    @response = Response.new(length, nil)

    length
  end

  def check_guess(guess)
    puts "The guess is #{guess}. "
    puts "Enter the positions of the letters separated by commas. "

    positions = gets.chomp.gsub(" ", "").split(",").map { |pos| pos.to_i - 1 }
    positions.each { |pos| @response[pos] = guess }

    @response
  end

  # Guesser Role
  def receive_length(length)
    length
  end

  def guess
    gets.chomp.downcase
  end

  def handle_guess_response(response)
  end
end




# computer = ComputerPlayer.new
# human = HumanPlayer.new
# game = Game.new(computer, human)
# game.play
