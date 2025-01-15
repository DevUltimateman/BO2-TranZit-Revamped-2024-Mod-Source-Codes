//this script is responsible for the tranzit 2.0 v2 "Fire Bootz" sidequest logic
//small sidequest for players to complete in the map
//upon completing the quest, players can pick up fireboots and avoid lava damage in the map while standing in lava

#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zombies\_zm_unitrigger;
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
#include maps\mp\zombies\_zm_perks;
#include maps\mp\_visionset_mgr;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\gametypes_zm\_hud;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zm_alcatraz_grief_cellblock;
#include maps\mp\zm_alcatraz_weap_quest;
#include maps\mp\zombies\_zm_weap_tomahawk;
#include maps\mp\zombies\_zm_weap_blundersplat;
#include maps\mp\zombies\_zm_magicbox_prison;
#include maps\mp\zm_prison_ffotd;
#include maps\mp\zm_prison_fx;
#include maps\mp\zm_alcatraz_gamemodes;
#include maps\mp\gametypes\_hud_message;
#include maps\mp\ombies\_zm_stats;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zm_transit_sq;
#include maps\mp\zm_transit_distance_tracking;
#include maps\mp\zm_alcatraz_utility;
#include maps\mp\zombies\_zm_afterlife;
#include maps\mp\zm_prison;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\gametypes_zm\_spawnlogic;
#include maps\mp\animscripts\traverse\shared;
#include maps\mp\animscripts\utility;
#include maps\mp\_createfx;
#include maps\mp\_music;
#include maps\mp\_script_gen;
#include maps\mp\_busing;
#include maps\mp\gametypes_zm\_globallogic_audio;
#include maps\mp\gametypes_zm\_tweakables;
#include maps\mp\_challenges;
#include maps\mp\gametypes_zm\_weapons;
#include maps\mp\_demo;
#include maps\mp\gametypes_zm\_globallogic_utils;
#include maps\mp\gametypes_zm\_spectating;
#include maps\mp\gametypes_zm\_globallogic_spawn;
#include maps\mp\gametypes_zm\_globallogic_ui;
#include maps\mp\gametypes_zm\_hostmigration;
#include maps\mp\gametypes_zm\_globallogic_score;
#include maps\mp\gametypes_zm\_globallogic;
#include maps\mp\zombies\_zm_ai_faller;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_pers_upgrades_functions;
#include maps\mp\zombies\_zm_pers_upgrades;
#include maps\mp\zombies\_zm_score;
#include maps\mp\animscripts\zm_run;
#include maps\mp\animscripts\zm_death;
#include maps\mp\zombies\_zm_blockers;
#include maps\p\animscripts\zm_shared;
#include maps\mp\animscripts\zm_utility;
#include maps\mp\zombies\_zm_power;
#include maps\mp\zombies\_zm_server_throttle;
#include maps\mp\zombies\_zm_melee_weapon;
#include maps\mp\zombies\_zm_audio_announcer;
#include maps\mp\zombies\_zm_perk_electric_cherry;
#include maps\mp\zm_transit;
#include maps\mp\createart\zm_transit_art;
#include maps\mp\createfx\zm_transit_fx;
#include maps\mp\zombies\_zm_ai_dogs;
#include codescripts\character;
#include maps\mp\zombies\_zm_game_module;
#include maps\mp\zm_transit_buildables;
#include maps\mp\zombies\_zm_magicbox_lock;
#include maps\mp\zombies\_zm_ffotd;
#include maps\mp\zm_transit_lava;


init()
{
    level.c_points = [];
    level.c_angles = [];
    level.rift_step_active = false;
    level.turbine_to_rift_treshold = 270; //distance in units
    level._malfunction_complete = false; //just a check at power off stage
    level.repaired_rifts = 0; //actually amount of fixed lamps for rift portal
    level.repaired_rifts_to_do = undefined;
    level.core_fx_move_to_spots = [];

    level.first_time_doing_ride = false;

    //check
    level.rift_camera_town = [];
    level.rift_camera_town_angles = [];

    //check
    level.rift_camera_bepo = [];
    level.rift_camera_bepo_angles = [];

    //check
    level.rift_camera_diner = [];
    level.rift_camera_diner_angles = [];

    //check
    level.rift_camera_corn = [];
    level.rift_camera_corn_angles = [];

    //check
    level.rift_camera_farm = [];
    level.rift_camera_farm_angles = [];
    
    //check
    level.rift_camera_pstation = [];
    level.rift_camera__pstation_angles = [];

    //these spots are above the reactor
    level.core_fx_move_to_spots[ 0 ] = ( 12567.9, 7314.66, -558.17 );
    level.core_fx_move_to_spots[ 1 ] = ( 12429.8, 7773.18, -675.528 );
    level.core_fx_move_to_spots[ 2 ] = ( 11860.2, 7827.12, -517.097 );
    level.core_fx_move_to_spots[ 3 ] = ( 12029.9, 7473.48, -682.232 );
    level.core_fx_move_to_spots[ 4 ] = ( 12577.8, 7305.51, -586.626 );

    //these spots are underneath the reactor
    level.core_fx_move_to_spots[ 5 ] = ( 12463.6, 7714.85, -1143.62 );
    level.core_fx_move_to_spots[ 6 ] = ( 11903.4, 7643.2, -1532.72 );
    level.core_fx_move_to_spots[ 7 ] = ( 11999, 7425.26, -1103.36 );
    level.core_fx_move_to_spots[ 8 ] = ( 12513.9, 7372.31, -1296.85 );


    level.access_panel_org = ( 12702.5, 7629.84, -755.875 ); // other playable sfx at brkoen comp step
    
    
    //these are  needed when we set up players cameras to get sucked by rift
    level.initial_rift_loop_locations = [];
    level.initial_rift_loop_locations[ 0 ] = ( 12472.5, 7936.19, -741.053 );
    level.initial_rift_loop_locations[ 1 ] = ( 12111.1, 8012.86, -684.853 );
    level.initial_rift_loop_locations[ 2 ] = ( 11777.6, 7756.22, -580.667 );
    level.initial_rift_loop_locations[ 3 ] = ( 11848, 7369.15, -776.511 );
    level.initial_rift_loop_locations[ 4 ] = ( 12187.6, 7390.46, -851.503 );
    level.initial_rift_loop_locations[ 5 ] = ( 12659.3, 7483.28, -712.102 );




    level.initial_rift_loop_locations_angles[ 0 ] = ( 0, 152.899, 0 );
    level.initial_rift_loop_locations_angles[ 1 ] = ( 0, -173, 0 );
    level.initial_rift_loop_locations_angles[ 2 ] = ( 0, -66.34442, 0 );
    level.initial_rift_loop_locations_angles[ 3 ] = ( 0, 3.2102, 0 );
    level.initial_rift_loop_locations_angles[ 4 ] = ( 0, -9.12193, 0 );
    level.initial_rift_loop_locations_angles[ 5 ] = ( 0, 77.5547, 0  );
    all_sky_camera_locations();
    //for each player
    level.initial_rift_core_loop_camera_obj = [];

    level.global_looping_in_progress = false;
    //origins for all lamps that need fixing
    all_fixable_spots();
    flag_wait( "initial_blackscreen_passed" ); 

    level thread start_fix_lamp_logic(); //lamp fix and all logic starts from here
    level thread make_light_hinters(); //sparking light hints for each lamp post to draw players attention towards spots
    
    level thread test_turn_off_lamps();
    //level thread playerss();

    wait 5;
    level thread setup_all_rift_use_setup();

    //level.players[ 0 ] thread do_rift_ride( level.rift_camera_diner, level.rift_camera_diner_angles, level.players[ 0 ] );
    //level thread tell_fog();

    //works. need to make it lot better tho.
    //level thread camera_points_debug();

    //debugs the camera motion
    
    //level thread spawn_rift_computer();//for debugging 

    //for the new sky box we might wanna use different values
    //skytransition true
    //skyrotation 250
    //skybleed = 1 or 0.8 for day light sky
    level thread monitor_dev();

    
}

monitor_dev()
{
    level endon( "end_game" );
    while( true )
    {
        if( level.players[ 0 ] usebuttonpressed() && level.players[ 0 ] adsButtonPressed() )
        {
            //level thread playerss();
            break;
        }
        wait 0.05;
    }
}
playerss_ride()
{
    level endon( "end_game" );
    //flag_wait( "initial_blackscreen_passed" ); //enable back after debug
    
    wait 1;

    level thread playloopsound_buried(); //enable back after debug
    level thread level_tell_about_rifts(); //enable back after debug
    level waittill( "do_it" ); //enable back after debug
    
    wait 2;
    foreach( p in level.players )
    {
        p thread flash_me_now();
    }
    wait 2.1;
    level thread wait_to_print_unlock_rift( 8 );
    for( i = 0; i < level.players.size; i++ )
    {
        level.players[ i ] thread do_rift_ride( level.rift_camera_diner, level.rift_camera_diner_angles, level.players[ i ] );
        wait 3;
    }
    level notify( "can_do_spirit_now" ); //enable back after debug
    level notify( "stop_mus_load_bur" );
}

wait_to_print_unlock_rift( wait_time )
{
    level endon( "end_game" );
    wait wait_time;
    PlaySoundAtPosition(level.jsn_snd_lst[ 30 ], level.players[ 0 ].origin );
    PlaySoundAtPosition( "mus_zombie_round_over", level.players[ 0 ].origin );
    level thread scripts\zm\zm_transit\warmer_days_sq_rewards::print_text_middle( "^9Rift Portals ^8Unlocked", "^8Survivors can now teleport around ^9Ravenholm^8 via rift rides.", "^8Each lamp has a different landing destination assigned to it.", 6, 0.25 );
}
flash_me_now()
{
	level endon( "end_game" );
	self endon( "disconnect" );
	self setclientdvar( "r_exposuretweak", true );
	for( i = 0; i < 4; i++ )
	{
		
		self setclientdvar( "r_exposurevalue", 2.8 );
		wait 0.08;
		self setclientdvar( "r_exposurevalue", 1.8 );
		wait 0.1;
		self setclientdvar( "r_exposurevalue", 2.5 );
		wait 0.05;
		self setclientdvar( "r_exposurevalue", .8 );
		wait 0.07;
		self setclientdvar( "r_exposurevalue", 2.8 );
		wait 0.1;
		self setclientdvar( "r_exposurevalue", .4 );
		wait 0.05;
		self setclientdvar( "r_exposurevalue", 3 );
		wait 0.1;
	}
	self setclientdvar( "r_exposuretweak", false );
}
level_tell_about_rifts()
{
    level endon( "end_game" );
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says( "^9Dr. Schruder^8: " + "Did you see that???", "^8The rift tried to grab you!", 6, 0.25 );
    wait 10;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says( "^9Dr. Schruder^8: " + "It will certainly try it again in a bit..", "^8Think you should get ready!", 5, 0.25 );
    wait 10;
    level notify( "do_it" );
    level notify( "stop_mus_load_bur" );
}

tell_fog()
{
    level endon( "end_game" );
    while( true )
    {
        iprintln( "level fog currently: ^9level.current_fog = ^3" + level.current_fog );
        wait 1;
    }
}

