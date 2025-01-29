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
    //define_global_subtitles();
}
init()
{   
    //why are we replacefuncing it here on this script file? O=: 
    replacefunc( ::manage_multiple_pieces, ::manage_multiple_pieces_new );
    level.player_out_of_playable_area_monitor = false;
    level.wait_time_left_after_someone_shot = 7; //dont allow schruder to talk even if someone_shot flag is set. wait at least this amount of time before continuing
    
    level.play_schruder_background_sound = false;
    //spawn schruder
    //this also calls a monitor_players from schruder function
    //and then notifies step1_talk function to start rolling if conditions are met.
    level thread schruder_model();
    level thread define_global_subtitles();
    //wait till players discover schruder. 
    //nowadays trigger after spawning in after a while..
    level thread step1_talk();

    //wait till power on and player has returned to schruder
    level thread step2_talk();

    //schruder talks when navcard table has been built and navcard has been applied
    level thread step3_talk();

    //locations
    level thread mr_s_outside_locations();
    //debugging
    level thread print_level_vars();

    //dont start overdrawing
    level.subtitles_on_so_have_to_wait = false;
    //TEMP
    //LOCATIONS FOR VERY HEAVY THUNDER STORMS
    level.thunderstorm_chaos_locations = [];
    level.thunderstorm_chaos_locations[ 0 ]  = ( -10098.5, 4198.79, 4464.55 );
    level.thunderstorm_chaos_locations[ 1 ]  = ( -4224.48, 4582.69, 3637.07 );

    level.thunderstorm_chaos_locations[ 2 ]  = ( -1427.1, -141.855, 2714.31 );
    level.thunderstorm_chaos_locations[ 3 ]  = ( 2117.35, -3576.54, 3685.48 );
    level.thunderstorm_chaos_locations[ 4 ]  = ( 2148.51, 2068.05, 3220.62 );
    level.thunderstorm_chaos_locations[ 5 ]  = ( 6948.11, 10247.2, 4097.42 );
    level.thunderstorm_chaos_locations[ 6 ]  = ( 12250.5, 4990.76, 5680.23 );
    level.thunderstorm_chaos_locations[ 7 ]  = ( 10548.4, -1013.13, 41459.75 );
    level.thunderstorm_chaos_locations[ 8 ]  = ( 13619.4, -3336.03, 4512.05 );
    level.thunderstorm_chaos_locations[ 9 ]  = ( 8317.63, -5254.21, 4359.19 );
    level.thunderstorm_chaos_locations[ 10 ]  = ( 8274, 12477.5, 4294.35 );
    level.thunderstorm_chaos_locations[ 11 ]  = ( 2051.37, -7887.97, 4135.53 );
    level.thunderstorm_chaos_locations[ 12 ]  = ( -4486.06, -5620.71, 5603.71 );
    level.thunderstorm_chaos_locations[ 13 ]  = ( -9212.68, -10793.5, 3635.45 );

    flag_wait("initial_blackscreen_passed" );
{
    level thread foreach_score();
}
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
step3_talk()
{
    level endon( "end_game" );
    level waittill( "s_talks_navcard" ); //this level waittill notify is triggered from: warmer_days_mq_03_crafting_the_transmitter once players have succefully placed down their custom navcard
    gets = level.players;
    foreach( g in gets )
    {
        g playsound( "zmb_sq_navcard_success" );
        playfx( level.myFx[ 82 ], g.origin );
    }
    wait 3;
    
    meeting_vox13( "" );
    wait 10;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    meeting_vox14( "" );
    wait 10;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    meeting_vox15( "" );

    //how much should we wait if someone shoots faster than schruder speaks?
    level thread stop_for_a_second();
    
    //apply a shot monitor for players
    level thread someone_shot();
    level waittill( "someone_shot" );
    //if someone shot faster than schruder had finished talking
    if( level.wait_time_left_after_someone_shot > 0 )
    {
        //global timer variable that is decreased by "stop_for_a_second" function
        wait level.wait_time_left_after_someone_shot;
    }
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    meeting_vox16( "" );
    wait 10;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    meeting_vox17( "" );
    wait 11;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    meeting_vox18( "" );
    wait 12;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    meeting_vox19( "" );
    wait 10;
    level notify( "start_fixing_rift_portals" );
    PlaySoundAtPosition( "mus_zombie_round_start", level.players[ 0 ].origin );
    level thread scripts\zm\zm_transit\warmer_days_sq_rewards::print_text_middle( "^9Rift Lamps", "^8What again..?", "", 6, 0.25 );
    wait 6;

}

zombie_healthbar( pos, dsquared )
{

    if ( distance2d( pos, self.origin ) > dsquared )
        return;

    rate = 1;

    if ( isdefined( self.maxhealth ) )
        rate = self.health / self.maxhealth;

    color = ( 1, 1, 1 );
    text = "ZOMBIE HEALTH" + int( self.health );
    print3d( self.origin + ( 0, 0, 200 ), text, color, 1, 2, 1 );

}

devgui_zombie_healthbar()
{

    while ( true )
    {
        
        lp = get_players()[0];
        zombies = getAIArray( level.zombie_team );

        if ( isdefined( zombies ) )
        {
            foreach ( zombie in zombies )
                zombie zombie_healthbar( lp.origin, 360000 );
        }
        wait 0.05;
    }
}

level_bus_hud()
{
    level endon( "end_game" );
    flag_wait( "initial_blackscreen_passed" );
    wait 5;
    if( level.dev_time ){ iprintlnbold( "BUS HUD SHOULD BE ON NOW" ); }
    level.bus_leave_hud.alpha = 1;

    
}

loopingeys()
{
    level endon( "end_game" );
    level.players[ 0 ] endon( "disconnect" );

    flag_wait( "initial_blackscreen_passed" );
    while( true )
    {
        level.players[0] setclientfield( "player_has_eyes", 1 );
        if( level.dev_time ){ iPrintLnBold( "EYES = ON " ) ;}
        wait 2; 

        level.players[0] setclientfield( "player_has_eyes", 0 );
        if( level.dev_time ){ iPrintLnBold( "EYES = OFF" ) ;}
        wait 2;
    }
}
//thread automatonSpeak( "inform", "out_of_gas" );

schruder_model()
{
    level endon( "end_game" );
    flag_wait( "initial_blackscreen_passed" );
    wait( 1 );

    
    if( !isDefined( level.the_bus ) )
    {
        while( !isDefined( level.the_bus ) )
        {
            wait 0.05;
        }
    }
    
    wait 2;
    if( level.dev_time ){ iprintlnbold( "BUS HAS BEEN DEFINED" );} 
    //rn just a reg spawn outside depo for debugging
    mr_s_location = ( -6260.04, 4286.27, -63.4731 );
    level.mr_s = spawn( "script_model", mr_s_location );
    level.mr_s setmodel( level.players[ 0 ].model );
    level.mr_s.angles = level.mr_s.angles;

    //level.mr_s_blocker = spawn( "script_model", level.mr_s.origin );
    //level.mr_s_blocker setmodel( "tag_origin" );
    //level.mr_s_blocker setmodel( "collision_player_32x32x128" );
   // level.mr_s_blocker.angles = (0,0,0);

    //tulo = spawn( "script_model", mr_s_location );
    //wait 0.05;
    //tulo setmodel( "tag_origin" );
    wait 0.05;
    //tulo enableLinkTo();
    //tulo linkTo( level.mr_s, "tag_origin" );
    //tulo movemeup();
    
    
    wait 1;

    //level.mr_s_blocker enableLinkTo();
  
    //level.mr_s_blocker linkto( level.mr_s );

    level.mr_s thread monitor_first_meetup();

}

//FUNCTION TO MONITOR IF ONE OF THE PLAYERS DISCOVERS SCHRUDER
monitor_first_meetup()
{
    level endon( "end_game" );
    //level waittill( "power_on" );
    while( true )
    {
        for( s = 0; s < level.players.size; s++ )
        {
            if( distance2d( self.origin, level.players[ s ].origin ) < 150 )
            {
                wait 0.1;
                level notify( "meet_schruder_time_first" );
                foreach( pl in level.players )
                {
                    pl playsound( "zmb_navcard_success" );
                }
                if( level.dev_time ) { iprintln( "SCRUDER WAS MET" ); }
                wait 0.05;
                break;
            }
        }
        wait 0.1;
    }
}

//THIS HAPPENS WHEN PLAYERS MEET SCHRUDER FOR FIRST TIME
//THIS INITIATES THE MAIN EASTER EGG QUEST
step1_talk()
{
    level endon( "end_game" );

    level waittill( "can_start_normal_zombie_huds" );
    wait 12.5;
    PlaySoundAtPosition(level.jsn_snd_lst[ 30 ], level.players[ 0 ].origin );
    PlaySoundAtPosition( "mus_zombie_round_start", level.players[ 0 ].origin );
    
    level thread scripts\zm\zm_transit\warmer_days_sq_rewards::print_text_middle( "^9Beginning Of The Journey", "^8Where am I..", "^8..and what does this guy want?", 6, 0.25 );
    gets = level.players;
    foreach( g in gets )
    {
        g playsound( "zmb_sq_navcard_success" );
    }
    level thread while_schruder_speaks();
    level thread schruder_talks_everything_part1();
}


test_powerups()
{
    level endon( "end_game" );
    self endon( "disconnect" );


    flag_wait( "initial_blackscreen_passed" );
    wait 5;

    testers = [];
    testers[ 0 ] = "yellow_nuke";
    testers[ 1 ] = "yellow_double";
    testers[ 2 ] = "red_nuke";
    testers[ 3 ] = "red_double";
    testers[ 4 ] = "red_ammo";
    testers[ 5 ] = "green_nuke";
    testers[ 6 ] = "green_monkey";
    testers[ 7 ] = "green_insta";
    testers[ 8 ] = "green_ammo";
    testers[ 9 ] = "blue_monkey";
    
    x = 0;

    while( true )
    {
        wait 2;
        level specific_powerup_drop( testers[ x ], level.players[ 0 ].origin + vectorScale( ( 0, 0, 1 ), 10 ) );
        if( level.dev_time ){ iprintlnbold( "Powerup: ^3" + testers[ x ]  ); }
        x++;
        if( x >= testers.size ){ x = 0;}
    }
}
/*
switch ( cmd_strings[0] )
    {
        case "yellow_nuke":
        case "yellow_double":
        case "red_nuke":
        case "red_double":
        case "red_ammo":
        case "green_nuke":
        case "green_monkey":
        case "green_insta":
        case "green_double":
        case "green_ammo":
        case "blue_monkey":
            maps\mp\zombies\_zm_devgui::zombie_devgui_give_powerup( cmd_strings[0], 1 );
            break;
        case "less_time":
            less_time();
            break;
        case "more_time":
            more_time();
            break;
        default:
            break;
*/
movemeup()
{
    level endon("end_game" );
    self endon( "death" );
    self endon( "disconnect" );

    while( true )
    {
        self movez( 1000, 1, 0.6, 0 );
        self waittill( "movedone" );
        self movez( -1000, 1, 0.6, 0 );
        self waittill( "movedone" );

    }
}


meeting_vox01( background_music )
{
    level endon( "end_game" );

    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "Hello..";
        subtitle_lower = "Are you able to hear me?";
        duration = 5;
        fadetimer = 1;
        level thread machine_says( "^9Dr. Schruder: ^8" + subtitle_upper, "^8" + subtitle_lower, duration, fadetimer );
       // SchruderSays( subtitle_upper, subtitle_lower, duration, fadetimer );
    }
    

}

