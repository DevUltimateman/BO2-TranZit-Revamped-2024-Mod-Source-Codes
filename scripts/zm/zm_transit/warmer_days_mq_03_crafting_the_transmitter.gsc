
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

#include maps\mp\zm_transit_utility;

main()
{
    replacefunc( ::init_navcomputer, ::init_navcomputer_dont_rebuild_if_done );
    replacefunc( ::sidequest_logic, ::sidequest_logic_skip );
    replacefunc( ::navcomputer_waitfor_navcard, ::navcomputer_waitfor_navcard_clean );
}
init()
{
    //replacefunc( ::sq_easy_cleanup, ::sidequest_prevent_cleaning );
    level.buildable_built_custom_func = undefined;
    level.sq_clip = undefined;
    //this turns false from meet_mr_s.gsc when meeting_vox11 has started playing. is to prevent players from completing next step even if navcard gets build before schruder asking for it
    level.not_doable_yet = false;
    level.transmitter_part_done = false;
    level thread for_connecting_players(); //apply marathon hud for late connecting player in case if players have already initialized with transmitter
    flag_wait( "initial_blackscreen_passed" );
    level thread track_transmitter_progress();

}

apply_on_debug()
{
    level endon( "end_game" );
    wait 5;
    //level.players[ 0 ] thread player_reward_marathon();
}
for_connecting_players()
{
    level endon( "end_game" );
    while( true )
    {
        level waittill( "connected", p );
        if( level.transmitter_part_done )
        { 
            p thread apply_jockie_on_spawn(); //if game has unlocked "MUSCLE UP" already, give it to connecting players
        }
    }
}

apply_jockie_on_spawn()
{
    level endon( "end_game" );
    self endon( "disconnect" );
    self waittill( "spawned_player" );
    wait 1;
    //self thread player_reward_marathon();
}
sidequest_prevent_cleaning()
{
    level endon( "end_game" );
    flag_wait( "initial_blackscreen_passed" );
    if( level.dev_time )
    iprintln( "Game tried to ^1clean sidquest logic." );
    wait 1;
    iprintln( "This func prevented game from removing sq items." );
    wait 1;
    //level.players[ 0 ] thread player_reward_marathon();
}
sidequest_logic_skip()
{
    level endon( "end_game" );
    flag_wait( "forever" );
}

track_transmitter_progress()
{
    level endon( "end_game" );
    level endon( "transmitter_ready" );

    //flag_wait( "schruder_talk_done" );
    //wait_for_buildable( "sq_common" );
    if( level.dev_time ){ iprintlnbold( "WE SHOULD TRACK TRANSMITTER NOW" ); }
    
    
    //need to have sq_common built first
    wait_for_buildable( "sq_common" );

    //level waittill( "custom" );
    //spawn the transmitter trigger
    level thread transmitter_wait_for_navcard();


}

navcomputer_waitfor_navcard_clean()
{
    level endon( "end_game" );
    flag_wait( "initial_blackscreen_passed" );
    if( level.dev_time ){ iprintlnbold( "Skipping default navcard triggers and strings." ); }
}
transmitter_wait_for_navcard()
{
    level endon( "end_game" );
    location = ( 7457.21, -431.969, -195.816 );
    navtrig = spawn( "trigger_radius_use", location, 0, 48, 48 );
    navtrig setcursorhint( "HINT_NOICON" );
    navtrig sethintstring( "^9[ ^3[{+activate}] ^8to apply your ^9navcard^8 to the transmitter ^9]" );
    navtrig triggerignoreteam();
    wait 0.1;

   // navtrig thread wait_for_final_meet_up();
    mod = spawn( "script_model", navtrig.origin );
    mod setmodel( "tag_origin" );
    mod.angles = mod.angles;
    wait 1;
    mod playloopsound( "zmb_screecher_portal_loop", 2 );

    while ( true )
    {
        navtrig waittill( "trigger", who );
        if ( isplayer( who ) && is_player_valid( who ) )
        {
            level.transmitter_part_done = true;
            level thread spawn_looping_wire_fx();
            navtrig sethintstring( "^9[ ^8Success! ^9Navcard^8 applied to the transmitter ^9]" );
            who playsound( "zmb_sq_navcard_success" );
            navtrig playsound( "zmb_sq_navcard_success" );

            navtrig playLoopSound( "zmb_spawn_powerup_loop" );
            level thread play_nav1_success( navtrig.origin );
            //update_sidequest_stats( "navcard_applied_zm_transit" );
            wait 3.2;
            //this notify triggers a thread from: warmer_days_meet_mr_s.gsc to make schruder talk with player
            //and starts the main quest step 4
            
            navtrig sethintstring( "^9[ ^8Transmitter is now sending ^9signals^8 to nearby ^9radiophones ^9]");
            wait 1;
            PlaySoundAtPosition(level.jsn_snd_lst[ 30 ], level.players[ 0 ].origin );
            level thread scripts\zm\zm_transit\warmer_days_sq_rewards::print_text_middle( "^9Muscle Up ^8Reward Unlocked", "^8Survivors can now run indefinitely without losing stamina.", "^8Survivor's running speed has also been increased.", 6, 0.25 );
            foreach( playa in level.players )
            {
                playa playsound( "evt_player_upgrade" );
                playa thread player_reward_marathon();
            }
            wait 6.5;
            level notify( "s_talks_navcard" );
            wait 3; 
            navtrig delete();
           // 
            break;
        }
    }
}

