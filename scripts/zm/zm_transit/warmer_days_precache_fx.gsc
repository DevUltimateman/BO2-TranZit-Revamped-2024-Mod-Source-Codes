//codename: warmer_days_precache_fx.gsc
//purpose: handles precaching for global 'level.myFx' fx array
//release: 2023 as part of tranzit 2.0 v2 update
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_hud_message;
#include maps\mp\ombies\_zm_stats;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zm_transit_sq;
#include maps\mp\zm_transit_distance_tracking;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zm_alcatraz_utility;
#include maps\mp\zombies\_zm_afterlife;
#include maps\mp\zm_prison;
#include maps\mp\zombies\_zm;
#include maps\mp\gametypes_zm\_spawning;
#include maps\mp\zombies\_load;
#include maps\mp\zombies\_zm_clone;
#include maps\mp\zombies\_zm_ai_basic;
#include maps\mp\animscripts\shared;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zm_alcatraz_travel;
#include maps\mp\gametypes_zm\_zm_gametype;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_perk_electric_cherry;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\_visionset_mgr;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\gametypes_zm\_hud;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zm_transit;

#include maps\mp\createart\zm_transit_art;
#include maps\mp\createfx\zm_transit_fx;

init()
{
    //fx list
    level.myFx = [];
    //precache all fxs for fx list
    //level thread precache_myfx();
}

