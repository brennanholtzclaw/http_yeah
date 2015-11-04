require 'minitest/autorun'
require 'minitest/pride'
require './lib/game'

class GameTest < Minitest::Test

  def test_you_can_start_a_game
    assert Game.new
  end

  def test_a_new_game_starts_with_0_for_guessed_number
    game = Game.new

    assert_equal 0, game.guessed_number
  end

  def test_that_you_can_guess_a_number
    game = Game.new
    game.guess(3)

    assert_equal 3, game.guessed_number
  end

  def test_that_the_counter_increases
    game = Game.new
    game.guess(3)

    assert_equal 1, game.counter
  end

  def test_you_can_specify_a_correct_number
    game = Game.new(3)

    assert_equal 3, game.correct_number
  end

  def test_game_tells_you_if_guess_is_high_or_low
    game = Game.new(5)

    too_high = "Too low!"
    assert_equal too_high, game.guess(9)


    too_low = "Too high!"
    assert_equal too_low, game.guess(1)

    just_right = "CORRECT!"
    assert_equal just_right, game.guess(5)
  end

end
