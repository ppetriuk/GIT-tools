#!/usr/bin/env perl

# You can pass argument to this script from the command line
# $REPO_DIR is a full path to the local diractory with git repository

use strict;
#no strict "refs";
use warnings;

use File::Spec;

my $REPO_DIR;
if ( $ARGV[0] eq "")
{
    $REPO_DIR =~ "";
    print "Looking for the git repo in the same directory as current script...\n";
}
else
{
    $REPO_DIR = $ARGV[0] ;
}

sub listing_tags {
    my $repo_path = shift;

    # Creating the file with list of git tags
    my $ifile_path = File::Spec->catfile( $repo_path, "tags.list" );
    open(my $ifile_handler, ">", $ifile_path) or die "Can't create tags.list: $!";
    
    my $list_tags = `git --git-dir="$repo_path/.git" tag -l`;
    print $ifile_handler "$list_tags";

    close ($ifile_handler) or die "Can't close tags.list: $!";
    return $ifile_path;
}

sub deleting_tags {
    my $repo_path = shift;
    open(my $ifile_handler, "<", listing_tags($repo_path)) or die "Can't open tags.list: $!";
    open (my $ofile_handler, ">", "tags.result") or die "Can't create tags.result: $!";
    while (<$ifile_handler>)
    {
        my $line  = <$ifile_handler>; 
        chomp($line);
        if($line =~ /Debug/)
        {
            print $ofile_handler "$line\n";
            my $git_delete = `git --git-dir="$repo_path/.git" tag -d $line`;
            print "$git_delete\n";
            my $git_push = `git --git-dir="$repo_path/.git" push origin :refs/tags/$line`;
            print "$git_push\n";
        }
    }
    close ($ifile_handler) or die "Can't close tags.list: $!";
    close ($ofile_handler) or die "Can't close tags.list: $!";
}

deleting_tags($REPO_DIR);

exit

