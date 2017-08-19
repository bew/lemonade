require "./blocks"

module Lemonbar
  class BarProvider
    include Iterator(String)

    def initialize(@bar : Bar)
    end

    def next
      if bla = @bar.next_bar
        bla
      else
        stop
      end
    end
  end

  class Bar
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

end