meeting_vox02( background_music )
{
    level endon( "end_game" );
    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "My name is Schruder, ^9Dr. Schruder^8.";
        subtitle_lower = "I will be your instructor till our paths separate.";
        duration = 6;
        fadetimer = 1;
        level thread machine_says( "^9Dr. Schruder: ^8" + subtitle_upper, "^8" + subtitle_lower, duration, fadetimer );
       // SchruderSays( subtitle_upper, subtitle_lower, duration, fadetimer );
    }
}

meeting_vox03( background_music )
{
    level endon( "end_game" );
    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "We could try working out something together once the power is restored.";
        subtitle_lower = "Think you can get it turned on by yourself?";
        duration = 7;
        fadetimer = 1;
        level thread machine_says( "^9Dr. Schruder: ^8" + subtitle_upper, "^8" + subtitle_lower, duration, fadetimer );
       // SchruderSays( subtitle_upper, subtitle_lower, duration, fadetimer );
    }
}

meeting_vox04( background_music )
{
    level endon( "end_game" );
    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "Come knock my door once you've turned on the power.";
        subtitle_lower = "It's the green shack here at Bus Depot, '^1X^8' marks the door!";
        duration = 7;
        fadetimer = 1;
        level thread machine_says( "^9Dr. Schruder: ^8" + subtitle_upper, "^8" + subtitle_lower, duration, fadetimer );
       // SchruderSays( subtitle_upper, subtitle_lower, duration, fadetimer );
    }
}


