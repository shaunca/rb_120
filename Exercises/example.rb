class Art

  def initialize
    @array = []
  end

  def produce_art
    @array.each do |obj|
      puts obj.create
    end
  end

  def <<(arg)
    @array << arg
  end
end

class WatercolorArtist
  def create
    "I paint art using watercolor!"
  end
end

class Draftsman
  def create
    "I draw and sketch!"
  end
end

class DigitalArtist
  def create
    "I create art using digital applications!"
  end
end

arts = Art.new
arts << Draftsman.new
arts << WatercolorArtist.new
arts << DigitalArtist.new

arts.produce_art