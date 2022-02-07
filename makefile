all: download blocks_in_nyc_counties geojson_of_nyc_centroids join_precincts_to_blocks confidence_check confidence_check confidence_check_populations

mypath :=/Volumes/JK_Smarts_Data/precinct_project/NY

download:
	mkdir -p $(mypath)
	# Download shapefile of all NY State Blocks
	curl "https://www2.census.gov/geo/tiger/TIGER2020/TABBLOCK20/tl_2020_36_tabblock20.zip" -o $(mypath)/tl_2020_36_tabblock20.zip
	unzip $(mypath)/tl_2020_36_tabblock20.zip -d $(mypath)/
	# Download geojson of NYPD precincts
	curl "https://data.cityofnewyork.us/api/geospatial/78dh-3ptz?method=export&format=GeoJSON" -o $(mypath)/nypd_precincts.json
	
blocks_in_nyc_counties:
	# convert census shapefile to csv
	npx mapshaper -i $(mypath)/tl_2020_36_tabblock20.shp \
	-filter "['061','005','085','047','081'].indexOf(COUNTYFP20) > -1" \
	-filter "ALAND20 > 0" \
	-o $(mypath)/nyc_blocks_centers.csv \
	-o format=geojson $(mypath)/nyc_blocks_shapes.json

geojson_of_nyc_centroids:
	npx csv2geojson --lat INTPTLAT20 --lon INTPTLON20 $(mypath)/nyc_blocks_centers.csv > $(mypath)/nyc_blocks_centers.json
	
join_precincts_to_blocks:
	npx mapshaper -i $(mypath)/nyc_blocks_centers.json \
	-join $(mypath)/nypd_precincts.json unjoined unmatched \
	-o $(mypath)/nyc_blocks_precincts_prelim.csv \
	-o target=unmatched format=geojson $(mypath)/unmatched.json \
	-o target=unmatched format=geojson $(mypath)/unmatched.csv
	
confidence_check:
	npx mapshaper -i $(mypath)/nyc_blocks_shapes.json \
	-join string-fields=* keys=GEOID20,GEOID20 $(mypath)/nyc_blocks_precincts_prelim.csv  \
	-o format=geojson $(mypath)/confidence_check.json
	
confidence_check_populations:
	npx mapshaper -i $(mypath)/confidence_check.json \
	-each "FULLID = '1000000US' + GEOID20" \
	-join fields=GEO_ID,P1_001N string-fields=GEO_ID keys=FULLID,GEO_ID $(mypath)/DECENNIALPL2020.P1_2022-02-06T162735/DECENNIALPL2020.P1_data_with_overlays_2022-02-06T162722.csv \
	-o format=geojson $(mypath)/confidence_check_pops.json

	
	
	

	

	