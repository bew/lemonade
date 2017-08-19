require "./block/base"
require "./color"

module Lemonbar
  module Block
    class Container < CachedBlock
      property blocks = [] of BaseBlock
      property? separator : CachedBlock?

      forward_missing_to @blocks

      def dirty?
        @blocks.any? &.dirty?
      end

      def cached_render(io)
        puts "rendering container"
        @blocks.each_with_index do |block, i|
          if i > 0 && (separator = separator?)
            separator.render io
          end
          block.render io
        end
      end
    end

    class TextBlock < CachedBlock
      @bg : Color?
      @fg : Color?

      def initialize(@text : String, @bg = nil, @fg = nil)
      end

      def cached_render(io)
        if fg = @fg
          io << "%{F" << fg.to_s << "}"
        end

        if bg = @bg
          io << "%{B" << bg.to_s << "}"
        end

        io << @text

        io << "%{B}" if @bg
        io << "%{F}" if @fg
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
