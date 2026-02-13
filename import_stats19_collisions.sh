#!/bin/bash
set -e; set -u;

INPUT="$DATASTORE/dft/stats19/new-dft-road-casualty-statistics-collision-1979-latest-published-year.csv"
[[ -f "$INPUT" ]] || { >&2 echo "Missing input file: [$INPUT]" ; exit 5 ; }
cat << EOF

DROP TABLE IF EXISTS landing.dft_stats19_collisions;
CREATE TABLE IF NOT EXISTS landing.dft_stats19_collisions (
  collision_index TEXT,
  collision_year TEXT,
  collision_ref_no TEXT,
  location_easting_osgr TEXT,
  location_northing_osgr TEXT,
  longitude TEXT,
  latitude TEXT,
  police_force TEXT,
  collision_severity TEXT,
  number_of_vehicles TEXT,
  number_of_casualties TEXT,
  date TEXT,
  day_of_week TEXT,
  time TEXT,
  local_authority_district TEXT,
  local_authority_ons_district TEXT,
  local_authority_highway TEXT,
  local_authority_highway_current TEXT,
  first_road_class TEXT,
  first_road_number TEXT,
  road_type TEXT,
  speed_limit TEXT,
  junction_detail_historic TEXT,
  junction_detail TEXT,
  junction_control TEXT,
  second_road_class TEXT,
  second_road_number TEXT,
  pedestrian_crossing_human_control_historic TEXT,
  pedestrian_crossing_physical_facilities_historic TEXT,
  pedestrian_crossing TEXT,
  light_conditions TEXT,
  weather_conditions TEXT,
  road_surface_conditions TEXT,
  special_conditions_at_site TEXT,
  carriageway_hazards_historic TEXT,
  carriageway_hazards TEXT,
  urban_or_rural_area TEXT,
  did_police_officer_attend_scene_of_accident TEXT,
  trunk_road_flag TEXT,
  lsoa_of_accident_location TEXT,
  enhanced_collision_severity TEXT,
  collision_injury_based TEXT,
  collision_adjusted_serious TEXT,
  collision_adjusted_slight TEXT);
EOF

echo "\copy staging.dft_stats19_collisions FROM $INPUT delimiter ',' csv header;"
echo "SELECT dft.import_dft_stats19_collisions_2024();"


