class Parsed
  attr_reader :request_lines

  def initialize(request_lines)
    @request_lines = request_lines
  end


  def parsed_template

  "Verb: #{verb}
  Path: #{path}
  Protocol: #{protocol}
  Host: #{host}
  Port: #{port}
  Origin: #{origin}
  Accept: #{accept}"
  end

  def verb
    request[0].split[0]
  end

  def path
    request[0].split[1]
  end

  def protocol
    request[0].split[2]
  end

  def host
    request[1].split[1][0..-6]
  end

  def port
    request[1][-4..-1]
  end

  def origin
    request[1].split[1][0..-6]
  end

  def accept
    request[2].split[1]
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