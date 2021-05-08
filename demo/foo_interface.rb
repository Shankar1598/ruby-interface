module FooInterface
  extend Interface

  # require a public abstract method
  abstract_method :sample_public_method

  # require a protected abstract method
  abstract_method :sample_protected_method, :protected

  # require a public or protected abstract method
  abstract_method :sample_method, :any
end
