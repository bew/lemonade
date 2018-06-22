require "spec"
require "../src/lemonade"

class Lemonade::Block::BaseBlock
  def redraw_s
    String.build do |io|
      redraw(io)
    end
  end
end

class TestBlock < Lemonade::Block::BaseBlock
  def initialize(@content = "content")
  end

  def render(io)
    io << @content
  end
end

class TestCachedBlock < Lemonade::Block::CachedBlock
  getter render_count = 0

  def initialize(@content = "content")
  end

  def render(io)
    io << @content
    @render_count += 1
  end
end

