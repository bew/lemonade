require "../spec_helper"
require "../../src/lemonade/bar"

describe Lemonade::Bar do
  it "renders left/center/right containers" do
    bar = Lemonade::Bar.new
    bar.left = TestBlock.new "left"
    bar.center = TestBlock.new "center"
    bar.right = TestBlock.new "right"

    bar.redraw_s.should eq "%{l}left%{c}center%{r}right"
  end

  it "doesn't render left or center or right containers if empty" do
    bar = Lemonade::Bar.new
    bar.redraw_s.should eq ""

    bar.left = TestBlock.new "left"
    bar.redraw_s.should eq "%{l}left"
    bar.left.clear

    bar.center = TestBlock.new "center"
    bar.redraw_s.should eq "%{c}center"
    bar.center.clear

    bar.right = TestBlock.new "right"
    bar.redraw_s.should eq "%{r}right"
    bar.right.clear
  end

  it "becomes dirty on all left/center/right operations" do
    bar = Lemonade::Bar.new

    bar.dirty?.should be_true
    bar.redraw_s
    bar.dirty?.should be_false

    bar.left = TestCachedBlock.new "left"
    bar.dirty?.should be_true
    bar.redraw_s
    bar.dirty?.should be_false

    bar.left.clear
    bar.dirty?.should be_true
    bar.redraw_s
    bar.dirty?.should be_false

    bar.center = TestCachedBlock.new "center"
    bar.dirty?.should be_true
    bar.redraw_s
    bar.dirty?.should be_false

    bar.right = TestCachedBlock.new "right"
    bar.dirty?.should be_true
    bar.redraw_s
    bar.dirty?.should be_false

    bar.center.clear
    bar.dirty?.should be_true
    bar.redraw_s
    bar.dirty?.should be_false

    bar.right.clear
    bar.dirty?.should be_true
    bar.redraw_s
    bar.dirty?.should be_false
  end

  it "re-render when changing left(/center/right) block" do
    bar = Lemonade::Bar.new

    bar.left = TestCachedBlock.new "left"
    bar.dirty?.should be_true

    bar.redraw_s.should eq "%{l}left"
    bar.dirty?.should be_false

    bar.left = TestCachedBlock.new "new left"
    bar.dirty?.should be_true

    bar.redraw_s.should eq "%{l}new left"
    bar.dirty?.should be_false

    bar.left.separator = TestCachedBlock.new " :: "
    bar.left << TestCachedBlock.new "foo"
    bar.dirty?.should be_true

    bar.redraw_s.should eq "%{l}new left :: foo"
    bar.dirty?.should be_false
  end
end
