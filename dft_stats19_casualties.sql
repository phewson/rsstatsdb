CREATE FUNCTION dft.import_dft_stats19_casualty() RETURNS void
AS $$
declare
begin
INSERT INTO dft.stats19_casualty
SELECT
s.collision_index::text AS collision_index,
s.vehicle_reference::int AS vehicle_reference,
s.casualty_reference::int AS casualty_reference,
casualty_class.label::dft.stats19_casualty_class AS casualty_class,
sex_of_casualty.label::dft.stats19_sex_of_casualty AS sex_of_casualty,
s.age_of_casualty::int AS age_of_casualty,
age_band_of_casualty.label::dft.stats19_age_band_of_casualty AS age_band_of_casualty,
casualty_severity.label::dft.stats19_casualty_severity AS casualty_severity,
pedestrian_location.label::dft.stats19_pedestrian_location AS pedestrian_location,
pedestrian_movement.label::dft.stats19_pedestrian_movement AS pedestrian_movement,
car_passenger.label::dft.stats19_car_passenger AS car_passenger,
bus_or_coach_passenger.label::dft.stats19_bus_or_coach_passenger AS bus_or_coach_passenger,
pedestrian_road_maintenance_worker.label::dft.stats19_pedestrian_road_maintenance_worker AS pedestrian_road_maintenance_worker,
s.casualty_type::int AS casualty_type,
casualty_imd_decile.label::dft.stats19_casualty_imd_decile AS casualty_imd_decile,
s.lsoa_of_casualty::text AS lsoa_of_casualty,
enhanced_casualty_severity.label::dft.stats19_enhanced_casualty_severity AS enhanced_casualty_severity,
s.casualty_injury_based::int AS casualty_injury_based,
s.casualty_adjusted_serious::float8 AS casualty_adjusted_serious,
s.casualty_adjusted_slight::float8 AS casualty_adjusted_slight,
casualty_distance_banding.label::dft.stats19_casualty_distance_banding AS casualty_distance_banding
FROM staging.dft_stats19_casualty s
LEFT JOIN staging.stats19_metadata casualty_class
ON casualty_class.field_name = 'casualty_class'
AND casualty_class.code = s.casualty_class
LEFT JOIN staging.stats19_metadata sex_of_casualty
ON sex_of_casualty.field_name = 'sex_of_casualty'
AND sex_of_casualty.code = s.sex_of_casualty
LEFT JOIN staging.stats19_metadata age_band_of_casualty
ON age_band_of_casualty.field_name = 'age_band_of_casualty'
AND age_band_of_casualty.code = s.age_band_of_casualty
LEFT JOIN staging.stats19_metadata casualty_severity
ON casualty_severity.field_name = 'casualty_severity'
AND casualty_severity.code = s.casualty_severity
LEFT JOIN staging.stats19_metadata pedestrian_location
ON pedestrian_location.field_name = 'pedestrian_location'
AND pedestrian_location.code = s.pedestrian_location
LEFT JOIN staging.stats19_metadata pedestrian_movement
ON pedestrian_movement.field_name = 'pedestrian_movement'
AND pedestrian_movement.code = s.pedestrian_movement
LEFT JOIN staging.stats19_metadata car_passenger
ON car_passenger.field_name = 'car_passenger'
AND car_passenger.code = s.car_passenger
LEFT JOIN staging.stats19_metadata bus_or_coach_passenger
ON bus_or_coach_passenger.field_name = 'bus_or_coach_passenger'
AND bus_or_coach_passenger.code = s.bus_or_coach_passenger
LEFT JOIN staging.stats19_metadata pedestrian_road_maintenance_worker
ON pedestrian_road_maintenance_worker.field_name = 'pedestrian_road_maintenance_worker'
AND pedestrian_road_maintenance_worker.code = s.pedestrian_road_maintenance_worker
LEFT JOIN staging.stats19_metadata casualty_imd_decile
ON casualty_imd_decile.field_name = 'casualty_imd_decile'
AND casualty_imd_decile.code = s.casualty_imd_decile
LEFT JOIN staging.stats19_metadata enhanced_casualty_severity
ON enhanced_casualty_severity.field_name = 'enhanced_casualty_severity'
AND enhanced_casualty_severity.code = s.enhanced_casualty_severity
LEFT JOIN staging.stats19_metadata casualty_distance_banding
ON casualty_distance_banding.field_name = 'casualty_distance_banding'
AND casualty_distance_banding.code = s.casualty_distance_banding
;
end
$$ LANGUAGE plpgsql;
