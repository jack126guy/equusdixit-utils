#!/usr/bin/perl
#Copyright (c) 2014 Jack "Fox" Grayson <http://github.com/jack126guy>
#All rights reserved.

#Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

#1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

#2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

#3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

#THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

use strict;

die 'Usage: perl fortuneprep.pl [quotedir] [fortunedir]' unless @ARGV >= 2;
my ($quotedir, $fortunedir) = @ARGV;
$quotedir .= '/' unless ($quotedir =~ m/\/$/ || $quotedir =~ m/\\$/);
$fortunedir .= '/' unless ($fortunedir =~ m/\/$/ || $fortunedir =~ m/\\$/);
die 'Could not open directory: ' . $! unless opendir(QUOTES, $quotedir);
my (%quotes, $pony, $number);
while($_ = readdir QUOTES) {
	next if m/^\./;
	next unless m/\./;
	next unless -f $quotedir . $_;
	($pony, $number) = split /\./;
	$quotes{$pony} = [] unless exists $quotes{$pony};
	warn 'Could not open ' . $_ . ': ' . $! unless open(QUOTEFILE, '<:crlf:encoding(UTF-8)', $quotedir . $_);
	while(<QUOTEFILE>) {
		$quotes{$pony}->[$number] .= $_;
	}
	close QUOTEFILE;
}
foreach(keys %quotes) {
	warn 'Could not open ' . $fortunedir . $_ . ': ' . $! unless open(FORTUNEFILE, '>:encoding(UTF-8)', $fortunedir . $_);
	foreach(@{$quotes{$_}}) {
		print FORTUNEFILE;
		print FORTUNEFILE '%', "\n";
	}
	#Make data file
	system 'strfile ' . $fortunedir . $_;
	#Add .u8 symlink
	system 'ln -sTr ' . $fortunedir . $_ . ' ' . $fortunedir . $_ . '.u8';
}