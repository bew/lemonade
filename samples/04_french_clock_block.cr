#!/usr/bin/env crystal

require "../src/lemonade"
require "../src/lemonade/formatting_helper"

include Lemonade
include FormattingHelper

# French's colors clock: Blue:White:Red
class FrenchClockBlock < Block::Container
  def initialize(separator = true)
    hours = Block::TimeBlock.new "%H"
    minutes = Block::TimeBlock.new "%M"
    seconds = Block::TimeBlock.new "%S"

    self << fg(hours, Material::Blue_500)
    self << fg(minutes, Material::White)
    self << fg(seconds, Material::Red_500)
    if separator
      @colon_separator = Block::TextBlock.new ":"
      @blank_separator = Block::TextBlock.new " "
      self.separator = @colon_separator
    end

    start
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
    puts "Hours update"
    blocks[0].dirty!
    puts "Minutes update"
    blocks[1].dirty!
    puts "Seconds update"
    blocks[2].dirty!

    if separator?
      self.separator = case separator?
                       when @colon_separator
                         @blank_separator
                       else
                         @colon_separator
                       end
    end
  end
end

lemon = Lemon.build do |b|
  b.fg_color = "#eee"
  b.font = "DejaVu Sans Mono:size=10"
end

bar = Bar.new

clock_with_separators = FrenchClockBlock.new
bar.left << clock_with_separators
bar.right << clock_with_separators

bar.center << Block::TextBlock.new "Without separators:"
bar.center << FrenchClockBlock.new(separator: false)
bar.center.separator = Block::TextSpacerBlock.new 2

lemon.use bar

manager = LemonManager.new
manager.wait lemon
