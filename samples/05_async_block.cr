#!/usr/bin/env crystal

require "../src/lemonade"
require "../src/lemonade/formatting_helper"

include Lemonade
H = FormattingHelper

class AsyncBlock < Block::BaseBlock
  @counter = 0

  def initialize
    start # will later be started from elsewhere?
  end

  def start
    spawn do
      loop do
        sleep 1
        update
      end
    end
  end

  def update
    @counter += 1
    dirty!
  end

  def render(io)
    io << "Counter: #{@counter}"
  end
end

lemon = Lemon.new

bar = Bar.new
bar.left << AsyncBlock.new

lemon.run bar
