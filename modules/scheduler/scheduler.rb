module Scheduler
  def start
    $scheduler = Rufus::Scheduler.new
    start_events
  end

  def start_events
    #Main server monitor
    $scheduler.every '1m' do
    end
  end
end