manage_multiple_pieces_new( max_instances )
{
    self.max_instances = max_instances;
    self.managing_pieces = 1;
    self.piece_allocated = [];
}

//THIS TALK HAPPENS WHEN PLAYERS HAVE TURNED ON POWER AND RETURNED BACK TO SCHRUDER FOR MORE INFORMATION
step2_talk()
{
    level endon( "end_game" );
    
    wait 2.5;

    fx_mark = spawn( "script_model", ( -6146.49, 4133.03, -51.875 ) );
    fx_mark setmodel( "tag_origin" );
    fx_mark.angles = ( -90, 0, 0 );
    wait 1;
    playFXOnTag( level._effect["lght_marker"], fx_mark, "tag_origin" );
    wait 0.1;
    playFXOnTag( level._effect["lght_marker_flare"], fx_mark, "tag_origin" );
    wait 1;
    fx_hint_mark = spawn( "trigger_radius_use", fx_mark.origin + ( 0, 0, 10 ), 0,120,120 );
    fx_hint_mark setHintString( "^9[ ^8Come back and knock the door once you've turned on the Power! ^9] " );
    fx_hint_mark setCursorHint( "HINT_NOICON" );
    fx_hint_mark TriggerIgnoreTeam();

    gets = level.players;
    level waittill( "power_on" );
    fx_hint_mark sethintstring( "^9[ ^8Knock on the door.. ^9]" );
    i = 0;
    while( true )
    {
        for( s = 0; s < level.players.size; s++ )
        {
            if( distance2d( level.mr_s.origin, level.players[ s ].origin ) < 200 )
            {
                if( level.players[ s ] meleeButtonPressed() )
                {
                    level notify( "meet_schruder_time_second" );
                    if( level.dev_time ) { iprintln( "SCRUDER WAS MET AFTER TURNING ON THE POWER!" ); }
                    i = 1;
                    wait 0.05;
                    fx_hint_mark delete();
                    fx_mark delete();
                    break;
                }
                
            }
        }
        wait 0.05;
    }
    foreach( g in gets )
    {
        g playsound( "zmb_sq_navcard_success" );
    }
}

