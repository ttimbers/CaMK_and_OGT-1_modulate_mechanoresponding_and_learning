## Set amount of memory to be devoted to running Choreography
export MWT_JAVA_OPTIONS=-Xmx$3g

## call choreography to analyze the MWT data (each folder within the specified directory)
for folder in */; do Chore --shadowless -p 0.027 -M 2 -t 20 -S -N all -o fDpesSlLwWaAmMkbPcdxyuvor1234 --plugin Reoutline::despike --plugin Respine --plugin MeasureReversal::all $folder; done

## need to create a large file containing all data files with 
## data, plate name and strain name in each row
##grep -r '[0-9]' $(find ./data -name '*.dat') > merged.file
for filename in $(find . -name '*.dat'); do grep -H '[0-9]' $filename >> merged.file; done
