require "./blocks"

class Lemonade::Renderer
  enum Event
    Draw
    Stop
  end

  def self.start(content, io)
    renderer = new
    renderer.start(content, io)
    renderer
  end

  getter controller = Channel(Event).new
  getter? running = false

  def start(content : Block::BaseBlock, io)
    frame_block = FrameBlock.new(content, self)

    # FIXME: indicate which renderer it is? (which bar? => how? I only now IO)
    spawn rendering_loop(frame_block, io), name: "renderer"
    @running = true

    notify_draw
  end

  def stop
    controller.send Event::Stop if running?
  end

  def notify_draw
    controller.send Event::Draw if running?
  end

  def rendering_loop(frame_block, io)
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
        break
      end
    end
    @running = false
  end

  # This block is the parent of all blocks of a bar, when a block needs to be
  # re-drawn, it sets itself as `dirty` (with a `dirty!` call), this dirty flag
  # goes up to its parents blocks, then up to their parents, until a
  # `FrameBlock` which will notify the renderer of the bar to redraw itself.
  private class FrameBlock < Block::BaseBlock
    @renderer : Renderer
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
end
