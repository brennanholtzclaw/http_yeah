class Game
  attr_accessor :counter, :guessed_number
  attr_reader :number

  def initialize
    @counter = 0
    @number = rand(1..10)
    @guessed_number = 0
  end
end