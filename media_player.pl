#!/usr/bin/env perl -X

use strict;
use warnings;

use List::Util qw/any/;
use Getopt::Long::Descriptive;

my ($opt, $usage) = describe_options(
    'media_perl.pl %o',
    ['song|s=s','name of song to play'],
    ['repeat|r=i','Number of times to repeat the song', {default=>1}],
    ['listme|l','List files in Music'],
    ['filetype|f=s', 'Type of file to list', {default=>'mp3'}],
    ['help|h','Print usage'],
);

if((!$opt->{song} && !$opt->{listme}) || $opt->{help}){
    print($usage->text);
}

my $song = $opt->{song};
my @valid_types = ('mp3','m4a','wav');
if($opt->{listme} ) {
    if($opt->{filetype} && any { $_ eq $opt->{filetype} } @valid_types){
        my $string = `ls ~/Music/*$opt->{filetype}`;
        $string =~ s{.*Music/}{}g;
        print $string;
        exit;
    }
    print `ls ~/Music/`;
    exit;
}
if($song){
    my $loop = 0;
    while(my $loop < $opt->{repeat}) {
        $song =~ s{\s+}{\\ }g;
        `afplay ~/Music/$song`;
        $loop++;
    }
}
