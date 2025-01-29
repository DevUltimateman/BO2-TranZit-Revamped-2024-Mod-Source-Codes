//not sure yet  if just high thought or what
//but have the player go to town bar
//and theres like 6 different dringks on th e bar counter
//make player dRINK THEM cos he needs to be drunk 
//cos he need to be in state of mind to hear the beeping that reveals
//a secret keycard that is required for pylon to continue
//and the keycard must be in town close
//cos players view and moement is slurred due to alcohol stuff lol
//once they find it
//schruder teleports them underneath the pylon where they can insert it into a machine
//once they do that they suddenly pass out / fade to black
//then wake up and see something different happening dunnno what yet
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


init()
{
    level.get_wasted_bottles = [];
    level.players_can_try = false;
    level.drinks_drank = 0;
    level.drunkness_time = 0;
    level.step_9_possible = false;
    flag_wait( "initial_blackscreen_passed" );
    level thread spawn_bottles_on_the_counter();
    level thread bottles_on_the_counter_logic();
    //level thread mr_s_spawn();
    level thread players_are_not_at_bar();
}

start_drunk_timer()
{
    level endon( "end_game" );
    //level.drunk_effect = false;
    time_to_beat = level.drunkness_time;
    if( level.dev_time ){ iprintlnbold( "DRUNKTIME IN SECONDS ^9" + time_to_beat ); }
    wait 1;
    level.drunk_effect = true;
    for( i = 0; i < time_to_beat; i++ )
    {
        if( level.dev_time ){ iprintlnbold( "TIME LEFT: ^3" + ( time_to_beat - i ) ); }
        wait 1;
    }
    if( level.dev_time ){ iprintlnbold( "DRUNKTIME COMPLETED" ); }
    wait 1;
    foreach( p in level.players )
    {
        p setMoveSpeedScale( 1 );
    }
    level notify( "drunk_state_over" );
}

spawn_bottles_on_the_counter()
{
    level endon( "end_game" );

    level waittill( "spawn_drinks" );
    height_org = ( -11.3314 );
    stair_side_org = ( 254.234 );
    door_side_org = ( 39.7995 );

    bottle_origins = [];
    bottle_origins[ 0 ] = ( 2315.6, stair_side_org, height_org );
    bottle_origins[ 1 ] = ( 2283.79, stair_side_org, height_org );
    bottle_origins[ 2 ] = ( 2250.98, stair_side_org, height_org );
    bottle_origins[ 3 ] = ( 2315.6, door_side_org, height_org ); //-55.875
    bottle_origins[ 4 ] = ( 2283.79, door_side_org, height_org );
    bottle_origins[ 5 ] = ( 2250.98, door_side_org, height_org );

    level.bottle_models = [];
    level.bottle_models[ 0 ] = ( "t6_wpn_zmb_perk_bottle_tombstone_world" );
    level.bottle_models[ 1 ] = ( "t6_wpn_zmb_perk_bottle_doubletap_world" );
    level.bottle_models[ 2 ] = ( "t6_wpn_zmb_perk_bottle_jugg_world" );
    level.bottle_models[ 3 ] = ( "t6_wpn_zmb_perk_bottle_marathon_world" );
    level.bottle_models[ 4 ] = ( "t6_wpn_zmb_perk_bottle_revive_world" );
    level.bottle_models[ 5 ] = ( "t6_wpn_zmb_perk_bottle_sleight_world" );

    wait 1;
    for( s = 0; s < bottle_origins.size; s++ )
    {
        level.get_wasted_bottles[ s ] = spawn( "script_model", bottle_origins[ s ] );
        level.get_wasted_bottles[ s ] setmodel( level.bottle_models[ s ] );
        level.get_wasted_bottles[ s ].angles = ( 0, randomInt( 360 ), 0 );
        wait 0.1;
        playFXOnTag( level.myFx[ 32 ], level.get_wasted_bottles[ s ], "tag_origin" );
    }
    level notify( "bottles_spawned" );

}

