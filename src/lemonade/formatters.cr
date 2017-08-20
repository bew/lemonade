require "./block/base"

module Lemonade
  module Formatter
    abstract class Base < Block::BaseBlock
      def initialize(@content_block : Block::BaseBlock)
      end

      def dirty?
        @content_block.dirty?
      end

      def render(io)
        pre_render(io)
        @content_block.render(io)
        post_render(io)
      end

      # To be overriden by formatter who needs to hook before rendering
      def pre_render(io)
      end

      # To be overriden by formatter who needs to hook after rendering
      def post_render(io)
      end
    end

    class FgColor < Base
      def initialize(@content_block, @fg : Color)
      end

      def pre_render(io)
        io << "%{F" << @fg.to_s << "}"
      end

      def post_render(io)
        io << "%{F-}"
      end
    end

    class BgColor < Base
      def initialize(@content_block, @bg : Color)
      end

      def pre_render(io)
        io << "%{B" << @bg.to_s << "}"
      end

      def post_render(io)
        io << "%{B-}"
      end
    end

    class Underline < Base
      def initialize(@content_block, @color : Color?)
      end

      def pre_render(io)
        if color = @color
          io << "%{U" << color.to_s << "}"
        end
        io << "%{+u}"
      end

      def post_render(io)
        io << "%{-u}"
        if color = @color
          io << "%{U-}"
        end
      end
    end

    class Strike < Base
      def initialize(@content_block, @color : Color?)
      end

      def pre_render(io)
        if color = @color
          io << "%{U" << color.to_s << "}"
        end
        io << "%{+o}"
      end

      def post_render(io)
        io << "%{-o}"
        if color = @color
          io << "%{U-}"
        end
      end
    end
  end
end
