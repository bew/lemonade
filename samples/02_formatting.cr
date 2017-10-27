#!/usr/bin/env crystal

require "../src/lemonade"
require "../src/lemonade/formatting_helper"

include Lemonade
include FormattingHelper

lemon = Lemon.build do |b|
  b.underline_height = 3
end

bar = Bar.new

content = Block::TextBlock.new "content"

bar.center.separator = Block::TextSpacerBlock.new 3
bar.center << content
bar.center << fg content, Material::Teal_500
bar.center << ul bg content, Material::Red_500
bar.center << fgbg content, fg: Material::Blue_500, bg: Material::White
bar.center << ul content, Material::Red_500

lemon.run bar, interval: 1.second
