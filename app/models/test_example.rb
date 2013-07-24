class TestExample
  def initialize(attrs, id)
    @tester = attrs[:tester] || attrs["tester"]
    @input = attrs[:input] || attrs["input"]
    @id = id
  end

  def persisted?
    true
  end

  def id
    @id
  end

  attr_accessor :tester, :input
end
