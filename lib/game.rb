class Game
  attr_accessor :counter, :guessed_number
  attr_reader :correct_number

  def initialize(correct_number = rand(1..10))
    @counter = 0
    @correct_number = correct_number
    @guessed_number = 0
  end

  def guess(number)
    @counter += 1
    @guessed_number = number
    if @guessed_number < @correct_number
      return "That guess was too low"
    elsif @guessed_number > @correct_number
      return "That guess was too high"
    else
      return "That's correct!"
    end
  end




end
