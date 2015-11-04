require 'minitest/autorun'
require 'minitest/pride'
require './lib/parsed'

class ParsedTest < Minitest::Test
  def setup
    sample_request = ["GET /pizza?topping=pepperoni HTTP/1.1", "Host: 127.0.0.1:9292",
                      "Accept: text/html,application/xhtml+xml, application/xml;q=0.9,*/*;q=0.8",
                      "Accept-Language: en-us", "Connection: keep-alive",
                      "Accept-Encoding: gzip, deflate",
                      "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/601.2.7 (KHTML, like Gecko) Version/9.0.1 Safari/601.2.7"]


    @parsed = Parsed.new(sample_request)
  end

  def test_verb_is_parsed_from_incoming_array
    assert_equal "GET", @parsed.verb
  end

  def test_path_is_parsed_from_incoming_array
    assert_equal "/pizza", @parsed.path
  end

  def test_protocol_is_parsed_from_incoming_array
    assert_equal "HTTP/1.1", @parsed.protocol
  end

  def test_host_is_parsed_from_incoming_array
    assert_equal "127.0.0.1", @parsed.host
  end

  def test_port_is_parsed_from_incoming_array
    assert_equal "9292", @parsed.port
  end

  def test_origin_is_parsed_from_incoming_array
    assert_equal "127.0.0.1", @parsed.origin
  end

  def test_accept_is_parsed_from_incoming_array
    accept = "text/html,application/xhtml+xml, application/xml;q=0.9,*/*;q=0.8"
    assert_equal accept, @parsed.accept
  end

  def test_accept_encoding_is_parsed_from_incoming_array
    assert_equal "gzip, deflate", @parsed.accept_encoding
  end


end
