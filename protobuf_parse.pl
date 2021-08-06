use warnings;
use strict;
use Data::Dumper;

our %field_types = (
	0 => \&parse_varint,
	1 => '64-bit',
	2 => \&parse_length_determined,
	5 => '32-bit',
);

sub parse
{
	my %row = ();
	my @bytes = map { ord } split(//, $_[0]);

	while(@bytes)
	{
		my $val = shift @bytes;
		my $wireType = $val & 7;
		my $fieldNum = $val >> 3;

		$row{$fieldNum} = $::field_types{$wireType}->(\@bytes);
	}

	return %row;
}

sub parse_varint
{
	my $bytes = $_[0];
	my @stack = ();
	my $decimal = 0;

	# Pop values until the MSB is no longer set
	while(my $val = shift $bytes)
	{
		push(@stack, $val);
		if(!($val & 0b10000000)){ last; }
	}

	# Reverse stack to put it in the correct order
	@stack = reverse(@stack);

	# Translate values to decimal
	while(my $val = shift @stack)
	{
		# Drop the the MSB
		$val &= 0b01111111;

		$decimal += $val * 128**(scalar @stack);
	}

	return $decimal;
}

sub parse_length_determined
{
	my $bytes = $_[0];

	my $string = "";
	# Get the string's length
	my $str_length = parse_varint($bytes);
	
	while($str_length--)
	{
		$string .= chr(shift $bytes);
	}

	return $string;
}