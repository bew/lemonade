#!/usr/bin/env crystal

require "../src/lemonbar"

include Lemonbar

lemonbar = Lemonbar.new
lemonbar.bg_color = Material::Teal_500
lemonbar.fg_color = "#eee"

bar = Bar.new
bar.spacer = Block::SpacerBlock.new 1

bar << Block::TextBlock.new "block1"
bar << Block::TextBlock.new "block2", bg: Material::Red_500
bar << Block::TextBlock.new "block3"
bar << Block::TextBlock.new "block4", fg: Material::Blue_500, bg: Material::White
bar << Block::TextBlock.new "block5"
bar << Block::SpacerBlock.new 3
bar << Block::ClockBlock.new "%H:%M:%S"

lemonbar.run bar, interval: 1.second
