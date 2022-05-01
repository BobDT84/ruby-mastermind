module CheckInput
  def check_color(input, prompt, colors)
    if colors.include?(input)
      input
    else
      puts "#{input} is not a valid color"
      puts "Valid colors are #{colors.join(', ')}"
      return ask_and_check(prompt, :check_color, [colors])
    end
  end

  def number?(subject)
    subject =~ /[0-9]/
  end

  def not_number?(subject)
    !number?(subject)
  end

  def call_downcase(subject)
    subject.downcase
  end

  def check_input(input, prompt, expects, modify = false)
    if modify
      input = method(modify).call(input)
    end
    if expects.include?(input)
      input
    else
      puts 'Incorrect Input'
      return ask_and_check(prompt, :check_input, [expects, modify])
    end
    input
  end

  def ask_and_check(prompt, check, arguments = false)
    print prompt
    input = gets.strip
    if arguments
      method(check).call(input, prompt, *arguments)
    else
      method(check).call(input, prompt)
    end
  end
end
