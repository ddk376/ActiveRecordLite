class AttrAccessorObject
  def self.my_attr_accessor(*names)
    # ...
    names.each do |name|
      define_method(name) do
         instance_variable_get("@#{name}".to_sym)
      end

      define_method("#{name}=") do |str|
        instance_variable_set "@#{name.to_s}", str
     end
    end

  end
end
