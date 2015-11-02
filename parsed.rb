class Parsed
  attr_reader :request_lines

  def initialize(request_lines)
    @request_lines = request_lines
  end


  def parsed_template

  "Verb: #{parsed(request_lines)[0]}
  Path: #{parsed(request_lines)[1]}
  Protocol: #{parsed(request_lines)[2]}
  #{parsed(request_lines)[3]}
  Port: #{parsed(request_lines)[4]}
  Origin: #{parsed(request_lines)[5]}
  #{parsed(request_lines)[6]}"

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
  end

end