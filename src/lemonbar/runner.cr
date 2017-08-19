require "./color"

module Lemonbar
  record Geometry,
    width : Int32,
    height : Int32,
    x : Int32,
    y : Int32

  class Runner
    BIN = "lemonbar"

    property? wm_name : String?
    property? force_dock : Bool?
    property? dock_bottom : Bool?
    property? geometry : Geometry?
    property? font : String?
    property? nb_click_areas : Int32?
    property? underline_width : Int32? # should be underline_height ??
    property? bg_color : Color | String?
    property? fg_color : Color | String?
    property? underline_color : Color | String?
    property permanent = false

    def run(bar : Bar, interval)
      run BarProvider.new(bar), interval
    end

    def run(bar_provider, interval)
      lemonbar = Process.new BIN, build_args, input: nil
      bar_provider.each do |bar_str|
        lemonbar.input.puts bar_str
        sleep interval
      end
    end

    private def build_args
      args = [] of String

      if wm_name = wm_name?
        args << "-n" << wm_name
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

      if font = font?
        args << font
      end

      if nb_click_areas = nb_click_areas?
        args << "-a" << nb_click_areas.to_s
      end

      if underline_width = underline_width?
        args << "-u" << underline_width.to_s
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
