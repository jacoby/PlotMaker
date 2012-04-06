package PlotMaker ;

# 201203 - DAJ - Creation
# 201204 - DAJ - Worried about return values, but there really isn't a good
#                mechanism I can use to tell yes or no.

use 5.010 ;
use strict ;
use warnings ;
use Exporter qw( import ) ;
use Template ;

our $VERSION = 0.0.1 ;
our @EXPORT = qw(
    make_plot
    ) ;

my $R = '/usr/local/R-2.11/bin/R ' ; # change when we get new R

# ========= ========= ========= ========= ========= ========= =========
# the one function of this package
# --------- --------- --------- --------- --------- --------- ---------
sub make_plot {
    my ( $input , $output , $vars ) = @_ ;
    my $rout = $output . 'out' ;
    my $config = {
        POST_CHOMP  => 1, # clean up white space
        ABSOLUTE    => 1, # allow absolute file names eg /home/ltl/templates/nanodrop.tt
        RELATIVE    => 1, # allow relative filenames  eg ../templates/nanodrop.tt
    };
    my $template = Template->new( $config );
    $template->process( $input, $vars, $output ) or croak $template->error();
    `$R CMD BATCH $output` ;
    }

1 ;

__END__


=pod

=head1 NAME

    PlotMaker - a module to hold a command to fill
    a Template with data to make a valid R script, than run that
    script to generate a plot

=head1 SYNOPSIS

    use PlotMaker qw{ make_plot }
    make_plot( $input_file , $output_file , $data_hashref ) ;

=head1 DESCRIPTION

    The PlotMaker module implements the make_plot function, which
    a file location for a Template Toolkit-formatted R script, fills
    in the variables from a hashref, writes to an output file location,
    and from there, generates a plot. The location of the output file
    should be in the R script, either hard-coded or taken from the
    data hashref.

    There exists no real good way to distinguish between a failed
    plot attempt and a working one, so users of this module are
    recommended to check their results and rerun if necessary, and,
    if you are using File::Temp to make a temporary directory, to
    include a means to use a real directory to inspect the .Rout file.

=head1 AUTHOR

    Dave Jacoby <jacoby.david@gmail.com>
