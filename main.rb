require_relative "./iridiumphonebook.rb"
require_relative "./osx_contacts.rb"

address_book = OSXContacts.new
contacts = address_book.get_contacts

device = ARGV[0]
puts "Using device #{device}"
iridium = IridiumPhonebook.new
iridium.connect(device)

contacts.each do |contact|
  puts "Add #{contact}? Y/n"
  reply = $stdin.gets.chomp.downcase
  iridium.add(contact) if reply == "y" || reply == ""
end
