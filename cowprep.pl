#!/usr/bin/perl
#Copyright (c) 2014 Jack "Fox" Grayson <http://github.com/jack126guy>
#All rights reserved.

#Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

#1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

#2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

#3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

#THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

use strict;
use feature 'unicode_strings';

die 'Usage: perl cowprep.pl [ponydir] [cowdir]' unless @ARGV >= 2;
my ($ponydir, $cowdir) = @ARGV;
$ponydir .= '/' unless ($ponydir =~ m/\/$/ || $ponydir =~ m/\\$/);
$cowdir .= '/' unless ($cowdir =~ m/\/$/ || $cowdir =~ m/\\$/);
die 'Could not open directory: ' . $! unless opendir(PONYDIR, $ponydir);
my $ponyname;
my $isheader;
while($_ = readdir PONYDIR) {
	next if m/^\./;
	($ponyname, undef) = split /\./;
	warn 'Could not open ' . $_ . ': ' . $! unless open(PONY, '<:encoding(UTF-8)', $ponydir . $_);
	warn 'Could not open ' . $ponyname . '.cow: ' . $! unless open(COW, '>:encoding(UTF-8)', $cowdir . $ponyname . '.cow');
	$isheader = 0;
	#Needed for Unicode block elements
	print COW 'use utf8;', "\n";
	while(<PONY>) {
		if(m/^\$\$\$/) {
			print COW '#', $_;
			if($isheader) {
				#End of header; add prefix to main text
				#Replace $/$ thoughts with either / or o, depending
				print COW '$rthoughts = $thoughts eq \'\\\\\' ? \'/\' : $thoughts;', "\n";
				print COW '$the_cow = <<EOF;', "\n";
			}
			$isheader = $isheader ? 0 : 1;
		}
		if($isheader) {
			print COW '#', $_;
		} else {
			next if m/\$balloon/;
			s/\$\\\$/\$thoughts/g;
			s/\$\/\$/\$rthoughts/g;
			print COW $_;
		}
	}
	print COW 'EOF', "\n";
	close PONY;
	close COW;
}