require 'minitest/autorun'
require 'minitest/pride'
require './lib/response'
require './lib/parsed'
require 'pry'

class ResponseClassTest < Minitest::Test
  def get_response_prep
    sample_request = ["GET / HTTP/1.1", "Host: 127.0.0.1:9292",
                      "Accept: text/html,application/xhtml+xml, application/xml;q=0.9,*/*;q=0.8",
                      "Accept-Language: en-us", "Connection: keep-alive",
                      "Accept-Encoding: gzip, deflate",
                      "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/601.2.7 (KHTML, like Gecko) Version/9.0.1 Safari/601.2.7"]

    @response = Response.new(sample_request)
  end

  def test_parsed_template
      get_response_prep

      expectation = "Verb: GET\n Path: /\n Protocol: HTTP/1.1\n Host: 127.0.0.1\n Port: 9292\n Origin: 127.0.0.1\n Accept: text/html,application/xhtml+xml, application/xml;q=0.9,*/*;q=0.8"
# binding.pry
      assert_equal expectation, @response.parsed_template
  end

end