#!/bin/bash
set -e; set -u;

INPUT="$DATASTORE/dft/stats19/new-dft-road-casualty-statistics-vehicle-1979-latest-published-year.csv"
[[ -f "$INPUT" ]] || { >&2 echo "Missing input file: [$INPUT]" ; exit 5 ; }
cat << EOF

DROP TABLE IF EXISTS landing.dft_stats19_vehicles;
CREATE TABLE IF NOT EXISTS landing.dft_stats19_vehicles (
  collision_index TEXT,
  collision_year TEXT,
  collision_ref_no TEXT,
  vehicle_reference TEXT,
  vehicle_type TEXT,
  towing_and_articulation TEXT,
  vehicle_manoeuvre_historic TEXT,
  vehicle_manoeuvre TEXT,
  vehicle_direction_from TEXT,
  vehicle_direction_to TEXT,
  vehicle_location_restricted_lane_historic TEXT,
  vehicle_location_restricted_lane TEXT,
  junction_location TEXT,
  skidding_and_overturning TEXT,
  hit_object_in_carriageway TEXT,
  vehicle_leaving_carriageway TEXT,
  hit_object_off_carriageway TEXT,
  first_point_of_impact TEXT,
  vehicle_left_hand_drive TEXT,
  journey_purpose_of_driver_historic TEXT,
  journey_purpose_of_driver TEXT,
  sex_of_driver TEXT,
  age_of_driver TEXT,
  age_band_of_driver TEXT,
  engine_capacity_cc TEXT,
  propulsion_code TEXT,
  age_of_vehicle TEXT,
  generic_make_model TEXT,
  driver_imd_decile TEXT,
  lsoa_of_driver TEXT,
  escooter_flag TEXT,
  driver_distance_banding TEXT);
EOF

echo "\copy staging.dft_stats19_vehicles FROM $INPUT delimiter ',' csv header;"
echo "SELECT dft.import_dft_stats19_vehicles_2024();"


