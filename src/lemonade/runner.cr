require "./color"

module Lemonade
  record Geometry,
    width : Int32,
    height : Int32,
    x : Int32,
    y : Int32

  class Lemon
    BIN = "lemonbar"

    property? win_name : String?
    property? force_dock : Bool?
    property? dock_bottom : Bool?
    property? geometry : Geometry?
    property? nb_click_areas : Int32?
    property? underline_height : Int32?
    property? bg_color : Color?
    property? fg_color : Color?
    property? underline_color : Color?
    property permanent = false
    property fonts = [] of String

    def run(bar, interval)
      lemon = Process.new BIN, build_args, input: nil
      while bar_str = bar.next_bar
        lemon.input.puts bar_str
        sleep interval

        if lemon.terminated?
          STDERR.puts "Lemonade process terminated unexpectedly, exiting.."
          exit 1
        end
      end
    end

    private def build_args
      args = [] of String

      if win_name = win_name?
        args << "-n" << win_name
      end

      if (force_dock = force_dock?) && force_dock
        args << "-d"
      end

      if (dock_bottom = dock_bottom?) && dock_bottom
        args << "-b"
      end

      if geo = geometry?
        geometry_arg = "#{geo.width}x#{geo.height}+#{geo.x}+#{geo.y}"
        args << geometry_arg
      end

      if @fonts.any?
        @fonts.each do |font|
          args << "-f"
          args << font
        end
      end

      if nb_click_areas = nb_click_areas?
        args << "-a" << nb_click_areas.to_s
      end

      if underline_height = underline_height?
        args << "-u" << underline_height.to_s
      end

      if bg_color = bg_color?
        args << "-B" << bg_color.to_s
      end

      if fg_color = fg_color?
        args << "-F" << fg_color.to_s
      end

      if underline_color = underline_color?
        args << "-U" << underline_color.to_s
      end

      if permanent
        args << "-p"
      end

      args
    end
  end
end
