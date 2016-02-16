#!/usr/bin/perl
#Copyright (c) 2014 Jack "Fox" Grayson <http://github.com/jack126guy>
#All rights reserved.

#Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

#1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

#2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

#3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

#THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

use strict;
use warnings;

#Check command-line arguments
die 'Usage: perl fortuneprep.pl [quotedir] [fortunedir]' unless @ARGV >= 2;

my ($quotedir, $fortunedir) = @ARGV;

#Add trailing slashes to directories
$quotedir .= '/' unless ($quotedir =~ m/\/$/ || $quotedir =~ m/\\$/);
$fortunedir .= '/' unless ($fortunedir =~ m/\/$/ || $fortunedir =~ m/\\$/);

die 'Could not open directory: ' . $! unless opendir(my $QUOTES, $quotedir);
my (%quotes, $pony, $number);

#Read quotations
while($_ = readdir $QUOTES) {
	#Skip things
	next if m/^\./; #Dotfiles
	next unless m/\./; #Files with no dot
	next unless -f $quotedir . $_; #Things that aren't files

	($pony, $number) = split /\./;

	#Create quotation array
	$quotes{$pony} = [] unless exists $quotes{$pony};

	warn 'Could not open ' . $_ . ': ' . $! unless open(my $QUOTEFILE, '<:crlf:encoding(UTF-8)', $quotedir . $_);
	while(<$QUOTEFILE>) {
		$quotes{$pony}->[$number] .= $_;
	}
	close $QUOTEFILE;
}

#Write fortunes
die 'Could not change to fortune directory: ' . $! unless chdir($fortunedir);
foreach(keys %quotes) {
	warn 'Could not open ' . $_ . ': ' . $! unless open(my $FORTUNEFILE, '>:encoding(UTF-8)', $_);
	foreach(@{$quotes{$_}}) {
		print $FORTUNEFILE $_;
		print $FORTUNEFILE '%', "\n";
	}
	#Make data file
	system 'strfile ' . $_;
	#Add .u8 symlink
	system 'ln -s ' . $_ . ' ' . $_ . '.u8';
}