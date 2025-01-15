//codename: wamer_days_mq_03_spirit_of_sorrow
//purpose: handles the first real main quest step ( players must follow schruder's light bulb )
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

init()
{
    //((level thread delete_after_initial();
    //level.dev_time = true;
     //can we do a new hover?
    level.spirit_hovers = false;
    //can we move him again?
    level.spirit_moves = false;

    level.spirit_of_sorrow_step_active = false;
    //mr_schruder points of interests
    level.spirit_locations = [];
    level.spirit_step_active = false;
    //tower to mr_schruder ground poi [0]
    level.fxtower = [];

    //for players who connect during the spirit moment
    level.bypass_visual_check = false;

    //locations for thunderfx during spirit
    level.thunder_s_loc = [];
    //entities during thunder spirit
    //level.thunderplayer = [];
    //nacht fx locs
    level.nacht_power_fx_event = [];
    //wait till initial blackscreen, then execute thread
    level thread waitflag();
    //all .level origin for this file
    global_locations();
    //all .level array & bools
    global_bools_arrays();
    
}

//{
   // flag_wait( "initial_blackscreen_passed" );
    //build_shield_trigger = getent( "9ACCC1A5", "guid" ); //&&"buildable_riotshield"
    //build_etrap_trigger = getent( "8D113EEA", "guid" );


    //build_shield_models = getentarray(/)
    //old_shield_trigger_origin = build_shield_trigger.origin;
   // new_shield_trigger_origin = build_etrap_trigger.origin;


    //old_etrap_trigger_origin = build_etrap_trigger.origin;
    //new_etrap_trigger_origin = build_shield_trigger.origin;


   // build_shield_trigger.origin = build_shield_trigger.origin + ( 10000, 0, 0 );
    //build_etrap_trigger.origin = new_etrap_trigger_origin;

   // iprintln( "ALL SET" );
    
   // etrap = getEnt( "buildable_trap", "targetname" );
   // if( etrap.model == "p6_anim_zm_buildable_etrap" &&
   //      etrap.origin == (  11332.5, 8171, -444.5 )  )
   //     {
   //         //we can also show the model while its hidden. the etrap is always on top of the table, its just not shown till build flag is set.
   //         etrap show();
   //         iprintln( "Made the etrap visible" );
    //    }

   // etrap_trigger = getent( "trigger_use", "classname" );
    //I believe triggers have "invisible cell" signed as the model, lets see if we can make it visible lol
   // if( etrap_trigger.guid == "8D113EEA" )
   // {
   //     etrap_trigger show();
   //     iprintln( "^2We also made the trigger visible to an eye" );
   // }
    //&&mod = getent( "script_model", "classname" )
    //if( mod.model == )

    //lets make bus depot trucks huuuuge
  //  cabs = getentarray( "script_struct", "classname" );
  //  foreach( cab in cabs )
  /*
    {
        if( cab.model == "veh_t6_civ_microbus_dead" )
        {
            cab.modelscale = 2.5;
            iprintln( "Just scaled " + cab + " to ^3" + cab.modelscale );
        }
    }
    */


//dbg press ads to shoot orbs above nach fx
    //level thread debug_nacht_shooter();
        //level.players[ 0 ] setOrigin( debug_tower_spawn() );
