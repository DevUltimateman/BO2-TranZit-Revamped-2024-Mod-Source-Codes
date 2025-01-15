//codename: wamer_days_mq_04_wondering_fields.gsc
//purpose: handles the cornfield fight at night
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
    
    //level.nigth_fight_fx_list = [];
    precachemodel( "p_lights_lantern_hang_on_corn" );
    flag_wait( "initial_blackscreen_passed" );
    
    level.lock_down_enabled = false;
    level thread levelwaiter();


    
    
}

levelwaiter()
{   
    level waittill( "orb_at_nacht" );
    level thread spawn_lockdown_enabler( ( 13832.4, -1273.99, -153.193 ) );
    level thread spawn_lockdown_blockers();
}
warm_up_the_fxs()
{


    
    level.night_fight_fx[ 0 ] = ( "" );
    level.night_fight_fx[ 1 ] = ( "" );
    level.night_fight_fx[ 2 ] = ( "" );
    level.night_fight_fx[ 3 ] = ( "" );
    level.night_fight_fx[ 4 ] = ( "" );
    level.night_fight_fx[ 5 ] = ( "" );
    level.night_fight_fx[ 6 ] = ( "" );
    level.night_fight_fx[ 7 ] = ( "" );
}

spawn_spark_fxs_night_fight()
{
    level endon( "end_game" );
    
    //remove fx entities notifier
    // remove_fxs 

    spark_locations = [];
    spark_locations[ 0 ] = ( "" );
    spark_locations[ 1 ] = ( ""  );
    spark_locations[ 2 ] = (  "" );
    spark_locations[ 3 ] = (  "" );
    spark_locations[ 4 ] = (  "" );
    spark_locations[ 5 ] = (  "" );
    spark_locations[ 6 ] = (  "" );
    spark_locations[ 7 ] = (  "" );
    spark_locations[ 8 ] = (  "" );
    spark_locations[ 9 ] = (  "" );
    spark_locations[ 10 ] = ( ""  );
    spark_locations[ 11 ] = ( ""  );
    spark_locations[ 12 ] = ( ""  );
    spark_locations[ 13 ] = ( ""  );
    spark_locations[ 14 ] = ( ""  );
    spark_locations[ 15 ] = ( ""  );
    spark_locations[ 16 ] = ( ""  );
    spark_locations[ 17 ] = ( ""  );
    spark_locations[ 18 ] = ( ""  );
    spark_locations[ 19 ] = ( ""  );
    spark_locations[ 19 ] = ( ""  );

    //total locs = 20;

    //so that we can delete looping fxs eventually
    fx_to_entity = [];
    for( i = 0; i < spark_locations.size; i++ )
    {
        fx_to_entity[ i ] = spawn( "script_model", spark_locations[ i ] );
        fx_to_entity[ i ] setmodel( "tag_origin" );
        fx_to_entity[ i ].angles = fx_to_entity[ i ].angles;
        wait 0.05;
        playFXOnTag( level.night_fight_fx[ "" ], fx_to_entity[ i ], "tag_origin" );
        wait randomfloatrange( 0.05, 1.45 );

        if( level.dev_time ) { iprintlnbold( "Sparks initiated to loop ^3" + i + " / " + spark_locations.size ); } 
    }

    wait 1;
    if( level.dev_time ) { iprintlnbold( "32 / 32 sparks running in loop!" ); }

    level waittill( "remove_fxs" );
    
    foreach( fx in fx_to_entity )
    {
        fx delete();
    }

    if( level.dev_time ) { iPrintLnBold( "Sparks loop terminated. FX_TO_ENTITY size now: " + fx_to_entity.size ); }

}




