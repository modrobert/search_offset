# search_offset.pl

### Copyright (C) 2020 by &lt;modrobert@gmail.com&gt;
### Software licensed under Zero Clause BSD.

---

### Description

Perl program which searches in file(s) or stdin for regex match and prints offset in different ways. Multiple hits within the same line are handled properly. Features recursive option traversing directories and symlinks. This was created as part of training to explore some useful internals.

---

### Usage

<pre>
Search for regex match and print offset in different ways.
Usage:
search_offset.pl -s|--search "REGEX_STRING" [FILE...*|-]
search_offset.pl -r|--recursive -s|--search "REGEX_STRING" [-p|--path PATH]
</pre>

### Examples

<pre>
$ search_offset.pl -s "[Ff]oo" *
File: greet2.pl                       Line: 24     Col: 5     Offset: 0x0000019b
File: greet2.pl                       Line: 25     Col: 20    Offset: 0x000001d1
File: regex_second_exercises.txt      Line: 6      Col: 11    Offset: 0x00000042
File: regex_second_exercises.txt      Line: 7      Col: 11    Offset: 0x0000005b
File: regex_test.txt                  Line: 4      Col: 1     Offset: 0x0000001d
File: regex_test.txt                  Line: 4      Col: 4     Offset: 0x00000020
File: regex_test.txt                  Line: 5      Col: 1     Offset: 0x00000024
File: regex_test.txt                  Line: 5      Col: 8     Offset: 0x0000002b
</pre>

<pre>
$ cat test.txt | search_offset.pl -s "print" -
File: -                               Line: 10     Col: 5     Offset: 0x00000078
File: -                               Line: 14     Col: 9     Offset: 0x000000e2
File: -                               Line: 16     Col: 9     Offset: 0x00000111
File: -                               Line: 20     Col: 9     Offset: 0x0000016f
File: -                               Line: 22     Col: 9     Offset: 0x000001ab
</pre>

<pre>
$ search_offset.pl -r -s "^\w+$"
File: ./file_1.txt                    Line: 1      Col: 1     Offset: 0x00000000
File: ./file_1.txt                    Line: 2      Col: 1     Offset: 0x00000005
File: ./foo/file_2.txt                Line: 1      Col: 1     Offset: 0x00000000
File: ./foo/file_2.txt                Line: 2      Col: 1     Offset: 0x00000005
</pre>

<pre>
$ search_offset.pl -r -s "([T|t]e)|(foo)" -p /tmp/test
File: /tmp/test/file_1.txt            Line: 1      Col: 1     Offset: 0x00000000
File: /tmp/test/file_1.txt            Line: 2      Col: 1     Offset: 0x00000005
File: /tmp/test/foo/file_2.txt        Line: 1      Col: 1     Offset: 0x00000000
File: /tmp/test/foo/file_2.txt        Line: 2      Col: 1     Offset: 0x00000005
</pre>

