#!/usr/bin/env crystal

require "../src/lemonade"
require "../src/lemonade/formatting_helper"

include Lemonade
include FormattingHelper

lemon = Lemon.new

bar = Bar.new

container = Block::Container.new
container.separator = bg Block::OffsetBlock.new(20), Material::Red_500

3.times do |i|
  container << Block::TextBlock.new("block #{i + 1}")
end

bar.left << container
bar.left << fg Block::TextBlock.new("End of left"), Material::Blue_500

bar.center.separator = bg Block::OffsetBlock.new(70), Material::Teal_500
bar.center << container
bar.center << container

spawn do
  # Change text of last block of *container* after 3s
  sleep 3
  last_block = container.blocks.last.as(Block::TextBlock)
  last_block.text = "New text of last block"
end

lemon.run bar, interval: 1.second