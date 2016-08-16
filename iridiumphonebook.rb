require "rubygems"
require "serialport"

class IridiumPhonebook

  # Connect to the iridium phone
  # @param device a string representing the phone's device, such as /dev/tty.usbmodem1421
  def connect(device)
    @sp = SerialPort.new(device, 9600, 8, 1, SerialPort::NONE)
    write("ATE0\r")
    read()
    read()
  end

  # Add a person and a specific list of phone numbers
  # @contact a contact object
  def add(contact)
    raise StandardError, "Must connect to device first" if @sp.nil?

    name_hex = to_hex(contact.name)
    home_hex = to_hex(contact.phone_numbers["home"])
    mobile_hex = to_hex(contact.phone_numbers["mobile"])
    work_hex = to_hex(contact.phone_numbers["work"])

    # https://satphoneshop.com/downloads/AT_Commands.pdf
    # +CAPBW=<name>,[<home_number>],[<work_number>],[<mobile_number>],[<other_number>],[<email>],[<notes>] 
    cmd = "AT+CAPBW=#{name_hex},#{home_hex},#{work_hex},#{mobile_hex},,,\r"

    write(cmd)
  end

  def write(cmd)
    cmd.each_byte do |b|
      @sp.putc(b.chr)
    end

    @sp.flush_output
  end

  # this method borrowed from https://github.com/adammck/rubygsm
  def read
    buf = ""
    term = ["\r\n"]

    while true do
      char = @sp.getc
      
      # die if we couldn't read
      # (nil signifies an error)
      raise StandardError if char.nil?
      
      # convert the character to ascii,
      # and append it to the tmp buffer
      buf << sprintf("%c", char)

      # if a terminator was just received,
      # then return the current buffer
      term.each do |t|
        len = t.length
        if buf[-len, len] == t
          return buf.strip
        end
      end
    end
  end

  def to_hex(str)
    return "" if str.nil?
    str.codepoints.map { |c| "%04X" % c }.join
  end
end
