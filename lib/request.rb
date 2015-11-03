require 'socket'

class Request
  attr_accessor :hello_counter, :request_counter

  def initialize
    @hello_counter = -1
    @request_counter = 0
    tcp_server = TCPServer.new(9292)
    client = tcp_server.accept
  end

  def read_request
  puts "Ready for a request"
  request_lines = []
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    request_lines
  end

end


if __FILE__
  request = Request.new.read_request
end