spawn_initial_rift_camera_points()
{
    level endon( "end_game" );

    earthquake( 0.25, 10, level.initial_rift_loop_locations[ 0 ], 1050 );
    for( i = 0; i < level.players.size; i++ )
    {
        
        playfxontag( level.myfx[ 82 ], level.players[ i ], "tag_origin" );

        level.players[ i ] playsound( level.jsn_snd_lst[ 32 ] );
        level.players[ i ] setMoveSpeedScale( 0.2 );
        for( i = 0; i < 3; i++ )
        {
            level.players[ i ] playsound( level.jsn_snd_lst[ 34 ] );
            wait 0.08;
            PlaySoundAtPosition( level.jsn_snd_lst[ 42 ], level.players[ i ].origin );
            wait 0.05;
        }
    }
    wait randomFloat( 0.4 );
    PlaySoundAtPosition( level.jsn_snd_lst[ 89 ], level.initial_rift_loop_locations[ 0 ] );

    wait 1;
    level.global_looping_in_progress = true;
    wait 0.05;
    level thread keep_players_on_loop_timer();
    level thread fade_to_black_on_impact();
    for( s = 0; s < level.players.size; s++ )
    {
       level.players[ s ] thread do_stuff_for_rift_grab();
   
    }
    wait 5.8;
    level notify( "do_first_rift_walk" );
    level thread fade_to_black_on_impact();
    wait 2;
    
    
}

do_stuff_for_rift_grab()
{
    self endon( "disconnect" );
    level endon( "end_game" );
    wait 0.05;
        
    self setclientdvar( "r_poisonfx_debug_enable", true );
    wait 1;
    self setMoveSpeedScale( 1 );
    self freezeControls(true);
    wait 0.05;
    org = spawn( "script_model", self geteye() );
    org setmodel( "tag_origin" );
    org.angles = self.angles;
    wait 0.05;
    playfxontag( level.myfx[ 1 ], org, "tag_origin" );
    playfx( level.myfx[ 82 ], self.origin );
    self playsound( level.jsn_snd_lst[ 30 ] );
    self enableInvulnerability();
    self camerasetposition( org );
    self camerasetlookat();
    self cameraactivate( 1 );
    self disableWeapons();
    self freezeControls(true);
    self hide();
    self.ignoreme = true;
    wait 0.05;
    org thread attachToLoop();// pass the camera index so we know which to loop
    wait 6;
    self playsound( level.jsn_snd_lst[ 30 ] );
    
    self CameraSetPosition( self.origin );
    self CameraActivate( false );
    self camerasetlookat();
    self show();
    self playsound( level.jsn_snd_lst[ 32 ] );
    self setMoveSpeedScale( 1 );
    wait 0.05;
    self enableWeapons();
    self freezeControls(false);
    self setMoveSpeedScale( 1 );
    self setMoveSpeedScale( 1 );
    for( s = 0; s < 32; s++ )
    {
        self enableInvulnerability();
        self.ignoreme = true;
        wait 0.25;
    }
    wait 2.5;
    self disableInvulnerability(); 
    self.ignoreme = false;
        
}

level_bring_back_normal_visuals_and_stuff()
{
    level notify( "stop_avogadro_shit" );
    level.zombie_total = undefined;
    for( i = 0; i < level.players.size; i++ )
    {
        level.players[ i ] CameraSetPosition( level.players[ i ].origin );
        level.players[ i ] CameraActivate( false );
        level.players[ i ] show();
        level.players[ i ] playsound( level.jsn_snd_lst[ 32 ] );
        level.players[ i ] setMoveSpeedScale( 1 );
        level.players[ i ] thread tranzit_2024_visuals();
    }
}

tranzit_2024_visuals()
{
    self setclientdvar( "r_filmusetweaks", true );
    self setclientdvar( "r_bloomtweaks", 1  );
    self setclientdvar( "cg_usecolorcontrol", 1 );
    self setclientdvar( "r_fog", 0  );
    self setclientdvar( "sm_sunsamplesizenear", 1.4  );
    self setclientdvar( "wind_global_vector", ( 200, 250, 50 )  );
    self setclientdvar( "vc_fsm", "1 1 1 1" );    
    self setclientdvar( "cg_colorscale", "1 1 1"  );
    self setclientdvar( "r_lodbiasrigid", -1000  );
    self setclientdvar( "r_lodbiasskinned", -1000 );
    self setclientdvar( "r_dof_bias", 0.5 );
    self setclientdvar( "r_dof_enable", true );
    self setclientdvar( "r_dof_tweak", true  );
    self setclientdvar( "r_dof_viewmodelStart", 2 );
    self setclientdvar( "r_dof_viewmodelend", 2.4 );
    self setclientdvar( "r_dof_farblur", 1.25 );
    self setclientdvar(  "r_dof_farStart", 3000 );
    self setclientdvar(  "r_dof_farend", 7000 );
    self setclientdvar(  "r_dof_nearstart", 10 );
    self setclientdvar(  "r_dof_nearend", 15 );
    self setclientdvar(  "r_sky_intensity_factor0", 2.4 );
    self setclientdvar(  "r_sky_intensity_factor1", 2.4 );
    self setclientdvar(  "r_skyColorTemp", 2000 );
    self setclientdvar(  "r_skyRotation", 125 );
    self setclientdvar(  "r_skyTransition", true );
    self setclientdvar( "cg_drawcrosshair", 0 );
    self setclientdvar( "cg_cursorhints", 2 );
    self setclientdvar( "vc_yl", "0 0 0 0" );
    self setclientdvar( "vc_yh", "0 0 0 0" );
    self setclientdvar( "cg_fov", 85 );
    self setclientdvar( "cg_fovscale", 1.15 );
    self setclientdvar( "r_lighttweaksunlight", 12 );
    self setclientdvar( "r_lighttweaksuncolor", ( 0.62, 0.52, 0.46) );
    self setclientdvar( "r_lighttweaksundirection", ( -155, 63, 0 ) );

    self setclientdvar( "vc_rgbh", "0.3 0.2 0.2 0" );
   self setclientdvar( "vc_rgbl", "0.1 0.05 0.05 0" );
}





prepare_gump_models( set_models_from, wait_before )
{
    self endon( "disconnect" );

    wait wait_before;
    
    self setOrigin( set_models_from + ( 0, 0, 90 ) );

    self.origin = set_models_from + ( 0, 0, 90 );

}


loop_hovering_sound()
{
    self endon( "stop_lp" );
    
    self playloopsound( "zmb_screecher_portal_loop", 2 );
    wait 1;
    self playLoopSound( "zmb_screecher_portal_loop", 2 );
    wait 0.1;
    self playLoopSound( "zmb_screecher_portal_loop", 2 );
    self waittill( "stop_lp" );
    wait 0.2;
    self stopLoopSound();
    
}
do_rift_ride( sudo, sudo_angles, real_player  )
{
    level endon( "end_game" );
    real_player thread flash_me_now();
    real_player playSound( "zmb_farm_portal_warp_2d" ); 
    real_player thread loop_hovering_sound();
    real_player setclientdvar( "r_poisonfx_debug_enable", true );
    //scary qiuiet zm nuked ending song
    //"mus_zombie_game_over" good song for upgrade notify or something plays tranzit end song
    //mus_zmb_secret_song works, carry on kevin sher
    //"mus_load_zm_transit_dr" works
    //"mus_load_zm_nuked_patch"  works
    wait 0.05;
    s = 0;
    real_player.ignoreme = true;
    real_player enableInvulnerability();
    real_player disableWeapons();
    real_player freezeControls(true);
    real_player.ignoreme = true;
    load_gump_from = sudo[ sudo.size ];
    real_player.origin = sudo[ sudo.size ];
    real_player setorigin( sudo[ sudo.size ] );

    rider = spawn( "script_model", sudo[ 0 ] );
    rider setmodel( "tag_origin" );
    rider.angles = sudo_angles[ 0 ];

    wait 0.05;
    rider thread loop_hovering_sound();
    camera_lookat_model = spawn( "script_model", sudo[ sudo.size -1 ] );
    camera_lookat_model setmodel( "tag_origin" );
    camera_lookat_model.angles = ( 0, 0, 0 );

    playfxontag( level.myfx[ 1 ], rider, "tag_origin" );
    real_player CameraSetPosition( rider, rider.angles );
    real_player CameraActivate( true );

    real_player setclientdvar( "r_fog", false );
    
    real_player thread do_rider_visuals();
    wait 0.05;
    
    temp_orbs = [];
    for( i = 0; i < 4; i++ )
    {
        temp_orbs[ i ] = spawn( "script_model", rider.origin );
        temp_orbs[ i ] setmodel( "tag_origin" );
        temp_orbs[ i ].angles = ( 0, 0, 0 );
        wait 0.05;
        playfxontag( level.myfx[ 1 ], temp_orbs[ i ], "tag_origin" );
        temp_orbs[ i ] thread locate_to_goal_on_own( sudo );
    }
    real_player CameraSetLookAt();
    real_player hide();
    real_player enableInvulnerability();
    
    for( s = 0; s < level.sky_camera_tower_location.size; s++ )
    {
        if( s == level.sky_camera_tower_location.size )
        {
            PlaySoundAtPosition(level.jsn_snd_lst[ 29 ], rider.origin );
            rider moveto( level.sky_camera_tower_location[ s ], 2, 1.5, 0 );
            rider rotateto( level.sky_camera_tower_location_angles[ s ], 2, 1, .25 );
            wait 2;
        }
        else 
        {
            PlaySoundAtPosition(level.jsn_snd_lst[ 29 ], rider.origin );
            rider moveto( level.sky_camera_tower_location[ s ], .75, 0, 0 );
            rider rotateto( level.sky_camera_tower_location_angles[ s ], .75, 0, .25 );
            wait .75;
        }
        PlaySoundAtPosition(level.jsn_snd_lst[ 27 ], rider.origin );
        
    }
    //rider thread self_rotate_yaw();
    
    
    speed = 580;
    safe_loc = sudo[ 1 ];



    target_point = sudo[ 0 ];
    target_angles = sudo_angles[ 0 ];
    
    
    real_player.origin = safe_loc + ( 0, 0, 20 );
    real_player setorigin( safe_loc + ( 0, 0, 20 ) );
        
    
    dist = distance( rider.origin, target_point ) / 2;
    time = dist / speed;
    q_time = time * 0.25;
    if ( q_time > 1 )
        q_time = 1;
    //time = 1;
    //safe offset +90 Z
    PlaySoundAtPosition(level.jsn_snd_lst[ 27 ], rider.origin );
    level thread riding_fx_snd( rider );
    
    rider moveto( target_point + ( 0, 0, 100 ), time, 0, 0 );
    rider rotateTo( target_angles, time, 0, 0.25 );
    wait time;
    s++;
    target_point_new = sudo[ 1 ];
    target_angles_new = sudo_angles[ 1 ];

    dist = distance( rider.origin, target_point_new ) / 2;
    time = dist / speed;
    q_time = time * 0.25;
    if ( q_time > 1 )
        q_time = 1;

    rider moveto( target_point_new, time, 0, .25 );
    //rider rotateto( target_angles_new, 1, 0.3, 0.2 );
    rider rotateyaw( 360, time, 0.25, 0.25 );
    wait time;
    real_player CameraActivate( false );
    //real_player CameraSetPosition( real_player, real_player.angles );
    real_player.origin = rider.origin + ( 0, 0, 40 );
    real_player setOrigin( rider.origin + ( 0, 0, 40 ) );
    
    wait 0.05;
    //rider.angles = sudo_angles[ s ];
    real_player setPlayerAngles( rider.angles );
    real_player.angles = sudo_angles[ sudo_angles.size ];
    real_player.angles =  rider.angles;
    real_player CameraSetPosition( real_player, rider.angles );
    wait 0.05;
    real_player enableWeapons();
    real_player freezeControls(false);
    real_player setclientdvar( "r_fog", false );
    real_player setclientdvar( "r_poisonfx_debug_enable", false );
    real_player show();
    real_player notify( "ride_over" );
    rider notify( "stop_lp" );
    wait 0.1;
    rider delete();
    
    real_player.ignoreme = false;
    camera_lookat_model delete();
    wait 2.5;
    real_player disableInvulnerability();
}

