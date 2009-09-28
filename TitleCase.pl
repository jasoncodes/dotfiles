#!/usr/bin/env perl

# 	This filter changes all words to Title Caps, and attempts to be clever
#	about *un*capitalizing small words like a/an/the in the input.
#
#	The list of "small words" which are not capped comes from
#	the New York Times Manual of Style, plus 'vs' and 'v'. 
#
#	10 May 2008
#	Original version by John Gruber:
#	http://daringfireball.net/2008/05/title_case
#
#	28 July 2008
#	Re-written and much improved by Aristotle Pagaltzis:
#	http://plasmasturm.org/code/titlecase/
#
#	License: http://www.opensource.org/licenses/mit-license.php
#


use strict;
use warnings;
use utf8;
use open qw( :encoding(UTF-8) :std );


my @small_words = qw( (?<!q&)a an and as at(?!&t) but by en for if in of on or the to v[.]? via vs[.]? );
my $small_re = join '|', @small_words;

my $apos = qr/ (?: ['’] [[:lower:]]* )? /x;

while ( <> ) {
	s{
		\b (_*) (?:
			( [-_[:alpha:]]+ [@.:/] [-_[:alpha:]@.:/]+ $apos ) # URL, domain, or email
			|
			( (?i: $small_re ) $apos )                         # or small word (case-insensitive)
			|
			( [[:alpha:]] [[:lower:]'’()\[\]{}]* $apos )       # or word w/o internal caps
			|
			( [[:alpha:]] [[:alpha:]'’()\[\]{}]* $apos )       # or some other word
		) (_*) \b
	}{
		$1 . (
		  defined $2 ? $2         # preserve URL, domain, or email
		: defined $3 ? "\L$3"     # lowercase small word
		: defined $4 ? "\u\L$4"   # capitalize word w/o internal caps
		: $5                      # preserve other kinds of word
		) . $6
	}exgo;


	# exceptions for small words: capitalize at start and end of title
	s{
		(  \A [[:punct:]]*         # start of title...
		|  [:.;?!][ ]+             # or of subsentence...
		|  [ ]['"“‘(\[][ ]*     )  # or of inserted subphrase...
		( $small_re ) \b           # ... followed by small word
	}{$1\u\L$2}xigo;

	s{
		\b ( $small_re )      # small word...
		(?= [[:punct:]]* \Z   # ... at the end of the title...
		|   ['"’”)\]] [ ] )   # ... or of an inserted subphrase?
	}{\u\L$1}xigo;


	print;
}

__END__

