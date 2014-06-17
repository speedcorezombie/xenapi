#!/usr/bin/perl
# Generate SHA-512 hash from password and salt
($pass, $salt) = @ARGV;
print crypt("$pass","\$6\$$salt\$") . "\n";