precache_myfx()
{
    level endon(  "end_game" );
    
    level.myFx = [];
	level.myFx[ 0 ] = loadfx( "env/electrical/fx_elec_wire_spark_burst" ); //small spark loop
	level.myFx[ 1 ] = loadfx( "maps/zombie/fx_zmb_race_trail_grief" );  //ee bolt
	level.myFx[ 2 ] = loadfx( "maps/zombie/fx_zmb_race_trail_neutral" ); //ee bolt
	level.myFx[ 3 ] = loadfx( "maps/zombie/fx_zmb_tranzit_sq_lightning_orb" ); //works
	level.myFx[ 4 ] = loadfx( "maps/zombie/fx_zombie_zapper_light_green" ); //no
	level.myFx[ 5 ] = loadfx( "maps/zombie/fx_zombie_zapper_light_red" ); //no
	level.myFx[ 6 ] = loadfx( "maps/zombie/fx_zmb_tranzit_marker" ); //yes pandora
	level.myFx[ 7 ] = loadfx( "maps/zombie/fx_zmb_tranzit_marker_fl" ); //yes pandora
	level.myFx[ 8 ] = loadfx( "misc/fx_zombie_couch_effect" ); //lighting beam buyable 
	level.myFx[ 9 ] = loadfx( "maps/zombie/fx_zmb_tranzit_lava_torso_explo" ); //small explo with explo and blood
	level.myFx[ 10 ] = loadfx( "maps/zombie/fx_zmb_tranzit_bus_headlight" ); //stays on 4 lights, front bus lights
	level.myFx[ 11 ] = loadfx( "lens_flares/fx_lf_zmb_tranzit_bus_headlight" ); //stays on small-medium yellow light orb similiar to mystery
	level.myFx[ 12 ] = loadfx( "maps/zombie/fx_zmb_tranzit_bus_brakelights" ); //stays on red back lights of bus
	level.myFx[ 13 ] = loadfx( "maps/zombie/fx_zmb_tranzit_bus_flashing_lights" ); //stays on orane red back lights of bus
	level.myFx[ 14 ] = loadfx( "maps/zombie/fx_zmb_tranzit_bus_turnsignal_right" ); //small red light bulb 
	level.myFx[ 15 ] = loadfx( "maps/zombie/fx_zmb_tranzit_bus_turnsignal_left" ); //small red light bulb 
	level.myFx[ 16 ] = loadfx( "maps/zombie/fx_zmb_tranzit_bus_fog_intersect" ); //dark smoke broom nice curtain collapses
	level.myFx[ 17 ] = loadfx( "maps/zombie/fx_zmb_tranzit_bus_fire_driving" ); //fire trails of bus nice non loop for fire area?
	level.myFx[ 18 ] = loadfx( "maps/zombie/fx_zmb_tranzit_bus_hatch_bust" ); //no fx
	level.myFx[ 19 ] = loadfx( "electrical/fx_elec_player_md" ); //no loop, med electric 5 sec
	level.myFx[ 20 ] = loadfx( "electrical/fx_elec_player_sm" ); //same as above
	level.myFx[ 21 ] = loadfx( "electrical/fx_elec_player_torso" ); //same
	level.myFx[ 22 ] = loadfx( "maps/zombie/fx_zombie_eye_single_blue" ); //stays on
	level.myFx[ 23 ] = loadfx( "env/fire/fx_fire_lava_player_torso" ); //nice fire sm med 10 sec

	//Might need to be disabled _>
	level.myFx[ 24 ] = loadfx( "maps/zombie/fx_zmb_morsecode_traffic_loop" ); //stays on flicer red
	level.myFx[ 25 ] = loadfx( "maps/zombie/fx_zmb_morsecode_loop" ); //stays on orange red bulb maybe for weapon fx
	//// <_


	level.myFx[ 26 ] = loadfx( "bio/insects/fx_insects_swarm_md_light" ); //small flies, loops
	level.myFx[ 27 ] = loadfx( "maps/zombie/fx_zmb_tranzit_flourescent_flicker" ); //stays on white fluor
	level.myFx[ 28 ] = loadfx( "maps/zombie/fx_zmb_tranzit_flourescent_glow" ); // same, no flicker
	level.myFx[ 29 ] = loadfx( "maps/zombie/fx_zmb_tranzit_flourescent_glow_lg" ); //same lighter
	level.myFx[ 30 ] = loadfx( "maps/zombie/fx_zmb_tranzit_flourescent_dbl_glow" ); //nice flat 3 light long bulb glow
	level.myFx[ 31 ] = loadfx( "maps/zombie/fx_zmb_tranzit_depot_map_flicker" ); //bus sign station light flicker
	level.myFx[ 32 ] = loadfx( "maps/zombie/fx_zmb_tranzit_light_bulb_xsm" ); //white glow bulb
	level.myFx[ 33 ] = loadfx( "maps/zombie/fx_zmb_tranzit_light_glow" ); //big white glow bulb
	level.myFx[ 34 ] = loadfx( "maps/zombie/fx_zmb_tranzit_light_glow_xsm" ); //small glow white bulb
	level.myFx[ 35 ] = loadfx( "maps/zombie/fx_zmb_tranzit_light_glow_fog" ); //big white glow bulb without bulb
	level.myFx[ 36 ] = loadfx( "maps/zombie/fx_zmb_tranzit_light_depot_cans" ); //light circle pointing straight upwards
	level.myFx[ 37 ] = loadfx( "maps/zombie/fx_zmb_tranzit_light_desklamp" ); //small glow bulb
	level.myFx[ 38 ] = loadfx( "maps/zombie/fx_zmb_tranzit_light_town_cans" ); //big glow circle can pointing straight upwards
	level.myFx[ 39 ] = loadfx( "maps/zombie/fx_zmb_tranzit_light_town_cans_sm" ); //smaller one as above
	level.myFx[ 40 ] = loadfx( "maps/zombie/fx_zmb_tranzit_light_street_tinhat" ); //big lamp pointing upwards, no light source, glow
	level.myFx[ 41 ] = loadfx( "maps/zombie/fx_zmb_tranzit_street_lamp" ); //light boxy light around a lamp nice maybe with sq glow, shootable flyable objects
	level.myFx[ 42 ] = loadfx( "maps/zombie/fx_zmb_tranzit_truck_light" ); //white beam pointing upwards, has light plate underneath
	level.myFx[ 43 ] = loadfx( "maps/zombie/fx_zmb_tranzit_spark_int_runner" ); //big spark explos (mediium), loops
	level.myFx[ 44 ] = loadfx( "maps/zombie/fx_zmb_tranzit_spark_ext_runner" ); //big spark ( tighter sparks + yellow ), loops
	level.myFx[ 45 ] = loadfx( "maps/zombie/fx_zmb_tranzit_spark_blue_lg_loop" ); //fast blue spark small med loop
	level.myFx[ 46 ] = loadfx( "maps/zombie/fx_zmb_tranzit_spark_blue_sm_loop" ); //nice loop forward, lighting bolts good for weapon upgrade fx
	level.myFx[ 47 ] = loadfx( "maps/zombie/fx_zmb_tranzit_bar_glow" ); //red glow bar sigh
	level.myFx[ 48 ] = loadfx( "maps/zombie/fx_zmb_tranzit_transformer_on" ); //med electric loop wirey style
	level.myFx[ 49 ] = loadfx( "fog/fx_zmb_fog_closet" ); //not good
	level.myFx[ 50 ] = loadfx( "fog/fx_zmb_fog_low_300x300" ); //not good 
	level.myFx[ 51 ] = loadfx( "fog/fx_zmb_fog_thick_600x600" );  //nice for edges
	level.myFx[ 52 ] = loadfx( "fog/fx_zmb_fog_thick_1200x600" ); //nice for edges
	level.myFx[ 53 ] = loadfx( "fog/fx_zmb_fog_transition_600x600" ); //big
	level.myFx[ 54 ] = loadfx( "fog/fx_zmb_fog_transition_1200x600" ); //yes
	level.myFx[ 55 ] = loadfx( "fog/fx_zmb_fog_transition_right_border" ); //no
	level.myFx[ 56 ] = loadfx( "maps/zombie/fx_zmb_tranzit_smk_interior_md" );
	level.myFx[ 57 ] = loadfx( "maps/zombie/fx_zmb_tranzit_smk_interior_heavy" );
	level.myFx[ 58 ] = loadfx( "maps/zombie/fx_zmb_ash_ember_1000x1000" );
	level.myFx[ 59 ] = loadfx( "maps/zombie/fx_zmb_ash_ember_2000x1000" );
	level.myFx[ 60 ] = loadfx( "maps/zombie/fx_zmb_ash_rising_md" );
	level.myFx[ 61 ] = loadfx( "maps/zombie/fx_zmb_ash_windy_heavy_sm" ); // nice
	level.myFx[ 62 ] = loadfx( "maps/zombie/fx_zmb_ash_windy_heavy_md" ); //yes
	level.myFx[ 63 ] = loadfx( "maps/zombie/fx_zmb_lava_detail" ); //no
	level.myFx[ 64 ] = loadfx( "maps/zombie/fx_zmb_lava_edge_100" ); //no
	level.myFx[ 65 ] = loadfx( "maps/zombie/fx_zmb_lava_50x50_sm" ); //no
	level.myFx[ 66 ] = loadfx( "maps/zombie/fx_zmb_lava_100x100" ); //no
	level.myFx[ 67 ] = loadfx( "maps/zombie/fx_zmb_lava_river" ); //nice
	level.myFx[ 68 ] = loadfx( "maps/zombie/fx_zmb_lava_creek" ); //nice small loopin
	level.myFx[ 69 ] = loadfx( "maps/zombie/fx_zmb_lava_crevice_glow_50" );  //nice
	level.myFx[ 70 ] = loadfx( "maps/zombie/fx_zmb_lava_crevice_glow_100" ); //bigger nice
	level.myFx[ 71 ] = loadfx( "maps/zombie/fx_zmb_lava_crevice_smoke_100" );  //nice big orange smoke loop
	level.myFx[ 72 ] = loadfx( "maps/zombie/fx_zmb_lava_smoke_tall" ); //very nice very big orange smoke loop
	level.myFx[ 73 ] = loadfx( "maps/zombie/fx_zmb_lava_smoke_pit" ); //big smoke time
	level.myFx[ 74 ] = loadfx( "maps/zombie/fx_zmb_tranzit_bowling_sign_fog" ); //light blue dots in a line
	level.myFx[ 75 ] = loadfx( "maps/zombie/fx_zmb_tranzit_lava_distort" );//nice weird gas fume effect 
	level.myFx[ 76 ] = loadfx( "maps/zombie/fx_zmb_tranzit_lava_distort_sm" );//smaller same
	level.myFx[ 77 ] = loadfx( "maps/zombie/fx_zmb_tranzit_lava_distort_detail" );//smaller
	level.myFx[ 78 ] = loadfx( "maps/zombie/fx_zmb_tranzit_fire_med" ); //nice med fire								
	level.myFx[ 79 ] = loadfx( "maps/zombie/fx_zmb_tranzit_fire_lrg" ); //big fire								
	level.myFx[ 80 ] = loadfx( "maps/zombie/fx_zmb_tranzit_smk_column_lrg" ); //big black smoke
	level.myFx[ 81 ] = loadfx( "maps/zombie/fx_zmb_papers_windy_slow" ); //no
    /*
    //commented out to test remaingin fxs
	level.myFx[ 82 ] = loadfx( "maps/zombie/fx_zmb_tranzit_god_ray_short_warm" ); //nice
	level.myFx[ 83 ] = loadfx( "maps/zombie/fx_zmb_tranzit_god_ray_vault" ); //bigger nice
	level.myFx[ 84 ] = loadfx( "maps/zombie/fx_zmb_tranzit_key_glint" ); //small yellow glint bulb flick
	level.myFx[ 85 ] = loadfx( "maps/zombie/fx_zmb_tranzit_god_ray_interior_med" ); //2d ray
	level.myFx[ 86 ] = loadfx( "maps/zombie/fx_zmb_tranzit_god_ray_interior_long" ); //2d ray
	level.myFx[ 87 ] = loadfx( "maps/zombie/fx_zmb_tranzit_god_ray_depot_cool" ); //yes
	level.myFx[ 88 ] = loadfx( "maps/zombie/fx_zmb_tranzit_god_ray_depot_warm" ); //yes
	level.myFx[ 89 ] = loadfx( "maps/zombie/fx_zmb_tranzit_god_ray_tunnel_warm" ); //yes big
	level.myFx[ 90 ] = loadfx( "maps/zombie/fx_zmb_tranzit_god_ray_pwr_station" );
	level.myFx[ 91 ] = loadfx( "maps/zombie/fx_zmb_tranzit_light_safety" ); //green light glow
	level.myFx[ 92 ] = loadfx( "maps/zombie/fx_zmb_tranzit_light_safety_off" ); //flicker white light same
	level.myFx[ 93 ] = loadfx( "maps/zombie/fx_zmb_tranzit_light_safety_max" ); //faster white flicker and sparks
	level.myFx[ 94 ] = loadfx( "maps/zombie/fx_zmb_tranzit_light_safety_ric" ); //green fastfast flicker and sparks
	level.myFx[ 95 ] = loadfx( "maps/zombie/fx_zmb_tranzit_bridge_dest" ); //big wood explos, then bus track fire
	level.myFx[ 96 ] = loadfx( "maps/zombie/fx_zmb_tranzit_power_pulse" ); //big electric power pulse nice
	level.myFx[ 97 ] = loadfx( "maps/zombie/fx_zmb_tranzit_power_on" );
    */
    
	level.myFx[ 82 ] = loadfx( "maps/zombie/fx_zmb_tranzit_power_rising" ); //cool
	level.myFx[ 83 ] = loadfx( "maps/zombie/fx_zmb_avog_storm" ); //storm clouds above loop
	level.myFx[ 84 ] = loadfx( "maps/zombie/fx_zmb_avog_storm_low" ); //no work
	level.myFx[ 85 ] = loadfx( "maps/zombie/fx_zmb_tranzit_window_dest_lg" ); //puff and window breaks
	level.myFx[ 86 ] = loadfx( "maps/zombie/fx_zmb_tranzit_spark_blue_lg_os" ); //cool blue explo
	level.myFx[ 87 ] = loadfx( "maps/zombie/fx_zmb_race_zombie_spawn_cloud" ); //no
	level.myFx[ 88 ] = level._effect[ "jetgun_smoke_cloud" ];
	level.myFx[ 89 ] = level._effect[ "jetgun_knockdown_ground" ];
	level.myFx[ 90 ] = level._effect[ "zombie_guts_explosion" ];
	level.myFx[ 91 ] = level._effect["avogadro_phasing"];
	level.myFx[ 92 ] = level._effect[ "avogadro_bolt" ];
	level.myFx[ 93 ] = level._effect["avogadro_phasing"];
	level.myFx[ 94 ] = level._effect["avogadro_health_full"];
	level.myFx[ 95 ] = level._effect["avogadro_health_half"];
	level.myFx[ 96 ] = level._effect["avogadro_health_low"];

	level._effect[97] = loadfx( "misc/fx_zombie_powerup_on_red" );
	level._effect[98] = loadfx( "misc/fx_zombie_powerup_red_grab" );
	level._effect[99] = loadfx( "misc/fx_zombie_powerup_red_wave" );

	//Test stuff from BO2 Beta dumb

	//FOG
    /*
	level.myFx[ 88 ] 	   = loadfx("env/smoke/fx_fog_ground_rising_md");
	level.myFx[ 89 ]      = loadfx("env/smoke/fx_fog_rolling_ground_md");
	level.myFx[ 90 ] 			   = loadfx("env/smoke/fx_fog_large_slow");
	level.myFx[ 91 ] 		   = loadfx("env/smoke/fx_fog_lit_overhead");
	level.myFx[ 92 ] 		   = loadfx("maps/zombie_bus/fx_zbus_fog_barrier");	

	// Lights -                                    
	level.myFx[ 93 ] 			     = loadfx("env/light/fx_dlight_fire_glow");
	level.myFx[ 94 ] 				     = loadfx("env/light/fx_light_overhead");
	
    //level.myFx[ 95 ] 			     = loadfx("env/light/fx_light_red_on_lg");
	//level.myFx[ 96 ] 				       = loadfx("env/light/fx_street_light");
	//level.myFx[ 97 ] 		     = loadfx("env/light/fx_search_light_tower");
    */
	//Weather                                      
	//level.myFx[ 88 ] = LoadFx( "maps/zombie_bus/fx_zbus_rain_lg" );
    
}