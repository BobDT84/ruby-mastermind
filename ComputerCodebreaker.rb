class Computer
  def initialize(colors)
    @colors = colors
    @round = -1
    @previous = {guess: [], guess_type: '', hint: []}
    @guess_history = []
    @suggested_guess_type = ''
    @suggested_position = 0
    @found_colors = false
    @solution = Array.new(4)
    @hits = []
  end

  def guess(hints)
    @round += 1
    think
    @hint_history = hints
    if @round > 0
      log_last_guess
      process_hint
    end
    guess = generate_guess
    @guess_history.push(guess)
    breakpoint if @round == 11
    guess[0]
  end

  def generate_guess
    if @found_colors
      next_guess
    else
      whole_guess
    end
  end

  def log_last_guess
    @previous[:guess] = @guess_history[-1][0]
    @previous[:guess_type] = @guess_history[-1][1]
    @previous[:hint] = @hint_history[-1]
  end

  def log_hits(color)
    if @previous[:guess_type] == 'whole'
      repeat = @previous[:hint].count('H')
      repeat.times { @hits.push(color) }
    elsif @previous[:guess_type] == 'single'
      index = @previous[:guess].index(color)
      @solution[index] = color
      @hits.delete(color)
      @suggested_guess_type = 'left' # restart left, right, single cycle for the next color
    end
    @found_colors = true if @hits.length == 4
  end

  def log_miss(color)
    case @previous[:guess_type]
    when 'left'
      unless @previous[:hint].any?('H')
        @suggested_guess_type = 'single'
        @suggested_position = 2
      end
    when 'right'
      @suggested_guess_type = 'left' unless @previous[:hint].any?('H')
    when 'single'
      index = @previous[:guess].index(color) + 1
      @solution[index] = color
      @hits.delete(color)
      @suggested_guess_type = 'left'
    end
    nil
  end

  def process_hint
    color = @previous[:guess].reject { |c| c == @filler }[0]
    case @previous[:guess_type]
    when 'whole'
      if @previous[:hint].include?('H')
        log_hits(color) 
      else
        @filler = @previous[:guess][0]
      end
    when 'left'
      if @previous[:hint].include?('H')
        suggest_on_hit('left')
      else
        @suggested_guess_type = 'single'
        @suggested_position = 2
      end
    when 'right'
      suggest_on_hit('right') if @previous[:hint].include?('H')
    when 'single'
      if @previous[:hint].include?('H')
        log_hits(color)
      else
        log_miss(color)
      end
    when 'double'
      @suggested_guess_type = 'double'
    end
  end

  def suggest_on_hit(guess_type)
    case guess_type
    when 'whole'
      @suggested_guess_type = 'left'
    when 'left'
      @suggested_guess_type = 'single'
      @suggested_position = 0
    when 'right'
      @suggested_guess_type = 'single'
      @suggested_position = 2
    end
  end

  def next_guess
    @filler = @colors[0] if @filler.nil?
    color = select_color
    if @solution.count(nil) <= 2
      return double_guess(@hits)
    end 
    if @previous[:guess_type] == 'whole'
      left_guess(color)
    else
      case @suggested_guess_type
      when 'left'
        left_guess(color)
      when 'right'
        right_guess(color)
      when 'single'
        single_guess(color,@suggested_position)
      when 'double'
        double_guess(@hits.reverse)
      end
    end
  end

  def select_color
    @hits.each { |color| return color if @hits.count(color) == 1}
  end

  def random_color
    @colors[rand(@colors.length)]
  end

  def whole_guess(color = random_color)
    @colors.delete(color)
    [Array.new(4) { color }, 'whole']
  end

  def left_guess(color = random_color)
    [[color, color].push(@filler, @filler), 'left']
  end

  def right_guess(color = random_color)
    [[@filler, @filler].push(color, color), 'right']
  end

  def single_guess(color = random_color, guess_position = 0)
    guess = Array.new(4) { @filler }
    guess[guess_position] = color
    [guess, 'single']
  end

  def double_guess(colors)
    colors = colors.clone
    guess = @solution.clone
    nils = guess.count(nil)

    nils.times do |i|
      index = guess.index(nil)
      guess[index] = colors[i]
    end
    [guess, 'double']
  end

  def think
    print 'thinking'
    4.times { sleep(0.5); print(' .')}
    print "\n"
  end
end
