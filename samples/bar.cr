#!/usr/bin/env crystal

require "../src/lemonade"
require "../src/lemonade/formatting_helper"

include Lemonade
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

lemon = Lemon.new
lemon.bg_color = Material::Black
lemon.fg_color = "#eee"
lemon.fonts << "DejaVuSansMonoForPowerline Nerd Font:size=10"

bar = Bar.new
bar.left.separator = Block::TextSpacerBlock.new 1

bar.left << Block::TextBlock.new "block1"
bar.left << bg Block::TextBlock.new("block2"), Material::Red_500
bar.left << Block::TextBlock.new "block3"
bar.left << fgbg Block::TextBlock.new("block4"), fg: Material::Blue_500, bg: Material::White
bar.left << Block::TextBlock.new "block5"

bar.center << french_clock

lemon.run bar, interval: 1.second
