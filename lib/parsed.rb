require_relative 'http_server'
require_relative 'response'
require 'pry'

class Parsed
  attr_reader :request_lines

  def initialize(request_lines)
    @request_lines = request_lines
    # @request = @request_lines[0]
    # @host = @request_lines[1]
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
    request_lines[0].split[0]
  end

  def path
    initial = request_lines[0].split[1]
    if initial.include?("?")
      initial.split("?")[0]
    else
      initial
    end
  end

  def parameter
    request_lines[0].split[1].split("?")[1].split("=")[0]
    #/pizza?topping=pepperoni&crust=thin
    # url encoding
    # enocde --> turn this into browser safe
    # /pizza%20%topping%d0%pepperoni
    # parse --> turn this into something i can manipulate
  end

  def value
    request_lines[0].split[1].split("?")[1].split("=")[1]
  end

  def protocol
    request_lines[0].split[2]
  end

  def host
    request_lines[1].split[1][0..-6]
  end

  def port
    request_lines[1][-4..-1]
  end

  def origin
    request_lines[1].split[1][0..-6]
  end

  def accept
    request_lines[2].split[1]
  end

  # def parsed(request_lines)
  #   verb = request[0].split[0]
  #   path = request[0].split[1]
  #   protocol = request[0].split[2]
  #   host_line = request[1].split[1][0..-6]
  #   port = request[1][-4..-1]
  #   origin = request[1].split[1][0..-6]
  #   accept_line = request[2]
  #
  #   [verb, path, protocol, host_line, port, origin, accept_line]
  # end

end