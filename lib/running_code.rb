require 'socket'
require 'pry'
require_relative 'parsed'
require_relative 'response'
require_relative 'http_server'
require_relative 'complete_me'

@request_counter = 0
@hello_counter = -1
@request = Server.new

tcp_server = TCPServer.new(9292)

def respond
  @request_counter += 1
 case @responder.parsed.path
 when "/"
   @responder.parsed_template
 when "/hello"
   @hello_counter += 1
   "Hello, World! #{@hello_counter}"
   # "Hello World!"
 when "/datetime"
   @responder.formatted_time
 when "/shutdown"
   "Total Requests: #{@request_counter}"
 when "/word_search"
   binding.pry
   if File.read("/usr/share/dict/words").include?(@responder.parsed.value)
     "#{@responder.parsed.value} is a known word fragment"
   else
     "#{@responer.parsed.value} is not a known word"
   end
 #
 end
end


loop do
  client = tcp_server.accept
  puts "Ready for a request"
  request_lines = []
  while line = client.gets and !line.chomp.empty?
    request_lines << line.chomp
  end
  @responder = Response.new(request_lines)

  response = "<pre>" + respond + "</pre>"
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





