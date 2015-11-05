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
      request_lines = []

      while line = @client.gets and !line.chomp.empty?
        request_lines << line.chomp
      end

      @responder = Response.new(request_lines, self)

      if @responder.parsed.path == "/start_game" && @responder.parsed.verb == "POST"
        @new_game = Game.new
      end

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
      @client.puts @responder.response_compiler(self)

      break if @responder.parsed.path == "/shutdown"

      @client.close
    end
  end
end


if __FILE__ == $0
  request = Server.new
  request.read_request
end
