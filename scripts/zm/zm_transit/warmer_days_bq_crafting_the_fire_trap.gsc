//codename: warmer_days_mq_02_meet_mr_s.gsc
//purpose: handles the first time meeting with Mr.Schruder
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

#include maps\mp\zombies\_zm_craftables;

main()
{
    //replacefunc( maps\mp\_visionset_mgr::init, ::override_mainer );
    //replacefunc( maps\mp\_visionset_mgr::vsmgr_activate, ::override_others );
    //replacefunc( maps\mp\_visionset_mgr::vsmgr_timeout_lerp_thread, ::ff1 ); 
   // replacefunc( maps\mp\_visionset_mgr::vsmgr_timeout_lerp_thread_per_player, ::ff2 ); 
   // replacefunc( maps\mp\_visionset_mgr::finalize_type_clientfields, ::blahblah );
   // replacefunc( maps\mp\_visionset_mgr::onplayerconnect, ::on_player_fucked );
    

   // replacefunc( maps\mp\createart\zm_transit_art::main, ::main_art );



    //replacefunc( maps\mp\zm_transit_fx::precache_scripted_fx, ::precache_scripted_fx_new );
    //replacefunc( maps\mp\zm_transit_fx::precache_createfx_fx, ::precache_createfx_fx_new );

}



init()
{
    //replacefunc( maps\mp\zm_transit_fx::precache_scripted_fx, ::precache_scripted_fx_new );
    //replacefunc( maps\mp\zm_transit_fx::precache_createfx_fx, ::precache_createfx_fx_new );
    //replacefunc( maps\mp\createart\zm_transit_art::main, ::main_art );
    
    //level thread fog_bank_alter_wait(); //dev func
    //level thread main_art(); //dev func
    //level thread loop_to_console(); //dev func
    flag_wait( "initial_blackscreen_passed" );
    level.gas_canister_pick_location = ( -4844.13, -7173.79, -56.2322 );
    level.gas_tools_pick_location = ( -4219.75, -7871.54, -62.8096 );
    level.gas_pour_location = ( 8051.65, -5330.98, 264.125 ); 
    level.gas_fire_pick_location = ( 8410.4, -6343.49, 103.431 ); //outside farm main base next to house lava crack
    level.gas_fire_place_location = level.gas_pour_location;

    
    level.cracker_pickups = [];
    level.cracker_pickups[ 0 ] = ( 8410.4, -6343.49, 103.431 ); //farm lava crack next to main house
    level.cracker_pickups[ 1 ] = ( -647.101, -1127.28, -61.3341 ); //outside towwn on left before bridge
    level.cracker_pickups[ 2 ] = ( 4742.58, 7480.7, -63.875 ); //behind cabin in the woods
    level.cracker_pickups[ 3 ] = ( 10837, 8066.7, -556.448 ); //power station behind the drop down back to outside, next to truck
    level.cracker_pickups[ 4 ] = ( -11296, -2678.63, 193.003 ); //tunnels, next to the big pillar at portal location
    
    level.gas_fireplaces = [];
    level.gas_fireplaces[ level.gas_fireplaces.size ] = ( 8483.78, -5406.71, 264.125 );
    level.gas_fireplaces[ level.gas_fireplaces.size ] = ( 8488.59, -5353.79, 264.125 );
    level.gas_fireplaces[ level.gas_fireplaces.size ] = ( 8476.43, -5304.71, 264.125 );
    level.gas_fireplaces[ level.gas_fireplaces.size ] = ( 8458.43, -5362.5, 264.125 );
     
    level.gas_has_been_picked = false;

    level.gas_been_picked_up = false;
    level.gas_is_the_trigger = false;
    //add a check before this so that we cant do it immediately
    //but now for testing on
    ///level thread do_everything_for_gas_pickup();
    level thread spawn_workbench_to_build_fire_trap_entrance();
    //level thread global_gas_quest_trigger_spawner( level.gas_pour_location, "^9[ ^8Workbench requires ^9Gasoline ^9]", "", level.myfx[ 75 ], level.myfx[ 76 ], "littered_floor" );

    //change hintstring text once gas has been picked for work bench
    //level thread while_gas_hasnt_been_picked();f
    wait 1;

    //next 5 steps are refactored to simplify the understanding of said code logic. 
    //original code was coded that long ago that I can'tremember anymore how certain things were supposed to match and work
    //this new simplified version seem to work well now
    level thread gas_quest_01_pick_up_gas();
    wait 6;
    level thread gas_quest_02_place_down_gas();
    level thread gas_quest_03_find_crackers();
    level thread gas_quest_04_place_down_fc();
    level thread gas_quest_05_fire_trap_logic();
    if( level.dev_time ){ iprintlnbold( "GAS GUEST NEW LOGIC APPLIES" ); }
    
}


precache_scripted_fx_new()
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

