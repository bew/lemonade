require "./block/base"
require "./color"

module Lemonbar
  module Block
    class Container < Base
      property blocks = [] of Base
      property? separator : Base?

      forward_missing_to @blocks

      def render(io)
        @blocks.each_with_index do |block, i|
          if i > 0 && (separator = separator?)
            separator.render io
          end
          block.render io
        end
      end
    end

    class TextBlock < Base
      @bg : Color?
      @fg : Color?

      def initialize(@name : String, @bg = nil, @fg = nil)
      end

      def render(io)
        if fg = @fg
          io << "%{F" << fg.to_s << "}"
        end

        if bg = @bg
          io << "%{B" << bg.to_s << "}"
        end

        io << @name

        io << "%{B}" if @bg
        io << "%{F}" if @fg
      end
    end

    class ClockBlock < Base
      def initialize(@format = "%H:%M")
      end

      def render(io)
        io << Time.now.to_s(@format)
      end
    end

    class SpacerBlock < Base
      @str : String

      def initialize(size = 1)
        @str = " " * size
      end

      def render(io)
        io << @str
      end
    end
  end
end
