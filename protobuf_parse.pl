use warnings;
use strict;
use Data::Dumper;

open(my $fh, '<:raw', $ARGV[0]) or die "Forgot input";

my $line = <$fh>;
chomp $line;
parse($line);

our %field_types = (
	0 => 'varint',
	1 => '64-bit',
	2 => 'length determined',
	5 => '32-bit',
)

sub parse
{
	my @bytes = map { unpack('H2') } split(//, $_[0]);

	foreach my $byte (@bytes)
	{
		my ($field_number, $wiretype) = parse
	}
	print Dumper(@bytes);
	# print join("\n", @bytes);

}