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

main()
{
    //replacefunc( ::is_player_in_fog, ::is_player_in_fog_new );
	//replacefunc( maps\mp\zm_transit_art::main, ::mainer );
}

init()
{
	level.tweakfile = 1;
    flag_wait( "initial_blackscreen_passed" );
    //iprintlnbold( "LOL" );
    //level thread ss();
	
	//level thread mainer();
    //level thread test_fogger();
}


mainer()
{
	level endon( "end_game" );
	lol1();
	while( true )
	{
		wait 5;
		iprintlnbold( "NEW FOGGG" );
		lol2();
		wait 5;
		iprintlnbold( "NEW FOGGG" );
		lol1();
	}
}

lol1()
{
	level.tweakfile = 1;
    setdvar( "scr_fog_exp_halfplane", "6339.219" );
    setdvar( "scr_fog_exp_halfheight", "18691.3" );
    setdvar( "scr_fog_nearplane", "1238.679" );
    setdvar( "scr_fog_red", "1" );
    setdvar( "scr_fog_green", "0" );
    setdvar( "scr_fog_blue", "1" );
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
    fog_r = 1;
    fog_g = 0;
    fog_b = 1;
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
    max_fog_opacity = 0.46;
    setvolfog( start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale, sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, sun_stop_ang, time, max_fog_opacity );
    visionsetnaked( "zm_transit", 0 );
    setdvar( "r_lightGridEnableTweaks", 1 );
    setdvar( "r_lightGridIntensity", 1.4 );
    setdvar( "r_lightGridContrast", 0.2 );
}

lol2()
{
	level.tweakfile = 1;
    setdvar( "scr_fog_exp_halfplane", "233" );
    setdvar( "scr_fog_exp_halfheight", "1456" );
    setdvar( "scr_fog_nearplane", "356" );
    setdvar( "scr_fog_red", "0" );
    setdvar( "scr_fog_green", "1" );
    setdvar( "scr_fog_blue", "0" );
    setdvar( "scr_fog_baseheight", "-456" );
    setdvar( "visionstore_glowTweakEnable", "1" );
    setdvar( "visionstore_glowTweakRadius0", "5" );
    setdvar( "visionstore_glowTweakRadius1", "" );
    setdvar( "visionstore_glowTweakBloomCutoff", "0.5" );
    setdvar( "visionstore_glowTweakBloomDesaturation", "0" );
    setdvar( "visionstore_glowTweakBloomIntensity0", "1" );
    setdvar( "visionstore_glowTweakBloomIntensity1", "" );
    setdvar( "visionstore_glowTweakSkyBleedIntensity0", "" );
    setdvar( "visionstore_glowTweakSkyBleedIntensity1", "" );
    start_dist = 342.679;
    half_dist = 1011.62;
    half_height = 10834.5;
    base_height = 1145.21;
    fog_r = 0.501961;
    fog_g = 0.501961;
    fog_b = 0.501961;
    fog_scale = 1;
    sun_col_r = 0;
    sun_col_g = 1;
    sun_col_b = 0.5;
    sun_dir_x = 45;
    sun_dir_y = 120;
    sun_dir_z = -0.11;
    sun_start_ang = 0;
    sun_stop_ang = 0;
    time = 0;
    max_fog_opacity = 0.2;
    setvolfog( start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale, sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, sun_stop_ang, time, max_fog_opacity );
    visionsetnaked( "zm_transit", 0 );
    setdvar( "r_lightGridEnableTweaks", 1 );
    setdvar( "r_lightGridIntensity", 1.4 );
    setdvar( "r_lightGridContrast", 0.2 );
}
test_fogger()
{
	while( true )
	{
		level.tweakfile = 1;
		setdvar( "scr_fog_exp_halfplane", "700.62" );
		setdvar( "scr_fog_exp_halfheight", "1000.5" );
		setdvar( "scr_fog_nearplane", "28.679" );
		setdvar( "scr_fog_red", "0" );
		setdvar( "scr_fog_green", "1" );
		setdvar( "scr_fog_blue", "0" );
		setdvar( "scr_fog_baseheight", "-500" );
		setdvar( "visionstore_glowTweakEnable", "1" );
		setdvar( "visionstore_glowTweakRadius0", "5" );
		setdvar( "visionstore_glowTweakRadius1", "" );
		setdvar( "visionstore_glowTweakBloomCutoff", "0.5" );
		setdvar( "visionstore_glowTweakBloomDesaturation", "0" );
		setdvar( "visionstore_glowTweakBloomIntensity0", "1" );
		setdvar( "visionstore_glowTweakBloomIntensity1", "" );
		setdvar( "visionstore_glowTweakSkyBleedIntensity0", "" );
		setdvar( "visionstore_glowTweakSkyBleedIntensity1", "" );
		start_dist = 28.679;
		half_dist = 700.62;
		half_height = 1000.5;
		base_height = -84708.1;
		fog_r = 0;
		fog_g = 0.9;
		fog_b = 0;
		fog_scale = 7.5834;
		sun_col_r = 0;
		sun_col_g = 0;
		sun_col_b = 0;
		sun_dir_x = -0.45;
		sun_dir_y = 0.6;
		sun_dir_z = -0.11;
		sun_start_ang = 0;
		sun_stop_ang = 0;
		time = 1;
		max_fog_opacity = 0;
		setvolfog( start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale, sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, sun_stop_ang, time, max_fog_opacity );
		visionsetnaked( "zm_transit", 0 );
		setdvar( "r_lightGridEnableTweaks", 1 );
		setdvar( "r_lightGridIntensity", 1.4 );
		setdvar( "r_lightGridContrast", 0.2 );

		wait 3;
	}
}
	
is_player_in_fog_new( player )
{
    iprintln( "PLAYER IS IN FOG BUT WE CHEAT THE SYSTEM" );
    if ( player_entered_safety_zone( player ) )
        return false;

    if ( player_entered_safety_light( player ) )
        return false;

    curr_zone = player get_current_zone( 1 );

    if ( isdefined( curr_zone ) && !( isdefined( curr_zone.screecher_zone ) && curr_zone.screecher_zone ) )
        return false;

    return false;
}

ss()
{
    infog = is_player_in_fog_new( level.players[ 0 ] );
    player = level.players[0];
    while( true )
    {
        player thread [[ level.set_player_in_fog ]]( infog );
        wait 0.5;
    }
}