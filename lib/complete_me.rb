class CompleteMe

  def initialize
    @root = ""
    @autocomplete = {}
    @dictionary = []
  end

  def parsed_word(word)
    length = word.length
    arr = []
    counter = 0
    loop do
      arr << word[0..counter]
      counter += 1
      break if counter == length
    end
    arr
  end

  def create_links(word)
    length = word.length
    counter = 0
    arr = parsed_word(word)
    loop do
      arr[-1] = arr[-1] + "*"
      if @autocomplete[arr[counter]] == true
        autocomplete[arr[counter]] += arr[counter..-1]
      else
        @autocomplete[arr[counter]] = arr[counter..-1]
        counter += 1
      end
      break if counter == length
    end
    @autocomplete
  end

  def find(prefix)
    possible_words = @autocomplete[prefix]
    actual_words = possible_words.map do |word|
      if word.include?("*")
        word
      end
    end
    binding.pry
    actual_words.compact.delete("*")
  end
end
