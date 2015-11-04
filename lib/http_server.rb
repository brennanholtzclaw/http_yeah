require 'socket'
# require 'open-uri'
require 'pry'
require_relative 'request'
require_relative 'parsed'
require_relative 'response'
counter = -1

class Server
  attr_accessor :hello_counter, :request_counter, :responder
  attr_reader :request

  def initialize
    # @tcp_server = TCPServer.new(9292)
    # @response = Response.new(read_request)
    # @client = @tcp_server.accept
    @hello_counter = -1
    @request_counter = 0
  end

  def read_request
    tcp_server = TCPServer.new(9292)
    loop do
    client = tcp_server.accept
    # loop do
  puts "Ready for a request"
  request_lines = []
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    @responder = Response.new(request_lines)
    response = "<pre>" + @responder.respond(self) + "</pre>"
    output = "<html><head></head><body>#{response}</body></html>"
    headers = ["http/1.1 200 ok",
              "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
              "server: ruby",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    client.puts headers
    client.puts output
    break if @responder.parsed.path == "/shutdown"
    end
  end



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
  @request = Server.new
  @request.read_request
end

