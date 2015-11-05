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
    "<pre>#{respond(@server)}</pre>"
  end

  def output_path_body
    "<html><head></head><body><pre>#{respond(@server)}</pre></body></html>"
  end

  def header_paths
    if @parsed.path == "/game" && @parsed.verb == "POST"
      header_template("303 Temprary Redirect", "http://127.0.0.1:9292/game")
    elsif @parsed.path == "/new_game" && @parsed.verb == "POST" && @server.new_game.nil?
      header_template("307 Redirect", "http://127.0.0.1:9292/start_game")
    elsif @parsed.path == "/new_game" && !@server.new_game.nil?
      header_template("403 Forbidden")
    elsif good_paths.include?(@parsed.path)
      ok_header_template
    elsif @parsed.path == "/force_error"
      raise SystemError
    else
      header_template("404 Page Not Found")
    end
  end

  def ok_header_template
    ["http/1.1 200 ok",
      "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
      "server: ruby",
      "content-type: text/html; charset=iso-8859-1",
      "content-length: #{output_path_body.length + 1}\r\n\r\n"].join("\r\n")
  end

  def header_template(code, location="http://127.0.0.1:9292")
    ["HTTP/1.1 #{code}",
    "Location: #{location}\r\n\r\n"].join("\r\n")
  end

  def good_paths
    ["/", "/hello", "/shutdown", "/start_game", "/datetime", "/word_search", "/game"]
  end

  def response_compiler(object)
    #
    if @parsed.path == "/game" && @parsed.verb == "POST"
      post_response(object)
      "#{header_paths}"
    else
    "#{header_paths}\n#{output_path_body}"
    end
  end

  def respond(object)
    #
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
      # if object.game_counter == 0
      # "You've taken #{object.game_counter} guesses."
      # else
        "You've taken #{object.game_counter} guesses.Your last guess was... #{object.new_game.guessed_number}, which is #{object.new_game.guess(object.new_game.guessed_number)}"
      # end
    end
  end



  def post_response(object)
    if @parsed.path == "/start_game"
      "Good Luck!"
    elsif @parsed.path == "/game"
      object.new_game.guessed_number = object.body_params[3]
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