waitflag()
{
    level endon( "end_game" );
    flag_wait( "initial_blackscreen_passed" );

    //step 1
    level waittill( "move_into_spirit_of_sorrow" );
    level.rock_summoning_step_active = false;
    wait 0.05;
    level.spirit_step_active = true;
    level thread monitor_players(); //disabled for now. dont want to go underneath pylon and start follow spirit step while testing other stuff.
    level waittill( "players_obey" ); //all players gathered together underneath the pylon
    level thread playloop_nuked();
    //step 2
    level thread follow_the_spirit_visuals(); //visual effect for step2
    level thread shoot_orbs(); // shoots orbs from the top of pylon towards the center of it
   // level thread spirit_thunder_locations(); //thunder fx while doing this step
    
    level waittill( "orbs_on_ground" ); //waiting for orbs to "touch" ground
    level thread spawn_spirit(); //spawn the spirit that players should follow
    level waittill( "spirit_ready" ); //waiting for all spirit stuff to be initialized
    level thread follow_spirit(); //handles the interaction logic with spirit & players and plays the proper text dialog
    level waittill( "orb_at_nacht" ); //notify once spirit reaches it's end goal
    level notify( "stop_nuked_sound" );

    //step3
    level thread nacht_shooter(); //shoot array of spirits from nacht roof
    level.spirit_step_active = false;

    level waittill( "lockdown_disabled" ); //debug to not let this go past
    
    foreach( play in level.players )
    {
        play thread tranzit_2024_visuals();
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
    self setclientdvar( "cg_fovscale", 1.15  );
    self setclientdvar( "r_lighttweaksunlight", 12 );
    self setclientdvar( "r_lighttweaksuncolor", ( 0.62, 0.52, 0.46 ) );
    self setclientdvar( "r_lighttweaksundirection", ( -155, 63, 0 ) );

    self setclientdvar( "vc_rgbh", "0.3 0.2 0.2 0" );
   self setclientdvar( "vc_rgbl", "0.1 0.05 0.05 0" );
}
playloop_nuked()
{
    level endon( "end_game" );
    level endon( "stop_nuked_sound" );

        foreach( p in level.players )
        {
            p playsound( "mus_load_zm_nuked_patch" );
            
        }
}
spirit_thunder_locations()
{
    
    level.thunder_s_loc[ 0 ] = ( 7945.49, -419.728, 7468.53 );
    thunders = [];
    wait 0.05;
    for( i = 0; i < level.thunder_s_loc.size; i++ )
    {
        thunders[ i ] = spawn( "script_model", level.thunder_s_loc[ i ] );
        thunders[ i ] setmodel( "tag_origin" );
        wait 0.05;
    }

    for( s = 0; s < thunders.size; s++ )
    {
        playfxontag( level.myFx[ 83 ], thunders[ s ], "tag_origin" );
        thunders[ s ] thread spin_me();
        wait 0.05;
    }
    level waittill( "destroy_clouds" );
    wait 0.1;
    foreach( isser in thunders )
    {
        isser delete();
    }
}

//thunder spinner
spin_me()
{
    level endon( "destroy_clouds" );
    while( true )
    {
        self rotateyaw( 360, 3, 0, 0 );
        self waittill( "movedone" );
    }
}

//tempoerary subtitles -to see how long each segment should take place
return_spirit_textline( switcher )
{
    index = switcher;
    switch( index )
    {
        case 1:
            u_ = "^8Hi there! ";
            d_ = "^8Where did that old fart go..?!"; 
            foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
            level thread spirit_says( u_, d_, 8, 1 );  
            break;

        case 4:
            u_ = "^8What are you doing here anyways?!";
            d_ = "^8Now listen up.";
            foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
            level thread spirit_says( u_, d_, 3, 0.2 );
            break;

        case 5:
            u_ = "^8I'm here to make sure that Dr. Schruder does not return.";
            d_ = "^8From now on you'll be helping me.";
            foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
            level thread spirit_says( u_, d_, 5, 1 );
            break;

        case 9:
            u_ = "^8A bit slow, aren't we?";
            d_ = "^8Get following, we got things to do!";
            foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
            level thread spirit_says( u_, d_, 8, 1 );
            break;

        case 14:
            u_ = "^8You know..";
            d_ = "^8You're slower than you look!";
            foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
            level thread spirit_says( u_, d_, 5, 1 );
            break;
        
        case 18:
            u_ = "^8Ah, I'm just playing around";
            d_ = "^8";
            foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
            level thread spirit_says( u_, d_, 7, 1 );
            break;

        case 22:
            u_ = "^8See ya!";
            d_ = "^8You were too slow ha.";
            foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
            level thread spirit_says( u_, d_, 5, 0.3 );
            break;

        default:
            break;
    }
}

follow_spirit()
{
    level endon( "end_game" );

    //first 3 moves are non monitored
    for( i = 1; i < 4; i++ )
    {
        //play a woosh fx for launch movement
        //playsound
        level.o_spirit moveto( level.spirit_locations[ i ], randomFloatRange( 3, 3.4 ), 0.4, 0.1 );
        level thread return_spirit_textline( i );
        level.o_spirit waittill( "movedone" );
    }
    PlaySoundAtPosition("wpn_jetgun_effect_plr_end", level.o_spirit.origin );
    PlaySoundAtPosition( "mus_zombie_round_start", level.o_spirit.origin );
    level thread scripts\zm\zm_transit\warmer_days_sq_rewards::print_text_middle( "^9Spirit Of Sorrow", "^8Finally met Dr. Schruder but where did he go and who's this flying thing?", "Maybe I should try to catch it.", 6, 0.25 );
    //hover till player is near the orb
    level.o_spirit thread hover_orb();
    while( player_is_away() )
    {
        wait 0.2;
    }
    //stop hovering
    level.o_spirit notify( "s_hover" );
    
    //points to skip touch check
    to_skip = false;
    // to know when to break from for loop
    final_dest = level.spirit_locations.size;
    //return back to mover array
    for( s = 4; s < level.spirit_locations.size; s++ )
    {
        //play a woosh sound for launch sound
        //playsound
        level thread return_spirit_textline( s );

        //these are "non touchable" level.spirit_locations[ key ] spots where we need to move the orb without player initiating the "push / fly in"
        if( s == 8 || s == 15 || s == final_dest || s == 24 || s == 23 || s == 22 || s == 21 || s == 20 || s == 19  )
        {
            to_skip = true;
        }
        PlaySoundAtPosition( "wpn_jetgun_effect_plr_start", level.o_spirit.origin );
        level.o_spirit moveto( level.spirit_locations[ s ], randomfloatrange( 1, 1.4 ), 0.2, 0.2 );
        level.o_spirit waittill( "movedone" );
        PlaySoundAtPosition("wpn_jetgun_effect_plr_end", level.o_spirit.origin );
        if( !to_skip )
        {
            level.o_spirit thread hover_orb();
            while( player_is_away() )
            {
                wait 0.1;
            }
            level.o_spirit notify( "s_hover" );
            
        }
        to_skip = false;
        wait 0.05;
    }

    //let the fireworks fly & move to the next step
    level notify( "orb_at_nacht" );
    level notify( "stop_looking" );
    //let's delete the orb
    level.o_spirit delete();
}

debug_tower_spawn()
{
    location = ( 7919.64, -975.906, -89.834 );
    return location;
}


follow_the_spirit_visuals()
{
    level endon( "end_game" );
    level.bypass_visual_check = true;
    for( i = 0; i < level.players.size; i++ )
    {
        level.players[ i ] thread initial_spirit_visual();
        level.players[ i ] setclientdvar( "r_lighttweaksuncolor", "0.2 0 0.4" );
        level.players[ i ] setclientdvar( "vc_fsm", "1 1 1 1" );
        level.players[ i ] setclientdvar( "r_filmusetweaks", 1 );
        level.players[ i ] setclientdvar( "r_sky_intensity_factor0", 4 );

        level.players[ i ] setclientdvar( "r_skyTransition", 0.5 );
        level.players[ i ] setclientdvar( "r_skyColorTemp", 12500 );
        level.players[ i ] setclientdvar( "cg_colorscale", "0.2 0.1 0.9" );
        level.players[ i ] setclientdvar( "r_fog", 1 );
        
    }
    wait 3;
    level.bypass_visual_check = false;

    for( i = 0; i < level.players.size; i ++ )
    {
        //enable back later
        //level.players[ i ] thread fog_cheater();
    }
    //while the spirit even is happening
    /*
    while( level.follow_the_spirit )
    {
        level waittill( "connected", player );
        player thread set_spirit_follow_visuals();
    }
    */
}

/* 
 purpose: fog has to stay on, even when disabled during the follow spirit step
 */
fog_cheater()
{
    level endon( "stop_looking" );
    is_fog = getdvarint( "r_fog" );
    while( true )
    {
        self setClientDvar( "r_fog", true );
        wait 0.05;
    }
}
set_spirit_follow_visuals()
{
    self endon( "disconnect" );
    level endon("end_game" );
    
    //if player is already in game when this event happens
    if( level.bypass_visual_check )
    {
        //self thread initial_spirit_visual();
        
        //self setclientdvar( "")
        /* self setclientdvar

        self setclientdvar
        self setclientdvar
        self setclientdvar
        self setclientdvar
        self setclientdvar
        self setclientdvar
        self setclientdvar */
    }
    //make sure that all game specific visuals gets applied before we apply ours and not afterwards when this thread is run at
    //when new player onnects in and the event is happening / ongoing
    else
    {
        self waittill( "spawned_player" );
        self setclientdvar( "r_lighttweaksuncolor", "0.2 0 0.4" );
        self setclientdvar( "vc_fsm", "1 1 1 1 " );
        self setclientdvar( "r_filmusetweaks", 1 );
        self setclientdvar( "r_sky_intensity_factor0", 4 );

        self setclientdvar( "r_skyTransition", 0.5 );
        self setclientdvar( "r_skyColorTemp", 12500 );
        self setclientdvar( "cg_colorscale", ( 1, 1, 1 ) );
        //self setclientdvar( "", 0 );
    }
}

//let's bounce this before we set other clientdvars that control the visuals during this ee step.
initial_spirit_visual()
{
    level endon( "end_game" );
    self endon( "disconnect" );
    for( i = 0; i < 32; i++ )
    {
        self setclientdvar( "cg_colorsaturation", 0 );
        wait 0.1;
        self setclientdvar( "cg_colorsaturation", 1 );
        if( i % 2 == 0 )
        {
            x = 0.05;
        }
        else if ( i % 2 != 0 )
        {
            x = 0.1;
        }

        wait x;
    }
    self setclientdvar( "cg_colorsaturation", 1 );
}

player_is_away()
{
    level endon( "end_game" );
    for( i = 0; i < level.players.size; i++ )
    {
        if( distance( level.players[ i ].origin, level.o_spirit.origin ) < 200 )
        {
            return false;
        }
        else { return true; }
    }
}

players_are_here()
{
    //if all players touch
    real_deal = level.players.size;
    reaching = 0;
    zone_to_touch = getent( "sq_common_area", "targetname" );
    for( i = 0; i < level.players.size; i++ )
    {
        if( distance ( level.players[ i ].origin, zone_to_touch.origin ) < 200 ) 
        {
            reaching++;
        }
    }
    wait 2.5;
    //if all players are touching the zone
    if( reaching >= real_deal ) { return true; }
    //all players didnt touch the shit simultaneously
    else { reaching = 0; return false; }
}

spawn_spirit()
{
    level endon( "end_game" );
    
    level.o_spirit = spawn( "script_model", level.spirit_locations[ 0 ] );
    level.o_spirit setmodel( "tag_origin" );
    level.o_spirit.angles = level.o_spirit.angles;
    wait 0.05;
    playFXOnTag( level.myFx[ 2 ], level.o_spirit, "tag_origin" );
    level notify( "spirit_ready" );
    level.o_spirit playloopsound( "zmb_screecher_portal_loop", 2 );
    wait 0.1;
    playfxontag( level.myfx[ 1 ], level.o_spirit, "tag_origin" );
    wait 1;
    playfxontag( level.myfx[ 2 ],level.o_spirit,"tag_origin");
}

debug_spirit_locations()
{
    level endon( "end_game" );
    wait 6;
    iprintlnbold( "LOCATIONS" + level.spirit_locations.size );
    wait 2;
    iprintlnbold( "GOING TO PRINT ALL LOCATIONS FROM LEVEL LIST" );
    wait 2;
    for( i = 0; i < level.spirit_locations.size; i++ )
    {
        iprintlnbold( "LOCATION " + i + " / " + level.spirit.locations.size + " ^3location ^7" + level.spirit_locations[ i ] );
        wait 0.5;
    }
}

hover_orb()
{
    level endon( "end_game" );
    level endon( "s_hover" );
    self endon( "s_hover" );
    while( true )
    {
        self movez( 50, 0.8, 0, 0 );
        self waittill( "movedone" );
        self movez( -50, 0.8, 0, 0 );
        self waittill( "movedone" );
    }
}

/* 
purpose:
orbs form a spirit underneath the pylon for the spirit_of_sorrow step
 */
shoot_orbs()
{
    level endon( "end_game" );

    temp_mover = [];
    for( i = 0; i < level.fxtower.size; i++ )
    {
        temp_mover[ i ] = spawn( "script_model", level.fxtower[ i ] );
        temp_mover[ i ] setmodel( "tag_origin" );
        temp_mover[ i ].angles = ( 0, 0, 0 );
    }
    wait 0.1;
    //play spawn sound here
    //playsound
    for( s = 0; s < temp_mover.size; s++ )
    {
        playfxontag( level.myFx[ 1 ], temp_mover[ s ], "tag_origin" );
        //playsoundatposition( "", temp_mover[ s ])
    }

    for( i = 0; i < temp_mover.size; i++ )
    {
        temp_mover[ i ] thread orb_moveto(level.spirit_locations[ 0 ], randomFloatRange( 1, 2.2 ), 0, 0.3 );
    }
    wait 2.3;
    
    foreach( s in temp_mover )
    {
        s delete();
    }
    //play box poof sound here
    //playsound
    level notify( "orbs_on_ground" );
}

orb_moveto( location, duration, acc, dec )
{
    self moveto( location, duration, acc, dec );
}

debug_nacht_shooter()
{
    level.players[ 0 ] endon( "disconnect" );
    level endon( "end_game" );

    while( true )
    {
        if ( level.players[ 0 ] adsButtonPressed() )
        {
            wait 1;
            iprintlnbold( "SHOOTING ORBS NOW" );
            level thread nacht_shooter();
        }
        wait 0.1;
    }
}
/* 
purpose:
returns vector
 */
world_dir( angles, multiplier )
{
    x = angles[ 0 ] * multiplier;
    y = angles[ 1 ] * multiplier;
    z = angles[ 2 ] * multiplier;
    return ( x, y, z );
}


/* 
purpose: 
shoot fxs to random directions when the spirit reaches nacht
 */
nacht_shooter()
{
    
    //angles mindset
    //first offset = how tilted up / downwards
    //second offset = which direction ( in yaw? )
    //third offset = roll? we can leave it to zero since no roll effect required

    for( i = 0; i < 25; i++ )
    {
        temper = spawn( "script_model", level.nacht_power_fx_event[ randomint( level.nacht_power_fx_event.size -3 ) ] );
        temper.angles = ( /* randomint( 360 ),  randomint( 270 ) */randomIntRange(270, 350 ), randomInt(360), 0 ); 
        temper setmodel( "tag_origin" );

        wait randomfloatrange( 0.05, 0.07 );
        rnd = choose_random_redblue();
        playFXOnTag( level.myfx[ rnd ], temper, "tag_origin" );
        wait 0.05;

        //define a random location to shoot the orb to from fx_event.size -3
        start_loc = temper.origin;
        to_forward = anglesToForward( temper.angles );
        shoot_somewhere = start_loc + world_dir( to_forward, 18000 );

        //let's shoot the orb now
        temper thread orb_moveto( shoot_somewhere, 6, 1, 0 );
        //make sure we failsafe delete the entity upon reaaching it's goal
        temper thread delete_upon_goal();
    }

    //spirit follow step done
    level notify( "obey_spirit_complete" );
}

choose_random_redblue()
{
    x = randomInt( 2 );
    if( x >= 1 )
    {
        return x;
    }
    return x;
}

delete_upon_goal()
{
    level endon( "end_game" );
    self waittill( "movedone" );
    self delete();
}

monitor_players()
{
    level endon( "end_game" );

    wait 1;
    
    players_touching = 0;
    //goal = level.players.size;
    //spawn the trigger
    loc = level.spirit_locations[ 0 ];
    /*

    trig = spawn( "trigger_radius", loc, 40, 40, 40 );
    wait 0.1;
    trig setHintString( "Requires more ^3survivors ^7to be present" );
    trig setCursorHint( "HINT_NOICON" );
    wait 0.1;
    */
    test = ( -6923.5, 4194.83, -63.8666 );
    mods = spawn( "script_model", loc);
    mods setmodel( "tag_origin" );
    mods.angles = ( -270, 0, 0 );
    wait 0.1;
    //playfxontag( level._effect[ "lght_marker" ], mods, "tag_origin" );
    
    //playfx( level._effect[ "lght_marker" ], mods.origin );
    cust_trig = spawn( "trigger_radius", loc, 48, 48, 48 );
    cust_trig setHintString( "^8Requires more ^9survivors ^8to be present!" );
    cust_trig setCursorHint( "HINT_NOICON" );
    
    //all players must stand in the sq common area before we proceed.
    //players_are_here() checks if all players in the game are touching level.sq_volume entity
    while( !players_are_here() )
    {
        wait 1;
    }

    if( level.dev_time ){ iprintlnbold( "PLAYER TOUCHED THE TRIGGER, CONTINUE IN QUEST" ); }
    mods delete();
    cust_trig delete();
    level.spirit_step_active = true;
    level.spirit_of_sorrow_step_active = true;
    level notify( "players_obey" );

    wait 2.5;
    
    
}


schruder_rise( latitude, duration, smooth_factor, smooth_factor_out )
{
    level endon( "end_game" );
    
    //keep track if we are hovering
    if( level.spirit_hovers )
    {
        if( level.dev_time ){ iPrintLnBold( "SCHRUDER IS STILL HOVERING, PAUSING THE CALL TILL ITS SAFE AGAIN" ); }
        wait 1;
        self waittill( "im_allowed_to_levitate" );
    }

    else if( !level.spirit_hovers )
    {
        if( isdefined( smooth_factor_out ) )
        {
            if( smooth_factor_out < 1.3 ){ smooth_factor_out = 0; }
        }
        if( level.dev_time ){ iPrintLnBold( "MOVING SCHRUDER ON THE Z AXIS" ); }
        level.spirit_hovers = true;
        self movez( latitude, duration, smooth_factor, smooth_factor_out );
        wait( duration );
        level.spirit_hovers = false;
        self notify( "im_allowed_to_levitate" );
        level notify( "allowed_to_continue" );
    }

}

schruder_desc( latitude, duration, smooth_factor )
{
    level endon( "end_game" );
    
    //keep track if we are hovering
    if( level.spirit_hovers )
    {
        if( level.dev_time ){ iPrintLnBold( "SCHRUDER IS STILL HOVERING, PAUSING THE CALL TILL ITS SAFE AGAIN" ); }
        wait 1;
        self waittill( "im_allowed_to_levitate" );
    }

    else if( !level.spirit_hovers )
    {
        if( isdefined( smooth_factor_out ) )
        {
            if( smooth_factor_out < 1.3 ){ smooth_factor_out = 0; }
        }
        if( level.dev_time ){ iPrintLnBold( "MOVING SCHRUDER ON THE Z AXIS" ); }
        level.spirit_hovers = true;
        self movez( latitude, duration, smooth_factor, smooth_factor_out );
        wait( duration );
        level.spirit_hovers = false;
        self notify( "im_allowed_to_levitate" );
    }
}

schruder_moves_to( location, duration, smooth_factor, smooth_factor_out )
{
    level endon( "end_game" );
    
    //keep track if we are already moving
    if( level.spirit_moves )
    {
        if( level.dev_time ){ iprintlnbold( "SCHRUDER IS ON THE MOVE, PAUSING THE CALL TILL ITS SAFE TO MOVE AGAIN" ); }
        self waittill( "im_allowed_to_move" );
        
    }

    if( !level.spirit_moves )
    {
        level.schuder_moves = true;
        if( isDefined( smooth_factor_out ) )
        {
            if( smooth_factor_out < 1.3 ){ smooth_facotr_out = 0; }
        }
        self moveTo( location, duration, smooth_factor, smooth_factor_out );
        wait( duration );
        level.schurder_moves = false;
        self notify( "im_allowed_to_move" );
    }
}

global_bools_arrays()
{
   
}
global_locations()
{
    level endon( "end_game" );
    //origin of pois

    
    //town side beacons
    level.fxtower[0] = (7330.05, -459.703, 677.731);
    level.fxtower[1] = (7260.85, -466.002, 1065.17);
    //nach side beacons
    level.fxtower[2] = (7964.11, -465.178, 677.731);
    level.fxtower[3] = (8034.62, -462.836, 1065.17);
    
    //ground pos at tower
    level.spirit_locations[ 0 ] = ( 7621.98, -466.573, -176.101 );
    //first elevation point middle tower
    level.spirit_locations[ 1 ] = ( 7621.98, -466.573, 11.0782 );
    //to the left from tower elevetated on small road
    level.spirit_locations[ 2 ] = ( 7646.55, -310.812, 91.5919 );
    //first t cross section head height
    level.spirit_locations[ 3 ] = ( 7796.12, 19.0566, -136.185 );
    //from the t cross to the other t cross
    level.spirit_locations[ 4 ] = ( 7366.78, 335.744, -115.185 );
    //continuing the new road path towards main road
    level.spirit_locations[ 5 ] = ( 7718.12, 575.061, -145.289 );
    //continuing towards same goal
    level.spirit_locations[ 6 ] = ( 8017.15, 645.111, -97.2837 );
    //same goal
    level.spirit_locations[ 7 ] = ( 8907.62, 567.834, -122.93 );
    //from the t cross to right, above the field
    level.spirit_locations[ 8 ] = ( 8875.65, 347.757, 235.32 );
    //descend from above back to the new "road"
    level.spirit_locations[ 9 ] = ( 8943.18, -152.234, -158.23 );
    //continue inner road
    level.spirit_locations[ 10 ] = ( 8969.18, -591.123, -56.2354 );
    //at t cross to the left
    level.spirit_locations[ 11 ] = ( 8754.45, -1000.42, -177.348 );
    //continue new road
    level.spirit_locations[ 12 ] = ( 9022.97, -1354.42, -17.4592 );
    //to the left at t cross
    level.spirit_locations[ 13 ] = ( 9236.54, -1149.23, -173.359 );
    //continue
    level.spirit_locations[ 14 ] = ( 9470.45, -1082.35, -122.498 );
    //middle of big roadd
    level.spirit_locations[ 15 ] = ( 10228.3, -1140.91, 96.2382 );
    //to the right, next to lamp
    level.spirit_locations[ 16 ] = ( 10192.6, -1686.52, -174.289 );
    //at the end of long hay road
    level.spirit_locations[ 17 ] = ( 12010.1, -1825.51, -136.329 );
    //at the next t cross
    level.spirit_locations[ 18 ] = ( 12204.4, -596.384, -103.349 );
    //continue a bit on the road
    level.spirit_locations[ 19 ] = ( 12475.5, -625.863, -71.3289 );
    //first electric pole
    level.spirit_locations[ 20 ] = ( 13097.7, -841.474, 166.237 );
    //second pole
    level.spirit_locations[ 21 ] = ( 13070.9, -1444.03, 118.348  );
    //third pole
    level.spirit_locations[ 22 ] = ( 13088.9, -1741.28, 135.123 );
    //on top of nacht
    level.spirit_locations[ 23 ] = ( 13685.3, -1042.41, 280.342 );
    //inside of nacht ( explo height )
    level.spirit_locations[ 24 ] = ( 13660.2, -951.123, 16.5059 );


    //NACHT NACHT NACHT // NACHT NACHT NACHT // NACHT NACHT NACHT //
    //rooftops//
    
    //front left
    level.nacht_power_fx_event[ 0 ] = ( 13674.7, 128.516, 144.581 );
    //front middle
    level.nacht_power_fx_event[ 1 ] = ( 14144.6, -616.437, 59.4182 );
    //front right back
    level.nacht_power_fx_event[ 2 ] = ( 13901.5, -1576.12, 86.3 );

    //outside areas//

    //right side out
    level.nacht_power_fx_event[ 3 ] = ( 13752.2, -1900.11, -190.231 );
    //green car right side
    level.nacht_power_fx_event[ 4 ] = ( 13223.4, -1418.9, -166.235 );
    //next to big turbines left
    level.nacht_power_fx_event[ 5 ] = ( 13597.5, 1190.08, 120.235 );
    /*
    level.spirit_locations[ 25 ] = (  );
    level.spirit_locations[ 26 ] = (  );
    level.spirit_locations[ 27 ] = (  );
    level.spirit_locations[ 28 ] = (  );
    level.spirit_locations[ 29 ] = (  );
    level.spirit_locations[ 30 ] = (  );
    
    */
    
}

//spirit

spirit_says( text, text2, duration, fadetimer )
{
    level endon( "end_game" );
    //level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says(  "^8" + text, "^8" + text2, duration, fadetimer );
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


