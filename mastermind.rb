require_relative 'CheckInput'

class Mastermind 
  include CheckInput
  def initialize
    @colors = ['red', 'orange', 'yellow', 'green', 'blue', 'purple']
    @secret_code = get_secret_code
    #@secret_code = ['orange', 'red', 'red', 'red']
    @round = 0
    @guess_history = []
    @guess = []
    @hint_history = []
    test
    play_round
  end

  private

  def get_secret_code
    code = []
    4.times {code.push(@colors.sample)}
    code
  end

  def play_round
    print_history unless @guess_history.empty?
    puts "Round #{@round + 1} of 12"
    get_player_guess
    process_guess
    unless @secret_code == @guess_history[@round]
      next_round
    else
      game_over('win')
    end
  end

  def get_player_guess
    guess = []
    4.times do |i|
      guess.push(ask_and_check("Guess Color#{i+1}: ", :check_color, [@colors]))
    end
    @guess_history.push(guess)
    @guess = guess
  end

  def process_guess
    hint = []
    count_hits.times{hint.push('H')}
    count_misses.times{hint.push('m')}
    @hint_history.push(hint)
  end

  def count_hits
    hits = 0
    4.times {|i| hits += 1 if @guess[i] == @secret_code[i]}
    hits
  end

  def count_misses
    misses = 0
    accuracy = guess_accuracy
    accuracy.each do |x|
      if x == 'H' || x.length == 0
        next
      else
        # counts a miss if other guesses for the same color were not a hit
        misses +=1 if x.select{|index| accuracy[index] != 'H'}.length > 0
      end
    end
    misses
  end

  def guess_accuracy
    # Records hits as an 'H'
    # Records misses as an array of the indices of the secret_code array
    # if guess color is not in secret_code an empty array is returned
    accuracy = []
    4.times do |i|
      if @guess[i] == @secret_code[i]
        accuracy.push('H')
      else
        accuracy.push(indices(@secret_code,@guess[i]))
      end
    end
    accuracy
  end

  def indices(array, searched_element)
    array.each_index.select { |index| array[index] == searched_element}
  end

  def print_history
    (0...@round).each do |i|
      num = i + 1
      num = " #{num}" if i < 10
      puts "Round#{num}: " + @guess_history[i].join("\t") + "\t=>\t" + @hint_history[i].join(', ')
    end
  end

  def next_round
    @round += 1
    if @round < 12
      play_round
    else
      puts "Out of Rounds"
      game_over('lost')
    end
  end

  def game_over(outcome)
    if outcome == 'win'
      puts 'You Won!'
      ask_to_play_again
    elsif outcome == 'lost'
      puts 'The computer won.'
      puts 'Better luck next time.'
      ask_to_play_again
    end
  end

  def ask_to_play_again
    answer = ask_and_check('Want to play again? (y/n)', :check_input, [%w[y n], :call_downcase])
    if answer == 'y'
      Mastermind.new
    else
    end
  end

  def test
    p "Secret Code: #{@secret_code}"
  end
end

Mastermind.new