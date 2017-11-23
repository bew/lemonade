require "./base"

module Lemonade::Block
  class Container < CachedBlock
    property blocks = [] of BaseBlock
    getter? separator : BaseBlock?

    def separator=(@separator)
      dirty!
    end

    def <<(block)
      block.parents << self
      @blocks << block
      dirty!

      self
    end

    def dirty?
      @blocks.any?(&.dirty?) || @separator.try(&.dirty?) || super
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
end