wait_for_final_meet_up()
{
    level endon( "end_game" );
    level waittill( "all_powered" );
    wait 0.1;
    
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

init_navcomputer_dont_rebuild_if_done()
{
    flag_wait( "start_zombie_round_logic" );
    spawn_navcomputer = 0; //always set to false
    players = get_players();
    foreach ( player in players )
    {
        built_comptuer = player maps\mp\zombies\_zm_stats::get_global_stat( "sq_transit_started" );
        if ( !built_comptuer )
        {
            spawn_navcomputer = 0;
            break;
        }
    }
    if ( !spawn_navcomputer ){ return; }
}



spawn_looping_wire_fx()
{
    level endon( "end_game" );
    level.cable_loc = [];
    wait 0.1;
    level.cable_loc[ 0] = ( 7403.49, -355.537, -250.859 );
    level.cable_loc[1 ]= ( 7403.49, -355.537, -200.859 );
    level.cable_loc[2] = ( 7369.03, -376.481, -101.493 );
    level.cable_loc[3] = ( 7362.51, -398.398, -19.2706 );
    level.cable_loc[4] = ( 7349.03, -427.933, 59.9438 );
    level.cable_loc[5] = ( 7334.27, -450.357, 173.891 );
    level.cable_loc[6 ]= ( 7325.85, -459.384, 285.322 );
    level.cable_loc[7] = ( 7321.75, -463.883, 474.774 );
    level.cable_loc[8] = ( 7322.12, -459.86, 666.975 );

    spawn1 = spawn( "script_model", level.cable_loc[ 0 ] );
    spawn1 setmodel( "tag_origin" );
    spawn1.angles = ( 0, 0, 0 );

    spawn2 = spawn( "script_model", level.cable_loc[ 0 ] );
    spawn2 setmodel( "tag_origin" );
    spawn2.angles = ( 0, 0, 0 );

    wait 1;
    playfxontag( level.myfx[ 2 ], spawn1, "tag_origin" );
    playfxontag( level.myfx[ 2 ], spawn2, "tag_origin" );
    wait 0.1;
    spawn1 thread go_cables();
    wait 3;
    spawn2 thread go_cables();
}

go_cables()
{
    level endon( "end_game" );
    while( isdefined( self ) )
    {
        for( i = 0; i <  level.cable_loc.size; i++ )
        {
            if( self.origin == level.cable_loc[ level.cable_loc.size ] )
            {
                self moveto( level.cable_loc[ i ],  0.05, 0, 0 );
                self waittill( "movedone" );
            }
            else {
                self moveto(  level.cable_loc[ i ], 1, 0, 0 );
            self waittill( "movedone" );
            }
            
        }
        wait 0.1;
    }
}

player_reward_marathon()
{
    
    level endon( "end_game" );
    self endon( "disconnect" );
    wait 1.5;

    self setperk( "specialty_unlimitedsprint" );
	self setperk( "specialty_fastmantle" );
    self setClientDvar( "player_backSpeedScale", 1 );
	self setClientDvar( "player_strafeSpeedScale", 1 );
	self setClientDvar( "player_sprintStrafeSpeedScale", 1 );
    self setClientDvar( "g_speed", 210 );
	self setClientDvar( "dtp_post_move_pause", 0 );
	self setClientDvar( "dtp_exhaustion_window", 100 );
	self setClientDvar( "dtp_startup_delay", 100 );
    while( true )
    {
        self waittill_any( "death", "remove_static", "disconnect" );
        wait 1;
        self waittill( "spawned_player" );
        self setperk( "specialty_unlimitedsprint" );
        self setperk( "specialty_fastmantle" );
        self setClientDvar( "player_backSpeedScale", 1 );
        self setClientDvar( "player_strafeSpeedScale", 1 );
        self setClientDvar( "player_sprintStrafeSpeedScale", 1 );
        self setClientDvar( "g_speed", 210 );
        self setClientDvar( "dtp_post_move_pause", 0 );
        self setClientDvar( "dtp_exhaustion_window", 100 );
        self setClientDvar( "dtp_startup_delay", 100 );
    }

    

}

