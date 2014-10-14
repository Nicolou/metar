#!/usr/bin/perl

use strict;
use warnings;
 
# For parsing
use XML::Simple;
 
# For downloading
use LWP::Simple;
 
# For debug output
use Data::Dumper;

# For floor methode
use POSIX;
 
if (!@ARGV) {
	print ("\nusage : metar.pl ICAO\n     with ICAO like LFRB for example\n");
	exit(-1);
}
my $data = get('https://www.aviationweather.gov/adds/dataserver_current/httpparam?dataSource=metars&requestType=retrieve&format=xml&stationString='.$ARGV[0].'&hoursBeforeNow=1');
     
my $parser = new XML::Simple;

my $dom = $parser->XMLin($data, ForceArray => ['METAR']);

my $resultNum = $dom->{'data'}->{'num_results'};
if ($resultNum == 0) {
	print("\nNo metar available for " . $ARGV[0] . "\n");
}else{

	#use Data::Dumper;
	#print Dumper($dom);
	
	#transcript meter altitude in feet
	my $feet = $dom->{'data'}->{'METAR'}->[0]->{'elevation_m'};
	$feet /= 0.3048;	
	
	print "\nflight rules : " . $dom->{'data'}->{'METAR'}->[0]->{'flight_category'};
	print "\n";
	print $dom->{'data'}->{'METAR'}->[0]->{'raw_text'};
	print "\nElevation : " .  floor($feet)
		. " feet\tLong:" . $dom->{'data'}->{'METAR'}->[0]->{'longitude'} 
		. "\tLat:" . $dom->{'data'}->{'METAR'}->[0]->{'latitude'};
	print "\n\n";
}