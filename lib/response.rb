require_relative 'parsed'
require_relative 'http_server'
require_relative 'game'
require 'pry'

class Response
  attr_reader :parsed
  attr_accessor :hello_counter, :request_counter

  def initialize(request_lines)
    @parsed = Parsed.new(request_lines)
  end


  def respond(object)
    object.request_counter += 1
    if @parsed.verb == "GET"
      get_response(object)
    elsif @parsed.verb == "POST"
      post_response
    end
  end

  def post_response

    if @parsed.path == "/start_game"
      new_game = Game.new
      "Good Luck! You've guessed #{new_game.counter} times."
    elsif @parsed.path == "/game"
      binding.pry
      new_game.counter += 1
      new_game.guess = @parsed.value
      "Send a GET message to see if you are right"
    end
  end

  def get_response(object)
    case @parsed.path
    when "/"
      parsed_template
    when "/hello"
      object.hello_counter += 1
      "Hello, World! #{object.hello_counter}"
    when "/datetime"
      formatted_time
    when "/shutdown"
      "Total Requests: #{object.request_counter}"
    when "/word_search"
      word_lookup
    end
  end

  def word_lookup
    if @parsed.parameter == "word"
      dictionary = File.read("/usr/share/dict/words").split("\n")
      if dictionary.include?(@parsed.value)
        return "#{@parsed.value} is a word."
      else
        return "#{@parsed.value} is not a known word."
      end
    end
  end
  # 11:07AM on Sunday, October November 1, 2015.

  def formatted_time
    t = Time.new
    t.strftime("%l:%M%p on %A, %B%e, %Y")
  end

  def parsed_template
 "Verb: #{@parsed.verb}
 Path: #{@parsed.path}
 Protocol: #{@parsed.protocol}
 Host: #{@parsed.host}
 Port: #{@parsed.port}
 Origin: #{@parsed.origin}
 Accept: #{@parsed.accept}"
  end
end