riding_fx_snd( where )
{
    level endon( "end_game" );
    for( i = 0; i < 24; i++ )
    {
        playfx( level._effects[70], where.origin );
        wait 0.05;
    }
    wait 1.5;
    for( s = 0; s < 14; s++ )
    {
        playfx( level._effects[ 70 ], where.origin );
        wait randomfloatrange( 0.1, 0.35 );
    }
    wait 2;
    while( isdefined( where ) ) 
    {
        playfx( level._effects[ 70 ], where.origin );
        wait randomfloatrange( 0.05, 0.35 );
    }
}
self_rotate_yaw()
{
    level endon( "end_game" );
    level endon( "stop_rotating_this" );
    while( isdefined( self ) )
    {
        self rotateyaw( 360, 4.5, 0, 0 );
        wait 4.5;
    }
}
locate_to_goal_on_own( sudo )
{   
    x = 0;
    while( x < sudo.size )
    {
        speed = 350;
        target_point = sudo[ x ];
        dist = distance( self.origin, target_point );
        time = dist / speed;
        q_time = time * 0.25;
        if ( q_time > 3 )
            q_time = 3;
        //time = 1;
        //safe offset +90 Z
        self moveto( target_point + ( randomintrange( -210, 210), randomintrange( -210, 210), randomintrange( -210, 210) ), time, 0, 0 );
        wait time;
        PlaySoundAtPosition( level.mysounds[ 8 ], self.origin );
        x++;
    }
    wait 1;
    if( isdefined( self ) )
    {
        self delete();
    }
}
do_rider_visuals()
{
    self endon( "disconnect" );
    self setclientdvar( "r_fog", true );
    self setclientdvar( "cg_colorhue", 150 );
    self setclientdvar( "r_exposuretweak", true );
    self setclientdvar( "r_exposurevalue", 4.5 );
    self waittill( "ride_over" );
    self setclientdvar( "r_fog", false );
    self setclientdvar( "cg_colorhue", 0 );
    self setclientdvar( "r_exposuretweak", false );

}


new_do_summoning_animation( real_player, cam_loc, cam_ang, which_lamp )
{
    ground_origin = self.origin;
    elevate_origin = ground_origin + ( 0, 0, 120 );
    
    //diner
    //int_cam
    //tag_cam

    int_cam = ( -3959.79, -7270.67, 64.9125 );
    int_cam_angles = ( 0, 26.6467, 0 );
    tag_cam = ( -4172.44, -7347.67, -62.899 );
    tag_cam_angles = ( 0, 22.362, 0 );
    last_loc = undefined;
    /* 
    // ALL POSSIBLE RIDE TARGETS
    level.rift_camera_town
    level.rift_camera_pstation
    level.rift_camera_bepo
    level.rift_camera_diner
    level.rift_camera_corn

    //LAMP BUS DEPO -->             CORNFIELD LANDING
    //LAMP DINER -->                POWER STATION LANDING
    //LAMP DINER FOREST -->         BUS DEPO LANDING
    //LAMP CORNFIELD -->            TOWN LANDING
    //LAMP CORNFIELD TO POWER -->   BUS DEPO LANDING
    //LAMP POWER STATION -->        DINER LANDING
    //LAMP POWER TO TOWN -->        BUS DEPO LANDING
    //LAMP AFTER BRIDGE -->         CORNFIELD LANDING
    do_rift_ride( sudo, sudo_angles, real_player  )
    */
    switch( which_lamp )
    {
        case "3p_diner_cam":
            int_cam = ( -3959.79, -7270.67, 64.9125 );
            int_cam_angles = ( 0, 26.6467, 0 );
            tag_cam = ( -4172.44, -7347.67, -62.899 );
            tag_cam_angles = ( 0, 22.362, 0 );
            ride_path = cam_loc;
            ride_angles = cam_ang;
            last_loc = cam_loc[ cam_loc.size ];
            break;

        case "3p_depo_cam":
            int_cam = ( -6345.48, 4557.82, 39.8997 );
            int_cam_angles = ( 0, 128.628, 39.8997 );
            tag_cam = ( -6092.08, 4435.41, -86.852 );
            tag_cam_angles = ( 0, 139.774, 0 );
            ride_path = cam_loc;
            ride_angles = cam_ang;
            last_loc = cam_loc[ cam_loc.size ];
            break;

        case "3p_bridge_cam":
            int_cam = ( -4403.42, -611.41, 121.119 );
            int_cam_angles = ( 0, -132.407, 0 );
            tag_cam = ( -4224.5, -417.632, -40.6571 );
            tag_cam_angles = ( 0, -131.632, 0 );
            ride_path = cam_loc;
            ride_angles = cam_ang;
            last_loc = cam_loc[ cam_loc.size ];
            break;

        case "3p_town_cam":
            int_cam = ( -620.785, -589.074, 58.7679 );
            int_cam_angles = ( 0, -115.074, 0 );
            tag_cam = ( -499.97, -391.066, -95.1842 );
            tag_cam_angles = ( 0, -118.066, 0 );
            ride_path = cam_loc;
            ride_angles = cam_ang;
            last_loc = cam_loc[ cam_loc.size ];
            break;

        case "3p_cabin_cam":
            int_cam = ( 6300.21, 5100.45, 3.35658 );
            int_cam_angles = ( 0, -88.8682, 0 );
            tag_cam = ( 6367.86, 5387.7, -148.319 );
            tag_cam_angles = ( 0, -115.082, 0 );
            ride_path = cam_loc;
            ride_angles = cam_ang;
            last_loc = cam_loc[ cam_loc.size ];
            break;

        case "3p_corn_off_cam":
            int_cam = ( 8150.26, 4803.07, -259.528 );
            int_cam_angles = ( 0, -122.717, 0 );
            tag_cam = ( 8340.19, 4916.78, -409.016 );
            tag_cam_angles = ( 0, -128.084, 0 );
            ride_path = cam_loc;
            ride_angles = cam_ang;
            last_loc = cam_loc[ cam_loc.size ];
            break;


        /*
        case "3p_corn_cam":
            int_cam = ( 10147.6, -1720.6, -111.971 );
            int_cam_angles = ( 0, -91.3017, 0 );
            tag_cam = ( 10270, -1555.53, -253.924 );
            tag_cam_angles = ( 0, -137.796, 0 );
            ride_path = cam_loc;
            ride_path = cam_ang;
            last_loc = cam_loc[ cam_loc.size ];
            break;
        */
        case "3p_short_cam":
            int_cam = ( -68.2999, -5450.4, 28.0531 );
            int_cam_angles = ( 0, -4.25701, 0 );
            tag_cam = ( -229.188, -5490.72, -79.9476 );
            tag_cam_angles = ( 0, 29.0755, 0 );
            ride_path = cam_loc;
            ride_angles = cam_ang;
            last_loc = cam_loc[ cam_loc.size ];
            break;


        case "3p_corn_cam": //cornfield cam
            int_cam = ( 10147.6, -1720.6, -111.971 );
            int_cam_angles = ( 0, -91.3017, 0 );
            tag_cam = ( 10270, -1555.53, -253.924 );
            tag_cam_angles = ( 0, -137.796, 0 );
            ride_path = cam_loc;
            ride_angles = cam_ang;
            last_loc = cam_loc[ cam_loc.size ];
            break;
    }
    
    wait 0.05;

    const_wait = 2;
    //real_player thread moveup();
    playfx( level._effect[ "avogadro_ascend_aerial" ], real_player.origin );
    wait 0.5;
    //playfx( level._effect[ "avogadro_ascend_aerial" ], origin_to_reach );
    real_player enableInvulnerability( );
    real_player freezeControls( true );
    cam = spawn( "script_model", int_cam );
    cam setmodel( "tag_origin" );
    cam.anlges = int_cam_angles;
    real_player thread play_crows();

    wait 0.05;

    real_player CameraSetPosition( cam, cam.angles );
    real_player CameraSetLookAt( int_cam );
    real_player CameraActivate( true );

    tag_cam = tag_cam + ( 0, 0, 90 );
    cam moveto( tag_cam, 2, 0.5, 1 );
    cam rotateto( tag_cam_angles, 2, 0.5, 1 );
    wait 2;
    PlaySoundAtPosition("vox_zmba_sam_event_magicbox_0", cam.origin );
    real_player thread fade_to_black_on_impact_self_only();
    real_player.ignoreme = true;
    //do rift_spawning now 
    level thread do_rift_ride( ride_path, ride_angles, real_player );
    wait 1;
    cam delete();




}