mr_s_outside_locations()
{
    flag_wait( "initial_blackscreen_passed" );
    last_location = ( -6404.16, 4072.74, -63.875 );
    last_location_angles = ( 0, 81, 0 );

    outside_door_location = ( -6395.44, 4000.85, -63.875 );
    outside_door_anles = ( 0, 83, 0 );

    inside_start_location = ( -6333.7, 3967.64, -63.875 );
    inside_start_angles = ( 0, 170, 0 );


    knock_schruder_location = ( -6146.46, 4029.84, -51.875 );

    wait 10;
    level.mr_s.origin = knock_schruder_location;

}
schruder_talks_everything_part1()
{
    level endon( "end_game" );
    wait 3;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    meeting_vox01("");
    wait 8;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    meeting_vox02("");
    wait 10;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    meeting_vox03("");
    wait 10;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    meeting_vox04("");
    level notify( "stop_mus_load_bur" );
    wait 10;
    //level notify( "stop_playing_sound" );
    if( level.dev_time ){ iprintln( "STEP 1 TALKS COMPLETED" ); }
    level thread schruder_talks_everything_part2();
}
schruder_talks_everything_part2()
{
    level endon( "end_game" );
    level waittill( "meet_schruder_time_second" );
    
    wait 2;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    meeting_vox07("");
    wait 10;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    meeting_vox08("");
    wait 10;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    meeting_vox09("");
    wait 10;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    meeting_vox10("");
    wait 10;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    meeting_vox11("");
    level.not_doable_yet = false;
    wait 13;
    PlaySoundAtPosition(level.jsn_snd_lst[ 30 ], level.players[ 0 ].origin );
    PlaySoundAtPosition( "mus_zombie_round_start", level.players[ 0 ].origin );
    level thread scripts\zm\zm_transit\warmer_days_sq_rewards::print_text_middle( "^9Obey The Voices", "^8This guy want's me to build us some sort of machine.", "I should start looking for the parts..", 6, 0.25 );
    if( level.dev_time ){ iprintln( "STEP 2 TALKS COMPLETED" ); }
}

meeting_vox07( background_music )
{
    level endon( "end_game" );
    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "Ahh.. Hey again!";
        subtitle_lower = "The power is on, great. Great success!";
        duration = 6; //these need to be changed for longer duration
        fadetimer = 1;
        level thread machine_says( "^9Dr. Schruder: ^8" + subtitle_upper,"^8" +  subtitle_lower, duration, fadetimer );
    }
}

