#!/usr/bin/perl -w
#
# for a file, e.g. bla.html
# if there is a directory bla
# then replace it with an empty file

if ($#ARGV < 0) { die "Usage: ./remove_if_dir_exists.pl <filename>\n"; }

$filename = $ARGV[0];
$filename_noext = $filename; $filename_noext =~ s/\.[^\/]*$//;

if (-d $filename_noext) {
  print "Directory $filename_noext exists!\n";
  system("echo 'rm $filename'");
  system("rm $filename");
  system("touch $filename");
} else {
  #print "No worries for $filename\n";
}
