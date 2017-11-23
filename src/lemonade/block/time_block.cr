require "./base"

module Lemonade::Block
  class TimeBlock < BaseBlock
    def initialize(@format = "%H:%M")
    end

    def render(io)
      io << Time.now.to_s(@format)
    end
  end
end
