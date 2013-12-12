module Scheduler
  def start
    $scheduler = Rufus::Scheduler.new
    start_events
  end

  def start_events

  end
end