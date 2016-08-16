This is a simple program to copy phone numbers from the Mac OS X address book to an Iridum Extreme phone.

## Usage
Connect the phone with a USB cable.

Find the device for the phone, something like:
    
    ls /dev/tty.usbmodem*

Run the script with that device as the first argument
    
    bundle exec ruby main.rb /dev/tty.usbmodem1421

## TODO
This is all very hacky so there's a lot of improvements to be made, such as sync support etc.
I probably won't get to it so if someone else wants to have at it feel free.