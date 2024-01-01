class GuessingGame

  def initialize
    @secret_number = nil
    @max_range = nil
    @start_range = nil
    @number_of_guesses = nil
  end

  def initialize_range
    (@start_range..@max_range).to_a
  end

  def check_guess(guess)
    if guess == @secret_number
      0
    elsif (@start_range...@secret_number).include?(guess)
      -1
    elsif ((@secret_number + 1)..@max_range).include?(guess)
      1
    end
  end

  def guess_high
    guess = @number_of_guesses == 6 ? "guess" : "guesses"
    puts "Your guess is too high. Try again."
    puts "You have #{@number_of_guesses -= 1} #{guess} remaining."
  end

  def guess_low
    guess = @number_of_guesses == 6 ? "guess" : "guesses"
    puts "Your guess is too low. Try again."
    puts "You have #{@number_of_guesses -= 1} #{guess} remaining."
  end

  def display_winner_message
    puts "That's the number!"
    puts ''
    puts "You won!"
  end

  def display_loser_message
    puts "The number was #{@secret_number}!"
    puts "You have no more guesses. You lost!"
  end

  def display_welcome_message
    puts "Please select beginning number for your range to generate a secret number"

    answer1 = nil
    loop do
      answer1 = gets.chomp.to_i
      break if answer1 >= 1
      puts "beginning number cannot be 0 or a negative number. Try again."
    end
    @start_range = answer1

    puts "Thank you. Please select maximum number for your range to generate a secret number"
    answer2 = nil
    loop do
      answer2 = gets.chomp.to_i
      break if answer2 > @start_range
      puts "maximum number cannot be lesser or equal to the starting number. Try again."
    end
    @max_range = answer2
    puts "Thank you for your input, you may now start guessing from #{@start_range} to #{@max_range}"

    @number_of_guesses = Math.log2(@max_range).to_i + 1
  end

  def get_answer
    guess = nil
    loop do
      guess = gets.chomp.to_i
      if guess > @max_range
        puts "guess too high, try again."
      elsif guess < @start_range
        puts "guess cannot be a negative number. Try again."
      end
      break if (@start_range..@max_range).include?(guess)
    end
    guess
  end

  def play
    display_welcome_message
    @secret_number = initialize_range.sample

    loop do
      return display_loser_message if @number_of_guesses == -1
      guess = get_answer
      result = check_guess(guess)
      break if result == 0
      if result == 1
        guess_high
      elsif result == -1
        guess_low
      end
    end
    display_winner_message
  end
end

game = GuessingGame.new
game.play