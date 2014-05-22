#! /usr/bin/perl

#use warnings;
use strict;

use Data::Dumper;
use Getopt::Long;
use List::Util qw(first);


my ($vcf_file, $outputFile, $par1, $par2, $f_missing,$pop,$covmin,$col_index,$help);

usage() if ( @ARGV < 1 or
	! GetOptions('help|?' => \$help, 
		'input=s' => \$vcf_file , 
		'output=s' => \$outputFile,
		'male=s' => \$par1,
		'female=s' => \$par2,
		'nmissing=f' =>\$f_missing,
		'pop=s' => \$pop,
		'depthcovmin=i' =>\$covmin,
		'columnn=s' =>\$col_index)
          #or defined $help 
);

sub usage
{
  print "Unknown option: @_\n" if ( @_ );
  print "usage: vcf_to_joinmap.pl [--input or -i : INPUTFILE] [--output or -o : OUTPUTFILE] [--male or -m : PARENT2] [--female or -f : PARENT2] [--nmissing or -n : maximum fraction of missing data to be accepted] [--pop or -p : population type e,g, F2, BC1F1 supported by joinmp] [-d --depthcovmin : minimum read depth] [-c or --columnn : column number which indicate the read depth; various tools keep this parameter in various column] [--help|-?]\n";
  exit;
}

if ($help) {
	die usage;
}

die usage if ( !defined($outputFile) or !defined($vcf_file) or !defined($par1) or !defined($par1) or !defined($col_index));

if ( !defined($f_missing)) {$f_missing=0.1;}
if ( !defined($pop)) {$pop = "F2";}
if ( !defined($covmin)) {$covmin = 5;}

if (($f_missing>1) or ($f_missing<0)) {die "fraction of missing data must be in a range between 0-1\n" };

my (@header,@only_samp,@only_samp_trim,$par1_ind,$par2_ind,@marker_info,@marker_sam,$i,@par1_all,@par2_all,@samp_all,$ms_count,$samp_all_mark,$marker_serial,@print,$class,$i,@total_print,$to_print_samid,$nsam,$nhetero,$na,$nb,$r_nhetero,$r_na,$r_nb,@hetero_ration,@total_hetero,$par1_cov,$par2_cov,$sam_cov);

my $passed_marker = 0;
@total_print=();
@total_hetero=();

`rm -f $outputFile.loc $outputFile.tab`;

