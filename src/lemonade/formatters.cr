require "./block/base"
require "./blocks"

module Lemonade
  module Formatter
    abstract class BaseBlock < Block::BaseBlock
      def formatting(io)
        io << "%{"
        yield
        io << "}"
      end
    end

    class ArroundBlock < Block::Container
      def initialize(pre_formatters, block, post_formatters)
        @blocks.concat(pre_formatters)
        @blocks << block
        @blocks.concat(post_formatters)

        block.parents << self
      end
    end

    module Raw
      # e.g: %{F#abcdef} or %{B-}
      class ColorChangerBlock < BaseBlock
        def initialize(@stuff : Char, @color : Color)
        end

        def render(io)
          formatting(io) do
            io << @stuff << @color
          end
        end
      end

      # e.g: %{+u} or %{!o}
      class AttributeBlock < BaseBlock
        def self.enable(attr)
          new(attr, '+')
        end

        def self.disable(attr)
          new(attr, '-')
        end

        def self.toggle(attr)
          new(attr, '!')
        end

        def initialize(@attribute : Char, @state : Char)
        end

        def render(io)
          formatting(io) do
            io << @state << @attribute
          end
        end
      end
    end
  end
end
