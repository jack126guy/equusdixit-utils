# Equus Dixit: Utilities

These are some simple Perl scripts for processing files from [Ponysay](https://github.com/erkin/ponysay). Equus Dixit proper was intended to be a backport of Ponysay to `cowsay` and `fortune`. However, Ponysay has diverged significantly from those two programs, so it is difficult to backport it without effectively reimplementing the entire program.

These tools have been tested against Ponysay 3.0.2.

## cowprep.pl

The `cowprep.pl` tool converts all Ponysay ponies in a directory into cowfiles for `cowsay`, which are placed in another directory.

Usage (can also be found by running without any arguments):

    perl cowsay.pl [ponydir] [cowdir]

This tool does not account for the balloon-width requirements of some ponies, which means that sometimes the line will not connect to the speech balloon.

## fortuneprep.pl

The `fortuneprep.pl` tool aggregates the quotations included in Ponysay in one directory into `fortune` files, one from each character, in another directory. It then prepares the data files using `strfile` and makes symbolic links from `[character].u8` to `[character]`.

**Because of the system tools involved, you should only run this on a Unix-like system (Linux, BSD, etc.).**

Usage (can also be found by running without any arguments):

    perl fortuneprep.pl [quotedir] [fortunedir]

## Naive Assumptions

These tools assume a few things about the files from Ponysay, and they (currently) do not function if these are not met:

* Unix-style line endings (LF or `"\n"`)
* A newline at the end of the file