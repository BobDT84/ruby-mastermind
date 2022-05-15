require_relative 'CheckInput'
require_relative 'ComputerCodebreaker'

class Mastermind 
  include CheckInput
  def initialize
    @colors = %w[red orange yellow green blue purple]
    @secret_code = make_secret_code
    @round = 0
    @last_round = 12
    @guess_history = []
    @guess = []
    @hint_history = []
    test
    select_role
  end

  private

  def make_secret_code
    code = []
    4.times { code.push(@colors.sample) }
    code
  end

  def select_role
    # Uncomment after debugging
    # answer = ask_and_check("Select your role:\n1. Codebreaker\n2. Codemaker\n", :check_input, [%w[1 2]])
    answer = '2'
    case answer
    when '1'
      @breaker = 'Player'
      @maker = 'Computer'
    when '2'
      @breaker = 'Computer'
      @maker =  'Player'
      @computer = Computer.new(@colors)
      ask_for_code
    end
    play_round
  end

  def play_round
    print_history unless @guess_history.empty?
    puts "Round #{@round + 1} of #{@last_round}"
    case @breaker
    when 'Player'
      get_player_guess
    when 'Computer'
      get_computer_guess
    end
    process_guess
    if @secret_code == @guess_history[@round]
      game_over(@breaker)
    else
      next_round
    end
  end

  def ask_for_code
    @secret_code = []
    puts 'Use the following colors to create your code'
    puts 'red, orange, yellow, green, blue, purple'
    4.times do |i|
      # Uncomment after debugging
      # @secret_code.push(ask_and_check("Code Color#{i + 1}: ", :check_color, [@colors]))
      @secret_code = %w[red green blue red]
    end
    test
    play_round
  end

  def get_computer_guess
    @guess = @computer.guess(@hint_history)
    @guess_history.push(@guess)
  end

  def get_player_guess
    guess = []
    4.times do |i|
      guess.push(ask_and_check("Guess Color#{i + 1}: ", :check_color, [@colors]))
    end
    @guess_history.push(guess)
    @guess = guess
  end

  def process_guess
    @hint_history.push(guess_accuracy)
  end

  def guess_accuracy
    # Records hits as an 'H'
    # Records misses as an array of the indices of the secret_code array
    # if guess color is not in secret_code an empty array is returned
    accuracy = []
    guess = @guess.clone
    @secret_code.each_with_index do |color, index|
      if color == @guess[index]
        accuracy.push('H')
        guess.pop(index)
      elsif guess.any?(color)
        guess.delete(color)
        accuracy.push('m')
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
      puts "Round#{num}: #{@guess_history[i].join("\t")}\t=>\t#{@hint_history[i].join(', ')}"
    end
  end

  def next_round
    @round += 1
    if @round < @last_round
      play_round
    else
      puts 'Out of Rounds'
      game_over(@maker)
    end
  end

  def game_over(winner)
    print_history
    puts "#{winner} wins!"
    puts @guess
    ask_to_play_again
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
