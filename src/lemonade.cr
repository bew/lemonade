require "./lemonade/**"
require "./material_color"

module Lemonade
  @@manager = LemonManager.new

  def self.current_manager
    @@manager
  end

  def manage(lemon)
    current_manager.manage(lemon)
  end

  def wait(*lemons)
    current_manager.wait(lemons)
  end
end

class Lemonade::LemonManager
  enum Event
    Exited
    ForceExited
  end

  class LemonData
    getter event_notifier = Channel(Event).new
  end

  getter managed_lemons = {} of Lemon => LemonData

  def manage(lemon)
    managed_lemons[lemon] ||= begin
      data = LemonData.new
      setup_lemon_process(lemon, data)
      data
    end
  end

  def wait(lemon : Lemon)
    wait({lemon})
  end

  def wait(lemons : Enumerable)
    event_notifiers = lemons.map { |l| manage(l).event_notifier }.to_a

    # wait for event_notifier of all lemons to send Exited event
    until event_notifiers.empty?
      index, event = Channel.select(event_notifiers.map(&.receive_select_action))
      case event
      when Event::Exited, Event::ForceExited
        event_notifiers.delete_at index
      end
    end
  end

  def setup_lemon_process(lemon, data)
    process = lemon.process

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
      if lemon.termination_requested?
        data.event_notifier.send Event::Exited
      else
        STDERR.puts "Lemon process (pid:#{pid}) terminated unexpectedly, exiting.."
        data.event_notifier.send Event::ForceExited
      end
    end
  end
end
