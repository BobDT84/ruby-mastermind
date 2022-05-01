require_relative 'CheckInput'

class Mastermind 
  include CheckInput
  def initialize
    @colors = ['red', 'orange', 'yellow', 'green', 'blue', 'purple']
    @secret_code = get_secret_code
    @round = 0
    @guess_history = []
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
    next_round
  end

  def get_player_guess
    guess = []
    4.times do |i|
      guess.push(ask_and_check("Guess Color#{i+1}: ", :check_color, [@colors]))
    end
    @guess_history.push(guess)
  end

  def process_guess
    hint = []
    guess = @guess_history[@round]
    4.times do |i|
      if guess[i] == @secret_code[i]
        hint.push('H')
      elsif @secret_code.include?(guess[i])
        hint.push('m')
      end
    end
    @hint_history.push(hint)
  end

  def print_history
    (0...@round).each do |i|
      puts "Round#{i+1}: " + @guess_history[i].join(', ') + ' => ' + @hint_history[i].join(', ')
    end
  end

  def next_round
    @round += 1
    if @round < 12
      play_round
    else
      game_over
    end
  end

  def test
    p "Secret Code: #{@secret_code}"
  end
end

Mastermind.new