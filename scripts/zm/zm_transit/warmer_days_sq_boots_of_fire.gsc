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

main()
{
    
}

init()
{
    //boot pick up subs, make complete new global variables for them
    level.bubtitle_lower = undefined;
    level.bubtitle_upper = undefined;
    //re build function to support lava shoes with player_lava_damage(trig) func check
    replacefunc( ::player_lava_damage, ::player_lava_damage_think_if_fireboots );
    //level thread define_global_bootprint_chats();
    //level thread define_global_bootprints();
    level.boots_found = 0; //how many fireboots have players found?
    level.summoning_kills_combined_total = 45; //check for if true
    level.summoninglevel_active = false; //defaults to false so that all summoning locations can be accessed before initiating

    level.side_texts_active = false; //fix for global subs when picking up something while text is already playing from main quest

    level.boots_are_being_picked_up = false; //initial state to get thru first define check in boot pick up step 1

    //keep track of which summoning is active
    level.summoning_active = [];
    level.summoning_active[ 0 ] = false;
    level.summoning_active[ 1 ] = false; 
    level.summoning_active[ 2 ] = false;

    //array to spawn the 3 different summoning models to
    level.summoning_linkedModel = [];

    //each trigger notify for a pool of kills required
    level.summoningkills = [];
    level.summoningkills[ "s0_kills++" ] = 0;
    level.summoningkills[ "s1_kills++" ] = 0;
    level.summoningkills[ "s2_kills++" ] = 0;

    //which summonings have players finished
    level.summoningFinished = [];
    level.summoningFinished[ "s0_kills++" ] = false;
    level.summoningFinished[ "s1_kills++" ] = false;
    level.summoningFinished[ "s2_kills++" ] = false;
    
    //step1 fire boot triggers ( list of them )
    level.boot_triggers = [];

    //step1 fire boot origins
    level.fireboot_locations = [];
    
    //how many souls required per summoning
    level.summoning_kills_required = 15;

    //array where we assign each fireboot summoning location
    level.fireboots_step2_origins = [];

    //initializes the starting logic for quest
    level thread fireboots_quest_init();
    
    //player specific logic for fireboots upon connecting
    level thread fireboots_playerconnect();

    //for zombie death callbacks while level.summoninglevel true
    register_zombie_death_event_callback( ::actor_killed_override );


    //let's test the 
}

actor_killed_override( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime, boneindex)
{
    lava = getentarray( "lava_damage", "targetname" );
    //might wanna do fire check instead of checking if zombie is touching lava.
    //lava areas seem to be quite inconsistent
    if( level.summoninglevel_active ) // have this check, otherwise they will drop the fxs and dont know where to go once all steps done
    {
        if( isdefined( level.summoning_active[ 0 ] && level.summoning_active[ 0 ] && isdefined( level.summoning_trigger ) ) )
        {
            if( isdefined( level.summoningFinished[ "s0_kills++" ] && !level.summoningFinished[ "s0_kills++" ] ) )
            {
                if( isdefined( self ) & self istouching( level.summoning_trigger ) ) 
                {
                    if( self.is_on_fire && self isTouching( lava ) )
                    {
                        if( self.is_on_fire )
                        {
                            level notify( "s0_kills++" );
                            self fireboots_souls( level.summoning_trigger, 0 );
                        }
                    }
                }
            }
        }
                

        if( isdefined( level.summoning_active[ 1 ] && level.summoning_active[ 1 ] && isdefined( level.summoning_trigger ) ) )
        {
            if( isdefined( level.summoningFinished[ "s1_kills++" ] && !level.summoningFinished[ "s1_kills++" ] ) )
            {
                if( isdefined( self ) & self istouching( level.summoning_trigger ) ) 
                {
                    if( self.is_on_fire && self isTouching( lava ) )
                    {
                        if( self.is_on_fire )
                        {
                            level notify( "s1_kills++" );
                            self fireboots_souls( level.summoning_trigger, 1 );
                        }
                    }
                }
            }
        }

        if( isdefined( level.summoning_active[ 2 ] && level.summoning_active[ 2 ] && isdefined( level.summoning_trigger ) ) )
        {
            if( isdefined( level.summoningFinished[ "s2_kills++" ] && !level.summoningFinished[ "s2_kills++" ] ) )
            {
                if( isdefined( self ) & self istouching( level.summoning_trigger ) ) 
                {
                    if( self.is_on_fire && self isTouching( lava ) )
                    {
                        if( self.is_on_fire )
                        {
                            level notify( "s2_kills++" );
                            self fireboots_souls( level.summoning_trigger, 2 );
                        }
                    }
                }
            }
        }
    }
   
}