bottles_on_the_counter_logic()
{
    level endon( "end_game" );

    level waittill( "bottles_spawned" );
    foreach ( p in level.players )
    {
        p.can_drink_again = true;
    }
    level.players_can_try = true;
    target = randomInt( level.get_wasted_bottles.size );
    for( a = 0; a < level.get_wasted_bottles.size; a++ )
    {
        trig = spawn( "trigger_radius_use", level.get_wasted_bottles[ a ].origin + ( 0, 0, -43 ) , 0, 2, 2 );
        trig setCursorHint( "HINT_NOICON" );
        trig setHintString( "^9[ ^3[{+activate}] ^8to roll the dice on the drink.^9 ]" );
        trig TriggerIgnoreTeam();
        trig UseTriggerRequireLookAt();
        trig thread delete_in_case_not_hit();
        wait 0.05;
        if( a == target )
        {
            trig.is_the_correct_drink = true;
            wait 0.05;
            trig thread wait_for_player_to_gamble();
            if( level.dev_time ){ playfx( level.myfx[ 1 ], trig.origin ); } //debug fx to reveal correct drink from the table
        }
        else if ( a != target )
        {
            trig.is_the_correct_drink = false;
            wait 0.05;
            trig thread wait_for_player_to_gamble();
        }
        wait 0.05;
    }

    foreach( b in level.get_wasted_bottles )
    {
        b movez( 3, 0.1, 0, 0 );
        b waittill( "movedone" );
    }
}

wait_for_player_to_gamble()
{
    level endon( "end_game" );
    //level endon( "stop_drinking_logic" );
    while( true )
    {
        self waittill( "trigger", who );
        if( !is_player_valid( who ) )
        {
            wait 0.1;
            continue;
        }
        else if ( is_player_valid( who ) && level.players_can_try && who.can_drink_again )
        {
            if( isdefined( self.is_the_correct_drink ) && !self.is_the_correct_drink )
            {
                changer = who GetMoveSpeedScale();
                level.drunkness_time += 15;
                who.can_drink_again = false;
                who setMoveSpeedScale( changer + ( -0.1 ) ); 
                if( level.dev_time ){ iprintlnbold( "SPEEDSCALE" + changer + ( -0.1 ) ); }
                PlaySoundAtPosition( "zmb_elec_jib_zombie" , who.origin );
                level.drinks_drank++;
                notify_on_drinks();
                
                self sethintstring( "" );
                who thread do_drink_animation();
                wait 1.5;
                who playsound(   level.jsn_snd_lst[ 68 ] );
                self setHintString( "^9[ ^8Drink contained ^1heavy dose of alcohol..^8 Survivor's stamina reduced for a certain period of time. ^9]" );
                who thread reduce_stamina_for_certain_time();
                //sfx
                who playSound( level.jsn_snd_lst[ 91 ] );
                PlaySoundAtPosition(level.jsn_snd_lst[ 91 ], who.origin );
                wait 0.1;
                PlaySoundAtPosition(level.jsn_snd_lst[ 34 ], who.origin );
                wait 2;
                self delete();
                break;
            }
            else if( isdefined ( self.is_the_correct_drink ) && self.is_the_correct_drink )
            {
                level.players_can_try = false;
                if( level.drunkness_time < 30 )
                {
                    level.drunkness_time = 30;
                }
                level notify( "move_s_to_middle" );
                //level.drinks_drank++;
                PlaySoundAtPosition("zmb_elec_jib_zombie" , who.origin );
                self sethintstring( "" );
                who thread do_drink_animation();
                wait 1.5;
                self setHintString( "^9[ ^8The drink contained some ^9antidote^8. ^9]" );
                PlaySoundAtPosition(level.jsn_snd_lst[ 4 ], who.origin );
                level notify( "stop_drinking_logic" );
                wait 0.1;
                level thread move_drinks_here_once_correct_found();
                
                wait 2;
                self delete();

                break;
            }
        }
        wait 0.05;
    }
}
delete_in_case_not_hit()
{
    level endon( "end_game" );
    level waittill( "stop_drinking_logic" );
    if( isdefined( self ) ){ self delete(); }
}
move_drinks_here_once_correct_found()
{
    level endon( "end_game" );
    loc = ( 2290.06, 142.108, 30.5524 );
    earthquake( 0.5, 2.5, loc, 1000 );
    wait 1.5;
    foreach( b in level.get_wasted_bottles )
    {
        b moveTo( loc, 2, 0.5, 0.5 );
        b waittill( "movedone" );
        PlaySoundAtPosition( level.jsn_snd_lst[ 71 ], b.origin );
        playfx( level._effects[ 77 ], b.origin );
        wait 0.05;
        b delete();
    }
    foreach( p in level.players )
    {
        p thread do_drunk_effect();
    }
    wait 1;
    setdvar( "g_ai", true );
    level thread start_drunk_timer();
}
do_drink_animation()
{
    level endon( "end_game" );
    current_w = self getCurrentWeapon();
    self giveWeapon( "zombie_perk_bottle_tombstone" );
    self switchToweapon( "zombie_perk_bottle_tombstone" );
    wait 2;
    self playSound( level.jsn_snd_lst[ 68 ] );
    wait 1;
    self playsound( "vox_plr_0_exert_burp_0" );
    wait 1.1;
    self maps\mp\zombies\_zm_weapons::switch_back_primary_weapon( current_w );
    self takeWeapon( "zombie_perk_bottle_tombstone" );
    self playsound( "evt_bottle_dispense" );
    self.can_drink_again = true;
}
reduce_stamina_for_certain_time()
{
    level endon( "end_game" );
    //iPrintLnBold( "THIS WAS NOT THE CORRECT DRINK!!!" );
}