moveup()
{
    xx = 0;
    origin_z = self.origin;
    origin_to_reach = origin_z + (0, 0, 80 );
    playfx( level._effect[ "avogadro_ascend_aerial" ], origin_to_reach );
    wait 0.5;
    playfx( level._effect[ "avogadro_ascend_aerial" ], origin_to_reach );
    self notify( "ready_for_rift_traversal" );
}
all_sky_camera_locations()
{

    level.sky_camera_location = [];
    level.sky_camera_location_angles = [];
    //initial teleport ( players shoot up inside of the tower of babble tower)
    level.sky_camera_tower_location = [];
    level.sky_camera_tower_location_angles = [];
    level.sky_camera_tower_location[ 0 ] = ( 7646.74, -470.402, 97.9369 );
    level.sky_camera_tower_location_angles[ 0 ] = ( 90, 90.6, 0 );
    level.sky_camera_tower_location[ 1 ] = ( 7646.74, -470.402, 340.938 );
    level.sky_camera_tower_location_angles[ 1 ] = ( 90, 90.6, 0 );
    level.sky_camera_tower_location[ 2 ] = ( 7646.74, -470.402, 610.401 );
    level.sky_camera_tower_location_angles[ 2 ] = ( 90, 90.6, 0 );
    level.sky_camera_tower_location[ 3 ] = ( 7646.74, -470.402, 917.295 );
    level.sky_camera_tower_location_angles[ 3 ] = ( 90, 90.6, 0 );
    level.sky_camera_tower_location[ 4 ] = ( 7646.74, -470.402, 1234.61 );
    level.sky_camera_tower_location_angles[ 4 ] = ( 90, 90.6, 0 );
    level.sky_camera_tower_location[ 5 ] = (  7646.74, -470.402, 3509.49 );
    level.sky_camera_tower_location_angles[ 5 ] = ( 90, 90.6, 0 );

    level.rift_camera_farm[ 0 ] = ( 7513.67, -8749.33, -16.2606 );
    level.rift_camera_farm_angles[ 0 ] = ( 0, 76, 0 );
    /*
    level.rift_camera_farm[ 1 ] = ( 7381.19, -7371.64, 327.608 );
    level.rift_camera_farm_angles[ 1 ] = ( -10, 87, 0 );
    level.rift_camera_farm[ 2 ] = ( 7530.42, -6199.58, 189.101 );
    level.rift_camera_farm_angles[ 2 ] = ( 0, 54, 0 );
    level.rift_camera_farm[ 3 ] = ( 8021.48, -5861.67, 111.669 );
    level.rift_camera_farm_angles[ 3 ] = ( 0, -90, 0 );
    level.rift_camera_farm[ 4 ] = ( 8393.52, -6084.79, 248.827 );
    level.rift_camera_farm_angles[ 4 ] = ( 0, -159, 0 );
    */
    level.rift_camera_farm[ 1 ] = ( 8728.97, -6408.69, 112.125 );
    level.rift_camera_farm_angles[ 1 ] = ( 0, 164, 0 );

    //all zombie camera fly by locations for rift portals
    //level.rift_camera_bepo
    //level.rift_camera_diner
    //level.rift_camera_farm
    //level.rift_camera_corn
    //level.rift_camera_pstation
    //level.rift_camera_town
    //normal ride
    //max difference and should also be around minimum difference beteween locations
    // to make the ride "smoother"
    //720, 760, 710
    level.rift_camera_corn[ 0 ] = ( 7411.7, -565.146, 967.805 );
    level.rift_camera_corn_angles[ 0 ] = ( 90, -48, 0 );
    /*
    level.rift_camera_corn[ 1 ] = ( 7847.56, -1203.34, 172.407 );
    level.rift_camera_corn_angles[ 1 ] = ( 45, -26, 0 );
    level.rift_camera_corn[ 2 ] = ( 9032.97, -1399.6, -163.185 );
    level.rift_camera_corn_angles[ 2 ] = ( 0, 3, 0 );
    level.rift_camera_corn[ 3 ] = ( 10785.6, -890.145, 92.9127 );
    level.rift_camera_corn_angles[ 3 ] = ( 25, 11, 0 );
    level.rift_camera_corn[ 4 ] = ( 12288.3, -926.831, 378.931 );
    level.rift_camera_corn_angles[ 4 ] = ( 80, 10, 0 );
    level.rift_camera_corn[ 5 ] = ( 13142.8, -548.021, -119.894 );
    level.rift_camera_corn_angles[ 5 ] = ( 30, 36, 0 );
    level.rift_camera_corn[ 6 ] = ( 13913.4, -295.204, -163.974 );
    level.rift_camera_corn_angles[ 6 ] = ( 0, 9, 0 );
    */
    level.rift_camera_corn[ 1 ] = ( 14023.7, -277.411, -179.399 );
    level.rift_camera_corn_angles[ 1 ] = ( 0, -165, 0 );

    level.rift_camera_diner[ 0 ] = ( -3016.38, -6001.13, 110.185 );
    level.rift_camera_diner_angles[ 0 ] = ( 0, -140, 0 );
    /*
    level.rift_camera_diner[ 1 ] = ( -3883.11, -6716.41, 26.8011 );
    level.rift_camera_diner_angles[ 1 ] = ( 0, -147, 0 );
    level.rift_camera_diner[ 2 ] = ( -4709.33, -7071.71, 139.79 );
    level.rift_camera_diner_angles[ 2 ] = ( 0, -165, 0 );
    level.rift_camera_diner[ 3 ] = ( -5603.88, -6752.83, -37.0558 );
    level.rift_camera_diner_angles[ 3 ] = ( 0, 136, 0 );
    level.rift_camera_diner[ 4 ] = ( -5972.19, -5896.91, -6.90376 );
    level.rift_camera_diner_angles[ 4 ] = ( 0, 109, 0 );
    level.rift_camera_diner[ 5 ] = ( -6126.05, -5604.38, 89.6978 );
    level.rift_camera_diner_angles[ 5 ] = ( 0, 115, 0 );
    */
    level.rift_camera_diner[1 ] = ( -6229.22, -5538.28, -28.0143 );
    level.rift_camera_diner_angles[ 1] = ( 0, -63, 0 );

    level.rift_camera_bepo[ 0 ] = ( -5006.1, 3178.58, 435.471);
    level.rift_camera_bepo_angles[ 0 ] = ( 0, 129, 0 );
    /*
    level.rift_camera_bepo[ 1 ] = ( -5373.97, 3711.45, 329.286 );
    level.rift_camera_bepo_angles[ 1 ] = ( 0, 132, 0 );
    level.rift_camera_bepo[ 2 ] = ( -6283.11, 4535.83, 3.03169 );
    level.rift_camera_bepo_angles[ 2 ] = ( 0, 151, 0 );
    level.rift_camera_bepo[ 3 ] = ( -6771.9, 4866.25, -44.4342 );
    level.rift_camera_bepo_angles[ 3 ] = ( 0, 121, 0 );
    level.rift_camera_bepo[ 4 ] = ( -6986.44, 5285.48, 26.1513 );
    level.rift_camera_bepo_angles[ 4 ] = ( 0, 128, 0 );
    */
    level.rift_camera_bepo[ 1] = ( -7122.85, 5451.4, -49.751 );
    level.rift_camera_bepo_angles[1 ] = ( 0, -45, 0 );

    level.rift_camera_town[ 0 ] = ( 1793.47, 1000.2, 165.142 );
    level.rift_camera_town_angles[ 0 ] = ( 0, -118, 0 );
    /*
    level.rift_camera_town[ 1 ] = ( 1450.35, -13.8936, 11.4322);
    level.rift_camera_town_angles[ 1 ] = ( 0, -102, 0 );
    level.rift_camera_town[ 2 ] = ( 1395.62, -1328.94, 211.589 );
    level.rift_camera_town_angles[ 2 ] = ( 20, -74, 0);
    level.rift_camera_town[ 3 ] = ( 1704.81, -1856.14, 122.428 );
    level.rift_camera_town_angles[ 3 ] = ( 15, 113, 0 );
    */
    level.rift_camera_town[ 1 ] = ( 1683.26, -1739.04, 36.401 );
    level.rift_camera_town_angles[1 ] = ( 0, 105, 0 );

    level.rift_camera_pstation[ 0 ] = ( 11638.1, 6156.6, -216.086 );
    level.rift_camera_pstation_angles[ 0 ] = ( 0, 115, 0 );
    /*
    level.rift_camera_pstation[ 1 ] = ( 11100.6, 6915.07, -139.991 );
    level.rift_camera_pstation_angles[ 1 ] = ( 0, 118, 0 );
    level.rift_camera_pstation[ 2 ] = ( 10966.3, 7618.43, -478.13 );
    level.rift_camera_pstation_angles[ 2 ] = ( 0, 65, 0 );
    level.rift_camera_pstation[ 3 ] = ( 11135.9, 8015.49, -479.178 );
    level.rift_camera_pstation_angles[ 3 ] = ( 0, 50, 0 );
    */
    level.rift_camera_pstation[ 1 ] = ( 11405.9, 8120.31, -525.913 );
    level.rift_camera_pstation_angles[1 ] = ( 0, -130, 0 );

    //ORDER

    //level.rift_camera_bepo v
    //level.rift_camera_diner v v
    //level.rift_camera_farm v v
    //level.rift_camera_corn v
    //level.rift_camera_pstation v
    //level.rift_camera_town v

    //LAMP DEPO             >                       FARM LANDING
    //LAMP DINER            >                       PSTATION LANDING
    //LAMP DINER AFTER      >                       BEPO LANDING
    //LAMP CORNFIELD        >                       TOWN LANDING
    //LAMP CORNFIELD AFTER  >                       DINER LANDING
    //LAMP CABIN            >                       DINER LANDING
    //TOWN LAMP             >                       FARM LANDING
    //BRIDGE LAMP           >                       CORNFIELD LANDING
}

fade_to_black_on_impact_self_only()
{
    level endon( "end_game" );
    
    self thread fadeForAWhile( 0, 3.4, 0.55, 0.5, "black" );
    self playsound( level.jsn_snd_lst[ 29 ] );
    wait 5;
    self playsound( level.mysounds[ 7 ] );
    playfx( level.myFx[ 87 ], self.origin );
    self show();
    self freezeControls( false );
    //self setclientdvar( "r_poisonfx_debug_enable", false );
}
fade_to_black_on_impact()
{
    level endon( "end_game" );
    foreach( play in level.players )
    {
        play thread fadeForAWhile( 3, 1, 0.25, 0.5, "black" );
        play playsound( level.jsn_snd_lst[ 29 ] );
        
    }
    wait 1;
    
    foreach( p in level.players )
    {
        p playsound( level.mysounds[ 7 ] );
        p show();
        p freezeControls( false );
        p setclientdvar( "r_poisonfx_debug_enable", false );
    }

    wait 4;

}

keep_players_on_loop_timer()
{
    level endon( "end_game" );
    wait randomintrange( 5, 8 );
    level.global_looping_in_progress = false;
    
}
attachtoloop()
{
    //self endon( "disconnect" );
    level endon( "end_game" );
    //angles = ( 0, -91.2141, 0 );
    // rotateto( level.core_rift_top.origin + ( 0, 160, -120 ), 0.3, 0, 0 );
    wait 0.1;
    self moveto(  level.core_rift_top.origin, 5, 2, 0.1 );
    self rotateto( level.core_rift_top.origin, 5, 2.1, 0 );
    wait 5;
    playfx( level.myfx[ 82 ], self.origin );    
}

camera_points_debug()
{
    level endon( "end_game" );
    level.c_points[ 0 ] = ( -6036.62, 4744.56, 233.066 );
    level.c_points[ 1 ] = ( -7464.92, 4988.43, 448.485 );
    level.c_points[ 2 ] = ( -8589.35, 4598.88, 89.8688 );
    level.c_points[ 3 ] = ( -7542.27, 3740.62, 1056.29 );
    level.c_points[ 4 ] = ( -6208.71, 4471.33, 40.4502 );


    level.c_angles[ 0 ] = ( 90, 180, 25  );
    level.c_angles[ 1 ] = ( -185, 0, 188 );
    level.c_angles[ 2 ] = ( 0, -120, 90 );
    level.c_angles[ 3 ] = ( -59, 254, 2 );
    level.c_angles[ 4 ] = ( 58, -142, 30 );

    
        org = spawn( "script_model", level.c_points[ 0 ] );
        org setmodel( "tag_origin" );
        org.angles = level.c_angles[ 0 ];
    

    wait 5;
    iprintlnbold( "LETS TEST THIS FUCKERY CAMERA SHIII" );
    for( s = 0; s < level.players.size; s++ )
    {
        level.players[ s ] CameraSetPosition( org );
        level.players[ s ] CameraSetLookAt();
        level.players[ s ] cameraactivate( 1 );
    }

    speed = 20;

    i = 1;
    while( i < level.c_points.size )
    {
        org moveto( level.c_points[ i ], 3, 0, 0 );
        org rotateTo( level.c_points[ i ], 3, 1, 1 );
        i++;
        wait 3;
    }
    level.players[ 0 ] camerasetposition( level.players[ 0 ].origin );
    level.players[ 0 ] cameraactivate( 0 );



}


start_fix_lamp_logic()
{
    level thread all_fixable_spots_spawn_fixer_logic();
}


