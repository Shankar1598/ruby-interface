class AbstractParentDemo
  include FooInterface
  self.abstract_class = true
  
  # This WILL NOT raise and error since this class is declared as an abstract class
end