precache_createfx_fx_new()
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
    //level._effect["fx_zmb_fog_thick_600x600"] = loadfx( "fog/fx_zmb_fog_thick_600x600" );
    //level._effect["fx_zmb_fog_thick_1200x600"] = loadfx( "fog/fx_zmb_fog_thick_1200x600" );
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
main_art()
{
    level.tweakfile = 1;
    setdvar( "scr_fog_exp_halfplane", "29.219" );
    setdvar( "scr_fog_exp_halfheight", "691.3" );
    setdvar( "scr_fog_nearplane", "199.679" );
    setdvar( "scr_fog_red", "0.9" );
    setdvar( "scr_fog_green", "0.1" );
    setdvar( "scr_fog_blue", "0.1" );
    setdvar( "scr_fog_baseheight", "-12145.21" );
    setdvar( "visionstore_glowTweakEnable", "1" );
    setdvar( "visionstore_glowTweakRadius0", "5" );
    setdvar( "visionstore_glowTweakRadius1", "" );
    setdvar( "visionstore_glowTweakBloomCutoff", "0.5" );
    setdvar( "visionstore_glowTweakBloomDesaturation", "0" );
    setdvar( "visionstore_glowTweakBloomIntensity0", "1" );
    setdvar( "visionstore_glowTweakBloomIntensity1", "" );
    setdvar( "visionstore_glowTweakSkyBleedIntensity0", "" );
    setdvar( "visionstore_glowTweakSkyBleedIntensity1", "" );
    start_dist = 21438.679;
    half_dist = 2011.62;
    half_height = 834.5;
    base_height = -2145.21;
    fog_r = 0.8;
    fog_g = 0.1;
    fog_b = 0.1;
    fog_scale = 0.5834;
    sun_col_r = 0.8;
    sun_col_g = 0.1;
    sun_col_b = 0.1;
    sun_dir_x = -45;
    sun_dir_y = 45;
    sun_dir_z = -0.11;
    sun_start_ang = 0;
    sun_stop_ang = 0;
    time = 0;
    max_fog_opacity = 1;
    setvolfog( start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale, sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, sun_stop_ang, time, max_fog_opacity );
    visionsetnaked( "zm_transit_base", 0 );
    setdvar( "r_lightGridEnableTweaks", 1 );
    setdvar( "r_lightGridIntensity", 1.4 );
    setdvar( "r_lightGridContrast", 0.2 );
}

loop_to_console()
{
    level endon( "end_game" );
    vision_trigs = getentarray( "vision_trig", "targetname" );
    wait( 5 );
    fogsettings = getfogsettings();
    iprintlnbold( fogsettings );

    //iprintlnbold( "PRINTED FOGSETTINGS" );
    level.current_fog = -1;
    gumps = getEntArray( "gump_triggers", "trigger_multiple" );
    
    while ( true )
    {
        if( gumps.size < 1 )
        {
            wait 0.1;
            iprintln( "^2" + level.players[ 0 ].origin );
            continue;
        }
        else if ( gumps.size > 0 )
        {
            for( i = 0; i < gumps.size; i++ )
            {
                iprintln( i + " = ^2" + gumps[ i ] );
                wait 0.25;
            }
            wait 1;
        }
        
        //iprintln( level.current_fog );
        wait 1;
    }
    
    /*
    while( true )
    {
        for( i = 0; i < level.fv2vs_infos.size; i++ )
        {
            iprintln( i + " ^2vision trigger" );
            wait 0.1;
        }
        wait 2;
    }
    */

}
/*
main_artss()
{
    level.tweakfile = 1;
    setdvar( "scr_fog_exp_halfplane", "639.219" );
    setdvar( "scr_fog_exp_halfheight", "18691.3" );
    setdvar( "scr_fog_nearplane", "138.679" );
    setdvar( "scr_fog_red", "0.806694" );
    setdvar( "scr_fog_green", "0.962521" );
    setdvar( "scr_fog_blue", "0.9624" );
    setdvar( "scr_fog_baseheight", "1145.21" );
    setdvar( "visionstore_glowTweakEnable", "0" );
    setdvar( "visionstore_glowTweakRadius0", "5" );
    setdvar( "visionstore_glowTweakRadius1", "" );
    setdvar( "visionstore_glowTweakBloomCutoff", "0.5" );
    setdvar( "visionstore_glowTweakBloomDesaturation", "0" );
    setdvar( "visionstore_glowTweakBloomIntensity0", "1" );
    setdvar( "visionstore_glowTweakBloomIntensity1", "" );
    setdvar( "visionstore_glowTweakSkyBleedIntensity0", "" );
    setdvar( "visionstore_glowTweakSkyBleedIntensity1", "" );
    start_dist = 138.679;
    half_dist = 1011.62;
    half_height = 10834.5;
    base_height = 1145.21;
    fog_r = 0.501961;
    fog_g = 0.501961;
    fog_b = 0.501961;
    fog_scale = 7.5834;
    sun_col_r = 0.501961;
    sun_col_g = 0.501961;
    sun_col_b = 0.501961;
    sun_dir_x = -0.99;
    sun_dir_y = 0.06;
    sun_dir_z = -0.11;
    sun_start_ang = 0;
    sun_stop_ang = 0;
    time = 0;
    max_fog_opacity = 0.8546;
    setvolfog( start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale, sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, sun_stop_ang, time, max_fog_opacity );
    visionsetnaked( "zm_transit", 0 );
    setdvar( "r_lightGridEnableTweaks", 1 );
    setdvar( "r_lightGridIntensity", 1.4 );
    setdvar( "r_lightGridContrast", 0.2 );
}
*/

