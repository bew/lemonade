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
    @blocks = [] of Block::Base

    setter spacer : Block::Base?

    def <<(block)
      if !@blocks.empty? && (spacer = @spacer)
        @blocks << spacer
      end
      @blocks << block
    end

    def next_bar
      io = IO::Memory.new

      @blocks.each do |block|
        block.render io
      end

      io.to_s
    end
  end

end