fireboots_souls( which_summoning, idx )
{
    level endon( "end_game" );

    
    zm_head = self gettagorigin( "j_head" );
    where_to_move = level.summoning_trigger.origin + ( 0, 0, 225 );

    inv_mover = spawn( "script_model", zm_head );
    inv_mover setmodel( "tag_origin" );
    wait .05;
    inv_mover playLoopSound( "zmb_spawn_powerup_loop" );
    playFXOnTag( level.myfx[ 1 ], inv_mover, "tag_origin" );
    inv_mover thread safety_delete();
    inv_mover moveto ( where_to_move, randomFloatRange( 0.2, 0.4 ), 0, 0 );
    inv_mover waittill( "movedone" );
    playfx( level.myFx[ 94 ], where_to_move );
    inv_mover delete();
    playFX( level._effect[ "fx_zombie_powerup_wave" ], where_to_move );
    playsoundatposition( "zmb_meteor_activate", where_to_move );                 
}

safety_delete()
{
    level endon( "end_game" );
    wait 4;
    if( isdefined( self ) )
    {
        self delete();
    }
}

spawn_global_summoning_trigger( origin, index )
{
    level.summoning_trigger = spawn( "trigger_radius", origin , 1, 250, 250 );
    level.summoning_trigger setteamfortrigger( level.zombie_team );
    //update it to move to the visible model origin
    wait 1;
    //level.summoning_trigger moveTo( level.summoning_linkedModel[ index ].origin, 0.1, 0, 0 );

    //safer is a notify
    // original notify comes from death call backs
    //like level notify( "s_0_kills++" );
    //since we cant do a global variable for this one we make a string and parse index between the string lines to match
    //the defined notifies in custom_Death_callback.
    safer = "s" + index + "_kills++";
    //summoning loop
    while( true )
    {
        level waittill( safer );
        level.summoningkills[ safer ] += 1;
        if( level.dev_time ){ iprintln( "SOULS COLLECTED " + level.summoningkills[ safer ] + " / 15 " ); }  
        if( level.summoningkills[ safer ] >= level.summoning_kills_required )
        {
            //release other summoning to be discoverable
            level.summoning_active[ index ] = false;
            level.summoninglevel_active = false;
            
            //let player know that boos have finished soul collecting
            level thread playVictoryFxAndDeleteEverything( level.summoning_linkedModel[ index ].origin, index );
            level.summoningFinished[ safer ] = true; 
            level notify( "summoning_done" );

            wait 1.5;
            //delete id trigger
            level.summoning_trigger delete();
            if( all_boots_summoned() )
            {
                level notify( "fireboots_step2_completed" );
            }
            //why havent we broke out of loop before?
            //this most likely is the reason why global spawn logic fails coz it has 2 while loops running fuck sakes
            if( level.dev_time ) { iprintln( "WE SUMMONED THIS BOOT! BREAKING OUT OF LOOP FROM OLD THREAD" ); }
            break;
        }
        wait 0.05;
    }   
}


playVictoryFxAndDeleteEverything( here, idx )
{
    level endon( "end_game" );
    for( i = 0; i < 12; i++ )
    {
        
        playfxontag( level.myFx[ 9 ], here, "tag_origin" ); 
        wait randomFloatRange( 0.05, 0.09 );
    }
    playfxontag( level.myfx[ 78 ], here, "tag_origin" );
    PlaySoundAtPosition("zmb_avogadro_death_short", here );
    
    wait 0.1;
    level.summoning_linkedModel[ idx ]delete();
}
fireboots_playerconnect()
{
    level endon( "end_game" );
    while( true )
    {
        level waittill( "connected", obeyer );
        obeyer thread setBootStat( false );
        //obeyer thread printer();
    }
}
setBootStat( firstTime )
{
    self endon( "disconnect" );
    level endon( "end_game" );

    self waittill( "spawned_player" );
    self.has_picked_up_boots = undefined;
    wait 1;
    self.has_picked_up_boots = firstTime;
} 


fireboots_quest_init()
{
    level endon( "end_game" );

    flag_wait( "initial_blackscreen_passed" );

    //step1
    level thread f_boots1(); //players collect 6 different fire boot pieces by jumping into found boot
    level waittill( "fireboots_step1_completed" );

    //step2
    level thread f_boots2(); //players must find 3 different booots and collect souls to them ( while zombies are on fire )
    level waittill( "fireboots_step2_completed" );

    //step3
    level thread f_boots3(); //fire boots have been spawned, players can now pick them up and avoid lava damage
}


