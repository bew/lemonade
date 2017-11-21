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
  end

  class LemonData
    getter event_notifier = Channel(Event).new
  end

  getter managed_lemons = {} of Lemon => LemonData

  def manage(lemon)
    return if managed_lemons.includes(lemon)

    data = LemonData.new
    setup_lemon_process(lemon, data)
    managed_lemons[lemon] = data
  end

  def wait(lemons)
    # NOTE: I don't really need them to be managed (with previous #manage calls)
    # to be able to be wait-ed?
    event_notifiers = managed_lemons.map do |lemon, data|
      if lemons.includes?(lemon)
        return data.event_notifier
      end
    end.compact!

    # wait for event_notifier of all lemons to send Exited event
    until event_notifiers.empty?
      index, event = Channel.receive_first(event_notifiers)
      if event == Event::Exited
        event_notifiers.delete_at index
      end
    end
  end

  def setup_lemon_process(lemon, data)
  end
end
