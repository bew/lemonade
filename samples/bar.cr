#!/usr/bin/env crystal

require "../src/lemonbar"
require "../src/lemonbar/formatting_helper"

include Lemonbar
include FormattingHelper

# French's colors clock: Blue:White:Red
def french_clock
  hour = Block::ClockBlock.new "%H"
  minutes = Block::ClockBlock.new "%M"
  seconds = Block::ClockBlock.new "%S"

  clock = Block::Container{
    fg(hour, Material::Blue_500),
    fg(minutes, Material::White),
    fg(seconds, Material::Red_500),
  }
  clock.separator = Block::TextBlock.new ":"

  clock
end

lemonbar = Lemonbar.new
lemonbar.bg_color = Material::Teal_500
lemonbar.fg_color = "#eee"

bar = Bar.new
bar.left.separator = Block::TextSpacerBlock.new 1

bar.left << Block::TextBlock.new "block1"
bar.left << Block::TextBlock.new "block2", bg: Material::Red_500
bar.left << Block::TextBlock.new "block3"
bar.left << Block::TextBlock.new "block4", fg: Material::Blue_500, bg: Material::White
bar.left << Block::TextBlock.new "block5"

bar.center << french_clock

lemonbar.run bar, interval: 1.second
