#!/usr/bin/env crystal

require "../src/lemonade"
require "../src/lemonade/formatting_helper"

include Lemonade
include FormattingHelper

# French's colors clock: Blue:White:Red
def french_clock(separator = true)
  hours = Block::ClockBlock.new "%H"
  minutes = Block::ClockBlock.new "%M"
  seconds = Block::ClockBlock.new "%S"

  clock = Block::Container{
    fg(hours, Material::Blue_500),
    fg(minutes, Material::White),
    fg(seconds, Material::Red_500),
  }
  if separator
    clock.separator = Block::TextBlock.new ":"
  end

  spawn do
    loop do
      sleep 1
      hours.dirty!
      minutes.dirty!
      seconds.dirty!
    end
  end

  clock
end

lemon = Lemon.build do |b|
  b.fg_color = "#eee"
  b.font = "DejaVu Sans Mono:size=10"
end

bar = Bar.new

clock_with_separators = french_clock
bar.left << clock_with_separators
bar.right << clock_with_separators

bar.center << Block::TextBlock.new "Without separators:"
bar.center << french_clock(separator: false)
bar.center.separator = Block::TextSpacerBlock.new 2

lemon.use bar

sleep
