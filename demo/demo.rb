class Demo
  include FooInterface

  def sample_public_method
  end
  
  protected def sample_protected_method
  end

  # Will raise a Interface::MethodMissingError with message:
  # Demo is not abstract and does not override abstract method sample_method in FooInterface
  # def sample_method
  # end
end