all_fixable_spots()
{
    //where we spawn triggers
    level.fixable_spots = [];

    level.fixable_spots[ 0 ]  = ( 6285.55, 5085.74, -108.38 ); //between forest and town
    level.fixable_spots[ 1 ]  = ( 8130.54, 4785.03, -365.242 ); //between corn and power
    level.fixable_spots[ 2 ]  = ( -48.3219, -5441.79, -75.5432 ); //between diner and farm
    level.fixable_spots[ 3 ]  = ( -6342.48, 4583.03, -63.875 ); //bus depot
    level.fixable_spots[ 4 ]  = ( -4419.78, -615.827, 20.285 ); //next to bridge when going town to depo
    level.fixable_spots[ 5 ]  = ( 10155, -1750.18, -220.092 ); //cornfields
    level.fixable_spots[ 6 ]  = ( -3960.01, -7251.38, -63.875 ); //diner lamp, next to turbine door shack
    level.fixable_spots[ 7 ] = ( -623.205, -642.809, -55.6223 ); //town to bridge 
}

LowerMessage( ref, text )
{
	if( !IsDefined( level.zombie_hints ) )
    {
        level.zombie_hints = [];
    }
	PrecacheString( text );
	level.zombie_hints[ ref ] = text;
}

setLowerMessage( ent, default_ref )
{
	if( IsDefined( ent.script_hint ) )
    {
        self SetHintString( get_zombie_hint( ent.script_hint ) );
    }	
	else
    {
        self SetHintString( get_zombie_hint( default_ref ) );
    }
		
}

initialize_all_rift_rides( which_spot )
{
    //ORDER

    //LAMP BUS DEPO -->             CORNFIELD LANDING
    //LAMP DINER -->                POWER STATION LANDING
    //LAMP DINER FOREST -->         BUS DEPO LANDING
    //LAMP CORNFIELD -->            TOWN LANDING
    //LAMP CORNFIELD TO POWER -->   BUS DEPO LANDING
    //LAMP POWER STATION -->        DINER LANDING
    //LAMP POWER TO TOWN -->        BUS DEPO LANDING
    //LAMP AFTER BRIDGE -->         CORNFIELD LANDING

    /* 
    // ALL POSSIBLE RIDE TARGETS
    level.rift_camera_town
    level.rift_camera_pstation
    level.rift_camera_bepo
    level.rift_camera_diner
    level.rift_camera_corn
    do_rift_ride( sudo, sudo_angles, real_player  )
    */
}

call_summoning_on_player_logic( ride_loc, ride_ang, which_lamp )
{
    level endon( "end_game" );
    old_hintstring = self.hintstring;
    while( isdefined( self ) )
    {
        self waittill( "trigger", player_to_summon );
        if( isdefined( level.rifts_disabled_for_while ) && level.rifts_disabled_for_while == true )
        {
            wait 1;
            continue;
        }
        wait 0.1;
        earthquake( 0.25, 10, self.origin, 1050 );
        level thread new_do_summoning_animation( player_to_summon, ride_loc, ride_ang, which_lamp );
        //self thread xdfx(); //why is this here? maybe causing some fucking
        player_to_summon thread xdfx();
        self.hintstring = "^6Summoning in progress!";
        //earthquake here
        //spawn summoning portal model here
        //move player up here
        wait 5;
        self.hintstring = old_hintstring;

    }
}

xdfx()
{
    s = spawn( "script_model", self.origin );
    s setmodel( "tag_origin" );
    s.angles = ( 0, 0, 0 );
    wait 0.1;
    playFXOnTag( level.myfx[ 48 ], s, "tag_origin" );
    wait 0.1;
    playFXOnTag( level.myfx[ 48 ], s, "tag_origin" );
    wait 0.05;
    playFXOnTag( level.myfx[ 48 ], s, "tag_origin" );
    wait 0.08;
    playFXOnTag( level.myfx[ 48 ], s, "tag_origin" );
    wait 1;
    s delete();
    
    
}

setup_all_rift_use_setup()
{
    for( i = 0; i < level.fixable_spots.size; i++ )
    {
        level thread spawn_callable_rift_ride( level.fixable_spots[ i ], i );
        wait 0.1;
    }
}
//CRASHES ON LAMP BEFORE PSTATION,
//CHECK IF GLOBAL OR JUST THAT LAMP'S ISSUE
//WE ALSO DO TELEPORT INSTANTLY AFTER 3PERSON VIEW
//FIX THE FLY IN TOO
spawn_callable_rift_ride( where, index )
{
    level endon( "end_game" );
    
    //ORDER
    //level.rift_camera_bepo v
    //level.rift_camera_diner v v
    //level.rift_camera_farm v v
    //level.rift_camera_corn v
    //level.rift_camera_pstation v
    //level.rift_camera_town v

    //LAMP DEPO             >                       FARM LANDING
    //LAMP DINER            >                       PSTATION LANDING
    //LAMP DINER AFTER      >                       BEPO LANDING
    //LAMP CORNFIELD        >                       TOWN LANDING
    //LAMP CORNFIELD AFTER  >                       DINER LANDING
    //LAMP CABIN            >                       DINER LANDING
    //TOWN LAMP             >                       FARM LANDING
    //BRIDGE LAMP           >                       CORNFIELD LANDING

    //index is based on "level.fixable_spots[ index ]
    if( index == 0 ) //cabin woods lamp, LANDING = DINER CAMERA
    {
        land_loc = "Mikey's Diner";
        trig_ = spawn( "trigger_radius_use", where, 1, 24, 24 );
        trig_ setHintString( "");
        trig_ setCursorHint( "HINT_NOICON" );
        trig_ TriggerIgnoreTeam();
        wait 0.1;
        level waittill( "can_do_spirit_now" );
        trig_ setHintString( "^9[ ^3[{+activate}] ^8to teleport yourself to: ^9" + land_loc + " ^9]");
        level thread spawn_on_trig_( trig_ );
        trig_ thread call_summoning_on_player_logic( level.rift_camera_diner, level.rift_camera_diner_angles, "3p_cabin_cam" );
    }
        
    if( index == 1 ) //corn to power lamp, LANDING = DINER CAMERA
    {
        land_loc = "Mikey's Diner";
        trig_ = spawn( "trigger_radius_use", where, 1, 24, 24 );
        trig_ setHintString( "");
        
        trig_ setCursorHint( "HINT_NOICON" );
        trig_ TriggerIgnoreTeam();
        wait 0.1;
        level waittill( "can_do_spirit_now" );
        trig_ setHintString( "^9[ ^3[{+activate}] ^8to teleport yourself to: ^9" + land_loc + " ^9]");
        level thread spawn_on_trig_( trig_ );
        trig_ thread call_summoning_on_player_logic( level.rift_camera_diner, level.rift_camera_diner_angles, "3p_corn_off_cam" );
    }
    
    if( index == 2 ) //diner forest lamp, LANDING = BUS DEPOT CAMERA
    {
        land_loc = "Stalinburgh's Bus Depot";
        trig_ = spawn( "trigger_radius_use", where, 1, 24, 24 );
        trig_ setHintString( "");
        
        trig_ setCursorHint( "HINT_NOICON" );
        trig_ TriggerIgnoreTeam();
        wait 0.1;
        level waittill( "can_do_spirit_now" );
        trig_ setHintString( "^9[ ^3[{+activate}] ^8to teleport yourself to: ^9" + land_loc + " ^9]");
        level thread spawn_on_trig_( trig_ );
        trig_ thread call_summoning_on_player_logic( level.rift_camera_bepo, level.rift_camera_bepo_angles, "3p_short_cam" );
    }
    
    if( index == 3 ) //bus depo lamp, LANDING = FARM CAMERA
    {
        land_loc = "Denny's Happy Cow Farm";
        trig_ = spawn( "trigger_radius_use", where, 1, 24, 24 );
        trig_ setHintString( "");
        
        trig_ setCursorHint( "HINT_NOICON" );
        trig_ TriggerIgnoreTeam();
        wait 0.1;
        level waittill( "can_do_spirit_now" );
        trig_ setHintString( "^9[ ^3[{+activate}] ^8to teleport yourself to: ^9" + land_loc + " ^9]");
        level thread spawn_on_trig_( trig_ );
        trig_ thread call_summoning_on_player_logic( level.rift_camera_farm, level.rift_camera_farm_angles, "3p_depo_cam" );
    }
     
    if( index == 4 ) //bridge lamp, LANDING = CORNFIELD
    {
        land_loc = "Lost Fields";
        trig_ = spawn( "trigger_radius_use", where, 1, 24, 24 );
        trig_ setHintString( "");
        
        trig_ setCursorHint( "HINT_NOICON" );
        trig_ TriggerIgnoreTeam();
        wait 0.1;
        level waittill( "can_do_spirit_now" );
        trig_ setHintString("^9[ ^3[{+activate}] ^8to teleport yourself to: ^9" + land_loc + " ^9]");
        level thread spawn_on_trig_( trig_ );
        trig_ thread call_summoning_on_player_logic( level.rift_camera_corn, level.rift_camera_corn_angles, "3p_bridge_cam" );
    }

   
    if( index == 5 ) //cornfield lamp, LANDING = TOWN
    {
        land_loc = "Dr. Ravenholm's Townhall";
        trig_ = spawn( "trigger_radius_use", where, 1, 24, 24 );
        trig_ setHintString( "");
        trig_ setCursorHint( "HINT_NOICON" );
        trig_ TriggerIgnoreTeam();
        wait 0.1;
        level waittill( "can_do_spirit_now" );
        trig_ setHintString("^9[ ^3[{+activate}] ^8to teleport yourself to: ^9" + land_loc + " ^9]");
        level thread spawn_on_trig_( trig_ );
        trig_ thread call_summoning_on_player_logic( level.rift_camera_town, level.rift_camera_town_angles, "3p_corn_cam" );
    }

    if( index == 6 ) //diner lamp, LANDING = PSTATION
    {
        land_loc = "Stalinburgh's Power Station";
        trig_ = spawn( "trigger_radius_use", where, 1, 24, 24 );
        trig_ setHintString( "");
        trig_ setCursorHint( "HINT_NOICON" );
        trig_ TriggerIgnoreTeam();
        wait 0.1;
        level waittill( "can_do_spirit_now" );
        trig_ setHintString("^9[ ^3[{+activate}] ^8to teleport yourself to: ^9" + land_loc + " ^9]");
        level thread spawn_on_trig_( trig_ );
        trig_ thread call_summoning_on_player_logic( level.rift_camera_pstation, level.rift_camera_pstation_angles, "3p_diner_cam"  );
    }
    
    if( index == 7 ) //town lamp, LANDING = FARM 
    {
        land_loc = "Denny's Happy Cow Farm";
        trig_ = spawn( "trigger_radius_use", where, 1, 24, 24 );
        trig_ setHintString( "");
        
        trig_ setCursorHint( "HINT_NOICON" );
        trig_ TriggerIgnoreTeam();
        wait 0.1;
        level waittill( "can_do_spirit_now" );
        trig_ setHintString("^9[ ^3[{+activate}] ^8to teleport yourself to: ^9" + land_loc + " ^9]");
        level thread spawn_on_trig_( trig_ );
        trig_ thread call_summoning_on_player_logic( level.rift_camera_farm, level.rift_camera_farm_angles, "3p_town_cam" );
    }
    
}