all_boots_summoned()
{
    level endon( "end_game" );
    if( level.summoningkills[ "s0_kills++" ] +
        level.summoningkills[ "s1_kills++" ] +
        level.summoningkills[ "s2_kills++" ] >= level.summoning_kills_combined_total  ) { return true; } return false;
}

monitor_all_boots()
{
    level endon( "end_game" );
    level endon( "boot_count_stop" );
    while( true )
    {
        if( all_boots_summoned() )
        {
            
            if( level.dev_time ) { iprintlnbold( "ALL SHOES SUMMONED. GO PICK THEM UP FROM LABS" ); }
            level notify( "boot_count_stop" );
            break;
        }
        else
        {
            wait 1;
        }
    }
}
are_boots_found()
{
    level endon( "end_game" );
    total = level.boot_triggers.size;
    if(  level.boots_found >= level.fireboot_locations.size  )
    {
        
        if( level.dev_time ) { iprintlnbold( "#### DEV CHECK ##### ^3 ALL BOOTS FOUND" ); }
        return true;
    }
    return false;
}

f_boots1() //fireboot quest step1. Find 8 different fireboots around the map ( jump into found boots, run into them to pick up )
{
    level endon( "end_game" );

    //120 ground to roof + mayb 40 for jump dist height
    //bus depot bus jump spot -7705.29, 4771.91, 111.526
    //

    level.fireboot_locations[ 0 ] = ( 10506.6, 8081.56, -368.851 ); // power jump
    level.fireboot_locations[ 1 ] = ( 10395.6, -110, -35.5112 ); //corn jump towards second nacht rout
    level.fireboot_locations[ 2 ] = ( 7941.22, -6043.94, 265.103 ); //farm balcony jump
    level.fireboot_locations[ 3 ] = ( -8575.85, 4831.1, 100 ); //bus depot
    level.fireboot_locations[ 4 ] = ( 1231.3, -1312, 114.477 ); //town jump from jugg to ground below
    level.fireboot_locations[ 5 ] = ( -11742.6, -827.903, 249.517 ); //tunnel location
    level.fireboot_locations[ 6 ] = ( -4357.61, -5948.82, -20.5901 ); //diner behind the mist outside grass area
    wait 0.1;

    for( s = 0; s < level.fireboot_locations.size; s++ )
    {
        level.boot_triggers[ s ] = spawn( "trigger_radius", level.fireboot_locations[ s ], 48, 48, 48 );
        level.boot_triggers[ s ] setHintString( "" );
	    level.boot_triggers[ s ] setCursorHint( "HINT_NOICON" );

        wait 1;
        level.boot_triggers[ s ] thread leg_trigger_logic( level.boot_triggers[ s ].origin );
        wait 0.05;
        playfxontag( level.myFx[ 6 ], level.boot_triggers[ s ], "tag_origin"  );
    }  
    wait 1;
    while( !are_boots_found() )
    {
        wait 1;
    }
    wait 8;
    /* TEXT | LOWER TEXT | DURATION | FADEOVERTIME */
    //activate this back when the crashing issue is figured out.
    if( isdefined( level.side_texts_active ) && level.side_texts_active )
    {
        while( level.side_texts_active )
        {
            wait 0.25;
        }
    }
    level thread boot_says( "^9Dr. Schruder^8: " + "^8You've located all the ^9fireboot^8 pieces, conqratulations!", "^8Quick, catch and summon them before they run away!", 8, 0.25 );
    wait 8;
    level notify( "fireboots_step1_completed" );
}



define_boot_subtitles()
{
    //if we already have other text playing on the screen..
    if( isdefined( level.subtitles_on_so_have_to_wait ) && level.subtitles_on_so_have_to_wait )
    {
        t_y = -86;
        l_y = -64;
    }
    //otherwise set the subs to their "og" location on screen
    else if( isdefined( level.subtitles_on_so_have_to_wait  ) && !level.subtitles_on_so_have_to_wait )
    {
        t_y = -42;
        l_y = -24;
    }
    level.bubtitle_upper = NewHudElem();
	level.bubtitle_upper.x = 0;
	level.bubtitle_upper.y = t_y;
	level.bubtitle_upper SetText( "" );
	level.bubtitle_upper.fontScale = 1.32;
	level.bubtitle_upper.alignX = "center";
	level.bubtitle_upper.alignY = "middle";
	level.bubtitle_upper.horzAlign = "center";
	level.bubtitle_upper.vertAlign = "bottom";
	level.bubtitle_upper.sort = 1;
    
    level.bubtitle_lower = NewHudelem();
    level.bubtitle_lower.x = 0;
    level.bubtitle_lower.y = l_y;
    level.bubtitle_lower SetText( "" );
    level.bubtitle_lower.fontScale = 1.22;
    level.bubtitle_lower.alignX = "center";
    level.bubtitle_lower.alignY = "middle";
    level.bubtitle_lower.horzAlign = "center";
    level.bubtitle_lower.vertAlign = "bottom";
    level.bubtitle_lower.sort = 1;

}



