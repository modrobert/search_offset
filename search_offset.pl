#!/usr/bin/perl
#
# search_offset.pl - Search for regex match and print offset in different ways.
# Copyright (C) 2020 by <modrobert@gmail.com>
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
# REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
# INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
# LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.
#

use strict;
use warnings;
use Getopt::Long;
use File::Basename;
use File::Find;

sub cmd_help {
    my ($reason) = @_;
    print ($reason) if ($reason);
    # Getting program name without path.
    print "Usage:\n";
    my $prog = basename $0;
    print "$prog -s|--search \"REGEX_STRING\" [FILE...*|-]\n";
    print "$prog -r|--recursive -s|--search \"REGEX_STRING\" [-p|--path PATH]\n";
    exit 1;
}

sub wanted {
    if (-f -r $_) {
        push @ARGV, $File::Find::name;
    }
    return;
}

my $help = 0;
my $recursive = 0;
my $search = '';
my $path = '.';

GetOptions(
    "help|?" => \$help,
    "recursive" => \$recursive,
    "search=s" => \$search,
    "path=s" => \$path,
) or &cmd_help;

if ($recursive) {
    find({ wanted => \&wanted, follow => 1 }, $path);
}

if ($help or not @ARGV) {
    &cmd_help("Search for regex match and print offset in different ways.\n");
}

&cmd_help("The search option is required.\n") unless($search);

my $oldfile = undef;
my $filename;
my $line_counter = 1;
my $match_length;
my $column;
my $line_offset;
my $byte_offset;
my $file_offset = 0;
my $line_length;
my $line;

while (<>) {
    if (defined $oldfile and $oldfile ne $ARGV) {
        $line_counter = 1;
        $file_offset = 0;
    }
    $column = 1;
    $line_offset = 1;
    $line = $_;
    $line_length = length $line;
    # Removing matches to get all hits on the same line.
    while ($line =~ s/(?<match>${search})//) {
        $match_length = length $+{match};
        $column = ($-[0] + $line_offset);
        # Offset starts at zero.
        $byte_offset = $file_offset + $column - 1;
        # Get current filename without path.
        if ($recursive) {
            $filename = $ARGV;
        } else {
            $filename = basename $ARGV;
        }
        printf "File: %-30s  ", $filename;
        printf "Line: %-6d ", $line_counter;
        printf "Col: %-5d ", $column;
        printf "Offset: 0x%08x\n", $byte_offset;
        $line_offset += $match_length;
    }
    $line_counter++;
    $file_offset += $line_length;
    $oldfile = $ARGV;
}
