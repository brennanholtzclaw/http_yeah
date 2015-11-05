require 'socket'
require 'net/http'
require 'pry'
require_relative 'request'
require_relative 'parsed'
require_relative 'response'


class Server
  attr_accessor :hello_counter,
                :request_counter,
                :responder,
                :new_game,
                :client,
                :tcp_server,
                :game_counter

  attr_reader :request,
              :tcp_server,
              :body_params

  def initialize
    @hello_counter   = -1
    @request_counter = 0
    @tcp_server      = TCPServer.new(9292)
    @game_counter    = 0
  end

  def read_request
    loop do
      @client = tcp_server.accept

      puts "Ready for a request"

      generate_and_send_response

      break if @responder.parsed.path == "/shutdown"

      @client.close
    end
  end
end

def generate_and_send_response
  headers_from_request

  start_new_game

  body_parameters

  send_response
end

def send_response
  begin
    @client.puts @responder.response_compiler(self)
  rescue => detail
    response = "<pre>#{detail.backtrace.join("\n")}</pre>".delete!("<main>")
    output = "<html><head></head><body>#{response}</body></html>"
    headers = ["http/1.1 500 Error",
      "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
      "server: ruby",
      "content-type: text/html; charset=iso-8859-1",
      "content-length: #{output.length}\r\n\r\n"].join("\r\n")
      @client.puts headers
      @client.puts output
    end
  end

def start_new_game
  if @responder.parsed.path == "/start_game"&& @responder.parsed.verb == "POST"
    @new_game = Game.new
  end
end

def headers_from_request
  request_lines = []

  while line = @client.gets and !line.chomp.empty?
    request_lines << line.chomp
  end

  @responder = Response.new(request_lines, self)
end

def body_parameters
  if @responder.parsed.path == "/game" && @responder.parsed.verb == "POST"
    @game_counter += 1
    web_kit_counter = 0
    @body_params = []

    until web_kit_counter == 2
      line = @client.gets
      @body_params << line.chomp

      if line.start_with?("------WebKitFormBoundary")
        web_kit_counter += 1
      end
    end
  end
end


if __FILE__ == $0
  request = Server.new
  request.read_request
end
