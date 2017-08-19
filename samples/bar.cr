#!/usr/bin/env crystal

require "../src/lemonbar"

include Lemonbar

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

bar.center << Block::ClockBlock.new "%H:%M:%S"

lemonbar.run bar, interval: 1.second
