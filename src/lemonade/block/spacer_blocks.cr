require "./base"

module Lemonade::Block
  class TextSpacerBlock < CachedBlock
    def initialize(@size = 1)
      @size = 0 if @size < 0
    end

    def render(io)
      io << " " * @size
    end
  end

  class OffsetBlock < CachedBlock
    def initialize(px @offset_px = 10)
    end

    def render(io)
      io << "%{O" << @offset_px << "}"
    end
  end
end
