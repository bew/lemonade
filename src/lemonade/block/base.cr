module Lemonade
  module Block
    abstract class BaseBlock
      abstract def render(io)

      # This is not a cached block, it always needs rendering.
      def dirty?
        true
      end
    end

    # Cached version of `BaseBlock`.
    #
    # Saves the rendering output, and use it to render the block,
    # until it is marked dirty.
    abstract class CachedBlock < BaseBlock
      @cache : String? = nil
      @dirty = true

      def dirty?
        # @cache | @dirty | dirty?
        # -------------------------
        #  nil   | false  | true
        #  nil   | true   | true
        #  "a"   | false  | false
        #  "a"   | true   | true
        @cache.nil? || @dirty
      end

      def render(io)
        return io << @cache unless dirty?

        cache_io = IO::Memory.new
        cached_render(cache_io)
        @dirty = false

        io << (@cache = cache_io.to_s)
      end

      abstract def cached_render(io)
    end

    # Other blocks
    # - StaticBlock => once rendered it never change
    # - IntervalBlock => need render every N seconds
    # - EventBlock => can receive click events
  end
end
