#!/bin/bash

csv_in='/home/arthur/Dropbox/projects/ambrals_modeling/BRDF-Reflectances-Point-Samples-MCD43A1-006-results_subset.csv'
csv_out='/home/arthur/Dropbox/projects/ambrals_modeling/BRDF_LUT_hemisphere.csv'

if [ -f $csv_out ];
then
    rm $csv_out
    echo "land cover,date,tile,lat,lon,modis_band,directional_ref,szen,vzen,relaz" >> $csv_out
else
    echo "land cover,date,tile,lat,lon,modis_band,directional_ref,szen,vzen,relaz" >> $csv_out
fi



# We need to iterate over vzen from -20 to +20
# every 1 degree and over szen from 0 to 72 deg every 5 deg.

# Can set szen as constant here, gets updated for extreme lats later
#szen=30.0

# use relaz=0 to get backscattering, relaz=180 to get forward scattering
#relaz_list="0 180"

# for this version, which iterates over entire set of relative azimuths
# between view and sun, set a max relative azimuth. I think use 359, since
# 360 would be the same as 0, which is done first
relaz_max=359

# Why do I have to incldue an unused field on the end of this while? but I do.
while IFS=, read -r Category ID Latitude Longitude Date test MCD43A1_006_Line_Y_500m
do
    lc=$Category
    date=$Date
    tile=$test
    lat=$Latitude
    lon=$Longitude
    echo $Category
    szen_high=65
    if [ "$Category" != "Category" ];
    then
	# Extremely rough SZA cutoff. Better method would actually calculate max/min
	if [ ${lat%.*} -gt 65 ];
	then
	    szen_low=50
	    szen_high=70
	else
	    szen_low=20
	    szen_high=70
	fi
	echo $szen_low
	echo $szen_high
	
	#This has been temporarily changed for a specific site's sza range
	for szen in $(seq ${szen_low} 5 ${szen_high}); do
	    for vzen in $(seq 0 1 60); do
		for relaz in $(seq 0 ${relaz_max}); do
		    #todo: would be great to be able to select column by its name rather than by position
		    # Future use (after 2020-08 e.g., check that these cols are correct -- appears output)
		    params_band_1=`awk -v lc_a="$lc" -v date_a="$date" -v tile_a="$tile" -F "," '$0~lc_a && $0~date_a && $0~tile_a && ($39==0 || $39==1){ print $9 "\t" $10 "\t" $11 }' $csv_in`
		    params_band_2=`awk -v lc_a="$lc" -v date_a="$date" -v tile_a="$tile" -F "," '$0~lc_a && $0~date_a && $0~tile_a && ($40==0 || $40==1){ print $12 "\t" $13 "\t" $14 }' $csv_in`
		    params_band_3=`awk -v lc_a="$lc" -v date_a="$date" -v tile_a="$tile" -F "," '$0~lc_a && $0~date_a && $0~tile_a && ($41==0 || $41==1){ print $15 "\t" $16 "\t" $17 }' $csv_in`
		    params_band_4=`awk -v lc_a="$lc" -v date_a="$date" -v tile_a="$tile" -F "," '$0~lc_a && $0~date_a && $0~tile_a && ($42==0 || $42==1){ print $18 "\t" $19 "\t" $20 }' $csv_in`
		    params_band_5=`awk -v lc_a="$lc" -v date_a="$date" -v tile_a="$tile" -F "," '$0~lc_a && $0~date_a && $0~tile_a && ($43==0 || $43==1){ print $21 "\t" $22 "\t" $23 }' $csv_in`
		    params_band_6=`awk -v lc_a="$lc" -v date_a="$date" -v tile_a="$tile" -F "," '$0~lc_a && $0~date_a && $0~tile_a && ($44==0 || $44==1){ print $24 "\t" $25 "\t" $26 }' $csv_in`
		    params_band_7=`awk -v lc_a="$lc" -v date_a="$date" -v tile_a="$tile" -F "," '$0~lc_a && $0~date_a && $0~tile_a && ($45==0 || $45==1){ print $27 "\t" $28 "\t" $29 }' $csv_in`

		    # This is the ambrals forward model
		    # Params: szen vzen relaz iso vol geo
		    # This first if is to check the forward/backward based on relaz, and add a negative sign to the output
		    # if relaz=180. This is because the negative values on the graph should indicate forward scattering
		    # but it is not possible to give the model negative szen values (will give a value... but it isn't correct)
		    if [ ${relaz} -gt 90 ] || [ ${relaz} -lt 270 ]; then
			echo "szen: ${szen} vzen: ${vzen} relaz: ${relaz}"
			# if [ -z "$params_band_1" ]
			# then
			#     : #echo "QA for band 1 is not 0!"
			# else
			#     result_band_1=`/home/arthur/code/ambrals_forward_model/multi_ref.exe $szen $vzen $relaz $params_band_1`	
			#     echo $lc "," $date "," $tile "," $lat "," $lon "," "Band 1" "," $result_band_1 "," $szen "," $vzen "," $relaz  >> $csv_out
			# fi
			
			# if [ -z "$params_band_2" ]
			# then
			#     : #echo "QA for band 2 is not 0!"
			# else
			#     result_band_2=`/home/arthur/code/ambrals_forward_model/multi_ref.exe $szen $vzen $relaz $params_band_2`
			#     echo $lc "," $date "," $tile "," $lat "," $lon "," "Band 2" "," $result_band_2 "," $szen "," $vzen "," $relaz  >> $csv_out
			# fi

			# if [ -z "$params_band_3" ]
			# then
			#     : #echo "QA for band 3 is not 0!"
			# else
			#     result_band_3=`/home/arthur/code/ambrals_forward_model/multi_ref.exe $szen $vzen $relaz $params_band_3`
			#     echo $lc "," $date "," $tile "," $lat "," $lon "," "Band 3" "," $result_band_3 "," $szen "," $vzen "," $relaz  >> $csv_out
			# fi
			
			# if [ -z "$params_band_4" ]
			# then
			#     : #echo "QA for band 4 is not 0!"	
			# else
			#     result_band_4=`/home/arthur/code/ambrals_forward_model/multi_ref.exe $szen $vzen $relaz $params_band_4`
			#     echo $lc "," $date "," $tile "," $lat "," $lon "," "Band 4" "," $result_band_4 "," $szen "," $vzen "," $relaz  >> $csv_out
			# fi
			
			# if [ -z "$params_band_5" ]
			# then
			#     : #echo "QA for band 5 is not 0!"
			# else
			#     result_band_5=`/home/arthur/code/ambrals_forward_model/multi_ref.exe $szen $vzen $relaz $params_band_5`
			#     echo $lc "," $date "," $tile "," $lat "," $lon "," "Band 5" "," $result_band_5 "," $szen "," $vzen "," $relaz  >> $csv_out
			# fi

			# if [ -z "$params_band_6" ]
			# then
			#     : #echo "QA for band 6 is not 0!"
			# else
			#     result_band_6=`/home/arthur/code/ambrals_forward_model/multi_ref.exe $szen $vzen $relaz $params_band_6`
			#     echo $lc "," $date "," $tile "," $lat "," $lon "," "Band 6" "," $result_band_6 "," $szen "," $vzen "," $relaz  >> $csv_out
			# fi
			
			# if [ -z "$params_band_7" ]
			# then
			#     : #echo "QA for band 7 is not 0!"
			# else
			#     result_band_7=`/home/arthur/code/ambrals_forward_model/multi_ref.exe $szen $vzen $relaz $params_band_7`
			#     echo $lc "," $date "," $tile "," $lat "," $lon "," "Band 7" "," $result_band_7 "," $szen "," $vzen "," $relaz  >> $csv_out
			# fi
		    elif [ ${relaz} -le 90 ] || [ ${relaz} -ge 270 ]; then
			echo "szen: ${szen} vzen: -${vzen} relaz: ${relaz}"
			# if [ -z "$params_band_1" ]
			# then
			#     : #echo "QA for band 1 is not 0!"
			# else
			#     result_band_1=`/home/arthur/code/ambrals_forward_model/multi_ref.exe $szen $vzen $relaz $params_band_1`	
			#     echo $lc "," $date "," $tile "," $lat "," $lon "," "Band 1" "," $result_band_1 "," $szen "," -$vzen "," $relaz  >> $csv_out
			# fi
			
			# if [ -z "$params_band_2" ]
			# then
			#     : #echo "QA for band 2 is not 0!"
			# else
			#     result_band_2=`/home/arthur/code/ambrals_forward_model/multi_ref.exe $szen $vzen $relaz $params_band_2`
			#     echo $lc "," $date "," $tile "," $lat "," $lon "," "Band 2" "," $result_band_2 "," $szen "," -$vzen "," $relaz  >> $csv_out
			# fi

			# if [ -z "$params_band_3" ]
			# then
			#     : #echo "QA for band 3 is not 0!"
			# else
			#     result_band_3=`/home/arthur/code/ambrals_forward_model/multi_ref.exe $szen $vzen $relaz $params_band_3`
			#     echo $lc "," $date "," $tile "," $lat "," $lon "," "Band 3" "," $result_band_3 "," $szen "," -$vzen "," $relaz  >> $csv_out
			# fi
			
			# if [ -z "$params_band_4" ]
			# then
			#     : #echo "QA for band 4 is not 0!"	
			# else
			#     result_band_4=`/home/arthur/code/ambrals_forward_model/multi_ref.exe $szen $vzen $relaz $params_band_4`
			#     echo $lc "," $date "," $tile "," $lat "," $lon "," "Band 4" "," $result_band_4 "," $szen "," -$vzen "," $relaz  >> $csv_out
			# fi
			
			# if [ -z "$params_band_5" ]
			# then
			#     : #echo "QA for band 5 is not 0!"
			# else
			#     result_band_5=`/home/arthur/code/ambrals_forward_model/multi_ref.exe $szen $vzen $relaz $params_band_5`
			#     echo $lc "," $date "," $tile "," $lat "," $lon "," "Band 5" "," $result_band_5 "," $szen "," -$vzen "," $relaz  >> $csv_out
			# fi

			# if [ -z "$params_band_6" ]
			# then
			#     : #echo "QA for band 6 is not 0!"
			# else
			#     result_band_6=`/home/arthur/code/ambrals_forward_model/multi_ref.exe $szen $vzen $relaz $params_band_6`
			#     echo $lc "," $date "," $tile "," $lat "," $lon "," "Band 6" "," $result_band_6 "," $szen "," -$vzen "," $relaz  >> $csv_out
			# fi
			
			# if [ -z "$params_band_7" ]
			# then
			#     : #echo "QA for band 7 is not 0!"
			# else
			#     result_band_7=`/home/arthur/code/ambrals_forward_model/multi_ref.exe $szen $vzen $relaz $params_band_7`
			#     echo $lc "," $date "," $tile "," $lat "," $lon "," "Band 7" "," $result_band_7 "," $szen "," -$vzen "," $relaz  >> $csv_out
			# fi
		    fi
		done
	    done
	done
    else
	echo "This is the header."
    fi
    
done < $csv_in


