#!/usr/bin/env crystal

require "../src/lemonade"
require "../src/lemonade/formatting_helper"

include Lemonade
include FormattingHelper

# French's colors clock: Blue:White:Red
def french_clock(separator = true)
  hour = Block::ClockBlock.new "%H"
  minutes = Block::ClockBlock.new "%M"
  seconds = Block::ClockBlock.new "%S"

  clock = Block::Container{
    fg(hour, Material::Blue_500),
    fg(minutes, Material::White),
    fg(seconds, Material::Red_500),
  }
  if separator
    clock.separator = Block::TextBlock.new ":"
  end

  clock
end

lemon = Lemon.new
lemon.fg_color = "#eee"
lemon.fonts << "DejaVu Sans Mono:size=10"

bar = Bar.new

clock_with_separators = french_clock
bar.left << clock_with_separators
bar.right << clock_with_separators

bar.center << Block::TextBlock.new "Without separators:"
bar.center << french_clock(separator: false)
bar.center.separator = Block::TextSpacerBlock.new 2

lemon.run bar, interval: 1.second
