#!/usr/bin/perl -W

use strict;
use warnings;
use Data::UUID;
use Errno qw(:POSIX);
use Getopt::Long;


###############################################################################
#
my $Namespace = undef;
my $Name      = undef;
#
###############################################################################
#
our $Verbose = 1; # Verbose by default;
#
###############################################################################



#==============================================================================
#
MAIN:
{
  &_init;
  my $ug   = new Data::UUID;
  my $uuid = (defined $Namespace and defined $Name)
           ? $ug->create_from_name_hex($Namespace, $Name)
           : $ug->create_hex;
     $uuid = lc substr($uuid, 2);
  if ($Verbose)
  {
  printf "-- UUID Generator --\n"
       . " - Namespace : %s\n"
       . " - Name      : %s\n\n",
         ( defined $Namespace ) ? $Namespace : '<undef>',
         ( defined $Name      ) ? $Name      : '<undef>';
  } 
  print "$uuid\n";
}
#
#==============================================================================



#------------------------------------------------------------------------------
#
sub _init ()
{

  my ($quiet1, $quiet2, $help1, $help2, $help3);
  GetOptions
  (
    'namespace=s' => \$Namespace,
    'name=s'      => \$Name,
    'quiet'       => \$quiet1,
    'q'           => \$quiet2,
    'help'        => \$help1,
    'h'           => \$help2,
  );

  # Handle namespace/name
  if (defined $Name and not defined $Namespace)
  {
    print STDERR "\nERROR: A --name requires a --namespace\n\n";
    exit EINVAL;
  }

  # Set verbosity / quietness
  $Verbose = 0 if $quiet1 or $quiet2;

  # Handle requests for help
  if ($help1 or $help2)
  {
    my $filename =  $0;
       $filename =~ s/^.+\///;
    print "\n",
          "USAGE: $filename [--namespace <NAMESPACE> [--name <NAME>]] [--quiet|-q] [--help|-h]\n",
          "\n",
          "   --namespace   Namespace to use    [optional]\n",
          "   --name        Name to use         [optional]\n",
          "   --quiet       Only display result [optional]\n",
          "   --help        This message        [optional]\n",
          "\n",
          "   NOTE: This generates a v3 UUID (also knwon as a GUID). A UUID is 128 bits\n",
          "         long, and will be generated as a lower-case hex string per RFC-4122.\n",
          "\n";
    exit;
  }

} 
#
#------------------------------------------------------------------------------



__END__