boot_says( sub_up, sub_low, duration, fadeTimer )
{
    //don't start drawing new hud if one already exists 
    if(  isdefined( level.subtitles_on_so_have_to_wait ) && level.subtitles_on_so_have_to_wait )
    {
        while(  level.subtitles_on_so_have_to_wait ) { wait 0.25; }
    }

    wait 1;
    define_boot_subtitles();
    level.bubtitle_upper settext( sub_up );
    if( isdefined( sub_low ) )
    {
        level.bubtitle_lower settext( sub_low );
    }
    
    level.bubtitle_upper.x = 0;
    level.bubtitle_lower.x = 0;
    level.bubtitle_upper.alpha = 0;
    level.bubtitle_upper fadeovertime( fadeTimer );
    level.bubtitle_upper.alpha = 1;
	if ( IsDefined( sub_low ) )
	{
        level.bubtitle_lower.alpha = 0;
        level.bubtitle_lower fadeovertime( fadeTimer );
        level.bubtitle_lower.alpha = 1;
	}

	wait ( duration );
    
	level thread flyby_bubtitles( level.bubtitle_upper );
    level.bubtitle_upper fadeovertime( fadeTimer );
    level.bubtitle_upper.alpha = 0;

	if ( IsDefined( sub_low ) )
	{
		level thread flyby_bubtitles( level.bubtitle_lower );
        level.bubtitle_lower fadeovertime( fadeTimer );
        level.bubtitle_lower.alpha = 0;
	}

    wait 1.5;
    level.bubtitle_upper destroy();
    if( isdefined( level.bubtitle_lower ) ) 
    {
        level.bubtitle_lower destroy();
    }
}

//this a gay ass hud flyer, still choppy af
flyby_bubtitles( element )
{
    level endon( "end_game" );
    x = 0;
    on_right = 640;

    while( element.x < on_right )
    {
        element.x += 200;
        wait 0.05;
    }
}


f_boots3()
{
    level endon( "end_game" );
    if( isdefined( level.side_texts_active ) && level.side_texts_active )
    {
        while( level.side_texts_active )
        {
            wait 0.25;
        }
    }
    level thread boot_says( "^9Dr. Schruder^8: " + "Excellent! ^8You've summoned each ^9Fire Boot^8!", "^8They're now yours to keep. You can pick them up from ^9Safe House.", 8, 0.25 );
    //text up
    text_u = [];
    text_u[ 0 ] = "^8Excellent stuff!";
    text_u[ 1 ] = "^8Lucky you, I guess.";
    text_u[ 2 ] = "^8aaa... AAAWESOOOOME!";
    
    //text down
    text_d = undefined;

    //trigger origin
    //rn outside bus station for debugging. -6188.75, 4594.24, -15.4793
    t_loc = ( 8326.36, -4649.86, 264.125 );
    m_loc = ( 8381.89, -4625.11, 304.939 );
    if( level.dev_time ){ iprintlnbold( "WE HAVE SETUP THE INTIAL BOOT PICK UP POINT NOW, WAITING FOR 5 SECS BEFORE SPAWNING IT" ); }
    pickup_model = spawn( "script_model", m_loc );
    pickup_model setmodel( "c_zom_zombie3_g_rlegspawn" );
    pickup_model.angles = ( randomintrange( 0, 360 ), randomintrange( 0, 360 ), randomintrange( 0, 180 ) );
    
    // need a pause before fxing script_model
    wait 0.05; 

    playfxontag( level.myFx[ 25 ], pickup_model, "tag_origin" );
    wait 0.05;
    //white glow bulp type loop //low vis.
    playfxontag( level.myFx[ 35 ], pickup_model, "tag_origin" );
    wait 0.05;
    //small stream of steam like geyshir type
    playfx( level.myFx[ 61 ], pickup_model.origin );

    trigg = spawn( "trigger_radius", t_loc, 45, 45, 45 );
    

    //trigg useRequireLookAt();

    wait 1;

    trigg setHintString( "^9[ ^3[{+activate}]^8 to pick up your ^3Fire Boots ]" );
    trigg setCursorHint( "HINT_NOICON" );
    while( true )
    {
        trigg waittill( "trigger", user );
        
        if( user in_revive_trigger() )
        {
            wait 0.1;
            continue;
        }

        if( user.has_picked_up_boots )
        {
            trigg sethintstring( "^9[ ^8You're already wearing ^3Fire Boots ^9]" );
            wait 1.5;
            trigg setHintString( "^9[ ^3[{+activate}]^8 to pick up your ^3Fire Boots ]" );
            //iprintlnbold( "You already have ^3Fire Bootz" );
            continue;
        }

        if( user useButtonPressed() )
        {
            

            if( is_player_valid( user ) )
            {
                

                text_d = "^9" + user.name + " ^8picked up  ^9Fire Bootz^8";
                temporary = randomint( text_u.size );
                text_upper = text_u[ temporary ];
                //small poof fx when picking up the boots
                playfx( level.myFx[ 9 ], user.origin );
                user.has_picked_up_boots = true;
                wait 0.05;
                //trigg setinvisibletoplayer( user );
                
                //needs an fire trail for boots when moving around
                //the tags need to be retrieved, cod2 tags wont work.
                playFXOnTag( level.myFx[ 25 ], user, "j_ankle_le" );
                wait 0.05;  
                playFXOnTag( level.myFx[ 25 ], user, "j_ankle_ri" );
                user thread watch_for_death_disconnect();
                
                /* TEXT | LOWER TEXT | DURATION | FADEOVERTIME */
                //this commented out till we can fix the text freeze issue that crashes the game after ~1 minute of calling it
                level thread boot_says( "^9Dr. Schruder^8: " + text_d, text_upper, 8, 0.25 );
                //wait_network_frame();
                text_d = undefined;
            }
            continue;
        }
        
        wait 0.05;
    }
}

