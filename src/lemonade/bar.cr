require "./blocks"

module Lemonade
  class Bar < Block::CachedBlock
    getter left = Block::Container.new
    getter center = Block::Container.new
    getter right = Block::Container.new

    {% for block_name in %w(left center right) %}
      def {{ block_name.id }}=(block : Block::BaseBlock)
        @{{ block_name.id }}.clear
        @{{ block_name.id }} << block
      end
    {% end %}

    def dirty?
      left.dirty? || center.dirty? || right.dirty? || super
    end

    def render(io)
      segment_output = IO::Memory.new

      left.redraw(segment_output)
      if segment_output.size > 0
        io << "%{l}" << segment_output
      end
      segment_output.clear

      center.redraw(segment_output)
      if segment_output.size > 0
        io << "%{c}" << segment_output
      end
      segment_output.clear

      right.redraw(segment_output)
      if segment_output.size > 0
        io << "%{r}" << segment_output
      end
      segment_output.clear
    end
  end
end
