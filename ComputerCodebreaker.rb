class Computer
  def initialize(colors, last_round)
    @colors = colors
    @round = -1
    @last_round = last_round
    @guess_history = []
    @hits = []
    @misses = []
    @data = data_initialize
  end

  def guess(hints)
    @round += 1
    think
    @hint_history = hints
    if hints.empty?
      puts 'random'
      guess = random_guess
    else
      puts 'generating'
      guess = generate_guess
    end
    @guess_history.push(guess)
    puts "Computer is guessing #{guess}"
    guess
  end

  def data_initialize
    data = {}
    @colors.each do |color| 
      data[color] = { count: 4, positions: [0, 1, 2, 3] }
    end
  end

  def generate_guess
    last_guess = @guess_history[-1]
    last_hint = @hint_history[-1]
    if last_hint.empty?
      @filler = last_guess[0]
      last_guess.each { |color| @colors.delete(color) }
      random_guess
    end
    random_guess
  end

  def random_guess
    i = rand(@colors.length)
    Array.new(4) { @colors[i] }
  end

  def think
    print 'thinking'
    # Uncomment after debugging
    #4.times { sleep(0.5); print(' .')}
    print "\n"
  end
end
