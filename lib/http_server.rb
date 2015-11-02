require 'socket'
# require 'open-uri'
require 'pry'
counter = -1



tcp_server = TCPServer.new(9292)


client = tcp_server.accept


puts "Ready for a request"
request_lines = []
  while line = client.gets and !line.chomp.empty?
    request_lines << line.chomp
  end

def parsed_template(request_lines)
  # binding.pry
  "
Verb: #{parsed(request_lines)[0]}
Path: #{parsed(request_lines)[1]}
Protocol: #{parsed(request_lines)[2]}
#{parsed(request_lines)[3]}
Port: #{parsed(request_lines)[4]}
Origin: #{parsed(request_lines)[5]}
#{parsed(request_lines)[6]}
"
end

  def parsed(request)
    verb = request[0].split[0]
    path = request[0].split[1]
    protocol = request[0].split[2]
    host_line = request[1].split[1][0..-6]
    port = request[1][-4..-1]
    origin = request[1].split[1][0..-6]
    accept_line = request[2]

    [verb, path, protocol, host_line, port, origin, accept_line]
  #     verb,
  #   #hash[path:] =
  #   request[0].split[1],
  #   # hash[protocol:] =
  #   request[0].split[2],
  #   # host_line:
  #   request[1].split[1][0..-6],
  #   # port:
  #   request[1][-4..-1],
  #   # origin:
  #   request[1].split[1][0..-6],
  #   # accept_line:
  #   request[2]
  # ]

  end




  puts "Got this request:"
  puts request_lines.inspect
  counter += 1
  puts "Sending response."
  # binding.pry
  response = "<pre>" + parsed_template(request_lines) + "</pre>"
  output = "<html><head></head><body>#{response}</body></html>"
  headers = ["http/1.1 200 ok",
            "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
            "server: ruby",
            "content-type: text/html; charset=iso-8859-1",
            "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  client.puts headers
  client.puts output




puts ["Wrote this response:", headers, output].join("\n")
# client.close
puts "\nResponse complete, exiting."


