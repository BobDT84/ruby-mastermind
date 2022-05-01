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
  end

  private

  def get_secret_code
    code = []
    4.times {code.push(@colors.sample)}
    code
  end

  def get_player_guess
    guess = []
    4.times do |i|
      guess.push(ask_and_check("Guess Color#{i+1}: ", :check_color, [@colors]))
    end
    guess
  end

  def print_history
    0...@round.each do |i|
      puts @guess_history[i] + @hint_history[i]
    end
  end

  def next_round
    @round += 1
  end

  def test
    p @secret_code
    p @colors
    p get_player_guess
  end
end

Mastermind.new