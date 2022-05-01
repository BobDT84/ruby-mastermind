require relative 'CheckInput'

class Mastermind 
  include CheckInput
  def initialize
    @colors = ['red', 'orange', 'yellow', 'green', 'blue', 'purple']
    @secret_code = get_secret_code
    @round = 1
    get_player_guess
    test
  end

  private

  def get_secret_code
    code = []
    4.times {code.push(@colors.sample)}
    code
  end

  def get_player_guess
    guess = ask_and_check('Guess the code: ')
  end

  def test
    p @secret_code
    p @colors
  end
end

Mastermind.new