require "./blocks"

module Lemonade
  # TODO: rename (RendererProxyBlock ?)
  private class RendererFrameBlock < Block::BaseBlock
    @renderer_controller : Channel(RendererEvent)
    @content : Block::BaseBlock

    def initialize(@content, @renderer_controller)
      @content.parents << self
    end

    def dirty!
      puts "need bar redraw!"

      # We'll probably have a futur issue here, when we cannot send an event to
      # the renderer because it is stopped.
      # ==> the operationnal fiber (running this method) will block! :/
      @renderer_controller.send RendererEvent::Draw
    end

    def render(io)
      @content.render io
    end
  end

  enum RendererEvent
    Draw
    Stop
  end

  class BarRenderer
    getter controller = Channel(RendererEvent).new
    getter? stopped = true

    def self.start(content, io)
      renderer = new
      renderer.start(content, io)
      renderer
    end

    def start(content : Block::BaseBlock, io)
      @stopped = false
      frame_block = RendererFrameBlock.new(content, controller)

      # FIXME: too much indent here!
      spawn name: "renderer" do # FIXME: indicate which renderer it is?
        loop do
          case event = controller.receive
          when RendererEvent::Draw
            begin
              rendered = String.build { |io| frame_block.render io }
              io.puts rendered
            rescue
              # TODO: Do sth? rescue only SOME exceptions?
            end
          when RendererEvent::Stop
            break
          end
        end
      end

      controller.send RendererEvent::Draw
    end

    def stop
      @stopped = true
      controller.send RendererEvent::Stop
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
