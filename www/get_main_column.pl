#!/usr/bin/perl -w

use Encode qw(decode encode);
use JSON;

if ($#ARGV != 0) {
  die "Usage get_main_column.pl <file>\n";
}

$title = "NLnet;";
$filename = $ARGV[0];
open (I, '<:encoding(UTF-8)', $filename) or die "File not found: $filename\n";

$inside = 0;
$description = "";
while (<I>) {
  #s/[^ -z\xC0-\xFF]//g;
  s/<script.*?<\/script>//g;
  if (/<title>([^<]+)<\/title>/i) {
    $title = $1;
  } elsif (/<div id="maincolumn/) {
    $inside = 1;
  } elsif (/<div id="rightcolumn/) {
    $inside = 0;
  } elsif (/<script>/) {
    $inside = 0;
  } elsif ($inside) {
    s/<[^>]+>/ /g;
    s/\s+/ /g;
    $description .= $_;
  }
}
close I;

$title =~ s/^NLnet; +//;
$title =~ s/<[^>]*>/ /g;
$title =~ s/\s+/ /g;
$title =~ s/^ | $//g;

$image = "";
if ($description =~ /<img[^>]+src="([^"]+)"/) {
  $image = $1;
}
$description =~ s/<[^>]*>/ /g;
$description =~ s/\s+/ /g;
$description =~ s/^ | $//g;
$description =~ s/ ([,\.\;\:]) /$1 /g;
if (length($description) > 4000) {
  $description = substr($description, 0, 4000);
  $rindex = rindex($description, " ");
  $description = substr($description, 0, $rindex);
}

$filename =~ s/^[a-z]*\.nlnet\.nl//;
$filename =~ s/\@.*$//;
$count = $filename =~ tr/\//\//;
$score = 9 - $count;
if ($filename =~ /\/index\.html$/) { 
    $score += 0.5; 
    $filename =~ s/\/index\.html$/\//;    
}
#if ($filename !~ /^https?:/) { $filename = 'https://nlnet.nl' . $filename; }
if ($score < 0) { $score = 0; }
if ($description !~ /[0-9A-za-z]/) { $description = $title; }

%my_object = ('title' => $title, 'description' => $description, 'url' => $filename);
#if ($image) { 
#   $my_object{'image'} = $image;
#}
$my_json = encode_json \%my_object;

$first = sprintf "\"prior\":%1.1f,", $score; # to make sure 'prior' is the first
$my_json =~ s/^{/{$first/;

if ($title ne "NLnet;" or $description ne "NLnet;") {
  print "$my_json,\n";
}
