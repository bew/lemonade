module Lemonade
  module Block
    # Note: Any container must add itself to the parents array of a given block.
    # Caching & dynamic block modification in multiple blocks count on that to
    # propagate to parents that a block is dirty.
    #
    # Example of a basic container:
    # ```
    # class Container < Lemonade::BaseBlock
    #   @blocks = [] of Lemonade::BaseBlock
    #
    #   def <<(block)
    #     block.parents << self # Add the container to block's parents.
    #     @blocks << block      # Add the block to the container's list of block.
    #   end
    # end
    #
    # Container.new << SomeBlock.new
    # ```
    abstract class BaseBlock
      property parents = [] of BaseBlock

      abstract def render(io)

      # This is not a cached block, it always needs rendering.
      def dirty?
        true
      end

      def dirty!
        @parents.each &.dirty!
      end

      REMOVE_IVARS_FROM_INSPECT = %w(parents)

      def inspect(io : IO) : Nil
        io << "#<" << {{@type.name.id.stringify}} << ":0x"
        object_id.to_s(16, io)
        {% for ivar, i in @type.instance_vars %}
          {% unless REMOVE_IVARS_FROM_INSPECT.includes?(ivar.stringify) %}
            {% if i > 0 %}
              io << ","
            {% end %}
            io << " @{{ivar.id}}="
            @{{ivar.id}}.inspect io
          {% end %}
        {% end %}
        io << ">"
        nil
      end
    end

    # Cached version of `BaseBlock`.
    #
    # Saves the rendering output, and use it to render the block,
    # until it is marked dirty.
    abstract class CachedBlock < BaseBlock
      @cache : String? = nil

      # Note: Don't set this attribute manually, use `dirty!` instead for
      # proper cache reloading.
      @dirty = true

      # Mark the `Block` and its parents as 'dirty', to force redraw next time.
      def dirty!
        puts "dirty!"
        @dirty = true
        super
      end

      def dirty?
        # @cache | @dirty | dirty?
        # ------------------------
        #  nil   | false  | true
        #  nil   | true   | true
        #  "a"   | false  | false
        #  "a"   | true   | true
        @cache.nil? || @dirty
      end

      def render(io)
        return io << @cache unless dirty?

        @cache = String.build do |io|
          cached_render(io)
        end
        @dirty = false

        io << @cache
      end

      abstract def cached_render(io)
    end

    # TODO: Other blocks? mixin?
    # StaticBlock => once rendered it never change
    # IntervalBlock => need render every N seconds
    # EventBlock => can receive click events (as a Trait? so all blocks could receive event?)
  end
end