players_are_not_at_bar()
{
    level endon( "end_game" );
    level endon( "player_at_bar" );
    mod = spawn( "script_model", ( 2286.58, 146.752, -55.875 ) );
    mod setmodel( "tag_origin" );
    mod.angles = ( 0, 0, 0 );
    wait 0.05;
    while( true )
    {
        if( !level.step_9_possible )
        {
            wait 1;
            continue;
        }
        else if( level.step9_possible )
        {
            for( a = 0; a < level.players.size; a++ )
            {
                if( level.players[ a ] get_current_zone() == "zone_bar" && distance( level.players[ a ].origin, mod.origin ) < 350 )
                {
                    
                    level thread mr_s_spawn();
                    mod delete();
                    if( level.dev_time ){ iprintlnbold( "SOMEONE IS AT BAR" ); }
                    level notify( "player_at_bar" );
                }
                else if( level.players[ a ] get_current_zone() != "zone_bar" || level.players[ a ] get_current_zone() == "" )
                {
                    wait 0.1;
                }
            }
        }
        wait 0.05;
    }
}

bleep_thread()
{
    level endon( "end_game" );
    self endon( "disconnect" );
    for( i = 0; i < 4; i++ ) 
    { 
        self playSound( level.jsn_snd_lst[ 20 ] );
        wait 0.5;
    } 
}
mr_s_spawn()
{
    level endon( "end_game" );
    middle_barcounter = ( 2286.58, 146.752, -55.875 );
    foreach( s in getAIArray( level.zombie_team ) )
    {
        s dodamage( self.health + 555, self.origin );
    }
    
    mr_s = spawn( "script_model", middle_barcounter );
    mr_s setmodel( level.automaton.model );
    mr_s.angles = ( 0, 270, 0 );
    wait 0.05;
    PlaySoundAtPosition("zmb_box_poof", mr_s.origin );
    earthquake( 0.6, 3, mr_s.origin, 1000 );
    level thread dialogs_for_bar_step();
    playfx( level._effects[ 77 ], middle_barcounter );
    wait 0.05;
    foreach( s in level.players ){ s thread bleep_thread(); }
    setdvar( "g_ai", false );
    degree_tagger = spawn( "script_model", mr_s.origin );
    degree_tagger setmodel( "tag_origin" );
    degree_tagger.angles = ( 180, 0, 0 );

    playfxontag( level._effect[ "screecher_hole" ], degree_tagger, "tag_origin" );
    wait 0.1;
    playfxontag( level._effect[ "screecher_vortex" ], degree_tagger, "tag_origin" );
    degree_tagger enableLinkTo();
    degree_tagger linkto( mr_s );
    playfxontag( level._effect[ "screecher_vortex" ], mr_s, "tag_origin"  );
    wait 0.05;
    degree_tagger enablelinkto();
    degree_tagger linkto( mr_s );
    playfxontag( level.myFx[ 57 ], mr_s, "tag_origin" );
    //playfxontag(level._effect[ "screecher_hole" ], mr_s, "tag_origin" );
    mr_s movez( 5, 3, 0.1, 1 );
    mr_s playLoopSound( "zmb_screecher_portal_loop", 2 );
    wait 1.85;
    foreach( p in level.players )setdvar( "g_ai", false );
    {
        p playSound( "mus_zombie_game_over" ); //mus_zombie_game_over
    }
    wait 1.5;
    mr_s playloopsound( "zmb_perks_machine_loop", 2 );
    mr_s thread move_around();
    wait 1;
    //to collect drinks upon drinking right drink
    mr_s thread move_to_middle( middle_barcounter,  ( 0, 270, 0 ), degree_tagger );
}

