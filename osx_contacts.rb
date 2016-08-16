require 'rubygems'
require_relative 'contact.rb'
require "osax"
include Appscript, OSAX

class OSXContacts

  # Fetches contacts and their phone numbers from the local osx contacts app
  # TODO this could be cleaned up a lot.
  def get_contacts
    ab = app("Address Book")
    p = ab.people
    last_names = p.last_name.get.collect { |val| val.is_a?(String) ? val : "" }
    first_names = p.first_name.get.collect { |val| val.is_a?(String) ? val : "" }
    numbers = p.phones.value.get
    number_labels = p.phones.label.get
    people = last_names.zip(first_names, numbers, number_labels)

    contacts = []

    people.each do |last_name, first_name, numbers, number_labels|
      name = [first_name, last_name].delete_if { |s| s == "" }.join(' ')
      next if name == "" || name.nil? || numbers.empty?
      
      phone_numbers = {}

      numbers.zip(number_labels).each do |number, label|
        phone_numbers[label]=number.gsub(/\s+/, "")
      end

      contacts.push(Contact.new(name, phone_numbers))
    end

    return contacts
  end

end