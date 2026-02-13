DO $$
BEGIN
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_age_band_of_casualty' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_age_band_of_casualty AS ENUM ('0 - 5', '11 - 15', '16 - 20', '21 - 25', '26 - 35', '36 - 45', '46 - 55', '56 - 65', '6 - 10', '66 - 75', 'Data missing or out of range', 'Over 75');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_bus_or_coach_passenger' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_bus_or_coach_passenger AS ENUM ('Alighting', 'Boarding', 'Data missing or out of range', 'Not a bus or coach passenger', 'Seated passenger', 'Standing passenger', 'unknown (self reported)');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_car_passenger' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_car_passenger AS ENUM ('Data missing or out of range', 'Front seat passenger', 'Not car passenger', 'Rear seat passenger', 'unknown (self reported)');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_casualty_class' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_casualty_class AS ENUM ('Driver or rider', 'Passenger', 'Pedestrian');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_casualty_distance_banding' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_casualty_distance_banding AS ENUM ('10-20km', '20-100km', '5-10km', 'Collision occurred over 100km of casualties home postcode', 'Collision occurred within 5km of casualties home postcode', 'Data missing or out of range');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_casualty_imd_decile' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_casualty_imd_decile AS ENUM ('Data missing or out of range', 'Least deprived 10%', 'Less deprived 10-20%', 'Less deprived 20-30%', 'Less deprived 30-40%', 'Less deprived 40-50%', 'More deprived 10-20%', 'More deprived 20-30%', 'More deprived 30-40%', 'More deprived 40-50%', 'Most deprived 10%');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_casualty_severity' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_casualty_severity AS ENUM ('Fatal', 'Serious', 'Slight');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_enhanced_casualty_severity' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_enhanced_casualty_severity AS ENUM ('Data missing or out of range', 'Fatal', 'Less Serious', 'Moderately Serious', 'Slight', 'Very Serious');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_pedestrian_location' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_pedestrian_location AS ENUM ('Centre without facilty', 'Crossing elsewhere within 50m. of pedestrian crossing', 'Crossing in zig-zag approach lines', 'Crossing in zig-zag exit lines', 'Crossing on pedestrian crossing facility', 'Data missing or out of range', 'In carriageway, crossing elsewhere', 'In carriageway, not crossing', 'Not a Pedestrian', 'On footway or verge', 'On refuge, central island or central reservation', 'Unknown or other');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_pedestrian_movement' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_pedestrian_movement AS ENUM ('Crossing from driver''s nearside', 'Crossing from driver''s offside', 'Crossing from nearside - masked by parked or stationary vehicle', 'Crossing from offside - masked by  parked or stationary vehicle', 'Data missing or out of range', 'In carriageway not crossing', 'Not a Pedestrian', 'Not crossing masked by parked car', 'Unknown or other', 'Walking along in carriageway, back to traffic', 'Walking along in carriageway, facing traffic');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_pedestrian_road_maintenance_worker' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_pedestrian_road_maintenance_worker AS ENUM ('Data missing or out of range', 'No / Not applicable', 'Not Known', 'Probable', 'Yes');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_sex_of_casualty' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_sex_of_casualty AS ENUM ('Data missing or out of range', 'Female', 'Male', 'unknown (self reported)');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_carriageway_hazards' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_carriageway_hazards AS ENUM ('Any animal in carriageway (except ridden horse)', 'Data missing or out of range', 'Defective traffic signals', 'Dislodged vehicle load in carriageway', 'Involvement with previous collision', 'Mud', 'None', 'Oil or diesel', 'Other object in carriageway', 'Pedestrian in carriageway - not injured', 'Poor or defective road surface', 'Roadworks', 'Sign/Marks defective or obscured', 'unknown (self reported)');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_carriageway_hazards_historic' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_carriageway_hazards_historic AS ENUM ('Any animal in carriageway (except ridden horse)', 'Data missing or out of range', 'Dog on road', 'None', 'Other animal on road', 'Other object on road', 'Pedestrian in carriageway - not injured', 'Previous accident', 'unknown (self reported)', 'Vehicle load on road');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_collision_severity' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_collision_severity AS ENUM ('Fatal', 'Serious', 'Slight');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_day_of_week' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_day_of_week AS ENUM ('Friday', 'Monday', 'Saturday', 'Sunday', 'Thursday', 'Tuesday', 'Wednesday');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_did_police_officer_attend_scene_of_accident' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_did_police_officer_attend_scene_of_accident AS ENUM ('Data missing or out of range', 'No', 'No; self-report form', 'Yes');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_did_police_officer_attend_scene_of_collision' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_did_police_officer_attend_scene_of_collision AS ENUM ('Data missing or out of range', 'No', 'No; self-report form', 'Yes');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_enhanced_collision_severity' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_enhanced_collision_severity AS ENUM ('Data missing or out of range', 'Fatal', 'Less Serious', 'Moderately Serious', 'Slight', 'Very Serious');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_first_road_class' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_first_road_class AS ENUM ('A', 'A(M)', 'B', 'C', 'Data missing or out of range', 'Motorway', 'Unclassified');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_first_road_number' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_first_road_number AS ENUM ('C or U', 'Number range', 'Unknown');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_junction_control' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_junction_control AS ENUM ('Authorised person', 'Auto traffic signal', 'Data missing or out of range', 'Give way or uncontrolled', 'Not at junction or within 20 metres', 'Stop sign', 'unknown (self reported)');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_junction_detail' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_junction_detail AS ENUM ('Crossroads', 'Data missing or out of range', 'Junction with more than four arms (not roundabout)', 'Not at junction or within 20 metres', 'T or staggered junction', 'unknown (self reported)', 'Using private drive or entrance');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_junction_detail_historic' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_junction_detail_historic AS ENUM ('Crossroads', 'Data missing or out of range', 'Mini-roundabout', 'More than 4 arms (not roundabout)', 'Not at junction or within 20 metres', 'Other junction', 'Private drive or entrance', 'Roundabout', 'Slip road', 'T or staggered junction', 'unknown (self reported)');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_light_conditions' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_light_conditions AS ENUM ('Darkness - lighting unknown', 'Darkness - lights lit', 'Darkness - lights unlit', 'Darkness - no lighting', 'Data missing or out of range', 'Daylight');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_pedestrian_crossing' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_pedestrian_crossing AS ENUM ('Central refuge - no other controls', 'Data missing or out of range', 'Footbridge or subway', 'Human crossing control by other authorised person', 'Human crossing control by school crossing patrol', 'No physical crossing facility within 50m', 'Non-junction light crossing', 'Pedestrian phase at traffic signal', 'unknown (self reported)', 'Zebra crossing');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_pedestrian_crossing_human_control_historic' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_pedestrian_crossing_human_control_historic AS ENUM ('Control by other authorised person', 'Control by school crossing patrol', 'Data missing or out of range', 'None within 50 metres', 'unknown (self reported)');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_pedestrian_crossing_physical_facilities_historic' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_pedestrian_crossing_physical_facilities_historic AS ENUM ('Central refuge', 'Data missing or out of range', 'Footbridge or subway', 'No physical crossing facilities within 50 metres', 'Non-junction light crossing', 'Pedestrian phase at traffic signal junction', 'unknown (self reported)', 'Zebra');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_road_surface_conditions' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_road_surface_conditions AS ENUM ('Data missing or out of range', 'Dry', 'Flood over 3cm. deep', 'Frost or ice', 'Mud', 'Oil or diesel', 'Snow', 'unknown (self reported)', 'Wet or damp');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_road_type' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_road_type AS ENUM ('Data missing or out of range', 'Dual carriageway', 'One way street', 'One way street/Slip road', 'Roundabout', 'Single carriageway', 'Slip road', 'Unknown');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_second_road_class' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_second_road_class AS ENUM ('A', 'A(M)', 'B', 'C', 'Data missing or out of range', 'Motorway', 'Not at junction or within 20 metres', 'Unclassified', 'Unknown (self rep only)');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_second_road_number' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_second_road_number AS ENUM ('C or U', 'Number range', 'Unknown');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_special_conditions_at_site' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_special_conditions_at_site AS ENUM ('Auto signal part defective', 'Auto traffic signal - out', 'Data missing or out of range', 'Mud', 'None', 'Oil or diesel', 'Road sign or marking defective or obscured', 'Road surface defective', 'Roadworks', 'unknown (self reported)');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_speed_limit' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_speed_limit AS ENUM ('Data missing or out of range', 'unknown (self reported)');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_trunk_road_flag' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_trunk_road_flag AS ENUM ('Data missing or out of range', 'Non-trunk', 'Trunk (Roads managed by Highways England)');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_urban_or_rural_area' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_urban_or_rural_area AS ENUM ('Data missing or out of range', 'Rural', 'Unallocated', 'Urban');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_weather_conditions' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_weather_conditions AS ENUM ('Data missing or out of range', 'Fine + high winds', 'Fine no high winds', 'Fog or mist', 'Other', 'Raining + high winds', 'Raining no high winds', 'Snowing + high winds', 'Snowing no high winds', 'Unknown');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_age_band_of_driver' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_age_band_of_driver AS ENUM ('0 - 5', '11 - 15', '16 - 20', '21 - 25', '26 - 35', '36 - 45', '46 - 55', '56 - 65', '6 - 10', '66 - 75', 'Data missing or out of range', 'Over 75');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_driver_distance_banding' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_driver_distance_banding AS ENUM ('10-20km', '20-100km', '5-10km', 'Collision occurred over 100km of drivers home postcode', 'Collision occurred within 5km of drivers home postcode');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_driver_imd_decile' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_driver_imd_decile AS ENUM ('Data missing or out of range', 'Least deprived 10%', 'Less deprived 10-20%', 'Less deprived 20-30%', 'Less deprived 30-40%', 'Less deprived 40-50%', 'More deprived 10-20%', 'More deprived 20-30%', 'More deprived 30-40%', 'More deprived 40-50%', 'Most deprived 10%');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_first_point_of_impact' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_first_point_of_impact AS ENUM ('Back', 'Data missing or out of range', 'Did not impact', 'Front', 'Nearside', 'Offside', 'unknown (self reported)');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_hit_object_in_carriageway' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_hit_object_in_carriageway AS ENUM ('Any animal (except ridden horse)', 'Bollard or refuge', 'Bridge (roof)', 'Bridge (side)', 'Central island of roundabout', 'Data missing or out of range', 'Kerb', 'None', 'Open door of vehicle', 'Other object', 'Parked vehicle', 'Previous accident', 'Road works', 'unknown (self reported)');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_hit_object_off_carriageway' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_hit_object_off_carriageway AS ENUM ('Bus stop or bus shelter', 'Central crash barrier', 'Data missing or out of range', 'Entered ditch', 'Lamp post', 'Near/Offside crash barrier', 'None', 'Other permanent object', 'Road sign or traffic signal', 'Submerged in water', 'Telegraph or electricity pole', 'Tree', 'unknown (self reported)', 'Wall or fence');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_journey_purpose_of_driver' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_journey_purpose_of_driver AS ENUM ('Commuting to or from work', 'Data missing or out of range', 'Education and educational escort', 'Emergency vehicle (blue light) on response', 'Journey as part of work', 'Not known or not requested', 'Personal business or leisure');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_journey_purpose_of_driver_historic' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_journey_purpose_of_driver_historic AS ENUM ('Commuting to/from work', 'Data missing or out of range', 'Journey as part of work', 'Not known', 'Other', 'Other/Not known', 'Pupil riding to/from school', 'Taking pupil to/from school');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_junction_location' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_junction_location AS ENUM ('Approaching junction or waiting/parked at junction approach', 'Cleared junction or waiting/parked at junction exit', 'Data missing or out of range', 'Entering from slip road', 'Entering main road', 'Entering roundabout', 'Leaving main road', 'Leaving roundabout', 'Mid Junction - on roundabout or on main road', 'Not at or within 20 metres of junction', 'unknown (self reported)');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_propulsion_code' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_propulsion_code AS ENUM ('Electric', 'Electric diesel', 'Fuel cells', 'Gas', 'Gas Diesel', 'Gas/Bi-fuel', 'Heavy oil', 'Hybrid electric', 'New fuel technology', 'Petrol', 'Petrol/Gas (LPG)', 'Steam', 'Undefined');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_sex_of_driver' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_sex_of_driver AS ENUM ('Data missing or out of range', 'Female', 'Male', 'Not known');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_skidding_and_overturning' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_skidding_and_overturning AS ENUM ('Data missing or out of range', 'Jackknifed', 'Jackknifed and overturned', 'None', 'Overturned', 'Skidded', 'Skidded and overturned', 'unknown (self reported)');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_towing_and_articulation' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_towing_and_articulation AS ENUM ('Articulated vehicle', 'Caravan', 'Data missing or out of range', 'Double or multiple trailer', 'No tow/articulation', 'Other tow', 'Single trailer', 'unknown (self reported)');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_vehicle_direction_from' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_vehicle_direction_from AS ENUM ('Data missing or out of range', 'East', 'North', 'North East', 'North West', 'Parked', 'South', 'South East', 'South West', 'unknown (self reported)', 'West');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_vehicle_direction_to' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_vehicle_direction_to AS ENUM ('Data missing or out of range', 'East', 'North', 'North East', 'North West', 'Parked', 'South', 'South East', 'South West', 'unknown (self reported)', 'West');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_vehicle_leaving_carriageway' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_vehicle_leaving_carriageway AS ENUM ('Data missing or out of range', 'Did not leave carriageway', 'Nearside', 'Nearside and rebounded', 'Offside', 'Offside - crossed central reservation', 'Offside and rebounded', 'Offside on to central reservation', 'Offside on to centrl res + rebounded', 'Straight ahead at junction', 'unknown (self reported)');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_vehicle_left_hand_drive' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_vehicle_left_hand_drive AS ENUM ('Data missing or out of range', 'No', 'Unknown', 'Yes');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_vehicle_location_restricted_lane' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_vehicle_location_restricted_lane AS ENUM ('Bus lane or Busway', 'Cycle lane (on main carriageway)', 'Cycleway or shared use footway (not part of main carriageway)', 'Data missing or out of range', 'Footway (pavement)', 'Lay-by or hard shoulder', 'On main carriageway (not in restricted lane)', 'Tram or Light rail track', 'unknown (self reported)');
END IF;
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = 'stats19_vehicle_location_restricted_lane_historic' AND typnamespace::regnamespace = 'dft'::regnamespace) THEN
CREATE TYPE dft.stats19_vehicle_location_restricted_lane_historic AS ENUM ('Bus lane', 'Busway (including guided busway)', 'Cycle lane (on main carriageway)', 'Cycleway or shared use footway (not part of  main carriageway)', 'Data missing or out of range', 'Entering lay-by or hard shoulder', 'Footway (pavement)', 'Leaving lay-by or hard shoulder', 'Not on carriageway', 'On lay-by or hard shoulder', 'On main c''way - not in restricted lane', 'Tram/Light rail track', 'unknown (self reported)');
END IF;
END $$;
