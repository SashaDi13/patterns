module Observable
  def self.included(base)
    base.after_initialize :observe_methods
    base.extend(ClassMethods)
    base.include(Callbacks)
  end

  module ClassMethods
    def observe(method_name, observer:)
      @methods_to_observe ||= {}
      @methods_to_observe[method_name.to_sym] = observer
    end

    def wrap_methods_with_observer
      return unless @methods_to_observe

      @methods_to_observe.each do |method_name, observer|
        if instance_methods.include?(method_name)
          alias_method "original_#{method_name}".to_sym, method_name

          define_method(method_name) do |*args, &block|
            puts 'Observer called'
            send("original_#{method_name}")

            observer.new(self).call if observer
          end
        else
          raise NameError, "Method `#{method_name}` wasn't finded #{self.name}"
        end
      end
    end
  end

  def observe_methods
    self.class.wrap_methods_with_observer
  end
end
