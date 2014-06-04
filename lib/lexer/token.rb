class Token
  attr_reader :type, :value

  def initialize(type, value)
    @type  = type
    @value = value
  end

  def ==(obj)
    type == obj.type && value == obj.value
  end

  def to_s
    "#{type} -> #{value}"
  end
end
