#!/usr/bin/perl

#gnome
#my $cmd = "dbus-monitor --session \"type='signal',interface='org.gnome.ScreenSaver',member='SessionIdleChanged'\"";

#kde
my $cmd = "dbus-monitor --session \"type='signal',interface='org.freedesktop.ScreenSaver',member='ActiveChanged'\"";
open (IN, "$cmd |");

while (<IN>) {
if (m/^\s+boolean true/) {
#when screensaver activates, run the following commands
system("ssh-add -D");
} elsif (m/^\s+boolean false/) {
#when screensaver deactivates, run the following commands
system("sh ssh-add.sh");
}
}
