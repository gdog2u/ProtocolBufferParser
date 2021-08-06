#################
# Demo.pl
#	A small proof of concept to demonstrate how to use the parser.
#################

use warnings;
use strict;

require('protobuf_parse.pl');

open(my $fh, '<:raw', $ARGV[0]) or die "Forgot input";

my $line = <$fh>;

close($fh);

chomp $line;
print Dumper(parse($line));

1;