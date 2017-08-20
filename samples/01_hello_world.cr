#!/usr/bin/env crystal

require "../src/lemonade"

include Lemonade

lemon = Lemon.new
bar = Bar.new

bar.center << Block::TextBlock.new "Hello world"

lemon.run bar, interval: 1.second