/*  HIT LOCS, WELL PLAY AN FX WITH FIREBOOTS ON THIS ONE
[ "j_head", "j_neck", "j_spine4", "j_spinelower", "j_mainroot", "pelvis",
 "j_ball_le", "j_ball_ri", "j_ankle_le", "j_ankle_ri",
  "j_shoulder_ri", "j_shoulder_le", "j_elbow_ri", "j_elbow_le",
   "j_wrist_ri", "j_wrist_le", "j_hip_ri", "j_hip_le", "j_knee_ri", "j_knee_le" ]; 
 */

printer()
{
    self endon( "disconnect" );
    level endon( "end_game" );
    flag_wait( "initial_blackscreen_passed" );
    while( true )
    {
        iprintln( "ORIGIN: ^3" + self.origin );
        wait 1;
    }
}


spinner( what_to_spin )
{
    level endon( "end_game" );
    while( true ) 
    {
        what_to_spin rotateYaw( 360, 1, 0, 0 );
        what_to_spin waittill( "movedone" );
    }
}

leg_trigger_logic( model_origin )
{
    level endon( "end_game" );
    //what_step_text = undefined;
    wait 1;
    leg_model = spawn( "script_model", model_origin );
    leg_model setmodel( level.myModels[ 77 ] ); //needs a better leg model, currently a broken torso c_zom_zombie1_body01_g_legsoff c_zom_zombie3_g_rlegspawn
    leg_model.angles = ( 0, 0, 0 );
    wait 0.05;
    playfxontag( level.myFx[ 1 ], leg_model, "tag_origin" ); 
    //need this to stop drawing multiple instances at once for pick up boots part's hud elem
    cooldownTimer = 10;
    wait 0.05;
    //playfx( level.myFx[ 1 ], model.origin );
    level thread spinner( leg_model );
    //playfx( level.myFx[ 9 ], model_origin );

    while( true )
    {
        self waittill( "trigger", guy );
        if( !is_player_valid( guy ) && isdefined( level.boots_are_being_picked_up ) && level.boots_are_being_picked_up )
        {
            wait 0.1;
            continue;
        }
        if( isdefined( level.boots_are_being_picked_up ) && level.boots_are_being_picked_up )
        {
            wait 0.1;
            continue;
        }
        //add this check, sometimes the game randomly thinks that the player is picking up the boots...
        if( isdefined( guy ) && distance2d( guy.origin, self.origin ) < 300 )
        {
            if( !is_player_valid( guy ) && isdefined( level.boots_are_being_picked_up ) && level.boots_are_being_picked_up )
            {
                wait 0.1;
                continue;
            }
             //this check needs to be added below since we need to check after the initial hit if someone is already picking up boots
            if( isdefined( level.boots_are_being_picked_up ) && level.boots_are_being_picked_up )
            {
                wait 0.1;
                continue;
            }

            if( is_player_valid( guy ) && isdefined( level.boots_are_being_picked_up ) && !level.boots_are_being_picked_up )
            {
                
                
                // to display the number of boots found currently
                true_indicator = level.boots_found + 1; 
                playsoundatposition( "zmb_box_poof", self.origin );
                wait 0.5;
                //give a little reward to the player who picked up said boots
                guy.score += 750;
                guy playsoundtoplayer( "zmb_vault_bank_deposit", guy );
                lower_text = "^9[ ^8Fireboots found: ^8" + true_indicator + "^9 / ^8" + ( level.fireboot_locations.size + " ^9]" );//- 1  ); 
                wait 0.1;
                level thread boot_says( "^9Dr. Schruder^8: " + _returnFireBootStepText(), lower_text, 8, 0.25 );
                wait 0.05;
                level.boots_found++;
                level thread picking_up_boots_cooldown_others_timer( cooldownTimer );
                //self == trigger
                if( isdefined( self ) ) { self delete(); }
                if( isdefined( leg_model ) ) {  leg_model delete(); } //delete linked model
                wait 0.1;
                break;
            }
           
        }
    }
}


