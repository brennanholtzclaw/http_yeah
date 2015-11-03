require 'socket'

class Request
  attr_accessor :hello_counter, :request_counter

  def initialize
    @hello_counter = -1
    @request_counter = 0
    tcp_server = TCPServer.new(9292)
    response = Response.new(read_request)
  end

  def read_request
  client = tcp_server.accept
  puts "Ready for a request"
  request_lines = []
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    request_lines
  end

  def procedure
    loop do
      #response.respond - add to response mechanism/class
      break if response.parsed.path == "/shutdown"
    end
  end
end


