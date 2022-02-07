# Process notes

These are mainly for myself, but feel free to glean info from what I've done.

## New York City 2022

### Census 2020 shapefiles

Main page: https://www.census.gov/geographies/mapping-files/time-series/geo/tiger-line-file.2020.html

All of NY State by block: https://www2.census.gov/geo/tiger/TIGER2020/TABBLOCK20/tl_2020_36_tabblock20.zip

NYPD police precincts as of Nov 24, 2021:
Site: https://data.cityofnewyork.us/Public-Safety/Police-Precincts/78dh-3ptz
File: https://data.cityofnewyork.us/api/geospatial/78dh-3ptz?method=export&format=GeoJSON


### Processing quirks

```
[join] Joined data from 77 source records to 37,337 target records
[join] 43 target records received no data
```

Those show up as "purple" or `precinct=null` in the confidence map.

At the end, will see if those blocks have any people in them. Will investigate any that do.

### Population data

Here: data.census.gov


And these two:

https://data.census.gov/cedsci/table?q=United%20States%20Race%20and%20Ethnicity&g=0500000US36005%241000000,36047%241000000,36061%241000000,36081%241000000,36085%241000000&y=2020&tid=DECENNIALPL2020.P1


https://data.census.gov/cedsci/table?q=United%20States%20Race%20and%20Ethnicity&g=0500000US36005%241000000,36047%241000000,36061%241000000,36081%241000000,36085%241000000&y=2020&tid=DECENNIALPL2020.P2


### Checking Confidence Populations Map

Query builder in Qgis:

```
"precinct" = ''
```
... gets us the same 43 from above



```
"precinct" = '' AND "P1_001N"  != '0'
```
... gets us 9 populated places we need to locate


```
GEOID20,precinct
360471018001000,69
360610007008002,1
360050274023006,45
360050090002018,45
360810945001000,109
360470628002029,61
360470628003014,61
360850097011000,120
360850223001000,121
```

Other oddities:

`360050334001003` - 50 people -- 50% in 47, 50% in 49 - actually bronx river forest
`360050096002000` - 33 people -- 50% in 45, 50% in 43 - industrial area


