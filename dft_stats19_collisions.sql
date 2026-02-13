CREATE FUNCTION dft.import_dft_stats19_collision() RETURNS void
AS $$
declare
begin
INSERT INTO dft.stats19_collision
SELECT
s.collision_index::text AS collision_index,
s.location_easting_osgr::int AS location_easting_osgr,
s.location_northing_osgr::int AS location_northing_osgr,
ST_SetSRID(ST_MakePoint(s.longitude::float8, s.latitude::float8), 4326) AS geom,
s.police_force::int AS police_force,
collision_severity.label::dft.stats19_collision_severity AS collision_severity,
s.number_of_vehicles::int AS number_of_vehicles,
s.number_of_casualties::int AS number_of_casualties,
to_timestamp(nullif(date,'NULL') || ' ' || nullif(time,'NULL'), 'DD/MM/YYYY HH24:MI'),
s.local_authority_district::int AS local_authority_district,
s.local_authority_ons_district::text AS local_authority_ons_district,
s.local_authority_highway::text AS local_authority_highway,
s.local_authority_highway_current::text AS local_authority_highway_current,
first_road_class.label::dft.stats19_first_road_class AS first_road_class,
s.first_road_number::int AS first_road_number,
road_type.label::dft.stats19_road_type AS road_type,
s.speed_limit::int AS speed_limit,
junction_detail_historic.label::dft.stats19_junction_detail_historic AS junction_detail_historic,
junction_detail.label::dft.stats19_junction_detail AS junction_detail,
junction_control.label::dft.stats19_junction_control AS junction_control,
second_road_class.label::dft.stats19_second_road_class AS second_road_class,
s.second_road_number::int AS second_road_number,
pedestrian_crossing_human_control_historic.label::dft.stats19_pedestrian_crossing_human_control_historic AS pedestrian_crossing_human_control_historic,
pedestrian_crossing_physical_facilities_historic.label::dft.stats19_pedestrian_crossing_physical_facilities_historic AS pedestrian_crossing_physical_facilities_historic,
pedestrian_crossing.label::dft.stats19_pedestrian_crossing AS pedestrian_crossing,
light_conditions.label::dft.stats19_light_conditions AS light_conditions,
weather_conditions.label::dft.stats19_weather_conditions AS weather_conditions,
road_surface_conditions.label::dft.stats19_road_surface_conditions AS road_surface_conditions,
special_conditions_at_site.label::dft.stats19_special_conditions_at_site AS special_conditions_at_site,
carriageway_hazards_historic.label::dft.stats19_carriageway_hazards_historic AS carriageway_hazards_historic,
carriageway_hazards.label::dft.stats19_carriageway_hazards AS carriageway_hazards,
urban_or_rural_area.label::dft.stats19_urban_or_rural_area AS urban_or_rural_area,
did_police_officer_attend_scene_of_accident.label::dft.stats19_did_police_officer_attend_scene_of_accident AS did_police_officer_attend_scene_of_accident,
trunk_road_flag.label::dft.stats19_trunk_road_flag AS trunk_road_flag,
s.lsoa_of_accident_location::text AS lsoa_of_accident_location,
enhanced_collision_severity.label::dft.stats19_enhanced_collision_severity AS enhanced_collision_severity,
s.collision_injury_based::int AS collision_injury_based,
s.collision_adjusted_serious::float8 AS collision_adjusted_serious,
s.collision_adjusted_slight::float8 AS collision_adjusted_slight
FROM staging.dft_stats19_collision s
LEFT JOIN staging.stats19_metadata collision_severity
ON collision_severity.field_name = 'collision_severity'
AND collision_severity.code = s.collision_severity
LEFT JOIN staging.stats19_metadata first_road_class
ON first_road_class.field_name = 'first_road_class'
AND first_road_class.code = s.first_road_class
LEFT JOIN staging.stats19_metadata road_type
ON road_type.field_name = 'road_type'
AND road_type.code = s.road_type
LEFT JOIN staging.stats19_metadata junction_detail_historic
ON junction_detail_historic.field_name = 'junction_detail_historic'
AND junction_detail_historic.code = s.junction_detail_historic
LEFT JOIN staging.stats19_metadata junction_detail
ON junction_detail.field_name = 'junction_detail'
AND junction_detail.code = s.junction_detail
LEFT JOIN staging.stats19_metadata junction_control
ON junction_control.field_name = 'junction_control'
AND junction_control.code = s.junction_control
LEFT JOIN staging.stats19_metadata second_road_class
ON second_road_class.field_name = 'second_road_class'
AND second_road_class.code = s.second_road_class
LEFT JOIN staging.stats19_metadata pedestrian_crossing_human_control_historic
ON pedestrian_crossing_human_control_historic.field_name = 'pedestrian_crossing_human_control_historic'
AND pedestrian_crossing_human_control_historic.code = s.pedestrian_crossing_human_control_historic
LEFT JOIN staging.stats19_metadata pedestrian_crossing_physical_facilities_historic
ON pedestrian_crossing_physical_facilities_historic.field_name = 'pedestrian_crossing_physical_facilities_historic'
AND pedestrian_crossing_physical_facilities_historic.code = s.pedestrian_crossing_physical_facilities_historic
LEFT JOIN staging.stats19_metadata pedestrian_crossing
ON pedestrian_crossing.field_name = 'pedestrian_crossing'
AND pedestrian_crossing.code = s.pedestrian_crossing
LEFT JOIN staging.stats19_metadata light_conditions
ON light_conditions.field_name = 'light_conditions'
AND light_conditions.code = s.light_conditions
LEFT JOIN staging.stats19_metadata weather_conditions
ON weather_conditions.field_name = 'weather_conditions'
AND weather_conditions.code = s.weather_conditions
LEFT JOIN staging.stats19_metadata road_surface_conditions
ON road_surface_conditions.field_name = 'road_surface_conditions'
AND road_surface_conditions.code = s.road_surface_conditions
LEFT JOIN staging.stats19_metadata special_conditions_at_site
ON special_conditions_at_site.field_name = 'special_conditions_at_site'
AND special_conditions_at_site.code = s.special_conditions_at_site
LEFT JOIN staging.stats19_metadata carriageway_hazards_historic
ON carriageway_hazards_historic.field_name = 'carriageway_hazards_historic'
AND carriageway_hazards_historic.code = s.carriageway_hazards_historic
LEFT JOIN staging.stats19_metadata carriageway_hazards
ON carriageway_hazards.field_name = 'carriageway_hazards'
AND carriageway_hazards.code = s.carriageway_hazards
LEFT JOIN staging.stats19_metadata urban_or_rural_area
ON urban_or_rural_area.field_name = 'urban_or_rural_area'
AND urban_or_rural_area.code = s.urban_or_rural_area
LEFT JOIN staging.stats19_metadata did_police_officer_attend_scene_of_accident
ON did_police_officer_attend_scene_of_accident.field_name = 'did_police_officer_attend_scene_of_accident'
AND did_police_officer_attend_scene_of_accident.code = s.did_police_officer_attend_scene_of_accident
LEFT JOIN staging.stats19_metadata trunk_road_flag
ON trunk_road_flag.field_name = 'trunk_road_flag'
AND trunk_road_flag.code = s.trunk_road_flag
LEFT JOIN staging.stats19_metadata enhanced_collision_severity
ON enhanced_collision_severity.field_name = 'enhanced_collision_severity'
AND enhanced_collision_severity.code = s.enhanced_collision_severity
;
end
$$ LANGUAGE plpgsql;