spawn_lockdown_enabler( origin )
{
    level endon( "end_game" );

    //turn back on for full build
    //level waittill( "obey_spirit_complete" );
    trig = spawn( "trigger_radius_use", origin, 0, 85, 85 );
    trig setCursorHint( "HINT_NOICON" );
    trig sethintstring( "^8[ ^9[{+activate}] ^8 to release ^9Spirit Of Sorrow^8. ^8Requires all survivors to be present. ^8]" );
    trig TriggerIgnoreTeam();
    wait 0.1;

    trig.can_be_hit = false;



    lamper = spawn( "script_model", origin );
    lamper setmodel( "p_lights_lantern_hang_on_corn" );
    lamper.angles = ( 0, 180, 0 );

    wait 0.05;
    lamper thread lrotateme();
    testfx = level.myfx[ 90 ];
    //cant stop looped fx thread, make a custom loop thread
    //playloopedfx( testfx, 0.35, lamper.origin );
    lamper thread blink_fx( testfx );
    lamper playLoopSound( "zmb_spawn_powerup_loop" );
    trig thread wait_players();
    wait 0.05;
    trig thread monitor_player_use();

    level waittill( "lockdown_enabled" );
    PlaySoundAtPosition(level.jsn_snd_lst[ 30 ], level.players[ 0 ].origin );
    PlaySoundAtPosition("mus_zombie_splash_screen", level.players[ 0 ].origin );
    //PlaySoundAtPosition( "mus_zombie_round_start", level.players[ 0 ].origin );
    level thread scripts\zm\zm_transit\warmer_days_sq_rewards::print_text_middle( "^9Spirit From Hell", "^8That was a stupid choice.", "Survive.", 6, 0.25 );
    wait 0.05;
    trig delete();
    lamper delete();
    
}

lrotateme()
{
    level endon( "end_game" );
    while( isdefined( self ) )
    {
        self rotateYaw( 360, 5, 0, 0 );
        wait 5;
    }
}

playlockdown_song()
{
    level endon( "end_game" );

}
wait_players()
{
    current_amount = 0;
    while( true )
    {
        for( s = 0; s < level.players.size; s++ )
        {
            if( distance( level.players[ s ], self.origin ) < 100 )
            {
                current_amount++;
            }
            else { current_amount = current_amount; }
        }
        if( current_amount >= level.players.size )
        {
            self.can_be_hit = true;
            break;
        }
        wait 0.25;
        self.can_be_hit = false;
        current_amount = 0;
    }
}

monitor_player_use()
{
    loca = self.origin;
    while( true )
    {
        self waittill( "trigger", someone );
        {
            if( isdefined( self.can_be_hit ) && !self.can_be_hit )
            {
                wait 0.05;
                continue;
            }

            else if( isdefined( self.can_be_hit ) && self.can_be_hit )
            {
                if( is_player_valid( someone ) )
                {
                    level.lock_down_enabled = true;
                    if( level.dev_time ) { iprintlnbold( "LOCKDOWN INITIATED" ); }
                    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
                    level thread _spirit_of_sorrow_sub_text_alt( "You fools!", "Time to pay for your wrong doings..", 7, 1 );
                    level notify( "lockdown_enabled" );
                    level notify( "spawn_blockers_for_lockdown" );
                    level.zombie_total = 9999;
                    wait 0.05;
                    PlaySoundAtPosition(level.jsn_snd_lst[ 33 ], loca );
                    wait 1;
                    PlaySoundAtPosition( "zmb_vox_monkey_explode", loca );
                    level thread do_zombies_go_crazy();
                    //add lockdown init here
                    Earthquake( 0.18, 10, loca, 2500 );
                    wait 1;
                    PlaySoundAtPosition( "zmb_vox_monkey_scream", loca );
                    
                    wait 2.5;
                     level thread playlockdown_song();
                    playsoundatposition( "vox_zmba_sam_event_magicbox_0", loca );
                    //
                }
            }
        }
    }
}

blink_fx( fx )
{
    while( true )
    {
        playfx( fx, self.origin );
        wait randomFloatRange( 0.15, 0.85 );
    }
}

