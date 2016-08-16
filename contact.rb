class Contact
  attr_accessor :name, :phone_numbers

  def initialize(name, phone_numbers = {})
    @name = name
    @phone_numbers = phone_numbers
  end

  def to_s
    "#{name} #{phone_numbers}"
  end
end