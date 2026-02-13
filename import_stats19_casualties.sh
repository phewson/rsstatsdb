#!/bin/bash
set -e; set -u;

INPUT="$DATASTORE/dft/stats19/new-dft-road-casualty-statistics-casualty-1979-latest-published-year.csv"
[[ -f "$INPUT" ]] || { >&2 echo "Missing input file: [$INPUT]" ; exit 5 ; }
cat << EOF

DROP TABLE IF EXISTS landing.dft_stats19_casualties;
CREATE TABLE IF NOT EXISTS landing.dft_stats19_casualties (
  collision_index TEXT,
  collision_year TEXT,
  collision_ref_no TEXT,
  vehicle_reference TEXT,
  casualty_reference TEXT,
  casualty_class TEXT,
  sex_of_casualty TEXT,
  age_of_casualty TEXT,
  age_band_of_casualty TEXT,
  casualty_severity TEXT,
  pedestrian_location TEXT,
  pedestrian_movement TEXT,
  car_passenger TEXT,
  bus_or_coach_passenger TEXT,
  pedestrian_road_maintenance_worker TEXT,
  casualty_type TEXT,
  casualty_imd_decile TEXT,
  lsoa_of_casualty TEXT,
  enhanced_casualty_severity TEXT,
  casualty_injury_based TEXT,
  casualty_adjusted_serious TEXT,
  casualty_adjusted_slight TEXT,
  casualty_distance_banding TEXT);
EOF

echo "\copy staging.dft_stats19_casualties FROM $INPUT delimiter ',' csv header;"
echo "SELECT dft.import_dft_stats19_casualties_2024();"


