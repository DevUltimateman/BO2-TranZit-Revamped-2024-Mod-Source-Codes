
#include maps\mp\_utility;
#include maps\mp\createfx\zm_transit_fx;
#include maps\mp\createart\zm_transit_art;


main()
{
   // precache_createfx_fx();
    //precache_scripted_fx();
    //maps\mp\createfx\zm_transit_fx::main();
   // maps\mp\createart\zm_transit_art::main();

   // replacefunc( maps\mp\createart\zm_transit_art::main, ::new_zm_transit_art_test );
    //replacefunc( maps\mp\zm_transit_fx::main, ::empty_tester );
}

init()
{
     //replacefunc( maps\mp\createart\zm_transit_art::main, ::new_zm_transit_art_test );
    //replacefunc( maps\mp\zm_transit_fx::main, ::empty_tester );
    level waittill( "initial_blackscreen_passed" );
    //level thread loller();
    
}
loller()
{
    level endon( "end_game" );
    wait(10);
    pos1 = (-4904, -7657, 4);
    pos3 = (7918, -6506, 177);
    pos2 = (1986, -73, 4);
    players = get_players();
    if(isdefined(players[0]))
    {
        players[0] setorigin(pos1);
    }
    wait(0.05);
    if(isdefined(players[1]))
    {
        players[1] setorigin(pos2);
    }
    wait(0.05);
    if(isdefined(players[2]))
    {
        players[2] setorigin(pos3);
    }
}
/*
init_ambient_package_triggers()
{
	waitforclient(0);
	init_trigger_data();
	trigs = getentarray(0, "ambient_package", "targetname");
	array_thread(trigs, ::ambientpackagetrigger);
	
	println("Client : " + trigs.size + " ambient package triggers.");
	
    for( i = 0; i < trigs.size; i++ )
    {
        println( "TRIGGER NAME = " + trigs[ i ] );
        wait 0.1;
    }
}
*/
empty_tester()
{
    //
}
new_zm_transit_art_test()
{
    level endon( "end_game" );
    level.tweakfile = 1;
	setdvar("scr_fog_exp_halfplane", "11639.219");
	setdvar("scr_fog_exp_halfheight", "118691.3");
	setdvar("scr_fog_nearplane", "11138.679");
	setdvar("scr_fog_red", "0");
	setdvar("scr_fog_green", "1");
	setdvar("scr_fog_blue", "0");
	setdvar("scr_fog_baseheight", "11145.21");
	setdvar("visionstore_glowTweakEnable", "0");
	setdvar("visionstore_glowTweakRadius0", "5");
	setdvar("visionstore_glowTweakRadius1", "");
	setdvar("visionstore_glowTweakBloomCutoff", "0.5");
	setdvar("visionstore_glowTweakBloomDesaturation", "0");
	setdvar("visionstore_glowTweakBloomIntensity0", "1");
	setdvar("visionstore_glowTweakBloomIntensity1", "");
	setdvar("visionstore_glowTweakSkyBleedIntensity0", "");
	setdvar("visionstore_glowTweakSkyBleedIntensity1", "");
	start_dist = 1700.679;
	half_dist = 12000.624;
	half_height = -5000.5;
	base_height = -6145.21;
	fog_r = 0.;
	fog_g = 1;
	fog_b = 0;
	fog_scale = 1;
	sun_col_r = 0;
	sun_col_g = 1;
	sun_col_b = 0;
	sun_dir_x = -0.99;
	sun_dir_y = 0.06;
	sun_dir_z = -0.11;
	sun_start_ang = 0;
	sun_stop_ang = 0;
	time = 0;
	max_fog_opacity = 1;
	setvolfog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale, sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, sun_stop_ang, time, max_fog_opacity);
	visionsetnaked("zm_transit", 0);
	setdvar("r_lightGridEnableTweaks", 1);
	setdvar("r_lightGridIntensity", 1.4);
	setdvar("r_lightGridContrast", 0.2);
}
precache_scripted_fx()
{
    level._effect["switch_sparks"] = loadfx( "env/electrical/fx_elec_wire_spark_burst" );
    level._effect["maxis_sparks"] = loadfx( "maps/zombie/fx_zmb_race_trail_grief" );
    level._effect["richtofen_sparks"] = loadfx( "maps/zombie/fx_zmb_race_trail_neutral" );
    level._effect["sq_common_lightning"] = loadfx( "maps/zombie/fx_zmb_tranzit_sq_lightning_orb" );
    level._effect["zapper_light_ready"] = loadfx( "maps/zombie/fx_zombie_zapper_light_green" );
    level._effect["zapper_light_notready"] = loadfx( "maps/zombie/fx_zombie_zapper_light_red" );
    level._effect["lght_marker"] = loadfx( "maps/zombie/fx_zmb_tranzit_marker" );
    level._effect["lght_marker_flare"] = loadfx( "maps/zombie/fx_zmb_tranzit_marker_fl" );
    level._effect["poltergeist"] = loadfx( "misc/fx_zombie_couch_effect" );
    level._effect["zomb_gib"] = loadfx( "maps/zombie/fx_zmb_tranzit_lava_torso_explo" );
    level._effect["fx_headlight"] = loadfx( "maps/zombie/fx_zmb_tranzit_bus_headlight" );
    level._effect["fx_headlight_lenflares"] = loadfx( "lens_flares/fx_lf_zmb_tranzit_bus_headlight" );
    level._effect["fx_brakelight"] = loadfx( "maps/zombie/fx_zmb_tranzit_bus_brakelights" );
    level._effect["fx_emergencylight"] = loadfx( "maps/zombie/fx_zmb_tranzit_bus_flashing_lights" );
    level._effect["fx_turn_signal_right"] = loadfx( "maps/zombie/fx_zmb_tranzit_bus_turnsignal_right" );
    level._effect["fx_turn_signal_left"] = loadfx( "maps/zombie/fx_zmb_tranzit_bus_turnsignal_left" );
    level._effect["fx_zbus_trans_fog"] = loadfx( "maps/zombie/fx_zmb_tranzit_bus_fog_intersect" );
    level._effect["bus_lava_driving"] = loadfx( "maps/zombie/fx_zmb_tranzit_bus_fire_driving" );
    level._effect["bus_hatch_bust"] = loadfx( "maps/zombie/fx_zmb_tranzit_bus_hatch_bust" );
    level._effect["elec_md"] = loadfx( "electrical/fx_elec_player_md" );
    level._effect["elec_sm"] = loadfx( "electrical/fx_elec_player_sm" );
    level._effect["elec_torso"] = loadfx( "electrical/fx_elec_player_torso" );
    level._effect["blue_eyes"] = loadfx( "maps/zombie/fx_zombie_eye_single_blue" );
    level._effect["lava_burning"] = loadfx( "env/fire/fx_fire_lava_player_torso" );
    level._effect["mc_trafficlight"] = loadfx( "maps/zombie/fx_zmb_morsecode_traffic_loop" );
    level._effect["mc_towerlight"] = loadfx( "maps/zombie/fx_zmb_morsecode_loop" );
}

