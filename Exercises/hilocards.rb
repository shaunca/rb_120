class Card
  SUITS = ['H', 'D', 'S', 'C']
  FACES = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']

  def initialize(suit, face) #card has a suit and face
    @suit = suit
    @face = face
  end

  def to_s
    "The #{face} of #{suit}"
  end

  def face
    case @face
    when 'J' then 'Jack'
    when 'Q' then 'Queen'
    when 'K' then 'King'
    when 'A' then 'Ace'
    else
      @face
    end
  end

  def suit
    case @suit
    when 'H' then 'Hearts'
    when 'D' then 'Diamonds'
    when 'S' then 'Spades'
    when 'C' then 'Clubs'
    end
  end

  def ace?
    face == 'Ace' #face refers to the getter method face and returns the value of face if it is a number or jack to king
  end

  def king?
    face == 'King'
  end

  def queen?
    face == 'Queen'
  end

  def jack?
    face == 'Jack'
  end
end

class Deck
  attr_accessor :cards

  def initialize
    @cards = []
    Card::SUITS.each do |suit|
      Card::FACES.each do |face|
        @cards << Card.new(suit, face) #creates an entire deck of card objects with suit and face
      end
    end

    scramble! # by the end of initialize, an array of cards have been createed and shuffled
  end

  def scramble!
    cards.shuffle!
  end

  def deal_one
    cards.pop # effectively draws a card and removes it permanently from the deck
  end
end

module Hand
  def show_hand
    puts "---- #{name}'s Hand ----"
    cards.each do |card|
      puts "=> #{card}"  #shows player cards
    end
    puts "=> Total: #{total}" # shows total
    puts ""
  end

  def total  #calculates current total of player cards
    total = 0
    cards.each do |card|
      if card.ace? #this method will only work for Card objects. will throw an error otherwise
        total += 11
      elsif card.jack? || card.queen? || card.king?
        total += 10
      else
        total += card.face.to_i
      end
    end

    # correct for Aces
    cards.select(&:ace?).count.times do
      break if total <= 21
      total -= 10
    end

    total
  end

  def add_card(new_card)
    cards << new_card #pushes new card, but what is new_card? I suppose the deal_one method will be thrown as an arg for this.
  end

  def busted?
    total > 21 #returns a boolean true if total is greater than 21
  end
end

class Participant # superclass, subclasses are player and dealer
  include Hand #hand behaviors are inherited and can be used. add_card, busted, total, and show_hand

  attr_accessor :name, :cards # both player and dealer has these
  def initialize
    @cards = [] #container for the cards drawn
    set_name #set name for both player and dealer
  end
end

class Player < Participant
  def set_name #different set name method for player and dealer (cpu)
    name = ''
    loop do
      puts "What's your name?"
      name = gets.chomp
      break unless name.empty?
      puts "Sorry, must enter a value."
    end
    self.name = name
  end

  def show_flop #shows hands, I do not understand the necessity for this method.
    show_hand
  end
end

class Dealer < Participant
  ROBOTS = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5']

  def set_name
    self.name = ROBOTS.sample #selects a random name for dealer(cpu)
  end

  def show_flop # a different behavior? because it's enemy i suppose we can't see all of their cards
    puts "---- #{name}'s Hand ----"
    puts "#{cards.first}"
    puts " ?? "
    puts ""
  end
end

class TwentyOne
  attr_accessor :deck, :player, :dealer

  def initialize # class 21 has 3 collaborator objects each assigned to an instance variable with their class name.
    @deck = Deck.new # a new random deck of 52 cards
    @player = Player.new # a player and dealer object that both inherits from participant which inherits the hands module.
    @dealer = Dealer.new
  end

  def reset # if player decides to play again, program refreshes for a new game
    self.deck = Deck.new
    player.cards = []
    dealer.cards = []
  end

  def deal_cards
    2.times do
      player.add_card(deck.deal_one) # yeah, so deal_one is the argument for add card, which takes a card from Deck, and then pushes it to the cards array for player.
      dealer.add_card(deck.deal_one)
    end
  end

  def show_flop # shows cards
    player.show_flop
    dealer.show_flop
  end

  def player_turn
    puts "#{player.name}'s turn..."

    loop do
      puts "Would you like to (h)it or (s)tay?"
      answer = nil
      loop do
        answer = gets.chomp.downcase
        break if ['h', 's'].include?(answer)
        puts "Sorry, must enter 'h' or 's'."
      end

      if answer == 's'
        puts "#{player.name} stays!"
        break
      elsif player.busted? #checks if the new card exceeds 21
        break # breaks if true
      else
        # show update only for hit
        player.add_card(deck.deal_one) #adds card
        puts "#{player.name} hits!"
        player.show_hand #show hand so that user can see their cards
        break if player.busted? #ruby verifies if busted
      end
    end
  end

  def dealer_turn
    puts "#{dealer.name}'s turn..."

    loop do
      if dealer.total >= 17 && !dealer.busted? #cpu behavior is to just see if their cards are greater or equal to 17. If dealer busted, statement is false
        puts "#{dealer.name} stays!"
        break
      elsif dealer.busted? #checks for bust
        break
      else
        puts "#{dealer.name} hits!"
        dealer.add_card(deck.deal_one) #adds card but won't show, overall similar behavior to player turn
      end
    end
  end

  def show_busted #outputs message if busted returns true for either player or dealer
    if player.busted?
      puts "It looks like #{player.name} busted! #{dealer.name} wins!"
    elsif dealer.busted?
      puts "It looks like #{dealer.name} busted! #{player.name} wins!"
    end
  end

  def show_cards #i don't understand why show flop and show cards are here
    player.show_hand
    dealer.show_hand
  end

  def show_result #shows cards if player/dealer decides to stay.
    if player.total > dealer.total
      puts "It looks like #{player.name} wins!"
    elsif player.total < dealer.total
      puts "It looks like #{dealer.name} wins!"
    else
      puts "It's a tie!"
    end
  end

  def play_again? #prompts player for another round
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if ['y', 'n'].include? answer
      puts "Sorry, must be y or n."
    end

    answer == 'y'
  end

  def start
    loop do
      system 'clear'
      deal_cards
      show_flop

      player_turn #most of the heavy lifting is here
      if player.busted? #this body of code is ran if the player busts and prompts for another round
        show_busted
        if play_again?
          reset
          next
        else
          break
        end
      end

      dealer_turn #cpu heavy lifting is here
      if dealer.busted? #similar to the code above but if computer busts
        show_busted
        if play_again?
          reset
          next
        else
          break
        end
      end

      # both stayed
      show_cards # if no one busts and both stays, this final code runs.
      show_result
      play_again? ? reset : break
    end

    puts "Thank you for playing Twenty-One. Goodbye!"
  end
end

game = TwentyOne.new
game.start