open(FILE, $vcf_file);
while(<FILE>)
	{chomp;
	@print = ();
	@hetero_ration = ();
	if($_ =~ /^#/) 
		{
		@header = split("\t", $_);
		@only_samp = @header;
		$par1_ind = first { $header[$_] eq $par1 } 0..$#header;
		$par2_ind = first { $header[$_] eq $par2 } 0..$#header;
		if ($par1_ind<$par2_ind) {splice @only_samp, $par1_ind, 1;splice @only_samp, ($par2_ind-1), 1;}
		else {splice @only_samp, $par1_ind, 1;splice @only_samp, $par2_ind, 1;}
		@only_samp_trim = @only_samp[9..$#only_samp];
		$nsam = ($#only_samp_trim+1); 
		$to_print_samid = join("\n", @only_samp_trim);
		#print "$par1_ind\t$par2_ind\n";
		}
	else {
		$ms_count =0;
		$nhetero = 0;
		$na = 0;
		$nb = 0;
		@marker_info = (split("\t", $_))[0..8];
		@marker_sam = (split("\t", $_))[9..$#header];
		@par1_all = split("/", (split(":",$marker_sam[($par1_ind-9)]))[0]);
		@par2_all = split("/", (split(":",$marker_sam[($par2_ind-9)]))[0]);
		$par1_cov = (split(":",$marker_sam[($par1_ind-9)]))[($col_index-1)];
		$par2_cov = (split(":",$marker_sam[($par2_ind-9)]))[($col_index-1)];
		$marker_serial = $marker_info[0]."_".$marker_info[1] ;
		if (($par1_all[0] ne ".") && ($par1_all[0] eq $par1_all[1]) && ($par2_all[0] ne ".") && ($par2_all[0] eq $par2_all[1]) && ($par1_cov >=$covmin) && ($par2_cov >=$covmin)) 
			{
			if ($par1_all[0] ne $par2_all[0])
				{
				$class = "<a,h,b>";
				push @print, $marker_serial;
				push @print, $class;
				push @hetero_ration, $marker_serial;
				my $c = $#marker_sam;

				for ($i=0;$i<=$#marker_sam;$i++)
					{
					if (($i == ($par1_ind-9)) or ($i == ($par2_ind-9))) {next;}
					else
						{
						$sam_cov = (split(":",$marker_sam[($i-9)]))[($col_index-1)]; 
						@samp_all = split("/", (split(":",$marker_sam[($i-9)]))[0]);
						if (@samp_all[0] eq "." or ($sam_cov<$covmin)) {$ms_count++;$samp_all_mark="-";push @print, $samp_all_mark;}
						else 
							{
							if (($samp_all[0] ne $samp_all[1]) &&  ( ( ($samp_all[0] eq $par1_all[0]) || ($samp_all[0] eq $par2_all[0]) )  ||  ( ($samp_all[1] eq $par1_all[0]) or ($samp_all[1] eq $par2_all[0]) ) ) )
								{$samp_all_mark="h";push @print, $samp_all_mark;$nhetero++;}
							if (($samp_all[0] eq $samp_all[1]) && ($samp_all[0] eq $par1_all[0])) 
								{$samp_all_mark="a";push @print, $samp_all_mark;$na++;}
							if (($samp_all[0] eq $samp_all[1]) && ($samp_all[0] eq $par2_all[0])) 
								{$samp_all_mark="b";push @print, $samp_all_mark;$nb++;}
							}
						}
					}
				if ( ($nhetero+$na+$nb) >0) 
					{
					$r_nhetero = sprintf("%.2f", ($nhetero/($nhetero+$na+$nb)));
					$r_na = sprintf("%.2f", ($na/($nhetero+$na+$nb)));
					$r_nb = sprintf("%.2f",($nb/($nhetero+$na+$nb)));
					push @hetero_ration, $r_na;
					push @hetero_ration, $r_nhetero;
					push @hetero_ration, $r_nb;
					}
				
				}			
			}

		}

	my $missing_f = $ms_count/($#marker_sam-1);

	if (($missing_f<=$f_missing) && ($#print == $#marker_sam)) 
		{
		my $to_print_all = join("\t", @print);
		my $to_print_hetero = join("\t",@hetero_ration);
		$passed_marker++; 
		push @total_print,$to_print_all;
		push @total_hetero,$to_print_hetero;
		#print "$to_print_all\n";
		}
	

	}
close(FILE);


my $to_print_all_all = join("\n", @total_print);
my $to_print_hetero_all = join("\n",@total_hetero);

open (FILEOUT,">>$outputFile.loc");
print FILEOUT "name = ".$outputFile."\n";
print FILEOUT "popt = ".$pop."\n";
print FILEOUT "nloc = ".$passed_marker."\n";
print FILEOUT "nind = ".$nsam."\n";
print FILEOUT "$to_print_all_all\n";
print FILEOUT "\nindividual names:\n";
print FILEOUT "$to_print_samid\n";
close(FILEOUT);

open (FILESTAT,">>$outputFile.tab");
print FILESTAT "Marker\tallele_A\tHetero\tallele_B";
print FILESTAT "$to_print_hetero_all\n";

#print "name = hoe.loc\n";
#print "popt = F2\n";
#print "nloc = ".$passed_marker."\n";
#print "nind = ".$nsam."\n";
#print "$to_print_all_all\n";
#print "\nindividual names:\n";
#print "$to_print_samid\n";