precache_createfx_fx()
{
    level._effect["fx_insects_swarm_md_light"] = loadfx( "bio/insects/fx_insects_swarm_md_light" );
    level._effect["fx_zmb_tranzit_flourescent_flicker"] = loadfx( "maps/zombie/fx_zmb_tranzit_flourescent_flicker" );
    level._effect["fx_zmb_tranzit_flourescent_glow"] = loadfx( "maps/zombie/fx_zmb_tranzit_flourescent_glow" );
    level._effect["fx_zmb_tranzit_flourescent_glow_lg"] = loadfx( "maps/zombie/fx_zmb_tranzit_flourescent_glow_lg" );
    level._effect["fx_zmb_tranzit_flourescent_dbl_glow"] = loadfx( "maps/zombie/fx_zmb_tranzit_flourescent_dbl_glow" );
    level._effect["fx_zmb_tranzit_depot_map_flicker"] = loadfx( "maps/zombie/fx_zmb_tranzit_depot_map_flicker" );
    level._effect["fx_zmb_tranzit_light_bulb_xsm"] = loadfx( "maps/zombie/fx_zmb_tranzit_light_bulb_xsm" );
    level._effect["fx_zmb_tranzit_light_glow"] = loadfx( "maps/zombie/fx_zmb_tranzit_light_glow" );
    level._effect["fx_zmb_tranzit_light_glow_xsm"] = loadfx( "maps/zombie/fx_zmb_tranzit_light_glow_xsm" );
    level._effect["fx_zmb_tranzit_light_glow_fog"] = loadfx( "maps/zombie/fx_zmb_tranzit_light_glow_fog" );
    level._effect["fx_zmb_tranzit_light_depot_cans"] = loadfx( "maps/zombie/fx_zmb_tranzit_light_depot_cans" );
    level._effect["fx_zmb_tranzit_light_desklamp"] = loadfx( "maps/zombie/fx_zmb_tranzit_light_desklamp" );
    level._effect["fx_zmb_tranzit_light_town_cans"] = loadfx( "maps/zombie/fx_zmb_tranzit_light_town_cans" );
    level._effect["fx_zmb_tranzit_light_town_cans_sm"] = loadfx( "maps/zombie/fx_zmb_tranzit_light_town_cans_sm" );
    level._effect["fx_zmb_tranzit_light_street_tinhat"] = loadfx( "maps/zombie/fx_zmb_tranzit_light_street_tinhat" );
    level._effect["fx_zmb_tranzit_street_lamp"] = loadfx( "maps/zombie/fx_zmb_tranzit_street_lamp" );
    level._effect["fx_zmb_tranzit_truck_light"] = loadfx( "maps/zombie/fx_zmb_tranzit_truck_light" );
    level._effect["fx_zmb_tranzit_spark_int_runner"] = loadfx( "maps/zombie/fx_zmb_tranzit_spark_int_runner" );
    level._effect["fx_zmb_tranzit_spark_ext_runner"] = loadfx( "maps/zombie/fx_zmb_tranzit_spark_ext_runner" );
    level._effect["fx_zmb_tranzit_spark_blue_lg_loop"] = loadfx( "maps/zombie/fx_zmb_tranzit_spark_blue_lg_loop" );
    level._effect["fx_zmb_tranzit_spark_blue_sm_loop"] = loadfx( "maps/zombie/fx_zmb_tranzit_spark_blue_sm_loop" );
    level._effect["fx_zmb_tranzit_bar_glow"] = loadfx( "maps/zombie/fx_zmb_tranzit_bar_glow" );
    level._effect["fx_zmb_tranzit_transformer_on"] = loadfx( "maps/zombie/fx_zmb_tranzit_transformer_on" );
    level._effect["fx_zmb_fog_closet"] = loadfx( "fog/fx_zmb_fog_closet" );
    level._effect["fx_zmb_fog_low_300x300"] = loadfx( "fog/fx_zmb_fog_low_300x300" );
    level._effect["fx_zmb_fog_thick_600x600"] = loadfx( "fog/fx_zmb_fog_thick_600x600" );
    level._effect["fx_zmb_fog_thick_1200x600"] = loadfx( "fog/fx_zmb_fog_thick_1200x600" );
    level._effect["fx_zmb_fog_transition_600x600"] = loadfx( "fog/fx_zmb_fog_transition_600x600" );
    level._effect["fx_zmb_fog_transition_1200x600"] = loadfx( "fog/fx_zmb_fog_transition_1200x600" );
    level._effect["fx_zmb_fog_transition_right_border"] = loadfx( "fog/fx_zmb_fog_transition_right_border" );
    level._effect["fx_zmb_tranzit_smk_interior_md"] = loadfx( "maps/zombie/fx_zmb_tranzit_smk_interior_md" );
    level._effect["fx_zmb_tranzit_smk_interior_heavy"] = loadfx( "maps/zombie/fx_zmb_tranzit_smk_interior_heavy" );
    level._effect["fx_zmb_ash_ember_1000x1000"] = loadfx( "maps/zombie/fx_zmb_ash_ember_1000x1000" );
    level._effect["fx_zmb_ash_ember_2000x1000"] = loadfx( "maps/zombie/fx_zmb_ash_ember_2000x1000" );
    level._effect["fx_zmb_ash_rising_md"] = loadfx( "maps/zombie/fx_zmb_ash_rising_md" );
    level._effect["fx_zmb_ash_windy_heavy_sm"] = loadfx( "maps/zombie/fx_zmb_ash_windy_heavy_sm" );
    level._effect["fx_zmb_ash_windy_heavy_md"] = loadfx( "maps/zombie/fx_zmb_ash_windy_heavy_md" );
    level._effect["fx_zmb_lava_detail"] = loadfx( "maps/zombie/fx_zmb_lava_detail" );
    level._effect["fx_zmb_lava_edge_100"] = loadfx( "maps/zombie/fx_zmb_lava_edge_100" );
    level._effect["fx_zmb_lava_50x50_sm"] = loadfx( "maps/zombie/fx_zmb_lava_50x50_sm" );
    level._effect["fx_zmb_lava_100x100"] = loadfx( "maps/zombie/fx_zmb_lava_100x100" );
    level._effect["fx_zmb_lava_river"] = loadfx( "maps/zombie/fx_zmb_lava_river" );
    level._effect["fx_zmb_lava_creek"] = loadfx( "maps/zombie/fx_zmb_lava_creek" );
    level._effect["fx_zmb_lava_crevice_glow_50"] = loadfx( "maps/zombie/fx_zmb_lava_crevice_glow_50" );
    level._effect["fx_zmb_lava_crevice_glow_100"] = loadfx( "maps/zombie/fx_zmb_lava_crevice_glow_100" );
    level._effect["fx_zmb_lava_crevice_smoke_100"] = loadfx( "maps/zombie/fx_zmb_lava_crevice_smoke_100" );
    level._effect["fx_zmb_lava_smoke_tall"] = loadfx( "maps/zombie/fx_zmb_lava_smoke_tall" );
    level._effect["fx_zmb_lava_smoke_pit"] = loadfx( "maps/zombie/fx_zmb_lava_smoke_pit" );
    level._effect["fx_zmb_tranzit_bowling_sign_fog"] = loadfx( "maps/zombie/fx_zmb_tranzit_bowling_sign_fog" );
    level._effect["fx_zmb_tranzit_lava_distort"] = loadfx( "maps/zombie/fx_zmb_tranzit_lava_distort" );
    level._effect["fx_zmb_tranzit_lava_distort_sm"] = loadfx( "maps/zombie/fx_zmb_tranzit_lava_distort_sm" );
    level._effect["fx_zmb_tranzit_lava_distort_detail"] = loadfx( "maps/zombie/fx_zmb_tranzit_lava_distort_detail" );
    level._effect["fx_zmb_tranzit_fire_med"] = loadfx( "maps/zombie/fx_zmb_tranzit_fire_med" );
    level._effect["fx_zmb_tranzit_fire_lrg"] = loadfx( "maps/zombie/fx_zmb_tranzit_fire_lrg" );
    level._effect["fx_zmb_tranzit_smk_column_lrg"] = loadfx( "maps/zombie/fx_zmb_tranzit_smk_column_lrg" );
    level._effect["fx_zmb_papers_windy_slow"] = loadfx( "maps/zombie/fx_zmb_papers_windy_slow" );
    level._effect["fx_zmb_tranzit_god_ray_short_warm"] = loadfx( "maps/zombie/fx_zmb_tranzit_god_ray_short_warm" );
    level._effect["fx_zmb_tranzit_god_ray_vault"] = loadfx( "maps/zombie/fx_zmb_tranzit_god_ray_vault" );
    level._effect["fx_zmb_tranzit_key_glint"] = loadfx( "maps/zombie/fx_zmb_tranzit_key_glint" );
    level._effect["fx_zmb_tranzit_god_ray_interior_med"] = loadfx( "maps/zombie/fx_zmb_tranzit_god_ray_interior_med" );
    level._effect["fx_zmb_tranzit_god_ray_interior_long"] = loadfx( "maps/zombie/fx_zmb_tranzit_god_ray_interior_long" );
    level._effect["fx_zmb_tranzit_god_ray_depot_cool"] = loadfx( "maps/zombie/fx_zmb_tranzit_god_ray_depot_cool" );
    level._effect["fx_zmb_tranzit_god_ray_depot_warm"] = loadfx( "maps/zombie/fx_zmb_tranzit_god_ray_depot_warm" );
    level._effect["fx_zmb_tranzit_god_ray_tunnel_warm"] = loadfx( "maps/zombie/fx_zmb_tranzit_god_ray_tunnel_warm" );
    level._effect["fx_zmb_tranzit_god_ray_pwr_station"] = loadfx( "maps/zombie/fx_zmb_tranzit_god_ray_pwr_station" );
    level._effect["fx_zmb_tranzit_light_safety"] = loadfx( "maps/zombie/fx_zmb_tranzit_light_safety" );
    level._effect["fx_zmb_tranzit_light_safety_off"] = loadfx( "maps/zombie/fx_zmb_tranzit_light_safety_off" );
    level._effect["fx_zmb_tranzit_light_safety_max"] = loadfx( "maps/zombie/fx_zmb_tranzit_light_safety_max" );
    level._effect["fx_zmb_tranzit_light_safety_ric"] = loadfx( "maps/zombie/fx_zmb_tranzit_light_safety_ric" );
    level._effect["fx_zmb_tranzit_bridge_dest"] = loadfx( "maps/zombie/fx_zmb_tranzit_bridge_dest" );
    level._effect["fx_zmb_tranzit_power_pulse"] = loadfx( "maps/zombie/fx_zmb_tranzit_power_pulse" );
    level._effect["fx_zmb_tranzit_power_on"] = loadfx( "maps/zombie/fx_zmb_tranzit_power_on" );
    level._effect["fx_zmb_tranzit_power_rising"] = loadfx( "maps/zombie/fx_zmb_tranzit_power_rising" );
    level._effect["fx_zmb_avog_storm"] = loadfx( "maps/zombie/fx_zmb_avog_storm" );
    level._effect["fx_zmb_avog_storm_low"] = loadfx( "maps/zombie/fx_zmb_avog_storm_low" );
    level._effect["glass_impact"] = loadfx( "maps/zombie/fx_zmb_tranzit_window_dest_lg" );
    level._effect["fx_zmb_tranzit_spark_blue_lg_os"] = loadfx( "maps/zombie/fx_zmb_tranzit_spark_blue_lg_os" );
    level._effect["spawn_cloud"] = loadfx( "maps/zombie/fx_zmb_race_zombie_spawn_cloud" );
}