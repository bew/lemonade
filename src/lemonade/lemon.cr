require "./color"

module Lemonade
  record Geometry,
    width : Int32,
    height : Int32,
    x : Int32,
    y : Int32

  class Lemon
    BIN = "lemonbar"

    getter? termination_requested = false
    getter process : Process

    def self.build
      b = Builder.new
      yield b

      start_process(b.build_args)
    end

    def self.start_process(args = [] of String)
      # this method creates the Lemon object, and use it to setup the process's controllers
      # Not sure if it's a good way to do it..

      puts "Starting Lemon with args: #{args}"
      process = Process.new BIN, args, input: nil, error: nil
      lemon = new(process)

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
        unless lemon.termination_requested?
          STDERR.puts "Lemon process (pid:#{pid}) terminated unexpectedly, exiting.."
          exit 1 # TODO: notify the Lemonade controlling process?
        end
      end

      lemon
    end

    def self.new
      start_process
    end

    def initialize(@process)
    end

    def run(bar, interval)
      while bar_str = bar.next_bar
        @process.input.puts bar_str
        sleep interval
      end
    end

    def close
      @termination_requested = true
      @process.kill
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