spawn_on_trig_( trig_ )
{
    mods = spawn( "script_model", trig_.origin + ( 0, 0, 125 ) );
    mods setmodel( "tag_origin" );
    mods.angles = mods.angles;
    wait 0.05;
    playfxontag( level.myFx[ 44 ], mods, "tag_origin" );
}
initialize_rift_ride_for_caller( who_called, which_target )
{
    self endon( "disconnect" );
    level endon( "end_game" );
}
all_fixable_spots_spawn_fixer_logic() //is in use 
{
    level endon( "end_game" );
    level waittill( "s_talks_navcard" );
    level.rift_step_active = true;
    size = 0; 
    for( sizer = 0; sizer < level.fixable_spots.size; sizer++ )
    {
        fix_trig = spawn( "trigger_radius", level.fixable_spots[ sizer ], 0, 48, 48 );
        fix_trig setCursorHint( "HINT_NOICON" );
        wait 0.05;
        fix_trig setHintString( "^9[ ^8Try fixing the lamp ^9]" );
        wait 0.05;
        fix_trig_available_fx = spawn( "script_model", level.fixable_spots[ sizer ] + ( 0, 0, -30 ) );
        fix_trig_available_fx setmodel( "tag_origin" );
        fix_trig_available_fx.angles = ( 0,0,0 );
        wait 0.05;
        fix_trig_available_fx thread monitor_everything( fix_trig, sizer );
    }
    //dont spawn the rift computer at power station till all lamps are fixed
    level thread keep_track_of_repair_amount(); 
}

make_light_hinters()
{
    level endon( "end_game" );
    initial_hinters = getstructarray( "screecher_escape", "targetname" );
    level.light_hinters = [];
    for( i = 0; i < initial_hinters.size; i++ )
    {
        //invisible models that we check distance against in another function.
        //remove the fxs cos engine cant handle the load but leave the tags
        level.light_hinters[ i ] = spawn( "script_model", initial_hinters[ i ].origin + ( 0, 0, 148 ) );
        level.light_hinters[ i ] setmodel( "tag_origin" );
        level.light_hinters[ i ].angles = ( 0, 0, 0 );
        wait 0.05;  
        wait 0.13;
        if( level.dev_time ) { iprintlnbold( "SPAWNED A LIGHT HINTER AT: " + level.light_hinters[ i ] ); }
    }
}
monitor_everything( trigger_to_monitor, fixable_spot_integer ) //in use now
{
    level endon( "end_game" );
    while( true )
    {
        for( close_ps = 0; close_ps < level.players.size; close_ps++ )
        {
            //bypass remainng threas from for loop for checked player if not in reach
            if( !level.players[ close_ps ] istouching( trigger_to_monitor ) ) { wait 0.05; continue; }
            //player is close enough one of the tag_origin models
            if( level.players[ close_ps ] isTouching( trigger_to_monitor ) )
            {
                //player is in reach but either dont have the turbine placed or dont own one.
                if( !isdefined( level.players[ close_ps ].buildableturbine ) ) { wait 0.05; continue; }
                //player is in reach and turbine's origin is inside of the treshold from lamp org
                if( distance2d( level.players[ close_ps ].buildableturbine.origin, trigger_to_monitor.origin ) < level.turbine_to_rift_treshold )
                {
                    //turbine is in reach of the tag_origin.
                    //now check which screecher_escape light is nearest
                    possible_light_locs = getstructarray( "screecher_escape", "targetname" );
                    for( locs = 0; locs < possible_light_locs.size; locs++ )
                    {
                        //is this player within 150 units from said screecher light?
                        if( distance2d( level.players[ close_ps ].origin, possible_light_locs[ locs ].origin ) < 150 )
                        {
                            wait 1; //wait a second to not instantly notify that its fixed.
                            if( level.dev_time ) { iprintlnbold( "WE JUST REPAIRED A LAMP!!!!"); }
                            trigger_to_monitor setHintString( "^9[ ^8Lamp got fixed ^9]" );
                            wait 1.5;
                            level thread just_in_case_apply( locs );
                            
                            trigger_to_monitor delete(); //delete the trigger_radius trigger
                            wait 0.1;
                            self thread rise_bulb_underneath( locs, fixable_spot_integer );  //self = script_model, locs = index number of screecher_zone array
                            break;
                        }
                    }
                    wait 0.05;
                }
                wait 0.05;
            }
            wait 0.05;
        }
        wait 0.05;
    }
}
//MAKE SURE THAT THIS HAS THE LAMPS NOT ENABLED TILL S_NAVCARD_TALKS NOTIFY
//CHECK TOMORROW THAT ALL IS WELL AND PUSH THE UPDATE OUT.
rise_bulb_underneath( value_at, fixable_integer ) //in use now
{
    level endon( "end_game" );
    
    target_light = getstructarray( "screecher_escape", "targetname" );

    //level notify( "start_thread_" + );
    //do the "initial rise"
    
    self moveto( target_light[ value_at ].origin, 2, 0.4, 0 );
    self waittill( "movedone" );
    playFXOnTag( level.myFx[ 19 ], self, "tag_origin" );
    wait 0.1;
    playfxontag( level.myFx[ 21 ], self, "tag_origin" );
    switch( fixable_integer ) //offsets based on location.
    {
        case 0: //forest to town
            self movez( 140, 1.5, 0, 0.4 );
            break;
        case 1: //corn to pstation
            self movez( 160, 1.5, 0, 0.4 );
            break;
        case 2: //diner to farm
            self movez( 158, 1.5, 0, 0.4 );
            break;
        case 3: //bdepot
            self movez( 146, 1.5, 0, 0.4 );
            break;
        case 4: //bridge to bdepot
            self movez( 138, 1.5, 0, 0.4 );
            break;
        case 6: //diner pdoor
            self movez( 146, 1.5, 0, 0.4 );
            break;
        case 5: //
            self movez( 146, 1.5, 0, 0.4 );
            break;
        case 7: //town to bridge
            self movez( 142, 1.5, 0, 0.4 );
            break;
        default:
            self movez( 148, 1.5, 0, 0.4 );
            break;
    }
    //self movez( 148, 1.5, 0, 0.4 );
    self waittill( "movedone" );
    level thread check_which_light_needs_changing( self ); 
    //playLoopedFX( level.myfx[ 96 ], 1.2, self.origin );
    
    playfx( level._effect[ "fx_zmb_tranzit_light_safety_ric" ], self.origin, 0, -90 ); // good
    wait 0.05;
    playfx( level.myFx[ 95 ], self.origin );
    //playfx( level. _effect[ "fx_zmb_tranzit_light_safety_max" ], self.origin, 0, -90 );  //good but doesnt have green light
   //playfx( level._effect[ "fx_zmb_tranzit_light_safety" ], self.origin, -50, -90 ); //boring basic light, this might need to be deleted from gsc and csc to not load in upon power turn on
    //playfx( level._effect[ "fx_zmb_tranzit_light_safety_off" ], self.origin, 0, -90 ); //just a basic light usually not on. this is before u turn power on
    self playLoopSound(  level.jsn_snd_lst[ 32 ] ); //these are "scary whispers", see if spawning multiple of em makes it a bit louder..
    wait 0.05;
    self playLoopSound(  level.jsn_snd_lst[ 32 ] );
    wait 0.1;
    self playLoopSound(  level.jsn_snd_lst[ 32 ] );
    level.repaired_rifts++;
    

}

test_turn_off_lamps()
{
    level endon( "end_game" );
    //level waittill( "power_on" );
    //wait 10;
    //iprintlnbold( "DOING THIS SHIT SHIT SHIT "); 
    //for( i = 0; i < level.players.size; i++ )
    //{
    //    level.players[ i ] setclientfield( "screecher_sq_lights", 0 );
    //    level.players[ i ] setclientfield( "sq_tower_sparks", 1 );
   // }
    
}
check_which_light_needs_changing( location_of_light )
{
    level endon( "end_game" );
    for( i = 0; i < level.light_hinters.size; i++ )
    {
        if( distance2d( location_of_light.origin, level.light_hinters[ i ].origin ) < 250 )
        {
            if( level.dev_time ){ iprintlnbold( "WE JUST REMOVED THE LIGHT HINT FROM: ^9" + level.light_hinters[ i ].origin ); }
            PlaySoundAtPosition( level.jsn_snd_lst[ 36 ], location_of_light.origin );
            wait 0.05;
            level.light_hinters[ i ] delete();
        }
        else{ if( level.dev_time ) { iprintlnbold( "^9COULDN'T FIND LIGHT HINT NEAR THIS SETUP!!!" ); } }
    }
}

keep_track_of_repair_amount() //in use now
{
    level endon( "end_game" );
    //remove wait when testing full functionality
    //wait 10;
    //level.repaired_rifts = level.fixable_spots.size;
    while( level.repaired_rifts < level.fixable_spots.size )
    {
        wait 1;
    }
    level thread lamps_fixed_schruder_speaks();
    //wait 5;
    //level.rift_step_active = false;
}

playloopsound_buried()
{
    level endon( "end_game" );
    level endon( "stop_mus_load_bur" );
    
        for( i = 0; i < level.players.size; i++ )
        {
            level.players[ i ] playsound( "mus_load_zm_buried" );
        }
    
}
play_nav1_success( this_position )
{
    level endon( "end_game" );
    for( i = 0; i < 5; i++ )
    {
        wait 0.1;
        PlaySoundAtPosition( "zmb_sq_navcard_success", this_position );
    }
}
lamps_fixed_schruder_speaks()
{
    level endon( "end_game" );
   // level waittill( "all_rift_lamps_repaired" );
    wait 2.5;
    
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says( "^9Dr. Schruder^8: " + "Ahh.. Good job!", "^9Rift Lamps^8 are powered now!", 5, 0.25 );
    wait 10;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says( "^9Dr. Schruder^8: " + "Check if ^9Stalinburg's Power Station^8 is receiving any signals from the lamps.", "^8The computer should be located somewhere in the ^9Control Room^8.", 7, 1 );
    wait 11;
    //level notify( "spawn_rift_computer" );
    level thread spawn_rift_computer();
    wait 1;
    level.rift_step_active = false;
}

spawn_rift_computer()
{
    level endon( "end_game" );
    org = ( 12057.7, 8487.55, -714.927 );
    level.rift_comp = spawn( "script_model", org );
    level.rift_comp setModel( "tag_origin" );
    level.rift_comp.angles = level.rift_comp.angles;

    trig_ = spawn( "trigger_radius_use", org, 0, 85, 85 );
    trig_ setCursorHint( "HINT_NOICON" );
    trig_ setHintString( "^9[ [{+activate}] ^8to restore computer's save point ^9]" );
    trig_ TriggerIgnoreTeam();
    level.global_org = trig_.origin;
    wait 0.05;
    playFXOnTag( level.myfx[ 43 ], level.rift_comp, "tag_origin" );
    wait 0.05;
    playFXOnTag( level.myfx[ 45 ], level.rift_comp, "tag_origin" );
    wait 0.05;
    level thread computer_wait_for_player_interact( trig_ );
}


