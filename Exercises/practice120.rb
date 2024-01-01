class Dog
  def speak(pet)
    puts "I, #{self}, can say #{bark}"
    puts "I, #{pet}, can not say `pet.bark`"
    puts pet.bark
  end

  private

  def bark
    "Bark! Bark! Bark!"
  end
end

rex = Dog.new
rex.speak(rex)