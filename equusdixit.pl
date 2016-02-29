#!/usr/bin/perl

use strict;
use warnings;
use Text::Wrap 'wrap';

my $width = 70;
local $Text::Wrap::columns = $width;

#Open pipe
open(my $COWSAY, '|-', 'cowsay', @ARGV, '-n')
	or die 'Could not open pipe: ' . $!;

#Format each line of input and pipe to cowsay
my ($wrapped, $WRAPPED_FILE);
while(<STDIN>) {
	$wrapped = wrap('', '', $_);
	open($WRAPPED_FILE, '<', \$wrapped)
		or die 'Could not read string: ' . $!;
	while(<$WRAPPED_FILE>) {
		chomp;
		print $COWSAY &center($_, $width), "\n";
	}
	close $WRAPPED_FILE;
}

close $COWSAY;

#Center a line of text in the given width
sub center {
	my ($text, $width) = @_;
	my $length = length $text;
	if($length >= $width) {
		return $text;
	} else {
		my $before = int(($width - $length) / 2);
		my $after = $width - $length - $before;
		return (' ' x $before) . $text . (' ' x $after);
	}
}