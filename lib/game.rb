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

#################################
  # def post_response
  #   if @parsed.path == "/start_game"
  #     new_game = Game.new
  #     "Good Luck!"
  #   elsif @parsed.path == "/game"
  #     new_game.counter += 1
  #     new_game.guess(@parsed.value)
  #     ###this should be where the server sends a redirect for a GET to /game
  #     # "Send a GET message to see if you are right"
  #   end
  # end

###############################
  # def get_response(object)
  #   case @parsed.path
  #   when "/"
  #     parsed_template
  #   when "/hello"
  #     object.hello_counter += 1
  #     "Hello, World! #{object.hello_counter}"
  #   when "/datetime"
  #     formatted_time
  #   when "/shutdown"
  #     "Total Requests: #{object.request_counter}"
  #   when "/word_search"
  #     word_lookup
  #   when "/game"
  #     "You've taken #{counter} guesses. Your last guess was...\n #{guess}"
  #   end
  # end


#if server is sent POST /start_game it should initiate Game.new
#if server is sent POST /game with a value that is an integer between 1 and 10
  #that's a guess. The game should return appropriately and make the client
  #issue a GET to /game in order to see the message.


####################
##random thought - is that "+" error throwing because "<pre>" doesn't really
##contain anything? What if we formatted line 68 below as:
## response = "<pre> #{@responder.respond(self)}</pre>"
##might getting rid of the "+" solve the problem?
# @responder = Response.new(request_lines)
# response = "<pre>" + @responder.respond(self) + "</pre>"
# output = "<html><head></head><body>#{response}</body></html>"
# headers = ["http/1.1 200 ok",

end