lollipopvols()
{

}
on_player_fucked()
{
    level endon( "end_game" );
    while( true )
    {
        level waittill( "connected", p );
        p thread passeds();
    }
}

passeds()
{
    self waittill( "spawned_player" );
    iprintln( "passed fogvols" );
}
ff1( timeout, opt_param_2 )
{
    players = getplayers();
    wait 0.05;
    return;
}

ff2( player, timeout, opt_param_2 )
{
    wait 0.05;
    return;
}

blahblah()
{
    if ( 1 >= self.info.size )
        return;

    self.in_use = 0;
    self.cf_slot_bit_count = getminbitcountfornum( self.info.size - 1 );
    self.cf_lerp_bit_count = self.info[self.sorted_name_keys[0]].lerp_bit_count;

    for ( i = 0; i < self.sorted_name_keys.size; i++ )
    {
        self.info[self.sorted_name_keys[i]].slot_index = i;

        if ( self.info[self.sorted_name_keys[i]].lerp_bit_count > self.cf_lerp_bit_count )
            self.cf_lerp_bit_count = self.info[self.sorted_name_keys[i]].lerp_bit_count;
    }

    registerclientfield( "toplayer", self.cf_slot_name, self.highest_version, self.cf_slot_bit_count, "int" );

    if ( 1 < self.cf_lerp_bit_count )
        registerclientfield( "toplayer", self.cf_lerp_name, self.highest_version, self.cf_lerp_bit_count, "float" );
}

override_mainer()
{
    if ( level.createfx_enabled )
        return;

    level.vsmgr_initializing = 1;
    level.vsmgr_default_info_name = "none";
    level.vsmgr = [];
    level thread register_type( "visionset" );
    level thread register_type( "overlay" );
    onfinalizeinitialization_callback( ::finalize_clientfields );
}

override_set_active( player, lerp )
{
    player_entnum = player getentitynumber();

    if ( !isdefined( self.players[player_entnum] ) )
        return;
}

override_others( type, name, playerf, opt_param_1, opt_param_2 )
{

    if ( level.vsmgr[type].info[name].state.activate_per_player )
    {
        return;
    }

    state = undefined;//level.vsmgr[type].info[name].state;

    if ( state.ref_count_lerp_thread )
    {
        state.ref_count++;

        if ( 1 < state.ref_count )
            return;
    }

    if ( isdefined( state.lerp_thread ) )
    {
        //iprintln
    }
       
    else
    {
        players = getplayers();
    }
}