picking_up_boots_cooldown_others_timer( time )
{
    level endon( "end_game" );

    if( level.dev_time ){ iPrintLnBold( "BOOTS PICK UP COOLDOWN ^9ACTIVATED "); }
    level.boots_are_being_picked_up = true;
    
    wait( time );

    if( level.dev_time ){ iPrintLnBold( "BOOTS PICK UP COOLDOWN ^1DEACTIVATED "); }
    level.boots_are_being_picked_up = false;
}

f_boots2() // fireboots, step 2
{
    level endon( "end_game" );

    
    level.fireboots_step2_origins[ 0 ] = ( -5909.55, -7742.08, 185.431 ); //diner roof
    level.fireboots_step2_origins[ 1 ] = ( 13382.2, -726.357, -263.877 ); //when u enter nach bunker, outside
    level.fireboots_step2_origins[ 2 ] = ( 1448.24, -444.592, -85.8376 ); //middle of lava pit in town

    
    wait 1;
    for( s = 0; s < level.fireboots_step2_origins.size; s++ )
    {
        level.summoning_linkedModel[ s ] = spawn( "script_model", level.fireboots_step2_origins[ s ] );
        level.summoning_linkedModel[ s ] setmodel( level.myModels[ 55 ] ); //needs a better model
        level.summoning_linkedModel[ s ].angles = ( 0, 0, 0 );
    }
    wait 0.1;

    for( i = 0; i < level.summoning_linkedModel.size; i++ )
    {
        //assigned_alias = "level.summoning_linkedModel" + i;
        //change first arg to level.summoning_linkedModel[ i ], array broke the previous thread linking
        level thread fireboots_sound_before_locating( level.summoning_linkedModel[ i ], i );
    }

    if( level.dev_time )
    {
        iprintlnbold( "ALL BOOT SPAWNS INITIALIZED!" );
    }
    

}
/*
lol()
{
    level endon( "end_game" );
    flag_wait( "initial_blackscreen_passed" );
    for( s = 0; s < level.players.size; s++ )
    {
        level.players[ s ] setclientdvar( "r_ligthtweaksunlight", 20 );
        level.players[ s ] setclientdvar( "r_lighttweaksuncolor", "0.1 0.1 0.9" );
        level.players[ s ] setclientdvar( "r_fog", false );
    }

    //incase r_fog is server sided
    setdvar( "r_fog", true );
}
*/


rise_boots_from_initial_ground_origin( rising_model, amount, trig_org, active_idx, summoning_bounce )
{
    level endon( "end_game" );
    rising_model movez( amount, 1.5, 0.3, 0.1 );
    playfx( level._effect[ "avogadro_ascend_aerial" ], rising_model.origin + ( 0, 0, 30 ) );
    playfx( level.myFx[ 87 ], rising_model.origin );
    rising_model waittill( "movedone" );
    level thread spawn_global_summoning_trigger( trig_org, active_idx );
    wait 0.05;
    rising_model thread summoning_in_progress( rising_model, summoning_bounce );
    playfxontag( level.myFx[ 92 ], rising_model, "tag_origin" );
    playfx( level.myfx[ 82 ], rising_model.origin );
}

