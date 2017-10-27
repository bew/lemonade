require "./blocks"

module Lemonade
  # TODO: rename (RendererProxyBlock ?)
  private class RendererFrameBlock < Block::BaseBlock
    @renderer_control : Channel(RendererEvent)
    @content : Block::BaseBlock

    def initialize(@content, @renderer_control)
      @content.parents << self
    end

    def dirty!
      puts "need bar redraw!"
      @renderer_control.send RendererEvent::Draw
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
    @renderer_control : Channel(RendererEvent)?
    getter? stopped = true

    def self.start(content, io)
      renderer = new
      renderer.start(content, io)
      renderer
    end

    def start(content : Block::BaseBlock, io)
      @stopped = false
      events = @renderer_control = Channel(RendererEvent).new
      frame_block = RendererFrameBlock.new(content, events)

      # FIXME: too much indent here!
      spawn name: "renderer" do # FIXME: indicate which renderer it is?
        loop do
          case event = events.receive
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

      events.send RendererEvent::Draw
    end

    def stop
      if events = @renderer_control
        @stopped = true
        events.send RendererEvent::Stop
        @renderer_control = nil
      end
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
