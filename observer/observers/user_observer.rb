module Observers
  class UserObserver
    def initialize(user)
      @user = user
    end

    def call
      puts "User observed"
    end
  end
end
