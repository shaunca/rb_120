=begin
- Write a textual description of the problem or exercise.
- Extract the major nouns and verbs from the description.
- Organize and associate the verbs with the nouns.
- The nouns are the classes and the verbs are the behaviors or methods.

Rock, Paper, Scissors is a two-player game where each player chooses
one of three possible moves: rock, paper, or scissors. The chosen moves
will then be compared to see who wins, according to the following rules:

- rock beats scissors
- scissors beats paper
- paper beats rock

If the players chose the same move, then it's a tie.

=end
class Player
  attr_accessor :move, :name, :score

  def initialize
    set_name
    @score = 0
  end

  def human?
    @player_type == :human
  end
end

class Move
  attr_accessor :value

  VALUES = ['rock', 'paper', 'scissors']

  def initialize(value)
    @value = value
  end

  def scissors?
    @value == 'scissors'
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def >(other_move)
    (rock? && other_move.scissors?) ||
      (scissors? && other_move.paper?) ||
      (paper? && other_move.rock?)
  end

  def <(other_move)
    (rock? && other_move.paper?) ||
      (scissors? && other_move.rock?) ||
      (paper? && other_move.scissors?)
  end

  def to_s
    @value
  end
end

class Human < Player
  def set_name
    n = ""
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, must enter value."
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts "Please choose rock, paper, or scissors:"
      choice = gets.chomp
      break if Move::VALUES.include?(choice)
      puts "Wrong selection, please try again."
    end
    self.move = Move.new(choice)
  end

  def add_score
    self.score += 1
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', "Chappie", 'Sonny', "Number 5"].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end

  def add_score
    self.score += 1
  end
end

def compare(move1, move2); end

class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors!"
  end

  def display_goodbye_message
    puts "Thank you for playing Rock, Paper, Scissors. Goodbye!"
  end

  def display_moves
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end

  def display_winner
    if human.move > computer.move
      human.add_score
      puts "You win!"
    elsif human.move < computer.move
      computer.add_score
      puts "You lose!"
    else
      puts "It's a tie!"
    end
  end

  def play_again?
    loop do
      puts "Would you like to play again? Yes/ No"
      answer = gets.chomp
      return true if ['yes', 'y'].include?(answer.downcase)
      return false if ['no', 'n'].include?(answer.downcase)
      puts "Sorry, invalid input."
    end
  end

  def display_score
    puts "Human player: #{human.score}"
    puts "Computer : #{computer.score}"
  end

  def play
    display_welcome_message

    loop do
      human.choose
      computer.choose
      display_moves
      display_winner
      display_score
      if human.score == 3 || computer.score == 3
        break if play_again?
      end
    end
    display_goodbye_message
  end
end

RPSGame.new.play