fog_bank_alter_wait()
{
    level endon( "end_game" );
    flag_wait( "initial_blackscreen_passed" );
    wait 1;
    
    ArrayRemoveIndex(level.fv2vs_infos, 501);
    ArrayRemoveIndex(level.fv2vs_infos, 502);
    ArrayRemoveIndex(level.fv2vs_infos, 504);
    ArrayRemoveIndex(level.fv2vs_infos, 506);
    ArrayRemoveIndex(level.fv2vs_infos, 508);
    ArrayRemoveIndex(level.fv2vs_infos, 510);
    
   
    /*
    level.fv2vs_infos[ 501 ].visionset = 1;
    level.fv2vs_infos[ 502 ].visionset = 2;
    level.fv2vs_infos[ 504 ].visionset = 4;
    wait 0.05;
    level.fv2vs_infos[ 506 ].visionset = 6;
    wait 0.05;
    level.fv2vs_infos[ 508 ].visionset = 8;
    wait 0.05;
    level.fv2vs_infos[ 510 ].visionset = 10;
     */
}
gas_quest_01_pick_up_gas()
{
    level endon( "end_game" );

    wait 5;
    level.fireplace_trigger = spawn( "trigger_radius_use", level.gas_pour_location, 0, 48, 48 );
    level.fireplace_trigger setCursorHint( "HINT_NOICON" );
    level.fireplace_trigger setHintString( "^9[ ^8Workbench requires ^3Gasoline^9 ]" );
    level.fireplace_trigger triggerignoreteam();
    wait 1;
    gas_trig = spawn( "trigger_radius_use", level.gas_canister_pick_location, 0, 24, 24 );
    gas_trig setcursorhint( "HINT_NOICON" );
    gas_trig sethintstring( "^9[ ^3[{+activate}] ^8to pick up ^3Gasoline ^9]" );
    gas_trig triggerignoreteam();
    wait 0.05;
    inv_mod_fx = spawn( "script_model", gas_trig.origin + ( 0, -40, 65) );
    inv_mod_fx setmodel( "tag_origin" );
    inv_mod_fx.angles = ( 0,0,0 );
    wait 1;
    playfxontag( level.myFx[ 2 ], inv_mod_fx, "tag_origin" );

    cans = spawn( "script_model", gas_trig.origin + ( 0, -20, 3 ) );
    cans setmodel( level.x_models[ 71 ] );
    cans.angles = cans.angles;
    wait 0.05;
    playfxontag( level.myfx[ 44 ], cans, "tag_origin" );
    cans vibrate( cans.angles[ 1 ] + 10, 30, 10, 9999 );

    while( true )
    {
        gas_trig sethintstring( "^9[ ^3[{+activate}] ^8to pick up ^3Gasoline ^9]" );
        gas_trig waittill( "trigger", presser );
        if( isplayer( presser ) && is_player_valid( presser ) )
        {
            gas_trig sethintstring( "" );
            level thread playlocal_plrsound();
            level.gas_has_been_picked = true;
            //presser freezeControls( true );
            presser playSound( "zmb_sq_navcard_success" );
            //presser.has_picked_up_g = false;
            current_w = presser getCurrentWeapon();
            presser giveWeapon( "zombie_builder_zm" );
            presser switchToWeapon( "zombie_builder_zm" );
            cans delete();
            waiter = 3;
            wait waiter;
            presser maps\mp\zombies\_zm_weapons::switch_back_primary_weapon( current_w );
            presser takeWeapon( "zombie_builder_zm" );
            presser.has_picked_up_g = true;
            level notify( "gas_got_picked" );
            level.gas_been_picked_up = true;
            level.gas_is_the_trigger = true;
            level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says( "^9" + presser.name + " ^8found some spoiled ^9Gasoline", "", 6, 1  );
           // coop_print_base_find_or_fortify_fire_trap( "gas_got_picked", presser );
            gas_trig delete();
            inv_mod_fx delete();
            wait 1;
            //level thread gas_quest_02_place_down_gas();
            level notify( "someone_picked_up_gas_to_bypass_check" );
            break;
        }
    }
}

//a/s_quest_05_fire_trap_logic()
//gas_quest_04_place_down_fc()
///gas_quest_03_find_crackers()
gas_quest_02_place_down_gas()
{
    level endon( "end_game" );
    level waittill( "gas_got_picked" );
    level.fireplace_trigger setHintString( "^9[ ^3[{+activate}] ^8to apply ^3Gasoline ^8to workbench ^9]");
    while( true )
    {
        level.fireplace_trigger waittill( "trigger", who );
        if( !is_player_valid( who ) )
        {
            wait 0.05;
            continue;
        }
        if( is_player_valid( who ) )
        {
            level.fireplace_trigger sethintstring( "^9[ ^8Applying ^3Gasoline^8... ^9] " );
            wait 0.1;
            who playsound( "zmb_sq_navcard_success" );
            
            now_weap = who getcurrentweapon();
            who giveweapon( "zombie_builder_zm" );
            who switchToWeapon( "zombie_builder_zm" );
            wait 3;
            who maps\mp\zombies\_zm_weapons::switch_back_primary_weapon( now_weap );
            who takeweapon( "zombie_builder_zm" );
            level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says( "^9" + who.name + " ^8brought Gasoline^8 to ^9Safe House", "", 6, 1   );
            level.fireplace_trigger setHintString( "^9[ ^8Workbench requires ^3Fire Crackers ^9] " );
            level notify( "start_firecracker_logic" );
            wait 1;
            break;
        }
    }
}
//gas_quest_05_fire_trap_logic()
//gas_quest_04_place_down_fc()
gas_quest_03_find_crackers()
{
    level endon( "end_game" );
    level waittill( "start_firecracker_logic" );
    firecracker_trigger = spawn( "trigger_radius_use", level.cracker_pickups[ randomint( level.cracker_pickups.size ) ], 0, 48, 48 );
    firecracker_trigger TriggerIgnoreTeam();
    firecracker_trigger setHintString( "^9[ ^3[{+activate}] ^8to dig up ^3Fire Crackers^8 ^9]");
    firecracker_trigger setCursorHint( "HINT_NOICON") ;

    wait 0.1;
    inv_mod = spawn( "script_model", firecracker_trigger.origin );
    inv_mod setmodel( "tag_origin" );
    inv_mod.angles = ( 0, 0, 0 );
    wait 0.25;
    playfxontag( level.myFx[ 75 ], inv_mod, "tag_origin" );
    wait 0.25;
    playfxontag( level.myFx[ 75 ], inv_mod, "tag_origin" );
    wait 0.25;
    playfxontag( level.myFx[ 34 ], inv_mod, "tag_origin" );
    wait 0.25;
    playfxontag( level.myFx[ level.myFx[ 39 ] ], inv_mod, "tag_origin" );
    wait 0.25;


    while( true )
    {
        firecracker_trigger waittill( "trigger", surv );
        if( !is_player_valid( surv ) )
        {
            wait 0.05;
            continue;
        }
        else if( is_player_valid( surv ) )
        {
            if( isalive( surv )) 
            {
                wait 0.25;
                level thread animate_fire_pickup( firecracker_trigger.origin );
                firecracker_trigger setHintString( "^9[ ^8Found some old ^3Fire Crackers ^9]" );
                wait 2.5;
                level notify( "crackers_can_be_put_down" );
                level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says( "^9" + surv.name + " ^8found some old ^9Fire Crackers", "", 6, 1   );
                firecracker_trigger delete();
                inv_mod delete();
                break;
            }
        }
    }
}

