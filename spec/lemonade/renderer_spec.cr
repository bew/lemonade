require "../spec_helper"

private class DummyBlock < Lemonade::Block::BaseBlock
  getter redraw_count = 0

  def render(io)
    io << "content"
    @redraw_count += 1
  end

  def reset_redraw_count
    @redraw_count = 0
  end
end

describe Lemonade::Renderer do
  it "starts & stops" do
    # dummy_block = DummyBlock.new
    # rendering_io = IO::Memory.new

    renderer = Lemonade::Renderer.new
    renderer.running?.should be_false
    renderer.start(DummyBlock.new, IO::Memory.new)
    renderer.running?.should be_true
    renderer.stop
    renderer.running?.should be_false
  end
end
