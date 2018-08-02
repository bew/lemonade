#!/usr/bin/env crystal

require "../src/lemonade"
require "../src/lemonade/formatting_helper"

include Lemonade
H = FormattingHelper

class AsyncBlock < Block::BaseBlock
  @counter = 0

  def initialize(@name : String, @interval : Time::Span)
    start # TODO: start this method from elsewhere?
    # ship a module for async blocks with abstract `start` & default `stop` method
    # with some helper to help create async stuff.
    # Or maybe not?
  end

  def start
    spawn do
      loop do
        sleep @interval
        update
      end
    end
  end

  def update
    @counter += 1
    puts "Counter #{@name} update: #{@counter}"
    dirty!
  end

  def render(io)
    io << "Counter #{@name}: #{@counter}"
  end
end

lemon = Lemon.new

bar = Bar.new
bar.left << AsyncBlock.new "fast", 100.milliseconds
bar.center << AsyncBlock.new "slow", 1.second

renderer = Renderer.start(bar, lemon.process.input)

sleep 4

renderer.stop

sleep 2
