require "./blocks"

# TODO: multiple renderers:
#  - abstract BaseRenderer (with start, stop, running?, notify_draw (or draw ? or request_draw ?))
#  - MinimalRenderer (no debouncer, no fiber)
#  - FiberRenderer (no debouncer)
#  - with render debouncer like here (TODO: find a name)
#
# TODO: explain how it works (?) and why it's important to render asynchronously, and not on every draw request
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

  getter name : String

  getter controller = Channel(Event).new
  getter? running = false

  property redraw_minimal_interval : Time::Span = 10.milliseconds

  getter? redraw_scheduled = false

  def initialize(@name = "renderer")
  end

  def start(content : Block::BaseBlock, io)
    frame_block = FrameBlock.new(content, self)

    spawn rendering_loop(frame_block, io), name: name
    @running = true

    notify_draw
  end

  def stop
    controller.send Event::Stop if running?
  end

  def notify_draw
    return unless running?

    if redraw_scheduled?
      renderer_debug "Redraw already scheduled, dismissing this draw request"
      return
    end

    renderer_debug "Scheduling redraw request, redraw in (at least) #{redraw_minimal_interval}"

    @redraw_scheduled = true
    debounce_channel = Channel(Nil).new
    spawn do
      sleep redraw_minimal_interval
      @redraw_scheduled = false
      debounce_channel.send nil
    end

    spawn do
      debounce_channel.receive
      renderer_debug "debouncer ended, render time!"
      controller.send Event::Draw
    end
  end

  def rendering_loop(frame_block, io)
    loop do
      case controller.receive
      when Event::Draw
        begin
          rendered = String.build { |io| frame_block.redraw io }
        rescue ex
          STDERR.puts "Error while rendering the bar: #{ex.inspect_with_backtrace}"
          next
        end

        begin
          io.puts rendered
        rescue ex # : IO::Error
          STDERR.puts "renderer: IO Error: #{ex.inspect_with_backtrace}"
          # FIXME: I/O (or other?) error, what do we do?
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
      @renderer.renderer_debug "need bar redraw!"

      @renderer.notify_draw
    end

    def render(io)
      @content.redraw io
    end
  end

  getter? enable_debug = false

  protected def renderer_debug(msg)
    return unless enable_debug?

    now = Time.now.to_s("%S.%L") # <seconds>.<milliseconds>
    puts "#{now} [#{@name}]: #{msg}"
  end
end