computer_wait_for_player_interact( trigger_delete ) //in use now
{
    level endon( "end_game" );
    level endon( "someone_accessed_rift_computer" );
    a_comp = trigger_delete;
    while( true )
    {
        for( i = 0; i < level.players.size; i++ )
        {
            if( !distance2d( level.players[ i ].origin, level.rift_comp.origin ) > 60 ) { continue; }
            if( distance2d( level.players[ i ].origin, level.rift_comp.origin ) < 55 )
            {
                if( !level.players[ i ] useButtonPressed() ) { continue; }
                if( level.players[ i ] useButtonPressed() )
                {
                    level thread malfunction_computers_sparks_fx();
                    PlaySoundAtPosition( level.jsn_snd_lst[ 31 ], trigger_delete.origin );
                    if( isdefined( trigger_delete ) ) { trigger_delete delete(); }
                    level thread computer_accessed_by_player(  level.players[ i ].name, a_comp );
                    level thread play_computer_attention_sfx( level.players[ i ].origin, level.access_panel_org );
                    wait 0.1;
                    PlaySoundAtPosition(level.jsn_snd_lst[ 30 ], level.rift_comp.origin );
                    wait 0.2;
                    level.rift_comp delete(); //delete the model that the player interacts with
                    level notify( "someone_accessed_rift_computer" );
                    break;
                }
            }
        }
        wait 0.1;
    }
}

computer_accessed_by_player( playa, a_comp )
{
    level endon( "end_game" );
    a_comp_origin = a_comp.origin;
    wait randomfloatrange( 1.1, 2.2 );
    
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says( "^9Dr. Schruder^8: " + "Excellent stuff!", "^9" + playa + " ^8was able to restore signal recception from the computer.", 6, .25 );
    wait 10;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says( "^9Dr. Schruder^8: " + "Something's wrong with the computer..", "^8Access the control panel and restart the computer, quick!", 6, 1  );
    wait 10;
    level thread wait_for_access_panel_interact( a_comp_origin );


}

wait_for_access_panel_interact( a_comp_origin )
{
    
    trig_panel = spawn( "trigger_radius_use", level.access_panel_org, 0, 48, 48 );
    trig_panel setCursorHint( "HINT_NOICON" );
    trig_panel setHintString( "^9[ ^3[{+activate}] ^8Restore computer's save point ^9]" );

    //trig_panel UseTriggerRequireLookAt();
    trig_panel TriggerIgnoreTeam(); 
    
    playFXOnTag( level.myfx[ 46 ], trig_panel, "tag_origin" );

    hinter = spawn( "script_model", trig_panel.origin + ( 30, 0, 62 ) );
    hinter setmodel( "tag_origin" );
    hinter.angles = ( 0, 180, 0 );
    wait 0.05;

    sfx = spawn( "script_model", hinter.origin );
    sfx setmodel( "tag_origin" );
    sfx.angles = sfx.angles;
    wait 0.05;
    playfxontag( level.myfx[ 24 ], hinter, "tag_origin" );
    wait 0.05;
    playfxontag( level.myfx[ 45 ], hinter, "tag_origin" );

    
    while( true )
    {
        trig_panel waittill( "trigger", who );
        PlaySoundAtPosition( level.jsn_snd_lst[ 7 ], trig_panel.origin );
        level thread do_zombie_builder_anim( who );
        wait 0.1;
        if( isdefined( who )  && isAlive( who ) )
        {
            trig_panel setHintString( "^9[ ^8Accessing restore point.. ^9]" );
            wait 1.5;
            
            for( x = 0; x < 3; x++ )
            {
                randomize = randomIntrange( 0, level.sparking_computers_locs.size ); 
                PlaySoundAtPosition(level.jsn_snd_lst[ 4 ], level.sparking_computers_locs[ randomize ] ); //snd zmb_pwr_rm_bolt_lrg
                wait 0.06;
            }
            wait 1;
            trig_panel setHintString( "^9[ ^8Critical malfunction ^9]" );
            sfx playsound( level.jsn_snd_lst[ 39 ] );
            hinter movez( -1260, 0.1, 0, 0 );
            foreach( p in level.players )
            {
                p playsound( level.jsn_snd_lst[ 39 ]  );
            }
            PlaySoundAtPosition( level.jsn_snd_lst[ 39 ], sfx.origin + ( 100, 0, 0 ) );
            wait 0.05;
            PlaySoundAtPosition( level.jsn_snd_lst[ 39 ], sfx.origin + ( 100, 0, 0 ) );
            level notify( "computer_accessed" ); //stop beeping broken computer sfx
            wait 2.5;
            trig_panel playSound( level.jsn_snd_lst[ 27 ] ); //snd evt_nuke_flash
            wait 0.05;
            level notify("stop_mus_load_bur");
            trig_panel playSound( level.jsn_snd_lst[ 43 ] ); //snd amb_church_bell
            trig_panel playsound( level.jsn_snd_lst[ 30 ] );
            wait 0.1;
            trig_panel playSound( level.jsn_snd_lst[ 3 ] );
            ai = getAIArray( level.zombie_team );
    
            for( a = 0; a < ai.size; a++ )
            {
                ai[ a ] doDamage( ai[ a ].health + 555, ai[ a ].origin );

            }
            wait 0.05;
            level.zombie_total = 9999;
            level thread scripts\zm\zm_transit\warmer_days_sq_rewards::reward_mini_quest_avogadro_zombies();
            level thread do_malfunction_visuals();
            PlaySoundAtPosition( level.jsn_snd_lst[ 3 ], trig_panel.origin );
            wait 1;
            level thread play_scary_children(); //make some scary noises for the dark part
            trig_panel setHintString("^9[ ^8Rebooting in progress.. ^9] " );
            wait 30;
            trig_panel setHintString("^9[ ^8Rebooting Complete ^9] " );
            //trig_panel delete();
            hinter delete();
            sfx delete();
            //level thread move_camera_to_teleport();
            level thread spawn_initial_rift_camera_points();
            wait 3.5;
            trig_panel delete();
            break;
        }
    }
    

}

play_computer_attention_sfx( b_comp, a_comp )
{
    level endon( "computer_accessed" );
    level endon( "end_game" );

    while( true )
    {
        PlaySoundAtPosition( level.jsn_snd_lst[ 20 ], b_comp );
        PlaySoundAtPosition( level.jsn_snd_lst[ 4 ] , a_comp );
        wait randomFloatRange( 0.3, 5 );
        PlaySoundAtPosition( level.jsn_snd_lst[ 4 ], b_comp );
        PlaySoundAtPosition( level.jsn_snd_lst[ 20 ] , a_comp );
        wait randomFloatRange( 1, 5 );
    }
}

spawn_initial_rift_portal_on_core()
{
    level endon( "end_game" );

    level.core_rift_loc_topper = ( 12210.5, 7588.57, -461.155 );

    level.core_rift_top = spawn( "script_model", level.core_rift_loc_topper );
    level.core_rift_top setmodel( "tag_origin" );
    level.core_rift_top.angles = level.core_rift_top_angles;


    level.core_rift_locs = [];
    level.core_rift_locs[ 0 ] = ( 12210.5, 7588.57, -480.404 ); //mid
    level.core_rift_locs[ 1 ] = ( 12210.5, 7743.26, -480.404 ); //mid left
    level.core_rift_locs[ 2 ] = ( 12210.5, 7433.57, -480.404 ); //mid right
    level.core_rift_locs[ 3 ] = ( 12055.5, 7588.57, -480.404 ); //mid back
    level.core_rift_locs[ 4 ] = ( 12365.5, 7588.57, -480.404 ); //mid front

    for( i = 0; i < level.core_rift_locs.size; i++ )
    {
        level._s_spawnpoint[ i ] = spawn( "script_model",  level.core_rift_locs[ i ]  + ( 0, 0, 20 )  );
        level._s_spawnpoint[ i ] setModel( "p6_zm_screecher_hole" );
        level._s_spawnpoint[ i ].angles = ( randomIntRange( 170, 190 ), 0, 0 );
        level._s_spawnpoint[ i ] playsound( "zmb_screecher_portal_spawn" );
        playfxontag( level.myfx[ 87 ], level._s_spawnpoint[ i ], "tag_origin" );
        wait 0.05;
        //playfxontag( level.myfx[ 12 ], spawnpoint, "tag_origin" );
        playFXOnTag( level._effect[ "screecher_hole" ], level._s_spawnpoint[ i ], "tag_origin" );
    }

    wait 2;
    foreach( sp in level._s_spawnpoint )
    {
        playFXOnTag( level._effect[ "screecher_vortex" ], sp, "tag_origin" );
        sp playLoopSound( "zmb_screecher_portal_loop", 2 );
    }

    while( !level._malfunction_complete )
    {
        wait 0.1;
    }
    Earthquake( 0.5, 8, level._s_spawnpoint[ 1 ].origin, 1000 );
    for( i = 0; i < level._s_spawnpoint.size; i++ )
    {
        playfx( level._effects[ 77 ], level._s_spawnpoint[ i ].origin );
        wait 0.1;
        level._s_spawnpoint[ i ] movez( 1000, 10, 3, 0 );
        level._s_spawnpoint[ i ] thread delete_after_move();
        wait randomFloatRange( 0.1, 1.2 );
    }
    wait 5.7;
    foreach( zom in level.zombie_team )
    {
        zom dodamage( zom.health + 50, zom.origin );
    }
    level notify( "stop_avogadro_shit" );
    level thread level_bring_back_normal_visuals_and_stuff();


}

delete_after_move()
{
    level endon( "end_game" );
    wait 11;
    playfx( level._effects[ 77 ], self.origin );
    wait 0.05;
    self delete();
}
play_scary_children()
{
    level endon( "end_game" );
    wait 1;
    for( i = 0; i < 20; i++ )
    {
        
        if( randomIntRange( 0, 5 ) > 2 )
        {
            if( randomintrange( 0, 10 ) > 7 )
            {
                PlaySoundAtPosition( level.jsn_snd_lst[ 37 ] , level.core_fx_move_to_spots[ randomIntRange( 0, level.core_fx_move_to_spots.size ) ] );
                wait 1;
            }
            else{ PlaySoundAtPosition( level.jsn_snd_lst[ 38 ], level.core_fx_move_to_spots[ randomIntRange( 0, level.core_fx_move_to_spots.size ) ] ); wait 1; }
        }
        else { wait 1;}
    }
}

//exposurevalue for labs = 4.3
//vc_rgbh = 1 1 1 1



move_camera_to_teleport()
{
    level endon( "end_game" );

    foreach( zombie in level.zombie_team )
    {
        zombie doDamage( zombie.health + 65, zombie.origin );
    }
    level.core_rift_camera_lerp_origin = ( 12235.2, 7578.6, -567.839 );
    angles = ( -90, 0, 0 );


    foreach( player in level.players )
    {
        cam = spawn( "script_model", player getEye() );
        cam setmodel( "tag_origin" );
        cam.angles = player.angles;
        
        wait 0.05;
        player CameraSetPosition( cam, cam.angles );
        player CameraSetLookAt();
        player CameraActivate( true );

        wait 0.05;
        time = 3;
        speed = 10;
        player hide();
        cam moveTo( level.core_rift_camera_lerp_origin, time, 1.2, 0 );
        cam rotateTo( angles, time, 2, 0 );
        cam rotateRoll( 360, time, 2, 0 );
        cam waittill( "movedone" );

        player show();
        player camerasetposition( player, player.angles );
        player CameraActivate( false );

    }
    wait 2.5;
    level thread playerss_ride();
}

