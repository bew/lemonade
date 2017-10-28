require "./blocks"

module Lemonade
  class Bar < Block::Container
    getter left = Block::Container.new
    getter center = Block::Container.new
    getter right = Block::Container.new

    def initialize
      self << left << center << right
    end

    # Blocks setters that invalidate previous cache on use

    {% for block_name in %w(left center right) %}
      def {{block_name.id}}=(@{{block_name.id}})
        dirty!
      end
    {% end %}

    def cached_render(io)
      puts "rendering bar..."
      unless left.blocks.empty?
        io << "%{l}"
        left.render io
      end

      unless center.blocks.empty?
        io << "%{c}"
        center.render io
      end

      unless right.blocks.empty?
        io << "%{r}"
        right.render io
      end
    end
  end
end
