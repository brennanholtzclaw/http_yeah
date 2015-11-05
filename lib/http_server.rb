require 'socket'
require 'net/http'
# require 'open-uri'
require 'pry'
require_relative 'request'
require_relative 'parsed'
require_relative 'response'


class Server
  attr_accessor :hello_counter,
                :request_counter,
                :responder,
                :new_game
                :client
                :tcp_server

  attr_reader :request,
              :tcp_server,
              :body_params

  def initialize
    # @tcp_server = TCPServer.new(9292)
    # @response = Response.new(read_request)
    # @client = @tcp_server.accept
    @hello_counter   = -1
    @request_counter = 0
    @tcp_server      = TCPServer.new(9292)
  end

  def read_request
    loop do
      @client = tcp_server.accept

      puts "Ready for a request"
      # # loop do
      request_lines = []

      while line = @client.gets and !line.chomp.empty?
        request_lines << line.chomp
      end


        # binding.pry
        # while line = @client.gets and !line.chomp.empty? and empty_line < 3
        #   empty_line += 1 if line == "\r\n"
        #   # binding.pry
        #   # puts line
        #   request_lines << line.chomp



      # end

      @responder = Response.new(request_lines, self)

      if @responder.parsed.path == "/start_game" && @responder.parsed.verb == "POST"
        @new_game = Game.new
      end

      if @responder.parsed.path == "/game" && @responder.parsed.verb == "POST"
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

  # response = "<pre> #{@responder.respond(self)}  </pre>"
  # output = "<html><head></head><body>#{response}</body></html>"
  # headers = ["http/1.1 200 ok",
  #           "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
  #           "server: ruby",
  #           "content-type: text/html; charset=iso-8859-1",
  #           "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  # client.puts headers

#GET / HTTP/1.1

  #
  # def procedure
  #   loop do
  #     generate_http_response
  #     break if response.parsed.path == "/shutdown"
  #   end
  # end
#
  # def generate_http_response
    # puts "Got this request:"
    # puts request_lines.inspect
    # puts "Sending response."
    # binding.pry
  #   response = "<pre>" + @response.respond + "</pre>"
  #   output = "<html><head></head><body>#{response}</body></html>"
  #   headers = ["http/1.1 200 ok",
  #             "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
  #             "server: ruby",
  #             "content-type: text/html; charset=iso-8859-1",
  #             "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  #   @client.puts headers
  #   @client.puts output
  # end
end


if __FILE__ == $0
  request = Server.new
  request.read_request
end