//gas_quest_05_fire_trap_logic()
gas_quest_04_place_down_fc()
{
    level endon( "end_game" );
    level waittill( "crackers_can_be_put_down" );
    level.fireplace_trigger setHintString( "^9[ ^3[{+activate}] ^8to apply ^3Fire Crackers ^8to workbench ^9]");
    while( true )
    {
        level.fireplace_trigger waittill( "trigger", who );
        if( !is_player_valid( who ) )
        {
            wait 0.05;
            continue;
        }
        if( is_player_valid( who ) )
        {
            level.fireplace_trigger sethintstring( "^9[ ^8Applying ^9Crackers^8... ^9] " );
            wait 0.1;
            who playsound( "zmb_sq_navcard_success" );
            
            now_weap = who getcurrentweapon();
            who giveweapon( "zombie_builder_zm" );
            who switchToWeapon( "zombie_builder_zm" );
            wait 3;
            who maps\mp\zombies\_zm_weapons::switch_back_primary_weapon( now_weap );
            who takeweapon( "zombie_builder_zm" );
            level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says(  "^9" + who.name + " ^8finished upgrading ^9Safe House's ^8window entrances.", "Zombies climbing through said windows will be ^9killed^8 by the crafted fire trap.", 8, 1  );
            level.fireplace_trigger sethintstring( "^9[ ^8Fire Trap ^8has been built ^9] " );
            level notify( "start_firetrap_logic" );
            level thread monitor_zombies();
            wait 1;
            break;
        }
    }
}

gas_quest_05_fire_trap_logic()
{
    level endon( "end_game" );
    level waittill( "start_firetrap_logic" );
    fxs = 12;
    starting = 0;
    while( fxs > starting )
    {
        if( starting < 4 )
        {
            s = 2;
            x = 0;
            if( randomInt( 4 ) < 2 )
            {
                playfx( level.myfx[ 75 ],level.gas_fireplaces[ starting ] );
            }
            else { playfx( level.myfx[ 76 ],level.gas_fireplaces[ starting ] ); }
            wait 0.08;
        }
        if( starting >= 4 && starting < 8 )
        {
            playfx( level.myfx[ 44 ], level.gas_fireplaces[ starting ] );
            wait 0.15;
        }


        playfx( level.myfx[ 78 ], level.gas_fireplaces[ starting ] );
        wait 0.1;

        if( starting >= 10 )
        {
            playfx( level.myfx[ 80 ], level.gas_fireplaces[ starting ] );
            PlaySoundAtPosition( level.mysounds[ 12 ], level.gas_fireplaces[ starting ] );
            wait 0.05;
            playsoundatposition( level.mysounds[ 7 ], level.gas_fireplaces[ starting ] );
        }
        starting++;
    }
    level thread playloop_electricsound();

}





coop_print_base_find_or_fortify_fire_trap( which_notify, who_found )
{
    level endon( "end_game" );
    switch( which_notify )
    {
        case "gas_got_picked":
        level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says( "^9" + who_found.name + " ^8found some spoiled ^9Gasoline", "", 6, 1 );
        break;

        case "littered_floor":
        level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says( "^9" + who_found.name + " ^8brought Gasoline^8 to ^9Safe House", "", 6, 1  );
        break;

        case "fire_picking":
        level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says( "^9" + who_found.name + " ^8found some old ^9Fire Crackers", "", 6, 1   );
        break;

        case "firetrap_active":
        level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says( "^9" + who_found.name + " ^8finished upgrading ^9Safe House's ^8window entrance.", "Zombies climbing through said window will be ^9killed^8 by the crafted fire trap.", 8, 1 );
        break;

        case "side_door_unlocked":
        level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says( "^9" + who_found.name + " ^8crafted a barricade on the side entrance of ^9Safe House ^8that prevents zombies from entering the barn.", "", 8, 1  );
        break;

        case "main_door_unlocked":
        level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says( "^9" + who_found.name + " ^8crafted an air locking door mechanism on the main entrance of ^9Safe House^8.", "^8Keep an eye on the door's ^9health^8. There might be a time when it needs ^9repairing^8..", 9, 1  );
        break;
        default:
        break;
    }
}

