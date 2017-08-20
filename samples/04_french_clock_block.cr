#!/usr/bin/env crystal

require "../src/lemonade"
require "../src/lemonade/formatting_helper"

include Lemonade
include FormattingHelper

# French's colors clock: Blue:White:Red
class FrenchClockBlock < Block::Container
  def initialize(separator = true)
    hour = Block::ClockBlock.new "%H"
    minutes = Block::ClockBlock.new "%M"
    seconds = Block::ClockBlock.new "%S"

    self << fg(hour, Material::Blue_500)
    self << fg(minutes, Material::White)
    self << fg(seconds, Material::Red_500)
    if separator
      self.separator = Block::TextBlock.new ":"
    end
  end
end

lemon = Lemon.new
lemon.fg_color = "#eee"
lemon.fonts << "DejaVu Sans Mono:size=10"

bar = Bar.new

clock_with_separators = FrenchClockBlock.new
bar.left << clock_with_separators
bar.right << clock_with_separators

bar.center << Block::TextBlock.new "Without separators:"
bar.center << FrenchClockBlock.new(separator: false)
bar.center.separator = Block::TextSpacerBlock.new 2

lemon.run bar, interval: 1.second