do_drunk_effect()
{
    level endon( "end_game" );
    self endon( "disconnect" );
    self thread fadeForAWhile( 0, 1, 0.5, 0.5, "black" );
    wait 0.8;
    self setclientdvar( "r_poisonfx_debug_enable", true );
    self setclientdvar( "r_poisonfx_dvisisionx", 4 );
    self setclientdvar( "r_poisonfx_pulse", 1 );
    self setclientdvar( "r_poisonfx_blurmax", 1 );

    level waittill( "drunk_state_over" );
    self thread fadeForAWhile( 0, 1, 0.5, 0.5, "black" );
    wait 0.8;
    self setclientdvar( "r_poisonfx_debug_enable", false );
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

move_to_middle( middle,  middle_ang , deg )
{
    level endon( "end_game" );
    level waittill( "move_s_to_middle" );
    level notify( "stop_moving" );
    self moveto( middle, 1, 0.1, 0.4 );
    self rotateto( middle_ang, 1, 0.1, 0.2 );
    self waittill( "movedone" );
    w = 2;
    for( i = 0; i < 12; i++ )
    {
        self rotateyaw( 360, w, 0.1, 0.1 );
        wait w;
        w -= 0.1475;
    }
    PlaySoundAtPosition( "zmb_box_poof", self.origin );
    self stopLoopSound();
    playfx( level._effects[ 77 ], self.origin );
    self delete();
    wait 0.1;
    deg delete();
}
move_around()
{
    level endon( "end_game" );
    level endon( "move_s_to_middle" );
    level endon( "stop_moving" );
    lola = [];
    lolas = [];
    lola[ 0 ] = ( 2284.7, 217.499, -55.875 ); //stairside
    lola[ 1 ] = ( 2286.58, 146.752, -55.875 ); //middle
    lola[ 2 ] = ( 2281.04, 74.9871, -55.875 ); //doorside


    lolas[ 0 ] = ( 0, -180, 0 ); //stairside
    lolas[ 1 ] = ( 0, 270, 0 ); //middle
    lolas[ 2 ] = ( 0, 0, 0 ); //doorside

    hover_up = 15;
    hover_down = -15;
    qw = 1;
    ww = 0.25;
    hover_mode = false;
    move_mode = true;
    has_to_rotate = false;
    current_loc = 1;
    while( true )
    {
        if( !hover_mode && move_mode )
        {
            for( s = 0; s < 7; s++ )
            {
                self movez( hover_up, qw, ww, ww ); 
                self waittill( "movedone" );
                PlaySoundAtPosition(level.jsn_snd_lst[ 73 ], self.origin );
                self movez( hover_down, qw, ww, ww );
                self waittill( "movedone" );
            }

            if( !has_to_rotate )
            {
                move_mode = true;
                has_to_rotate = true;
                x = randomInt( lola.size );
                if( current_loc == x )
                {
                    while( x == current_loc )
                    {
                        x = randomInt( lola.size );
                        wait 0.05;
                    }
                }
                self rotateto( lolas[ x ], 2, 0.25, 0.25 );
                PlaySoundAtPosition( level.jsn_snd_lst[ 73 ], self.origin );
                wait 0.05;
                PlaySoundAtPosition(level.jsn_snd_lst[ 105 ], self.origin );
                wait 2;
                self moveto( lola[ x ], 2.5, 0.25, 0.25 );
                PlaySoundAtPosition( level.jsn_snd_lst[ 73 ], self.origin );
                self waittill( "movedone" );
                move_mode = false;
                has_to_rotate = false;
                hover_mode = true;
                current_loc = x;
            }
        }

        if( hover_mode && !move_mode )
        {
            x = randomint( 50 );
            if( x < 20 )
            {
                hover_mode = false;
                move_mode = true;
            }
            else 
            {
                s = randomintrange( -360, 360 );
                self movez( hover_up, qw, ww, ww ); 
                self rotateYaw( s, qw, ww, ww );
                self waittill( "movedone" );
                self movez( hover_down, qw, ww, ww );
                self rotateYaw( s, qw, ww, ww );
                self waittill( "movedone" );
            }
        }
        wait 0.05;
    }
}


dialogs_for_bar_step()
{
    level endon( "end_game" );
    //level waittill( "player_at_bar" );
    wait 2;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    do_dialog_here_too( "^8Well hello again my friend!", "^8Glad to see you doing fine..", 7, 1 );
    wait 10;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    do_dialog_here_too( "I wanted to throw a party for you for your achievements!", "^8You've been a great help and I've never come across survivors like you..", 10, 1 );
    wait 13;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    do_dialog_here_too( "^8Here, come closer to the counter!", "^8The drinks are on me.. Feel free to pick any one of em!", 7, 1 );
    PlaySoundAtPosition(level.jsn_snd_lst[ 30 ], level.players[ 0 ].origin );
     PlaySoundAtPosition( "mus_zombie_round_start", level.players[ 0 ].origin );
    level thread scripts\zm\zm_transit\warmer_days_sq_rewards::print_text_middle( "^9Drink Responsibly", "^8Drinking this random guy's mixes?", "For this time, why not.", 6, 0.25 );
    level notify( "spawn_drinks" );
    wait 3;
    while( level.players_can_try )
    {
        wait 1;
    }
    wait 1.5;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    do_dialog_here_too( "^8Hahaa, look what you've done!", "^8You drank too much you cheeky bastard!", 7, 1 );
    wait 11;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    do_dialog_here_too( "^8I'll be in touch with you once you've sobered up.", "^8Watch out, you might be a bit stubmly now haha. Bye bye!", 7, 1 );
}

notify_on_drinks()
{
    if( level.drinks_drank == 2 )
    {
        do_dialog_here_too( "^8Good old brew..", "^8How about another one?", 2, 0.1 );
    }

    if( level.drinks_drank == 3 )
    {
        do_dialog_here_too( "^8Few don't seem to cause a problem.. ha!", "^8You're quite good at it!", 2.5, 0.1 );
    }

    if( level.drinks_drank == 5 )
    {
        do_dialog_here_too( "^8What?!", "^8Chugging them down like a champion!", 2, 0.1 );
    }
}


do_dialog_here_too( sub_up, sub_low, duration, fader )
{
    durations = duration;
    fadetimer = fader;
    level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says( "^9Dr. Schruder: ^8" + sub_up, "^8" + sub_low, durations, fadetimer );
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
    level.subtitles_on_so_have_to_wait = false;
}

