class AbstractChildDemo
  include FooInterface
  
  # This WILL raise an error since this class is NOT declared as an abstract class
end