//todo
//make each player link to the spinning rift roll camera thing seperately at different times
//loop players somewhere else before allowing them to link to loop where next person is already at
//then spin all around room simultaneously
//throw them towards generator
//then dark puff
//then rift on sky 
//make them fly towwards some sorta rift landing
//boom rifts opened
do_malfunction_visuals()
{
    level endon( "end_game" );
    foreach( plr in level.players )
    {
        plr.electry = spawn( "script_model", plr getTagOrigin( "j_head" ) );
        plr.electry setmodel( "tag_origin" );
        plr.electry enableLinkTo();
        plr.electry linkto( plr, "j_head" );
        plr.electry thread delete_after_while();

        plr thread fadeForAWhile( 0, 1, 0.5, 0.5, "white" );
        plr setClientDvar( "r_exposureTweak", true );
        plr setClientDvar( "r_exposurevalue", 8 );
        plr setclientdvar( "cg_colorscale", "2 2 2" );
        plr setclientdvar( "cg_colorhue", 250 );
    }
    wait 0.05;
    level thread malfunction_core_fx();
    level thread spawn_initial_rift_portal_on_core();
    while( !level._malfunction_complete )
    {
        wait 0.1;
    }
    
    /* //might be obsolete since it we get the fade twice instead of once
    foreach( pl in level.players )
    {
        pl thread fadeForAWhile( 0, 1, 0.5, 0.5, "white" );
    }
    */
    wait 0.1;
    foreach( pls in level.players )
    {
        pls setclientdvar( "r_exposurevalue", 3 );
        pls setClientDvar( "r_exposureTweak", false );
        pls setclientdvar( "cg_colorscale", "1 1 1" );
        pls setclientdvar( "cg_colorhue", 0 );
        if( isdefined( plr.electry ) )
        {
            plr.electry unlink();
        }
    }

    level thread playerss_ride();

    
    
}

delete_after_while() //is used now
{
    level endon( "end_game" );
    wait 0.7;
    self delete();
}
fadeForAWhile( startwait, blackscreenwait, fadeintime, fadeouttime, shadername, n_sort ) //is used now
{
    if ( !isdefined( n_sort ) )
        n_sort = 50;

    wait( startwait );

    if ( !isdefined( self ) )
        return;

    if ( !isdefined( self.blackscreen ) )
        self.blackscreen = newclienthudelem( self );

    self.blackscreen.x = 0;
    self.blackscreen.y = 0;
    self.blackscreen.horzalign = "fullscreen";
    self.blackscreen.vertalign = "fullscreen";
    self.blackscreen.foreground = 0;
    self.blackscreen.hidewhendead = 0;
    self.blackscreen.hidewheninmenu = 1;
    self.blackscreen.sort = n_sort;

    if ( isdefined( shadername ) )
        self.blackscreen setshader( shadername, 640, 480 );
    else
        self.blackscreen setshader( "black", 640, 480 );

    self.blackscreen.alpha = 0;

    if ( fadeintime > 0 )
        self.blackscreen fadeovertime( fadeintime );

    self.blackscreen.alpha = 1;
    wait( fadeintime );

    if ( !isdefined( self.blackscreen ) )
        return;

    wait( blackscreenwait );

    if ( !isdefined( self.blackscreen ) )
        return;

    if ( fadeouttime > 0 )
        self.blackscreen fadeovertime( fadeouttime );

    self.blackscreen.alpha = 0;
    wait( fadeouttime );

    if ( isdefined( self.blackscreen ) )
    {
        self.blackscreen destroy_hud();
        self.blackscreen = undefined;
    }
}
do_zombie_builder_anim( players )
{
    level endon( "end_game" );
    players endon( "disconnect" );
    players endon( "death" );

    ex_weapon = players getCurrentWeapon();
    players giveweapon( "zombie_builder_zm" );
    players switchToWeapon( "zombie_builder_zm" );
    wait 3.5;
    players maps\mp\zombies\_zm_weapons::switch_back_primary_weapon( ex_weapon );
    players takeWeapon( "zombie_builder_zm" );

}
malfunction_computers_sparks_fx() //is used now
{
    level endon( "end_game" );
    level.sparking_computers_locs = [];
    level.sparking_computers_locs[ 0 ] = ( 12006.7, 8499.82, -686.112 );
    level.sparking_computers_locs[ 1 ] = ( 12075.6, 8503.3, -708 );
    level.sparking_computers_locs[ 2 ] = ( 12465.9, 8173.58, -682.125 );
    level.sparking_computers_locs[ 3 ] = ( 12474.5, 8236.4, -716.03 );
    level.sparking_computers_locs[ 4 ] = ( 12352.6, 8515.76, -686.659 );
    level.sparking_computers_locs[ 5 ] = ( 12321.5, 8511.94, -709.913 );
    mods = [];

    for( s = 0; s < level.sparking_computers_locs.size; s++ )
    {
        mods[ s ] = spawn( "script_model", level.sparking_computers_locs[ s ] );
        mods[ s ] setmodel( "tag_origin" );
        mods[ s ].angles = ( 0, 0, 0 );
        wait 0.05;
        playfxontag( level.myfx[ 44 ], mods[ s ], "tag_origin" ); 
        wait randomFloatRange( 0.3, 1.1 );
    }
    if( level.dev_time ){ iprintlnbold( "WE SPAWNED SPARKING FX FOR MALFUNC STEP" ); }
    while( !level.malfunction_complete )
    {
        wait 1;
    }
    foreach( mod in mods )
    {
        mod delete();
    }
}
malfunction_core_fx() //is used now
{
    level endon( "end_game" );
    level.core_fx_loc = ( 12207.7, 7581.04, -659.363 );
    wait 0.05;
    level thread playthisstupidfxontag();
    wait 0.1;

    for( i = 0; i < level.core_fx_move_to_spots.size; i++ )
    {
        temps = spawn( "script_model", level.core_fx_loc );
        temps setModel( "tag_origin" );
        temps.angles = temps.angles;

        wait 0.05;

        playfxontag( level.myfx[ 1 ], temps, "tag_origin" );
        temps thread move_these_around();
        playFXOnTag( level.myfx[ 48 ], temps, "tag_origin" );
        wait randomFloatRange( 0.05, 0.6 );
    }
    level thread malfunction_time();

}

playthisstupidfxontag() //is used now
{
    level endon( "end_game" );
    while ( true )
    {
        if( isDefined( level._malfunction_complete ) && level._malfunction_complete )
        {
            break;
        }
        playfx( level.myFx[ 82 ], level.core_fx_loc ); //power rising
        wait randomFloatRange( 2.9, 4.2 );
        
    }
}
malfunction_time() //is used now
{
    level endon( "end_game" );
    for( time = 0; time < 5; time++ ) { wait 1; }
    PlaySoundAtPosition(level.jsn_snd_lst[ 100 ], level.core_fx_loc ); //snd zmb_power_on_quad
    for( turn_on_time = 0; turn_on_time < 30; turn_on_time++ ){ wait 1; }
    level._malfunction_complete = true;
    if( level.dev_time ){ iPrintLnBold( "MALFUNCTION STEP OK" ); }
}

move_these_around() //is used now
{
    level endon( "end_game" );
    //playfxontag( level.myFx[ 86 ], self, "tag_origin" );
    while( true )
    {   
         
        new_loc = randomIntRange( 0, level.core_fx_move_to_spots.size );
        self moveto( level.core_fx_move_to_spots[ new_loc ], randomFloatRange( 0.15, 1.4 ), 0, 0 );
        self waittill( "movedone" );
        playfx( level.myFx[ 92 ], self.origin );
        if( level._malfunction_complete )
        {
            self moveTo( level.core_fx_loc, randomFloatRange( 0.5, 1.2 ), 0, 0.35 );
            self waittill( "movedone" );
            wait 0.05;
            self delete();
        }
    }
}
just_in_case_apply( which_light )  // is used now
{
    level endon( "end_game" );
    
    ws = getstructarray( "screecher_escape", "targetname" );

    level notify( "safety_light_power_on", ws[ which_light ] );
    ws[ which_light ] notify( "safety_light_power_on" );
    foreach( playa in level.players )
    {
        //playa setclientfield( "screecher_maxis_lights", true );
        //playa setclientfield( "screecher_sq_lights", true );
        //playa.green_light = ws[ which_light ];
    }

    /*
        foreach( playa in level.players )
        {
            //flickering white and sparks, could be used for before fixing em.
            //playa setclientfield( "screecher_maxis_lights", 1 );

            //not that good looking. Could be used to initialize this step.
            //playa setclientfield( "screecher_sq_lights", 1 );
            
        }
    */
}

player_entered_safety_light( player )
{
    safety = getstructarray( "screecher_escape", "targetname" );

    if ( !isdefined( safety ) )
        return false;

    player.green_light = undefined;

    for ( i = 0; i < safety.size; i++ )
    {
        if ( !( isdefined( safety[i].power_on ) && safety[i].power_on ) )
            continue;

        if ( !isdefined( safety[i].radius ) )
            safety[i].radius = 256;

        plyr_dist = distancesquared( player.origin, safety[i].origin );

        if ( plyr_dist < safety[i].radius * safety[i].radius )
        {
            player.green_light = safety[i];
            return true;
        }
    }

    return false;
}

play_crows()
{
    for( i = 0; i < 6; i++ )
    {
        self playsound( level.jsn_snd_lst[ 36 ] );
        wait randomfloatrange( 0.05, 0.3 );
    }
    
}


// HUD SPECIFIC | HUD SPECIFIC | HUD SPECIFIC | HUD SPECIFIC | HUD SPECIFIC | HUD SPECIFIC //

//this is a global sayer, all players in game will receive this at once
_play_schruder_texts( subtitle_upper, subtitle_lower, duration, fadetimer )
{
    level endon( "end_game" );
	level thread machine_says( "^9Dr. Schruder: ^8" + subtitle_upper, "^8" + subtitle_lower, duration, fadetimer );
}
machine_says( sub_up, sub_low, duration, fadeTimer )
{
    //don't start drawing new hud if one already exists 
    if(  isdefined( level.subtitles_on_so_have_to_wait ) && level.subtitles_on_so_have_to_wait )
    {
        while(  level.subtitles_on_so_have_to_wait ) { wait 1; }
    }
    level.subtitles_on_so_have_to_wait = true;
    level.play_schruder_background_sound = true;
    level.subtitle_upper settext( sub_up );
    if( isdefined( sub_low ) )
    {
        level.subtitle_lower settext( sub_low );
    }
    level.subtitle_upper.x = 0;
    level.subtitle_lower.x = 0;
    level.subtitle_upper.alpha = 0;
    level.subtitle_upper fadeovertime( fadeTimer );
    level.subtitle_upper.alpha = 1;
	if ( IsDefined( sub_low ) )
	{
        level.subtitle_lower.alpha = 0;
        level.subtitle_lower fadeovertime( fadeTimer );
        level.subtitle_lower.alpha = 1;
	}

	wait ( duration );
    
	level thread flyby( level.subtitle_upper );
    level.subtitle_upper fadeovertime( fadeTimer );
    level.subtitle_upper.alpha = 0;

	if ( IsDefined( sub_low ) )
	{
		level thread flyby( level.subtitle_lower );
        level.subtitle_lower fadeovertime( fadeTimer );
        level.subtitle_lower.alpha = 0;
	}

    wait 1;
    level.play_schruder_background_sound = false;
}

//this a gay ass hud flyer, still choppy af
flyby( element )
{
    level endon( "end_game" );
    x = 0;
    on_right = 640;

    while( element.x < on_right )
    {
        element.x += 100;
        wait 0.05;
    }
    level.subtitles_on_so_have_to_wait = false;
}