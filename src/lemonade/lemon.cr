require "./color"

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
      lemon = new(process)
      lemon.setup_process
    end

    def self.start_process(args = [] of String)
      puts "Starting Lemon with args: #{args}"

      Process.new BIN, args, input: nil, output: nil, error: nil
    end

    def self.new
      lemon = new(start_process)
      lemon.setup_process
      lemon
    end

    getter? termination_requested = false
    getter process : Process
    getter renderer = Renderer.new

    def initialize(@process)
    end

    def setup_process
      spawn do
        while line = process.error.gets
          STDERR.puts "[lemon pid:#{process.pid}] #{line}"
        end
      end

      spawn do
        pid = process.pid
        # FIXME: Is there a better way to wait for process termination?
        until process.terminated?
          sleep 0.1 # Wait a bit, to release the CPU
        end
        unless termination_requested?
          STDERR.puts "Lemon process (pid:#{pid}) terminated unexpectedly, exiting.."
          exit 1 # TODO: notify the Lemonade controlling process?
        end
      end
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
    property permanent = false
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

      if permanent
        args << "-p"
      end

      args
    end
  end
end
