require "./lemon"

class Lemonade::LemonManager
  enum Event
    Exited
    ForceExited
  end

  class LemonMetadata
    getter event_notifier = Channel(Event).new
  end

  getter managed_lemons = {} of Lemon => LemonMetadata

  def manage(lemons : Enumerable(Lemon))
    lemons.each do |lemon|
      manage(lemon)
    end
  end

  def manage(lemon : Lemon)
    managed_lemons[lemon] ||= begin
      data = LemonMetadata.new

      setup_process_errors_stream(lemon.process)
      setup_lemon_exit_event(lemon, data)

      data
    end
  end

  def wait(lemon : Lemon)
    wait({lemon})
  end

  def wait(lemons : Enumerable(Lemon))
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

  protected def setup_process_errors_stream(process)
    spawn do
      while line = process.error.gets
        STDERR.puts "[lemon pid:#{process.pid}] #{line}"
      end
    end
  end

  protected def setup_lemon_exit_event(lemon, data)
    process = lemon.process
    spawn do
      pid = process.pid
      # FIXME: Is there a better way to wait for process termination?
      until process.terminated?
        sleep 0.1 # Wait a bit, to release the CPU
      end
      if lemon.termination_requested?
        data.event_notifier.send Event::Exited
      else
        STDERR.puts "Lemon process (pid:#{pid}) terminated unexpectedly"
        data.event_notifier.send Event::ForceExited
      end
    end
  end
end
