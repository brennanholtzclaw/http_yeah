require_relative 'parsed'
require_relative 'http_server'
require_relative 'game'
require 'pry'

class Response
  attr_reader :parsed
  attr_accessor :new_game

  def initialize(request_lines, server)
    @parsed = Parsed.new(request_lines)
    @server = server
  end

  def output_path
    body_response = "<pre>#{respond(@server)}</pre>"
    "<html><head></head><body>#{body_response}</body></html>"
  end

  def header_paths
    if @parsed.path == "/game" && @parsed.verb == "POST"
      ["HTTP/1.1 303 Temporary Redirect",
      "Location: http://127.0.0.1:9292/game\r\n\r\n"].join("\r\n")
    else
    ["http/1.1 200 ok",
      "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
      "server: ruby",
      "content-type: text/html; charset=iso-8859-1",
      "content-length: #{output_path.length - 9}\r\n\r\n"].join("\r\n")
    end
  end

  def response_compiler(object)
    # binding.pry
    if @parsed.path == "/game" && @parsed.verb == "POST"
      post_response(object)
      "#{header_paths}"
    else
    "#{header_paths}\n#{output_path}"
    end
  end

# unless @parsed.path == "/game" && @parsed.verb == "POST"

  def respond(object)
    binding.pry
    object.request_counter += 0.5
    if @parsed.verb == "GET"
      get_response(object)
    elsif @parsed.verb == "POST"
      post_response(object)
    end
  end


  def get_response(object)
    case @parsed.path
    when "/"
      parsed_template
    when "/hello"
      object.hello_counter += 0.5
      "Hello, World! #{object.hello_counter}"
    when "/datetime"
      formatted_time
    when "/shutdown"
      "Total Requests: #{object.request_counter}"
    when "/word_search"
      word_lookup
    when "/game"
      "You've taken #{object.new_game.counter} guesses. Your last guess was... #{object.new_game.guessed_number}, which is #{object.new_game.guess(object.new_game.guessed_number)}"
    end
  end

  def post_response(object)
    binding.pry
    if @parsed.path == "/start_game"
      "Good Luck!"
    elsif @parsed.path == "/game"
      binding.pry
      object.new_game.counter += 1
      object.new_game.guess(@parsed.value)

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
