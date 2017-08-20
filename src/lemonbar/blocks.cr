require "./block/base"
require "./color"

module Lemonbar
  module Block
    class Container < CachedBlock
      property blocks = [] of BaseBlock
      property? separator : CachedBlock?

      forward_missing_to @blocks

      def dirty?
        @blocks.any? &.dirty? || ((sep = @separator) && sep.dirty?) || @dirty
      end

      def cached_render(io)
        separator = @separator

        @blocks.each_with_index do |block, i|
          if i > 0 && separator
            separator.render io
          end
          block.render io
        end
      end
    end

    class TextBlock < CachedBlock
      def initialize(@text : String)
      end

      def cached_render(io)
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

      def cached_render(io)
        io << " " * @size
      end
    end

    class OffsetBlock < CachedBlock
      def initialize(@offset_px = 10)
      end

      def cached_render(io)
        io << "%{O" << @offset_px << "}"
      end
    end
  end
end