meeting_vox08( background_music )
{
    level endon( "end_game" );
    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "So you're down to help, yes?";
        subtitle_lower = "I remind you that the favor works both ways.";
        duration = 7;
        fadetimer = 1;
        level thread machine_says( "^9Dr. Schruder: ^8" + subtitle_upper, "^8" + subtitle_lower, duration, fadetimer );
       // SchruderSays( subtitle_upper, subtitle_lower, duration, fadetimer );
    }
}

meeting_vox09( background_music )
{
    level endon( "end_game" );
    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "First goal is to restore the power to our ^9Rift Lamps^8.";
        subtitle_lower = "You'll be able to teleport around Ravenholm once the lamps are working!";
        duration = 7;
        fadetimer = 1;
        level thread machine_says( "^9Dr. Schruder: ^8" + subtitle_upper,"^8" +  subtitle_lower, duration, fadetimer );
       // SchruderSays( subtitle_upper, subtitle_lower, duration, fadetimer );
    }
}

meeting_vox10( background_music )
{
    level endon( "end_game" );
    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "The lamps require power from the ^9Pylon ^8that was used by some great heads long time ago..";
        subtitle_lower = "The pylon requires some sort of ^9Navcard Machine^8 to work properly.";
        duration = 7;
        fadetimer = 1;
        level thread machine_says( "^9Dr. Schruder: ^8" + subtitle_upper,"^8" +  subtitle_lower, duration, fadetimer );
       // SchruderSays( subtitle_upper, subtitle_lower, duration, fadetimer );
    }
}

meeting_vox11( background_music )
{
    level endon( "end_game" );
    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "See if you can locate the parts for ^9Navcard Machine^8.";
        subtitle_lower = "Bring the parts underneath pylon and try building the machine once you have all the required pieces!";
        duration = 9;
        fadetimer = 1;
        level thread machine_says( "^9Dr. Schruder: ^8" + subtitle_upper,"^8" +  subtitle_lower, duration, fadetimer );
       // SchruderSays( subtitle_upper, subtitle_lower, duration, fadetimer );
    }
}

meeting_vox12( background_music )
{
    level endon( "end_game" );
    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "See if you can also switch on the machine once you've built it.";
        subtitle_lower = "I'll try to contact you via the reader later!";
        duration = 7;
        fadetimer = 1;
        level thread machine_says( "^9Dr. Schruder: ^8" + subtitle_upper,"^8" +  subtitle_lower, duration, fadetimer );
       // SchruderSays( subtitle_upper, subtitle_lower, duration, fadetimer );
    }
}

meeting_vox13( background_music )
{
    level endon( "end_game" );
    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "Exceeelleeeentt";
        subtitle_lower = "I knew the machine was working when I started to hear beeping in my left ear haha!";
        duration = 7;
        fadetimer = 1;
        level thread machine_says( "^9Dr. Schruder: ^8" + subtitle_upper,"^8" +  subtitle_lower, duration, fadetimer );
    }
}

meeting_vox14( background_music )
{
    level endon( "end_game" );
    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "Did I say my ear? Ha, well my inner circuit board hahaa..";
        subtitle_lower = "..why is nobody laughing at my joke?! What??";
        duration = 7;
        fadetimer = 1;
        level thread machine_says( "^9Dr. Schruder: ^8" + subtitle_upper,"^8" +  subtitle_lower, duration, fadetimer );
    }
}

meeting_vox15( background_music )
{
    level endon( "end_game" );
    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "Hmm.. Hold on a second..";
        subtitle_lower = "Could you try shooting your weapon in the air so that I know that at least you can hear me?";
        duration = 7;
        fadetimer = 1;
        level thread machine_says( "^9Dr. Schruder: ^8" + subtitle_upper,"^8" +  subtitle_lower, duration, fadetimer );
        //the function below monitors the time it takes to be able to access shooting part
        //the function also counts and decreases the global variable till there is no time left.
        level thread stop_for_a_second();
    }
}

stop_for_a_second()
{
    level endon( "end_game" );
    //level.dont_allow_speak_now = true;
    for( i = level.wait_time_left_after_someone_shot; i > 0; i-- )
    {
        wait 1;
        level.wait_time_left_after_someone_shot = i;
        if( level.wait_time_left_after_someone_shot == 0 )
        {
            break;
        }
    }

}

someone_shot()
{
    level endon( "end_game" );
    players = get_players();
    for( i = 0; i < players.size; i++ )
    {
        players[ i ] thread monitor_shot();
    }
}

