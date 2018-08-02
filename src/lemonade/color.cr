module Lemonade
  struct Color
    def self.new(color : Color)
      color
    end

    getter hex_code : String

    def initialize(color @hex_code : String)
    end

    def initialize(color)
      @hex_code = color.to_s
    end

    def to_s(io)
      io << @hex_code
    end

    def to_s
      @hex_code
    end
  end

  ColorReset = Color.new "-"
end
