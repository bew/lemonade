#!/usr/bin/env crystal

require "../src/lemonade"
require "../src/lemonade/formatting_helper"

include Lemonade
H = FormattingHelper

lemon = Lemon.build do |b|
  b.underline_height = 3
end

bar = Bar.new

content = Block::TextBlock.new "content"

bar.center.separator = Block::TextSpacerBlock.new 3
bar.center << content

# bar.center << H.fg content, Material::Teal_500
container = Block::Container.new
container << H.fg_color(Material::Teal_500)
container << content
container << H.fg_reset
bar.center << container

# bar.center << H.ul H.bg content, Material::Red_500
container = Block::Container.new
container << H.enable_underline << H.bg_color(Material::Red_500)
container << content
container << H.bg_reset << H.disable_underline
bar.center << container

# bar.center << H.fgbg content, fg: Material::Blue_500, bg: Material::White
container = Block::Container.new
container << H.fg_color(Material::Blue_500) << H.bg_color(Material::White)
container << content
container << H.bg_reset << H.fg_reset
bar.center << container

# bar.center << H.ul content, Material::Red_500
container = Block::Container.new
container << H.enable_underline << H.line_color(Material::Red_500)
container << content
container << H.line_reset << H.disable_underline
bar.center << container

lemon.use bar

manager = LemonManager.new
manager.wait lemon
