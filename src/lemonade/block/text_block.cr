require "./base"

module Lemonade::Block
  class TextBlock < CachedBlock
    def initialize(@text : String)
    end

    def text=(@text)
      dirty!
    end

    def render(io)
      io << @text
    end
  end
end
