require 'minitest/autorun'
require 'minitest/pride'
require './lib/response'
require './lib/parsed'
require 'pry'

class ResponseClassTest < Minitest::Test
  def get_response_prep(verb = "GET", path = "/")
    sample_request = ["#{verb} #{path} HTTP/1.1", "Host: 127.0.0.1:9292",
                      "Accept: text/html,application/xhtml+xml, application/xml;q=0.9,*/*;q=0.8",
                      "Accept-Language: en-us", "Connection: keep-alive",
                      "Accept-Encoding: gzip, deflate",
                      "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/601.2.7 (KHTML, like Gecko) Version/9.0.1 Safari/601.2.7"]

    @response = Response.new(sample_request)
  end

  def test_parsed_template
      get_response_prep

      expectation = "Verb: GET\n Path: /\n Protocol: HTTP/1.1\n Host: 127.0.0.1\n Port: 9292\n Origin: 127.0.0.1\n Accept: text/html,application/xhtml+xml, application/xml;q=0.9,*/*;q=0.8"
      assert_equal expectation, @response.parsed_template
  end

  def test_root_path_responds_with_template
    get_response_prep

    assert_equal @response.parsed_template, @response.respond(Server.new) #passed Server.new to simulate object.
  end

  def test_hello_path_returns_hello_string
    a = get_response_prep("GET", "/hello")

    s = Server.new
    s.responder = a

    assert_equal "Hello, World! 0", s.responder.respond(s)
  end

  def test_hello_counter_increments
    a = get_response_prep("GET", "/hello")

    s = Server.new
    s.responder = a

    assert_equal "Hello, World! 0", s.responder.respond(s)
    assert_equal "Hello, World! 1", s.responder.respond(s)
    refute_equal "Hello, World! 0", s.responder.respond(s)
    assert_equal "Hello, World! 3", s.responder.respond(s)
  end

  def test_datetime_returns_time_now
    a = get_response_prep("GET", "/datetime")

    s = Server.new
    s.responder = a

    t = Time.new

    assert_equal t.strftime("%l:%M%p on %A, %B%e, %Y"), s.responder.respond(s)
  end

  def test_shutdown_path_returns_1_initially
    a = get_response_prep("GET", "/shutdown")

    s = Server.new
    s.responder = a
    expectation = "Total Requests: 1"

    assert_equal expectation, s.responder.respond(s)
  end

  def test_shutdown_path_returns_1_initially
    a = get_response_prep("GET", "/shutdown")

    s = Server.new
    s.responder = a
    s.responder.respond(s)
    expectation = "Total Requests: 2"

    assert_equal expectation, s.responder.respond(s)
  end

  def test_word_search_returns_valid_or_invalid
      a = get_response_prep("GET", "/word_search?word=piz")

      s = Server.new
      s.responder = a
      s.responder.respond(s)
      expectation = "piz is not a known word."

      assert_equal expectation, s.responder.respond(s)
  end


end