fireboots_sound_before_locating( alias, which_active )
{
    level endon( "end_game" );
    self endon( "stop_summon_sound" );

    //kill the loop on said model
    break_thread = false;
    sound_to_play = "zmb_spawn_powerup_loop";
    self playloopsound( sound_to_play );
    //how high in z  do we launch the model and fxs
    bounce_upwards = 200;

    //we have not found this summoning yet
    someone_located = false;
    //distance to be within for the leg to spawn
    close_enough = 350;
    wait 0.05;
    //what the fuck is this fx?
    playfxontag( level.myFx[ 6 ], self, "tag_origin" );

    while( true )
    {

        if( isdefined( level.summoning_active[ 0 ] ) && level.summoning_active[ 0 ] == false ||
        isdefined( level.summoning_active[ 1 ] ) && level.summoning_active[ 1 ] == false ||
        isdefined( level.summoning_active[ 2 ] ) && level.summoning_active[ 2 ] == false &&
        level.summoninglevel_active == false )
        {
            if( level.dev_time ) { iprintlnbold( "WE ARE DOING THE LOCATE CHECK NOW" ); }
            if( someone_located || level.summoninglevel_active )
            {
                if( level.dev_time ){ iprintlnbold( "Someone is already doing another summoning elsewhere." ); }
                wait 1; 
            }
            for( players = 0; players < level.players.size; players++ )
            {
                p = level.players[ players ];
                distance_p_object = distance2d( p.origin, alias.origin );
                if( distance_p_object <= close_enough && level.summoninglevel_active == false )
                {
                    wait 0.1;
                    break_thread = true;
                    if( level.dev_time ) { iprintln( "Distance between boot & " + p.name + " was ^9" + distance_p_object ); }
                    someone_located = true;
                    level.summoninglevel_active = true;
                    level.summoning_active[ which_active ] = true;
                    // small indicator for something
                    alias playsound( "ignite" );
                    Earthquake( 0.35, 5, alias.origin, 1000 );
                    while( distance2d( p.origin, alias.origin ) < 350 &&
                            distance2d( p.origin, alias.origin ) > 250 )
                    {
                        wait 0.5;
                    }
                    // let it rip harder
                    earthquake( 0.65, 3, alias.origin, 1000 );
                    alias playsound( "zmb_avogadro_death_short" );
                    //rising model, how much to rise, where to spawn trig(model origin), model index, how much to bounce from ground
                    level thread rise_boots_from_initial_ground_origin( alias, 50, alias.origin, which_active, 200 );
                    playfx( level._effect[ "avogadro_ascend_aerial" /*"avogadro_ascend"*/ ], alias.origin + ( 0, 0, 300 ) ); //needs a better fx
                    
                    break;
                }
            }

            if( break_thread )
            {
                if( level.dev_time )
                {
                    iprintln( "Exiting out of while loop for linked model" );
                    
                }
                wait 1;
                break;
            }
        }
        else { wait 1; }
        wait 0.1;
    }
}





fliebies( element )
{
    level endon( "end_game" );
    x = 0;
    on_right = 640;

    while( element.x < on_right )
    {
        element.x += 200;
        wait 0.05;
    }
    if( isdefined( element ) )
    {
        element destroy_hud();
    }
    
}




summoning_in_progress( model, bounce_upwards )
{
    level endon( "end_game" );
    level endon( "summerover" );

    
    model playLoopSound( "zmb_spawn_powerup_loop" );
    playfxontag( level.myFx[ 19 ], self, "tag_origin" );
    wait 0.05;
    playfxontag( level.myFx[ 1 ], self, "tag_origin" );
    model moveZ( bounce_upwards, 0.5, 0.2, 0.1 );
    model waittill( "movedone" );
    
    //threads
    model thread mover_z( 30, -30, 2, .3, .3 );
   // wait 0.05;
   // level notify( "summerover" );
    //models thread are_zombies_close_to_legs( models );
    //model thread keep_track_of_progress();
}

keep_track_of_progress()
{
    level endon( "end_game" );

    while( true )
    {
        if( boots_summoned() )
        {
            if(level.dev_time)
            {
                iprintlnbold( "This boot_summoing done, UNLOCKING OTHER LOCATIONS AGAIN" );
            }
            
            wait 0.05;
            Earthquake( 0.5, 0.75, self.origin, 1000 );
            self playsound( "zmb_avogadro_death_short" );
            playfx( level._effect[ "avogadro_ascend_aerial" /*"avogadro_ascend"*/ ], self.origin ); //needs a better fx
            level notify( "summoning_done" );
            level.summoning_active = false;
            level.summoning_kills = 0;
            wait 0.1;
            self delete();
            break;
            
        }
        wait 1;
    }

}

boots_summoned()
{
    level endon( "end_game" );
    if( level.summoning_kills >= level.summoning_kills_required )
    {
        return true;
    }
    return false;
}


