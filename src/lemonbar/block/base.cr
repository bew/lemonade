module Lemonbar
  module Block
    abstract class BaseBlock
      abstract def render(io)

      # This is not a cached block, it always needs rendering.
      def dirty?
        true
      end
    end

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
  end
end
