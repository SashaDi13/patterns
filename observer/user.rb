require "./observable"
require "./observers/user_observer"
require "./callbacks"

class User
  include Callbacks
  include Observable

  observe :hello, observer: Observers::UserObserver

  def initialize(*args)
    super()
  end

  def hello
    puts 1
    puts 'Hello'
  end
end
