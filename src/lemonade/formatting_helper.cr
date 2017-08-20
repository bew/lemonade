module Lemonade
  module FormattingHelper
    extend self # Allow inclusion or direct FormattingHelper.method access

    # Formats *block* with foreground *color*.
    def fg(block, color = ColorReset)
      Formatter::Arround.new({fg_color(color)}, block, {fg_reset})
    end

    # Formats *block* with background *color*.
    def bg(block, color = ColorReset)
      Formatter::Arround.new({bg_color(color)}, block, {bg_reset})
    end

    # Underlines *block*, colored using *color*.
    def ul(block, color = ColorReset)
      pre_formatters = {line_color(color), enable_underline}
      post_formatters = {disable_underline, line_reset}

      Formatter::Arround.new pre_formatters, block, post_formatters
    end

    # Overlines *block*, colored using *color*.
    def ol(block, color = ColorReset)
      pre_formatters = {line_color(color), enable_overline}
      post_formatters = {disable_overline, line_reset}

      Formatter::Arround.new pre_formatters, block, post_formatters
    end

    # Formats *block* with foreground *fg* color, and background *bg* color.
    def fgbg(block, fg fg_color, bg bg_color)
      inner = fg(block, fg_color)
      bg(inner, bg_color)
    end

    RAW_STUFF = {
      fg: {"foreground", 'F'},
      bg: {"background", 'B'},
      line: {"underline & overline attributes", 'U'},
    }

    {% for raw_what, data in RAW_STUFF %}
      {% raw_doc = data[0]; raw_char = data[1] %}

      # Set {{raw_doc}} *color*.
      def {{raw_what.id}}_color(color)
        Formatter::Raw::StuffColor.new({{raw_char}}, color)
      end

      # Reset {{raw_doc}} color.
      def {{raw_what.id}}_reset
        {{raw_what.id}}_color ColorReset
      end
    {% end %}

    {% for attr, attr_char in {underline: 'u', overline: 'o'} %}
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