Subtitle( text, text2, duration, fadeTimer )
{
	subtitle = NewHudElem();
	subtitle.x = 0;
	subtitle.y = -42;
	subtitle SetText( text );
	subtitle.fontScale = 1.32;
	subtitle.alignX = "center";
	subtitle.alignY = "middle";
	subtitle.horzAlign = "center";
	subtitle.vertAlign = "bottom";
	subtitle.sort = 1;
    
	//subtitle2 = undefined;
	subtitle.alpha = 0;
    subtitle fadeovertime( fadeTimer );
    subtitle.alpha = 1;

	if ( IsDefined( text2 ) && text2 != "" )
	{
		subtitle2 = NewHudelem();
		subtitle2.x = 0;
		subtitle2.y = -24;
		subtitle2 SetText( text2 );
		subtitle2.fontScale = 1.22;
		subtitle2.alignX = "center";
		subtitle2.alignY = "middle";
		subtitle2.horzAlign = "center";
		subtitle2.vertAlign = "bottom";
		subtitle2.sort = 1;
        subtitle2.alpha = 0;
        subtitle2 fadeovertime( fadeTimer );
        subtitle2.alpha = 1;
	}
	
	wait ( duration );

    subtitle fadeovertime( fadetimer );
    if( isdefined( subtitle2 ) )
    {
        subtitle2 fadeovertime( fadetimer );
        subtitle2.alpha = 0;
    }
    
    subtitle.alpha = 0;
    
    wait fadetimer;
    subtitle destroy_hud();
    if( isdefined( subtitle2 ) )
    {
    subtitle2 destroy_hud();
    }
    
}

flyby( element )
{
    level endon( "end_game" );
    x = 0;
    on_right = 640;

    while( element.x < on_right )
    {
        element.x += 200;
        /*
        //if( element.x < on_right )
        //{
            
            //waitnetworkframe();
        //    wait 0.01;
        //}
        //if( element.x >= on_right )
        //{
        //    element destroy();
        //}
        */
        wait 0.05;
    }
    if( isdefined( element ) )
    {
        element destroy_hud();
    }
    
}



while_gas_hasnt_been_picked()
{
    level endon( "end_game" );
    while( true )
    {
        level waittill( "someone_picked_up_gas_to_bypass_check" );
        level.tr setHintString( "^9[ ^3[{+activate}] ^8to apply ^3Gasoline ^8on the workbench ^9]" );
        level waittill( "fire_picking" );
        level.tr sethintstring( "^9[ ^3[{+activate}] ^8to apply ^3Fire Crackers ^8on the workbench ^9]" );
        break;
    }
}
global_gas_quest_trigger_spawner( location, text1, text2, fx1, fx2, notifier )
{
    level endon( "end_game" );

    level.tr = spawn( "trigger_radius_use", location, 0, 48, 48 );
    level.tr setCursorHint( "HINT_NOICON" );
    level.tr setHintString( text1 );
    level.tr triggerignoreteam();
    wait 0.05;
    i_m = spawn( "script_model", level.tr.origin );
    i_m setmodel( "tag_origin" );
    i_m.angles = ( 0, 0, 0 );
    wait 0.5;
    if( isdefined( fx1 ) && fx1 != "" )
    {
        playfxontag( fx1, i_m, "tag_origin" );
        wait 0.05;
        if( isdefined( fx2 ) && fx2 != "" )
        {
            playfxontag( fx2, i_m, "tag_origin" );
        }
    }
   while( !level.gas_been_picked_up && !level.gas_is_the_trigger ) //ghetto hack to prevent playher from triggering
    {
        wait 1;
    }
    while( true )
    {
        level.tr waittill( "trigger", me );
        if( isplayer( me ) && is_player_valid( me ) )
        {
            
            me playsound( "zmb_sq_navcard_success" );

            if( level.tr.origin == level.gas_pour_location )
            {
                if( isdefined( text2 ) && text2 != "" )
                {
                    wait 0.25;
                    level.tr setHintString( text2 );
                }
            }
            if( level.tr.origin == level.gas_fire_pick_location + ( 0, 0, 60 ) )
            {
                level.tr setHintString("");
            }
            me thread playlocal_plrsound();
            current_w = me getCurrentWeapon();
            me giveWeapon( "zombie_builder_zm" );
            me switchToWeapon( "zombie_builder_zm" );
            waiter = 3.5;
            wait waiter;
            me maps\mp\zombies\_zm_weapons::switch_back_primary_weapon( current_w );
            me takeWeapon( "zombie_builder_zm" );
            if( level.tr.origin == level.gas_pour_location )
            {
                //wait extra second to read the text
                wait 1;
            }
            wait 0.1;
            if( isdefined( notifier ) && notifier != "" )
            {
                level notify( notifier );
                coop_print_base_find_or_fortify_fire_trap( notifier, me );
                if( isdefined( level.tr ) )
                {
                    //level.tr delete();
                }
                if( isdefined( i_m ) )
                {
                    i_m delete();
                }
                wait 0.05;
                break;
            }
        }
    }
}

