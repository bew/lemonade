module Lemonade
  module FormattingHelper
    # Formats *block* with foreground *color*.
    def fg(block, color = ColorReset)
      Formatter::FgColor.new block, color
    end

    # Formats *block* with background *color*.
    def bg(block, color = ColorReset)
      Formatter::BgColor.new block, color
    end

    # Underlines *block*, colored using *color*.
    def ul(block, color = ColorReset)
      Formatter::Underline.new block, color
    end

    # Formats *block* with foreground *fg* color, and background *bg* color.
    def fgbg(block, fg fg_color, bg bg_color)
      inner = fg(block, fg_color)
      bg(inner, bg_color)
    end
  end
end
