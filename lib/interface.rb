module Interface
  class MethodMissingError < Exception
  end

  # List of all interfaces in the system
  @interfaces = []
  class << self
    attr_reader :interfaces
  end
  attr_reader :implementors

  # This method is called when a FooInterface is initialized (i.e. when it extends Interface module)
  # self => Interface
  # interface => FooInterface
  def self.extended(interface)
    @interfaces << interface
    interface.initialize_attributes
  end

  # self => FooInterface
  def initialize_attributes
    @implementors ||= []
    @abstract_methods ||= {
      protected: [],
      public: [],
      any: [],
    }
  end

  def abstract_method method_name, scope = :public
    @abstract_methods[scope] << method_name
  end

  def get_abstract_methods scope
    @abstract_methods[scope]
  end

  # This method is called when FooInterface in included in a class
  # klass => Bar (include FooInterface, i.e. Bar "implements" FooInterface)
  def included(klass)
    klass.extend(ImplementorClassMethods)
    @implementors << klass
  end

  module ImplementorClassMethods
    # Compatible with ActiveRecord abstract_class methods
    def abstract_class=(value)
      @abstract_class = value
    end
    def abstract_class?
      @abstract_class.eql?(true)
    end
  end

  def self.validate!
    Interface.interfaces.each do |interface|
      interface.implementors.each do |klass|
        next if klass.abstract_class?
        Interface.require_methods_by_scope!(:protected, interface, klass)
        Interface.require_methods_by_scope!(:public, interface, klass)
        Interface.require_methods_by_scope!(:any, interface, klass)
      end
    end
  end

  def self.require_methods_by_scope! scope, interface, klass
    _method_name = scope.eql?(:any) ? :instance_methods : "#{scope}_instance_methods"
    required_methods = interface.get_abstract_methods(scope)
    required_methods.each do |method_name|
      if !klass.public_send(_method_name).include?(method_name)
        if scope.eql?(:any)
          message = "#{klass} is not abstract and does not override abstract method #{method_name} in #{interface}"
        else
          message = "#{klass} is not abstract and does not override #{scope} abstract method #{method_name} in #{interface}"
        end
        raise MethodMissingError.new(message)
      end
    end
  end
end