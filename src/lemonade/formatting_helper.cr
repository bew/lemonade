module Lemonade
  module FormattingHelper
    extend self # Allow inclusion or direct FormattingHelper.method access

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

    # Set foreground *color*.
    def fg_color(color)
      Formatter::Raw::StuffColor.new('F', color)
    end

    # Reset foreground color.
    def fg_reset
      fg_color ColorReset
    end

    # Set background *color*.
    def bg_color(color)
      Formatter::Raw::StuffColor.new('B', color)
    end

    # Reset background color.
    def bg_reset
      bg_color ColorReset
    end

    # Set underline & strike attributes *color*.
    def line_color(color)
      Formatter::Raw::StuffColor.new('U', color)
    end

    # Reset underline & strike attributes color.
    def line_reset
      line_color ColorReset
    end

    {% for attr, attr_char in {underline: 'u', strike: 'o'} %}
      # Enables attribute {{attr.id}}
      def enable_{{attr.id}}
        Formatter::Raw::Attribute.enable({{attr_char}})
      end

      # Disables attribute {{attr.id}}
      def disable_{{attr.id}}
        Formatter::Raw::Attribute.disable({{attr_char}})
      end

      # Toggles attribute {{attr.id}}
      def toggle_{{attr.id}}
        Formatter::Raw::Attribute.toggle({{attr_char}})
      end
    {% end %}
  end
end
