module Callbacks
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def before_initialize_callbacks
      @before_initialize_callbacks ||= []
    end

    def after_initialize_callbacks
      @after_initialize_callbacks ||= []
    end

    def before_initialize(method_name = nil, &block)
      before_initialize_callbacks << (block || method_name)
    end

    def after_initialize(method_name = nil, &block)
      after_initialize_callbacks << (block || method_name)
    end
  end

  def initialize(*args)
    run_callbacks(:before_initialize)

    super(*args)

    run_callbacks(:after_initialize)
  end

  private

  def run_callbacks(type)
    callbacks = self.class.send("#{type}_callbacks")

    callbacks.each do |callback|
      if callback.is_a?(Proc)
        callback.call(self)
      elsif callback.is_a?(Symbol)
        send(callback)
      end
    end

    puts "Callback #{type} was called!"
  end
end