damageWaiter( goal_loc )
{
    level endon( "end_game" );
    self endon( "death" );

    self waittill( "death" );
    
    playfx( level.myFx[ 9 ], self.origin );

    temp_mover = spawn( "script_model", self.origin + ( 0, 0, 92 ) ); //offset
    temp_mover setmodel( "tag_origin" );
    temp_mover.angles = ( 0, 0, 0 );
    
    wait 0.05;
    playfxontag( level.myFx[ 1 ], temp_mover, "tag_origin" );
    wait 0.05;
    temp_mover moveto( goal_loc, randomfloatrange( 1, 3 ), 0, 0.5 );
    temp_mover waittill( "movedone" );
    playFX( level.myFx[ 9 ], temp_mover.origin );

    level.summoning_kills++;
    level.summoning_kills_combined++;
    temp_mover playsound( "zmb_box_poof" );
    wait 0.1;
    temp_mover delete();
    
    

}




_returnFireBootStepText()
{
    level endon( "end_game" );

    boots_found = level.boots_found;
    step = undefined;

    switch( boots_found )
    {
        case 0: //apparently we skip this, implement if case in the main thread to include this text
            step = "^8Ah you've found the first piece of fireboots!";
            break;
        case 1:
            step = "^8These fireboots will help you eventually travel through lava safely.";
            break;
        case 2:
            step = "^8Where might the other fireboot pieces be located at..?";
            break;
        case 3:
            step = "^8Oh, look another piece!";
            break;
        case 4:
            step = "^8Few more to go..";
            break;
        case 5:
            step = "^8Tsah tsing! Piece found.";
            break;
        case 6:
            step = "^8Last one?... One more!";
            break;
        default:
            step = "^8Ah finally!";
        break;
    }

    return step; //return text info to be displayed

}


mover_z( up, down, timer, acc, decc )
{
    level endon( "end_game" );
    while( true )
    {
        if( isdefined( self ) )
        {
            self movez( up, timer, acc, decc );
            self waittill( "movedone" );
            self movez( down, timer, acc, decc );
            self waittill( "movedone" );
        }
        
    }
}

SpawnAndLinkFXToTag(effect, ent, tag)
{
    level endon( "end_game" );
    fxEnt =  Spawn("script_model", ent GetTagOrigin(tag));
    fxEnt SetModel("tag_origin"); // tag_origin_animate
    fxEnt LinkTo(ent, tag);
    
	wait_network_frame();
    
    PlayFxOnTag(effect, fxEnt, "tag_origin");
    return fxEnt;
}

spinner_yaw( clockwise, counterclock, timer, lerp_acc, lerp_decc )
{
    level endon( "end_game" );
    while( true )
    {
        if( isdefined( self ) )
        {
            self rotateYaw( clockwise, timer, lerp_acc, lerp_decc );
            self waittill( "movedone" );
            self rotateyaw( counterclock, timer, lerp_acc, lerp_decc );
            self waittill( "movedone" );
        }

    }
}





watch_for_death_disconnect()
{
    self endon( "disconnect" );
    self endon( "time_to_end_this" );
    wait 0.05;
    //trail fx
    //playfxontag( level.myFx[  ], self, "tag_origin" );

    while( true )
    {
        self waittill( "death" );
        self.has_picked_up_boots = false; //requires player to pick up again
        self notify( "time_to_end_this" );
        break;
        
    }   
}




player_lava_damage_think_if_fireboots( trig )
{
    self endon( "zombified" );
    self endon( "death" );
    self endon( "disconnect" );
    max_dmg = 15;
    min_dmg = 5;
    burn_time = 1;

    if ( isdefined( self.is_zombie ) && self.is_zombie )
        return;

    self thread player_stop_burning();

    if( isdefined( self.has_picked_up_boots ) && self.has_picked_up_boots )
    {
        return;
    }

    if ( isdefined( trig.script_float ) )
    {
        max_dmg = max_dmg * trig.script_float;
        min_dmg = min_dmg * trig.script_float;
        burn_time = burn_time * trig.script_float;

        if ( burn_time >= 1.5 )
            burn_time = 1.5;
    }

    if ( !isdefined( self.is_burning ) && is_player_valid( self ) )
    {
        self.is_burning = 1;
        maps\mp\_visionset_mgr::vsmgr_activate( "overlay", "zm_transit_burn", self, burn_time, level.zm_transit_burn_max_duration );
        self notify( "burned" );

        if ( isdefined( trig.script_float ) && trig.script_float >= 0.1 )
            self thread player_burning_fx();

        if ( !self hasperk( "specialty_armorvest" ) || self.health - 100 < 1 )
        {
            radiusdamage( self.origin, 10, max_dmg, min_dmg );
            wait 0.5;
            self.is_burning = undefined;
        }
        else
        {
            if ( self hasperk( "specialty_armorvest" ) )
                self dodamage( 15, self.origin );
            else
                self dodamage( 1, self.origin );

            wait 0.5;
            self.is_burning = undefined;
        }
    }
}