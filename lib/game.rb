require "pry"
class Game
  attr_accessor :counter, :guessed_number
  attr_reader :correct_number

  def initialize(correct_number = rand(1..10))
    @correct_number = correct_number
    @guessed_number = 0
  end

  def guess(number = @guessed_number)
        # @guessed_number = number
    if number.to_i < @correct_number
      return "Too low!"
    elsif number.to_i > @correct_number
      return "Too high!"
    else
      return "CORRECT!"
    end
  end
end
