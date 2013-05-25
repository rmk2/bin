#!/usr/bin/perl

my $blanked = 0;
open (IN, "xscreensaver-command -watch |");
while (<IN>) {
    if (m/^(BLANK|LOCK)/) {
	    if (!$blanked) {
		    system "ssh-add -D";
		    $blanked = 1;
		}
        } elsif (m/^UNBLANK/) {
	    system "bash ssh-add.sh";
	    $blanked = 0;
        }
}
