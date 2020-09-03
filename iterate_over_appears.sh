#!/bin/bash

csv_in='/home/arthur/Dropbox/projects/ambrals_modeling/mcd43a1_results_subset_test.csv'
csv_out='/home/arthur/Dropbox/projects/ambrals_modeling/BRDF_LUT.csv'

# We need to iterate over vzen from -20 to +20
# every 1 degree and over szen from 0 to 72 deg every 5 deg.

# Keep relaz constant for now, set to the default defined in the ambrals readme
relaz=120.0

# Why do I have to incldue an unused field on the end of this while? but I do.
while IFS=, read -r Category ID Latitude Longitude Date test MCD43A1_006_Line_Y_500m
do
    lc=$Category
    date=$Date
    tile=$test
    lat=$Latitude
    lon=$Longitude
    echo $Category
    if [ "$Category" != "Category" ]
    then
	#This has been temporarily changed for a specific site's sza range
	#for szen in $(seq 0 5 70); do
	for szen in $(seq 23 5 65); do	
	    for vzen in $(seq -20 1 20); do
		#todo: would be great to be able to select column by its name rather than by position
		# lc='Broadleaf Forest'
		# date='2018-04-16'
		# tile='h19v04'
		# lat='41.84936'
		# lon='13.58814'
		# Silly way to do this, but it works for now.
		# Future use (after 2020-08 e.g., check that these cols are correct -- appears output)
		params_band_1=`awk -v lc_a="$lc" -v date_a="$date" -v tile_a="$tile" -F "," '$0~lc_a && $0~date_a && $0~tile_a && $39==0{ print $9 "\t" $10 "\t" $11 }' $csv_in`
		params_band_2=`awk -v lc_a="$lc" -v date_a="$date" -v tile_a="$tile" -F "," '$0~lc_a && $0~date_a && $0~tile_a && $40==0{ print $12 "\t" $13 "\t" $14 }' $csv_in`
		params_band_3=`awk -v lc_a="$lc" -v date_a="$date" -v tile_a="$tile" -F "," '$0~lc_a && $0~date_a && $0~tile_a && $41==0{ print $15 "\t" $16 "\t" $17 }' $csv_in`
		params_band_4=`awk -v lc_a="$lc" -v date_a="$date" -v tile_a="$tile" -F "," '$0~lc_a && $0~date_a && $0~tile_a && $42==0{ print $18 "\t" $19 "\t" $20 }' $csv_in`
		params_band_5=`awk -v lc_a="$lc" -v date_a="$date" -v tile_a="$tile" -F "," '$0~lc_a && $0~date_a && $0~tile_a && $43==0{ print $21 "\t" $22 "\t" $23 }' $csv_in`
		params_band_6=`awk -v lc_a="$lc" -v date_a="$date" -v tile_a="$tile" -F "," '$0~lc_a && $0~date_a && $0~tile_a && $44==0{ print $24 "\t" $25 "\t" $26 }' $csv_in`
		params_band_7=`awk -v lc_a="$lc" -v date_a="$date" -v tile_a="$tile" -F "," '$0~lc_a && $0~date_a && $0~tile_a && $45==0{ print $27 "\t" $28 "\t" $29 }' $csv_in`

		# This is the ambrals forward model
		# Params: szen vzen relaz iso vol geo
		#todo add a line that checks if the csv exists, if not make it with correct headers
		if [ -z "$params_band_1" ]
		then
		    echo "QA for band 1 is not 0!"
		else
		    result_band_1=`/home/arthur/code/ambrals_forward_model/multi_ref.exe $szen $vzen $relaz $params_band_1`	
		    echo $lc "," $date "," $tile "," $lat "," $lon "," "Band 1" "," $result_band_1 "," $szen "," $vzen "," $relaz  >> $csv_out
		fi
		
		if [ -z "$params_band_2" ]
		then
		    echo "QA for band 2 is not 0!"
		else
		    result_band_2=`/home/arthur/code/ambrals_forward_model/multi_ref.exe $szen $vzen $relaz $params_band_2`
		    echo $lc "," $date "," $tile "," $lat "," $lon "," "Band 2" "," $result_band_2 "," $szen "," $vzen "," $relaz  >> $csv_out
		fi

		if [ -z "$params_band_3" ]
		then
		    echo "QA for band 3 is not 0!"
		else
		    result_band_3=`/home/arthur/code/ambrals_forward_model/multi_ref.exe $szen $vzen $relaz $params_band_3`
		    echo $lc "," $date "," $tile "," $lat "," $lon "," "Band 3" "," $result_band_3 "," $szen "," $vzen "," $relaz  >> $csv_out
		fi
		
		if [ -z "$params_band_4" ]
		then
		    echo "QA for band 4 is not 0!"	
		else
		    result_band_4=`/home/arthur/code/ambrals_forward_model/multi_ref.exe $szen $vzen $relaz $params_band_4`
		    echo $lc "," $date "," $tile "," $lat "," $lon "," "Band 4" "," $result_band_4 "," $szen "," $vzen "," $relaz  >> $csv_out
		fi
		
		if [ -z "$params_band_5" ]
		then
		    echo "QA for band 5 is not 0!"
		else
		    result_band_5=`/home/arthur/code/ambrals_forward_model/multi_ref.exe $szen $vzen $relaz $params_band_5`
		    echo $lc "," $date "," $tile "," $lat "," $lon "," "Band 5" "," $result_band_5 "," $szen "," $vzen "," $relaz  >> $csv_out
		fi

		if [ -z "$params_band_6" ]
		then
		    echo "QA for band 6 is not 0!"
		else
		    result_band_6=`/home/arthur/code/ambrals_forward_model/multi_ref.exe $szen $vzen $relaz $params_band_6`
		    echo $lc "," $date "," $tile "," $lat "," $lon "," "Band 6" "," $result_band_6 "," $szen "," $vzen "," $relaz  >> $csv_out
		fi
		
		if [ -z "$params_band_7" ]
		then
		    echo "QA for band 7 is not 0!"
		else
		    result_band_7=`/home/arthur/code/ambrals_forward_model/multi_ref.exe $szen $vzen $relaz $params_band_7`
		    echo $lc "," $date "," $tile "," $lat "," $lon "," "Band 7" "," $result_band_7 "," $szen "," $vzen "," $relaz  >> $csv_out
		fi
		
	    done
	done
    else
	echo "This is the header."
    fi
    
done < $csv_in


