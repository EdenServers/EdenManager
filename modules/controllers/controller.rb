class Controller
  attr_accessor :controller_type

  def initialize(type)
    self.controller_type = type
  end

  def parse_request(json_request)
    Console.show "This controller can not handle JSON requests : #{json_request}", 'ERROR'
  end
end