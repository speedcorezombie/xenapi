#!/usr/bin/perl
($pass, $salt) = @ARGV;
print crypt("$pass","\$6\$$salt\$") . "\n";
