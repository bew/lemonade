module Material
  record Color, hex_code : String do
    def to_s(io)
      io << hex_code
    end
  end

  # TODO: generate thoses
  Teal_500 = Color.new "#009688"
  Red_500  = Color.new "#f44336"
  Blue_500 = Color.new "#2196f3"

  White    = Color.new "#ffffff"
  Black    = Color.new "#000000"
end
