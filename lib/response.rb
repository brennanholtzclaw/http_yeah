class Response

  def initialize(request_lines)
    @parsed = Parsed.new(request_lines)
  end

  def respond
    request.request_counter += 1
    case parsed.path
    when "/"
      parsed_template
    when "/hello"
      request.hello_counter += 1
      "Hello, World! #{request.hello_counter}"
    when "/datetime"
      formatted_time
    when "/shutdown"
      "Total Requests: #{request.request_counter}"
    end    
  end
  # 11:07AM on Sunday, October November 1, 2015.

  def formatted_time
    t = Time.new
    t.strftime("%l:%M%p on %A, %B%e, %Y")
  end

  def parsed_template
  "Verb: #{parsed.verb}
  Path: #{parsed.path}
  Protocol: #{parsed.protocol}
  Host: #{parsed.host}
  Port: #{parsed.port}
  Origin: #{parsed.origin}
  Accept: #{parsed.accept}"
  end
end