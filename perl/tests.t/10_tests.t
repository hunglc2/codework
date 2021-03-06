# http://www.petdance.com/perl/adding-testing-to-existing-projects.pdf
# $Id$


use constant USER => 'SYS';
use constant PASS => 'CHANGE_ON_INSTALL';
my $dbh = DBI->connect( $mydb, USER, PASS );
my $sth = $dbh->prepare( "select 1 from dual" );
my $rc = $sth->execute;
isnt( $rc, 0, q/SYS user does not have default PW/ );




# Get all ISBNs and run them through a validator
my $sth = $dbh->prepare( "select ISBN from BOOK" );
$sth->execute();
my $bad;
while ( my $row = $sth->fetch ) {
    $isbn = new Business::ISBN( $row->[0] );
    if ( !$isbn->is_valid ) {
        fail( "Invalid ISBN(s) found" )
        unless $bad++;
        diag( "$row->[0] is invalid" );
    }
}
pass( "No bad ISBNs found" ) unless $bad;


# Use warnings/strict

    # Find all Perl files, but don�t look in CVS
    my $rule = File::Find::Rule->new;
    $rule->or(
        $rule->new->directory->name('CVS')->prune->discard,
        $rule->new->file->name( '*.pl','*.pm','*.t' )
    );
    my @files = $rule->in( $base );
    check( $_ ) for @files;

    # check tem
    sub check {
        my $filename = shift;
        my $dispname =
        File::Spec->abs2rel( $filename, $base );

        local $/ = undef;
        open( my $fh, $filename ) or
        return fail( "Couldn't open $dispname: $!" );
        my $text = <$fh>;
        close $fh;

        like( $text, qr/use strict;/, "$dispname uses strict" );
        like( $text, qr/use warnings;|perl -w/,
        "$dispname uses warnings" );
    } # check()


# All .pm have .t
    # Get a list of .pm files and then...
    sub check {
        my $filename = shift;
        my $tname = $filename;
        $tname =~ s/ \.pm \Z / .t /x
            or die "Only send me .pm files, please";
        ok( -s $tname, "$filename has a test file" );
    } # check()


# All HTML valid
    # Get a list of HTML files, and...
    for my $filename ( @files ) {
        open( my $fh, $filename ) or
            fail( "Couldn't open $filename" ), next;
        my $text = do { local $/ = undef; <$fh> }
        local $/ = undef;
        close $fh;

        my $lint = HTML::Lint->new;
        $lint->only_types( HTML::Lint::Error::STRUCTURE );
        html_ok( $lint, $text, $dispname );
    }
    diag( "$html HTML files" );

# Installed modules

    my %requirements = ( # 0 means we don't care
        'Business::ISBN' => 0,
        'Carp::Assert' => '0.17',
        'Carp::Assert::More' => '1.10',
        'Date::Calc' => 0,
        'Date::Manip' => 0,
        'DateTime' => '0.20',
        'DB_File' => '1.808',
        'Exporter' => '5.562',
        'File::Spec' => '0.82',
        'File::Temp' => '0.13',
        ...
    );

    for my $module ( sort keys %requirements ) {
        my $wanted = $requirements{ $module };
        if ( use_ok( $module ) ) {
            if ( $wanted ) {
            my $actual = $module->VERSION;
            cmp_ok( $actual,'>=',$wanted, $module );
            }
            else {
                pass( "$module loaded" );
            }
        }
        else {
            fail( "Can't load $module" );
        }
    } # for keys %requirements

# No embedded tabs
    sub check {
        my $fname = shift;
        open( my $fh, "<", $fname )
            or die "$fname: $!\n";
        my $bad;
        while ( my $line = <$fh> ) {
        if ( $line =~ /\t/ ) {
            fail( "$fname has tabs" ) unless $bad++;
            diag( "$.: $line" );
        }
        } # while
        pass( "$fname is tab-free" ) unless $bad;
    } # check

# All POD is ok
    use Test::More;
    use Test::Pod 1.00;
    all_pod_files_ok();


# All functions have POD
    Test::Pod::Coverage makes it terribly simple
    use Test::More;
    use Test::Pod::Coverage 1.04;
    all_pod_coverage_ok();

