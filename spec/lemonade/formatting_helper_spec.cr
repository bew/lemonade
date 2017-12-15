require "../spec_helper"
require "../../src/lemonade/formatting_helper"

private H = Lemonade::FormattingHelper

private class DummyBlock < Lemonade::Block::BaseBlock
  def render(io)
    io << "content"
  end
end

private def assert_format(expected)
  block = yield
  render_result = String.build do |io|
    block.redraw io
  end
  render_result.should eq expected
end

describe Lemonade::FormattingHelper do
  describe "raw formatters" do
    it "sets & resets foreground color" do
      assert_format "%{F#abc}" { H.fg_color("#abc") }
      assert_format "%{F-}" { H.fg_color_reset }
    end

    it "sets & resets background color" do
      assert_format "%{B#abc}" { H.bg_color("#abc") }
      assert_format "%{B-}" { H.bg_color_reset }
    end

    it "sets & resets line color" do
      assert_format "%{U#abc}" { H.line_color("#abc") }
      assert_format "%{U-}" { H.line_color_reset }
    end

    it "enables & disables underline" do
      assert_format "%{+u}" { H.enable_underline }
      assert_format "%{-u}" { H.disable_underline }
    end

    it "enables & disables underline" do
      assert_format "%{+o}" { H.enable_overline }
      assert_format "%{-o}" { H.disable_overline }
    end
  end

  describe "block formatters" do
    dummy_block = DummyBlock.new

    it "formats block with foreground color" do
      assert_format "%{F#abcdef}content%{F-}" do
        H.fg(dummy_block, "#abcdef")
      end
      assert_format "%{F-}content%{F-}" do
        H.fg(dummy_block)
      end
    end

    it "formats block with background color" do
      assert_format "%{B#abcdef}content%{B-}" do
        H.bg(dummy_block, "#abcdef")
      end
      assert_format "%{B-}content%{B-}" do
        H.bg(dummy_block)
      end
    end

    it "underlines block with color" do
      assert_format "%{U#abc}%{+u}content%{-u}%{U-}" do
        H.ul(dummy_block, "#abc")
      end
      assert_format "%{U-}%{+u}content%{-u}%{U-}" do
        H.ul(dummy_block)
      end
    end

    it "overlines block with color" do
      assert_format "%{U#abc}%{+o}content%{-o}%{U-}" do
        H.ol(dummy_block, "#abc")
      end
      assert_format "%{U-}%{+o}content%{-o}%{U-}" do
        H.ol(dummy_block)
      end
    end
  end
end
