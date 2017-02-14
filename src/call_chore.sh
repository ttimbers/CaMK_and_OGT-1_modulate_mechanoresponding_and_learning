## Written by: Tiffany A. Timbers
## Feb 14, 2017
##
## This is the driver script will run Choreography to get a summary file of
## reversals taps that occur 1s after a tap from each worm from data files from
## the Multi-worm tracker (Swierczek et al., 2011).
##
## Requires the following input from the user:
##
##		$1: gigabytes of memory to be used to run Choreography (dependent upon
##			the machine you are using
##		$2: path to where data lives (all files should be in one folder - no subfolders)

## Set amount of memory to be devoted to running Choreography (see README for how
## Choreography should be installed to run this script)
export MWT_JAVA_OPTIONS=-Xmx$1g

## call choreography to analyze the MWT data (each folder within the specified directory)
for folder in $2/*; do Chore --shadowless --pixelsize 0.027 --minimum-move-body 2 --minimum-time 20 --segment --output speed,midline,morphwidth --plugin Reoutline::despike --plugin Respine --plugin MeasureReversal::tap::dt=1::collect $folder; done

## need to create a large file containing all rev files with
## data, plate name and strain name in each row
for filename in $(find . -name '*.rev'); do grep -H '[.]*' $filename >> ./$2/data.srev; done
