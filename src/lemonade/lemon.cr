require "./color"
require "./renderer"

module Lemonade
  record Geometry,
    width : Int32,
    height : Int32,
    x : Int32,
    y : Int32

  class Lemon
    BIN = "lemonbar"

    def self.build
      b = Builder.new
      yield b

      process = start_process(b.build_args)
      new(process)
    end

    def self.start_process(args = [] of String)
      puts "Starting Lemon with args: #{args}"

      Process.new BIN, args, input: :pipe, output: :pipe, error: :pipe
    end

    def self.new
      new(start_process)
    end

    getter? termination_requested = false
    getter process : Process
    getter renderer = Renderer.new

    # Replace the renderer
    #
    # Stop & resume the rendering if it was running
    # Probably not needed, but why not :P
    def renderer=(new_renderer)
      old_renderer = @renderer
      old_renderer.stop if was_running = old_renderer.running?

      @renderer = new_renderer
      use(old_renderer.content) if was_running
    end

    def initialize(@process)
    end

    def close
      @termination_requested = true
      @process.kill
    end

    def use(bar)
      if renderer.running?
        renderer.stop
      end
      renderer.start(bar, process.input)
    end
  end

  class Lemon::Builder
    property? win_name : String?
    property? force_dock : Bool?
    property? dock_bottom : Bool?
    property? geometry : Geometry?
    property? nb_click_areas : Int32?
    property? underline_height : Int32?
    property? bg_color : Color?
    property? fg_color : Color?
    property? underline_color : Color?
    property? permanent = false
    property fonts = [] of String

    def font=(font)
      fonts.clear
      fonts << font
    end

    protected def build_args
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

      if permanent?
        args << "-p"
      end

      args
    end
  end
end