playlocal_plrsound()
{
    self endon( "disconnect" );
    self playsound( level.mysounds[ 12 ] );
    wait 0.05;
    self playsound( level.mysounds[ 8 ] );
    wait 0.6;
    self playsound( level.mysounds[ 9 ] );
}

playloop_electricsound()
{
    level endon( "end_game" );
    while( true )
    {
        PlaySoundAtPosition( level.mysounds[ 1 ], level.gas_pour_location );
        wait 5;
    }
}


do_everything_for_gas_pickup()
{
    level endon( "end_game" );

    gas_trig = spawn( "trigger_radius_use", level.gas_canister_pick_location, 0, 24, 24 );
    gas_trig setcursorhint( "HINT_NOICON" );
    gas_trig sethintstring( "^9[ ^3[{+activate}] ^8to pick up ^3Gasoline ^9]" );
    gas_trig triggerignoreteam();
    wait 0.05;
    inv_mod_fx = spawn( "script_model", gas_trig.origin + ( 0, -40, 65) );
    inv_mod_fx setmodel( "tag_origin" );
    inv_mod_fx.angles = ( 0,0,0 );
    wait 1;
    playfxontag( level.myFx[ 2 ], inv_mod_fx, "tag_origin" );

    cans = spawn( "script_model", gas_trig.origin + ( 0, -20, 3 ) );
    cans setmodel( level.x_models[ 71 ] );
    cans.angles = cans.angles;
    wait 0.05;
    playfxontag( level.myfx[ 44 ], cans, "tag_origin" );
    cans vibrate( cans.angles[ 1 ] + 10, 30, 10, 9999 );
    level thread do_everything_for_gas_placedown();

    while( true )
    {
        gas_trig sethintstring( "^9[ ^3[{+activate}] ^8to pick up ^9Gasoline ^9]" );
        gas_trig waittill( "trigger", presser );
        if( isplayer( presser ) && is_player_valid( presser ) )
        {
            gas_trig sethintstring( "" );
            level thread playlocal_plrsound();
            level.gas_has_been_picked = true;
            //presser freezeControls( true );
            presser playSound( "zmb_sq_navcard_success" );
            //presser.has_picked_up_g = false;
            current_w = presser getCurrentWeapon();
            presser giveWeapon( "zombie_builder_zm" );
            presser switchToWeapon( "zombie_builder_zm" );
            cans delete();
            waiter = 3;
            wait waiter;
            presser maps\mp\zombies\_zm_weapons::switch_back_primary_weapon( current_w );
            presser takeWeapon( "zombie_builder_zm" );
            presser.has_picked_up_g = true;
            level notify( "gas_got_picked" );
            level.gas_been_picked_up = true;
            level.gas_is_the_trigger = true;
            coop_print_base_find_or_fortify_fire_trap( "gas_got_picked", presser );
            gas_trig delete();
            inv_mod_fx delete();
            level notify( "someone_picked_up_gas_to_bypass_check" );
            break;
        }
    }
}