monitor_shot()
{
    level endon( "someone_shot_weapon" );
    while( true )
    {
        self waittill( "weapon_fired" );
        level notify( "someone_shot" );
        level notify( "someone_shot_weapon" );

    }
}
meeting_vox16( background_music )
{
    level endon( "end_game" );

    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "You can hear me.. Perfect!";
        subtitle_lower = "Maybe the microphone on your tranceiver is dead.";
        duration = 7;
        fadetimer = 1;
        level thread machine_says( "^9Dr. Schruder: ^8" + subtitle_upper,"^8" +  subtitle_lower, duration, fadetimer );
    }
}

meeting_vox17( background_music )
{
    level endon( "end_game" );
    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "Well you should be good as long as you can hear my instructions.";
        subtitle_lower = "The pylon is now sending signals to ^9Rift Lamps^8!";
        duration = 7;
        fadetimer = 1;
        level thread machine_says( "^9Dr. Schruder: ^8" + subtitle_upper, "^8" + subtitle_lower, duration, fadetimer );
    }
}

meeting_vox18( background_music )
{
    level endon( "end_game" );
    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "The lamps now require some power..";
        subtitle_lower = "Try bringing a turbine or something underneath the lamp!";
        duration = 9;
        fadetimer = 1;
        level thread machine_says( "^9Dr. Schruder: ^8" + subtitle_upper,"^8" +  subtitle_lower, duration, fadetimer );
    }
}

meeting_vox19( background_music )
{
    level endon( "end_game" );
    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "I've marked lamps for you that requires fixing.";
        subtitle_lower = "I'll be in touch with you once ^9Rift Lamps ^8are powered!";
        duration = 7;
        fadetimer = 1;
        level thread machine_says( "^9Dr. Schruder: ^8" + subtitle_upper,"^8" +  subtitle_lower, duration, fadetimer );
    }
}

while_schruder_speaks()
{
    level endon( "stop_playing_sound" );
    level.mr_s playsound( level.mysounds[ 9 ] );
    while( true )
    {
        level.mr_s playsound( level.jsn_snd_lst[ 72 ] );
        wait 0.2;
        level.mr_s playsound( level.jsn_snd_lst[ 73 ] );
        wait 2.5;
    }
}

print_level_vars()
{
    flag_wait( "initial_blackscreen_passed" );
    while( true )
    {
        for( i = 0; i < level.zombie_vars.size; i++ )
        {
            iprintln( "^1" + level.zombie_vars[ i ].name );
            wait 1;
        }
        wait 1;
    }
}



define_global_subtitles()
{
    
    level.subtitle_upper = NewHudElem();
	level.subtitle_upper.x = 0;
	level.subtitle_upper.y = -42;
	level.subtitle_upper SetText( "" );
	level.subtitle_upper.fontScale = 1.32;
	level.subtitle_upper.alignX = "center";
	level.subtitle_upper.alignY = "middle";
	level.subtitle_upper.horzAlign = "center";
	level.subtitle_upper.vertAlign = "bottom";
	level.subtitle_upper.sort = 1;
    
	level.subtitle_lower = NewHudelem();
    level.subtitle_lower.x = 0;
    level.subtitle_lower.y = -24;
    level.subtitle_lower SetText( "" );
    level.subtitle_lower.fontScale = 1.22;
    level.subtitle_lower.alignX = "center";
    level.subtitle_lower.alignY = "middle";
    level.subtitle_lower.horzAlign = "center";
    level.subtitle_lower.vertAlign = "bottom";
    level.subtitle_lower.sort = 1;

}


foreach_score()
{
    level endon( "end_game" );
    foreach( p in level.players )
    {
        //p.score += 50000;
    }
}
machine_says( sub_up, sub_low, duration, fadeTimer )
{
    //don't start drawing new hud if one already exists 
    if(  isdefined( level.subtitles_on_so_have_to_wait ) && level.subtitles_on_so_have_to_wait )
    {
        while(  level.subtitles_on_so_have_to_wait ) { wait 0.25; }
    }

    wait 0.1;
    define_global_subtitles();
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
    level.subtitle_upper destroy();
    if( isdefined( level.subtitle_lower ) ) 
    {
        level.subtitle_lower destroy();
    }
    level.subtitles_on_so_have_to_wait = false;
    
}

//this a gay ass hud flyer, still choppy af
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
    //let new huds start drawing if needed
    level.subtitles_on_so_have_to_wait = false;
}


