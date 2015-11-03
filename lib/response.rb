require_relative 'parsed'
require_relative 'http_server'
require 'pry'

class Response
  attr_reader :parsed
  attr_accessor :hello_counter, :request_counter

  def initialize(request_lines)
    # @hello_counter = -1
    # @request_counter = 0
    @parsed = Parsed.new(request_lines)
  end


  # def request_counter
  #   0
  # end

  # def respond
  #   # request_counter
  #   case @parsed.path
  #   when "/"
  #     parsed_template
  #   when "/hello"
  #     "Hello, World! #{hello_counter}"
  #     # "Hello World!"
  #   when "/datetime"
  #     formatted_time
  #   when "/shutdown"
  #     "Total Requests: #{request_counter}"
  #   # when "/word_search" && parsed.verb == GET && parsed.parameter == "word"
  #   #   if File.read("/usr/share/dict/words").include?(parsed.value)
  #   #
  #   end
  # end
  # 11:07AM on Sunday, October November 1, 2015.

  def formatted_time
    t = Time.new
    t.strftime("%l:%M%p on %A, %B%e, %Y")
  end

  def parsed_template
  "Verb: #{@parsed.verb}
  Path: #{@parsed.path}
  Protocol: #{@parsed.protocol}
  Host: #{@parsed.host}
  Port: #{@parsed.port}
  Origin: #{@parsed.origin}
  Accept: #{@parsed.accept}"
  end
end