require "./block/base"
require "./color"

module Lemonade
  module Block
    class Container < CachedBlock
      property blocks = [] of BaseBlock
      property? separator : BaseBlock?

      def <<(block)
        block.parents << self
        @blocks << block
        dirty!

        self
      end

      def dirty?
        @blocks.any? &.dirty? || ((sep = @separator) && sep.dirty?) || super
      end

      # Do we want that? We can't ensure that it will put everything in dirty state.
      # def dirty!
      #   @blocks.each &.dirty!
      # end

      def render(io)
        separator = @separator

        @blocks.each_with_index do |block, i|
          if i > 0 && separator
            separator.redraw io
          end
          block.redraw io
        end
      end
    end

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

    class ClockBlock < BaseBlock
      def initialize(@format = "%H:%M")
      end

      def render(io)
        io << Time.now.to_s(@format)
      end
    end

    class TextSpacerBlock < CachedBlock
      def initialize(@size = 1)
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
end