do_zombies_go_crazy()
{
    level endon( "end_game" );
    saved_round = level.round_number;
    ai = getAIArray( level.zombie_team );

    if( level.dev_time ){ iprintlnbold( "ZOMBIE TOTAL FOR LOCKDOWN = ^4" + level.zombie_total ); }
    //dont make zombies super sprinters here. 
    //have that in the second lockdown later down the quest when players are most likely better equipped
    //to fuck zombies that are super speeedy. 
    wait 48;
    if( level.dev_time ){ iprintlnbold( "LOCKDOWN STEP FINISHED, REMOVING BLOCKS" );}
    level notify( "lockdown_disabled" );
    level.spirit_of_sorrow_step_active = false;
    ai = getAIArray( level.zombie_team );
    
    for( a = 0; a < ai.size; a++ )
    {
        ai[ a ] doDamage( ai[ a ].health + 555, ai[ a ].origin );

    }
    foreach( playu in level.players )
    {
        playu playsound( level.jsn_snd_lst[ 30 ] );
    }
    //level notify( "end_round" );
    level.lock_down_enabled  = false;
    level.round_number = saved_round;
    level.zombie_total = undefined;
}
spawn_lockdown_blockers()
{
    level waittill( "spawn_blockers_for_lockdown" );
    level.zombie_total = 10000;
    //PlaySoundAtPosition(level.jsn_snd_lst[ 61 ], (0,0,0));
    locs = [];
    locs[ 0 ] = ( 13551.9, -290.809, -187.875 );
    locs[ 1 ] = ( 13547.4, -964.105, -187.875 );
    
    block = [];
    block_upper = [];
    wait 0.05;
    for( i = 0; i < locs.size; i++ )
    {
        block[ i ] = spawn( "script_model", locs[ i ] );
        block[ i ] setmodel( level.myModels[ 0 ] );
        block[ i ].angles = block[ i ].angles;
        wait 1;
        playfxontag(level.myFx[ 78 ], block[ i ], "tag_origin" ); 
        block_upper[ i ] = spawn( "script_model", locs[ i ] + ( 0, 0, 50 ) );
        block_upper[ i ] setmodel( level.myModels[ 0 ] );
        block_upper[ i ].angles = block[ i ].angles;
        playfxontag(level.myFx[ 78 ], block_upper[ i ], "tag_origin" ); 
    }

    level waittill( "lockdown_disabled" );
    for( i = 0; i < locs.size; i++ )
    {
        block[ i ] movez( -1600, 2.5 );
        block_upper[ i ] movez( -1600, 2.5 );
    }
    level.zombie_total = undefined;
    wait 4;
    for( s = 0; s < locs.size; s++ )
    {
        block[ s ] delete();
        block_upper[ s ] delete();
    }
    wait 1;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread _someone_unlocked_something( "^8Let's regroup at ^9Safe House", "^8Some sorta toxic cloud is forming around the map.", 7, 1 );
    wait 10;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread _someone_unlocked_something( "^8Watch out for the poisonous gas!!!", "^8Get to your ^9Safe House^8 immediately!", 8, 1 );
    level notify( "stop_mus_load_bur" );
    
}

playloopsound_buried()
{
    level endon( "end_game" );
    level endon( "stop_mus_load_bur" );

        for( i = 0; i < level.players.size; i++ )
        {
            level.players[ i ] playsound( "mus_load_zm_buried" );
        }
        wait 40;
}

_someone_unlocked_something( text, text2, duration, fadetimer )
{
    level endon( "end_game" );
    level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says(  "^9Dr. Schruder: ^8" + text, "^8" + text2, duration, fadetimer );
}

_spirit_of_sorrow_sub_text_alt( text, text2, duration, fadetimer )
{
    level endon( "end_game" );
    level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says(  "^4Spirit Of Sorrow: ^8" + text, "^8" + text2, duration, fadetimer  );
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
    level.subtitle_upper.alpha = 0;
    level.subtitle_upper.x = 0;
    level.subtitle_lower.x = 0;
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
flyby( element )
{
    level endon( "end_game" );
    x = 0;
    on_right = 640;

    while( element.x < on_right )
    {
        element.x += 200;
        wait 0.05;
    }
    level.subtitles_on_so_have_to_wait = false;
}
