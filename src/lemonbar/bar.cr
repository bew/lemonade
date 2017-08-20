require "./blocks"

module Lemonbar
  abstract class BarProvider
    abstract def next_bar
  end

  class Bar < BarProvider
    getter left = Block::Container.new
    getter center = Block::Container.new
    getter right = Block::Container.new

    def next_bar
      io = IO::Memory.new

      unless left.empty?
        io << "%{l}"
        left.render io
      end

      unless center.empty?
        io << "%{c}"
        center.render io
      end

      unless right.empty?
        io << "%{r}"
        right.render io
      end

      io.to_s
    end
  end

  # Or implement this as a Block, with swappable blocks?
  # Or make like `Bar`, but with swappable left,center,right containers?
  #   => this could be done in `Bar`
  class SwappableBar
    property bar : BarProvider

    def initialize(@bar)
    end

    def next_bar
      @bar.next_bar
    end
  end
end