animate_fire_pickup( here )
{
    level endon( "end_game" );
    origin = here + ( 0, 50, 60 );
    nade = spawn( "script_model", origin );
    nade setmodel( level.myModels[ 75 ] );
    nade.angles = (0,0,0);

    wait 0.05;
    playfxontag( level.myfx[ 1 ], nade, "tag_origin" );
    nade movex( 20, 0.2, 0, 0 );
    nade waittill( "movedone" );
    nade movex( -50, 0.2, 0, 0 );
    nade waittill( "movedone" );
    nade movez( 20, 0.2, 0, 0 );
    wait 0.1;
    playfx( level.myfx[ 9  ], nade.origin );
    wait 0.1;
    nade delete();
}
do_everything_for_gas_placedown()
{
    level endon( "end_game" );
    //double waittill?? do we trigger it twice before spawning a new trigger or am I drunk as fuck
    //check tomorrow
    
    level waittill( "gas_got_picked" );
    level waittill( "gas_got_picked" );
    level waittill( "dontgopastthis" );
    //global_gas_quest_trigger_spawner( location, text1, text2, fx1, fx2, notifier )
    level thread global_gas_quest_trigger_spawner( level.gas_pour_location, "Hold ^3[{+activate}] ^8to pour gasoline on the floor.", "Floor is now littered with ^3Gasoline", level.myfx[ 75 ], level.myfx[ 76 ], "littered_floor" );
    level waittill( "littered_floor" ); 
    temp = spawn( "trigger_radius_use", level.gas_pour_location, 0, 48, 48 );
    temp setCursorHint( "HINT_NOICON" );
    temp setHintString( "^9[ ^8Workbench requires ^3Fire Crackers ^9]" );
    temp triggerignoreteam();

    level thread global_gas_quest_trigger_spawner( level.gas_fire_pick_location + ( 0, 0, 60 ), "^9[ ^3[{+activate}]^8 to dig up ^3Fire Crackers ^9]", "", "", "", "fire_picking" );
    level waittill( "fire_picking" );

    level thread animate_fire_pickup( );

    if( isdefined( temp ) )
    {
        temp delete();
    }
    level thread global_gas_quest_trigger_spawner( level.gas_fire_place_location, "^9[ ^3[{+activate}]^8 to add ^3Fire Crackers^8 to the fire trap ^9]", "^9[ ^8Fire Trap has been built ^9]", level.myfx[ 75 ], level.myfx[ 76 ], "firetrap_active" );
    level waittill( "firetrap_active" );
    
    fxs = 12;
    starting = 0;
    while( fxs > starting )
    {
        if( starting < 4 )
        {
            s = 2;
            x = 0;
            if( randomInt( 4 ) < 2 )
            {
                playfx( level.myfx[ 75 ],level.gas_fireplaces[ starting ] );
            }
            else { playfx( level.myfx[ 76 ],level.gas_fireplaces[ starting ] ); }
            wait 0.08;
        }
        if( starting >= 4 && starting < 8 )
        {
            playfx( level.myfx[ 44 ], level.gas_fireplaces[ starting ] );
            wait 0.15;
        }


        playfx( level.myfx[ 78 ], level.gas_fireplaces[ starting ] );
        wait 0.1;

        if( starting >= 10 )
        {
            playfx( level.myfx[ 80 ], level.gas_fireplaces[ starting ] );
            PlaySoundAtPosition( level.mysounds[ 12 ], level.gas_fireplaces[ starting ] );
            wait 0.05;
            playsoundatposition( level.mysounds[ 7 ], level.gas_fireplaces[ starting ] );
        }
        starting++;
    }
    level thread playloop_electricsound();
    level notify( "base_firetrap_active" );

    level thread monitor_zombies();
}

monitor_zombies()
{
    level endon( "end_game" );
    spawn_shitter = spawn( "script_model", level.gas_fireplaces[ 1 ] );
    spawn_shitter setmodel( "tag_origin" );
    spawn_shitter.angles = ( 0, 0, 0 );
    wait 1;
    while( true )
    {
        som = getAIArray( level.zombie_team );
        
        //loop kills zombies
        for( s = 0; s < som.size; s++ )
        {
            if( distance( som[ s ].origin, spawn_shitter.origin ) < 150 )
            {
                wait 0.1;
                som[ s ] dodamage( som[ s ].health + 50, som[ s ].origin );
            }
        }

        //loop damages players that are close enough
        for( s = 0; s < level.players.size; s++ )
        {
            if( distance( level.players[ s ].origin, spawn_shitter.origin ) < 50 )
            {
                level.players[ s ] dodamage( 50, level.players[ s ].origin );
            }
        }
        wait .5;   
    }
}
spawn_workbench_to_build_fire_trap_entrance()
{
    level endon( "end_game" );
    wait 7;
    org = ( 8038.65, -5349.47, 264.125 );
    build_firetrap_table = spawn( "script_model", level.gas_pour_location );
    build_firetrap_table setmodel( level.myModels[ 6 ] );
    build_firetrap_table.angles = ( 0, -142.748, 0 );

    build_firetrap_table_clip = spawn( "script_model", org );
    build_firetrap_table_clip setmodel( "collision_geo_64x64x64_standard" );
    build_firetrap_table_clip.angles = (  0, -142.748, 0 );

    head_org = ( 7991.02, -5270.24, 304.92 );
    new_loc_for_s_peep = org + ( 0, 0, 50 );
    build_firetrap_table_clip_head = spawn( "script_model", new_loc_for_s_peep );
    build_firetrap_table_clip_head setmodel( "tag_origin" );
    build_firetrap_table_clip_head.angles = ( 0, 0, 0 );

    wait 0.1;
    playFXOnTag( level.myfx[ 2 ], build_firetrap_table_clip_head, "tag_origin" );
    wait 0.05;
    playfxontag( level.myfx[ 75 ], build_firetrap_table_clip, "tag_origin" );
    build_firetrap_table_clip_head thread spin_and_move_table_headf();
    
}

spin_and_move_table_headf()
{
    level endon( "end_game" );
    while( true )
    {
        self movez( 25, 0.8, 0.2, 0.2 );
        self rotateyaw( 360, 0.8, 0.2, 0.2 );
        self waittill( "movedone" );
        self movez( -25, 0.8, 0.2, 0.2 );
        self rotateyaw( 360, 0.5, 0.2, 0.2 );
        self waittill( "movedone" );
    }
}