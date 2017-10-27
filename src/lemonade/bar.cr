require "./blocks"

module Lemonade
  # This block is the parent of all blocks of a bar, when a block needs to be
  # re-drawn, it sets itself as `dirty` (with a `dirty!` call), this dirty flag
  # goes up to its parents blocks, then up to their parents, until a
  # `RendererFrameBlock` which will notify the renderer of the bar to redraw itself.
  private class RendererFrameBlock < Block::BaseBlock
    @renderer : BarRenderer
    @content : Block::BaseBlock

    def initialize(@content, @renderer)
      @content.parents << self
    end

    def dirty!
      puts "need bar redraw!"

      @renderer.notify_draw
    end

    def render(io)
      @content.render io
    end
  end

  class BarRenderer
    enum Event
      Draw
      Stop
    end

    getter controller = Channel(Event).new
    getter? stopped = true

    def self.start(content, io)
      renderer = new
      renderer.start(content, io)
      renderer
    end

    def start(content : Block::BaseBlock, io)
      @stopped = false
      frame_block = RendererFrameBlock.new(content, self)

      # FIXME: too much indent here!
      spawn name: "renderer" do # FIXME: indicate which renderer it is?
        loop do
          case event = controller.receive
          when Event::Draw
            begin
              rendered = String.build { |io| frame_block.render io }
              io.puts rendered
            rescue ex
              STDERR.puts "Error while rendering the bar: #{ex.inspect_with_backtrace}"
              # FIXME: Do sth else?
            end
          when Event::Stop
            @stopped = true
            break
          end
        end
      end

      notify_draw
    end

    def stop
      controller.send Event::Stop
    end

    def notify_draw
      controller.send Event::Draw unless stopped?
    end
  end

  class Bar < Block::Container
    getter left = Block::Container.new
    getter center = Block::Container.new
    getter right = Block::Container.new

    def initialize
      self << left << center << right
    end

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
