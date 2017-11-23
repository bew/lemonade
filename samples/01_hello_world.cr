#!/usr/bin/env crystal

require "../src/lemonade"

include Lemonade

lemon = Lemon.new
bar = Bar.new

bar.center << Block::TextBlock.new "Hello world"

lemon.use bar

manager = LemonManager.new
manager.wait lemon
