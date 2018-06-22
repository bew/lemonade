require "../spec_helper"
require "../../src/lemonade/blocks"

private alias LB = Lemonade::Block

describe LB::BaseBlock do
end

describe LB::CachedBlock do
  it "caches render" do
    cblock = TestCachedBlock.new

    cblock.render_count.should eq 0

    # first redraw, render
    cblock.redraw_s.should eq "content"
    cblock.render_count.should eq 1

    # second redraw, use cached render
    cblock.redraw_s.should eq "content"
    cblock.render_count.should eq 1
  end

  it "dismisses cached render on dirty!" do
    cblock = TestCachedBlock.new

    cblock.render_count.should eq 0
    cblock.dirty?.should be_true

    # first redraw, render
    cblock.redraw_s.should eq "content"
    cblock.render_count.should eq 1
    cblock.dirty?.should be_false

    # second redraw, use cached render
    cblock.redraw_s.should eq "content"
    cblock.render_count.should eq 1
    cblock.dirty?.should be_false

    # make block dirty, dismiss cache
    cblock.dirty!

    # third redraw, render
    cblock.redraw_s.should eq "content"
    cblock.render_count.should eq 2
    cblock.dirty?.should be_false
  end
end

describe LB::Container do
  it "renders all blocks" do
    container = LB::Container.new
    container << TestBlock.new "1"
    container << TestBlock.new "2"
    container << TestBlock.new "3"

    container.redraw_s.should eq "123"
  end

  it "renders separator between blocks" do
    container = LB::Container.new
    container << TestBlock.new "1"
    container << TestBlock.new "2"
    container << TestBlock.new "3"
    container.separator = TestBlock.new "  "

    container.redraw_s.should eq "1  2  3"
  end

  it "adds blocks and sets itself as parent" do
    container = LB::Container.new
    container << (b1 = TestBlock.new)
    container << (b2 = TestBlock.new)

    container.blocks.should eq [b1, b2] of LB::BaseBlock
    b1.parents.should eq [container] of LB::BaseBlock
    b2.parents.should eq [container] of LB::BaseBlock
  end

  it "re-render container when child dirty" do
    container = LB::Container.new
    container << (block = TestCachedBlock.new)

    # first render
    container.redraw_s.should eq "content"
    container.redraw_s
    block.render_count.should eq 1

    container.dirty?.should be_false
    block.dirty?.should be_false

    # make child dirty!
    block.dirty!

    container.dirty?.should be_true
    block.dirty?.should be_true

    # second render
    container.redraw_s.should eq "content"
    block.render_count.should eq 2

    container.dirty?.should be_false
    block.dirty?.should be_false
  end
end

describe LB::TextSpacerBlock do
  it "defaults to 1 space" do
    block = LB::TextSpacerBlock.new
    block.redraw_s.should eq " "
  end

  it "renders many spaces" do
    block = LB::TextSpacerBlock.new 3
    block.redraw_s.should eq "   "
  end

  it "renders no space minimum" do
    block = LB::TextSpacerBlock.new 0
    block.redraw_s.should eq ""

    block = LB::TextSpacerBlock.new -3
    block.redraw_s.should eq ""
  end
end

describe LB::OffsetBlock do
  it "makes pixel-based spacing, default to 10" do
    block = LB::OffsetBlock.new
    block.redraw_s.should eq "%{O10}"
  end

  it "makes pixel-based spacing" do
    block = LB::OffsetBlock.new px: 32
    block.redraw_s.should eq "%{O32}"
  end
end

describe LB::TextBlock do
  it "renders given text" do
    block = LB::TextBlock.new "my content"
    block.redraw_s.should eq "my content"
  end

  it "rerenders when changing text" do
    block = LB::TextBlock.new "my content"
    block.redraw_s.should eq "my content"

    block.text = "new content"
    block.redraw_s.should eq "new content"
  end
end
