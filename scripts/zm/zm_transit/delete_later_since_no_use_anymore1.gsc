//  codename: wamer_days_mq_05_burning_time
//  purpose: handles the spawn logic for roasting,
//  players must take the object from nacht after a lockdown to the cabin in the woods
//  and then place the head inside of the furnace
//  release: 2023 as part of tranzit 2.0 v2 update
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
    // might wanna disable the whole script
    //since we don't use denizens anymore.. 
    //no point in gettting protector helmet otherwise. 
    //the head that needs to be spawned
    level.protection_helmet_spawn = undefined;
    //global attachable  model to players' head
    level.protection_helmet = undefined;
    //who is the initial picker
    level.protection_helmet_picker = undefined;
    //failsafe if the player who picked up disconnects
    level.someone_picked = false;
}

after_initial_blackscreen()
{
    level endon( "end_game" );

    flag_wait( "initial_blackscreen_passed" );
    level thread head_needs_spawning();
}

head_needs_spawning()
{
    level endon( "end_game" );
    //not working for some reason
    level waittill( "obey_spirit_complete" );

    protection_spawn = ( 14080.9, -571.94, -149.073 );
    helmet_model = "tag_origin"; //needs a model eventually

    level.protection_helmet_spawn = spawn( "script_model", protection_spawn );
    level.protection_helmet_spawn setModel( helmet_model );
    level.protection_helmet_spawn.angles = ( 0, 180, 0 );

    
    trig = spawn( "trigger_radius", protection_spawn, 40,40,40 );
    trig setCursorHint( "HINT_NOICON" );
    trig setHintString( "^3 {[+reload]} ^7to pick up the protection helmet" );
    trig useTriggerRequireLookAt();
    wait 0.1;

    //schruder text for the protection helmet pick up
    t1 = "Ahh! You survived the battle, well done!";
    t2 = "The helmet, you'll need to pick it up and take to somewhere cozy and warm!";
    time = 6;
    fade_off = 0.2;
    level.protection_helmet_spawn thread hover_helmet();
    //sub_player( t1, t2, time, fade_off );
    //&&level thread scripts\zm\zm_transit\warmer_days_sq_boots_of_fire::Subtitle( "^3Dr. Scruder: ^7" + t1,t2,time,fade_off);

    playFXOnTag( level.myfx[ 1 ], level.protection_helmet_spawn, "tag_origin" );
    //playsound
    play_sound_at_pos( "zmb_box_poof", protection_spawn );

    while( true )
    {
        trig waittill( "trigger", player );
        if( player in_revive_trigger() )
        {
            continue;
        }

        if( is_player_valid( player ) )
        {
            if( player useButtonPressed() )
            {
                wait 0.1;
                //assign the player to be the one who picked up the head
                level.helmet_picker = player;

                //reward the picker by a few points
                level.helmet_picker.score = level.helmet_picker.score * 0.1;
                level.protection_helmet_spawn delete();
                trig delete();

                //failsafe check for upcoming disconnect
                level.someone_picked = true;
                //level thread scripts\zm\zm_transit\warmer_days_sq_boots_of_fire::Subtitle( "^3Dr. Schruder: ^7" + t1, t2, time, fade_off );
                
                //make schruder ask about the spirit of sorrow
                level notify( "ask_sometime_after" );
                //let the cabin know that we can start the cabin thread
                level notify( "get_cabin_ready" );
                break;
            }
        }
    }    
}

schruder_reminds_about_spirit()
{
    level endon( "end_game" );
    level waittill( "ask_sometime_after" );
    wait( randomIntRange( 30, 50 ));
    
    w1 = "I forgot to ask you guys if you've seen the ^6Spirit Of Sorrow^7.";
    w2 = "She's been quiet ever since she lead you guys to the ^3abandonen ^7airfield bunker.";
    time = 8;
    fade = 0.2;
    //onscreen subs
    sub_player( w1, w2, time, fade );
    
}

prepare_cabin()
{
    level endon( "end_game" );
    helmet_placement = ( 5439.38, 6874.01, -22.201 );
    helmet = level.myModels[ 75 ];

    helmet_of_fire = spawn( "script_model", helmet_placement );
    helmet_of_fire setmodel( helmet );
    helmet_of_fire.angles = ( 0, 180, 0 );

    sound_ent = spawn( "script_model", helmet_placement );
    sound_ent setmodel( "tag_origin" );
    sound_ent.angles = ( 0, 0, 0 );
    
    sound_ent playLoopSound( "zmb_powerup_loop", 2 );
    wait 0.1;
    helmet_of_fire hide();
    

    while( true )
    {
        //check if the initial head picker is still in the game
        if( isdefined( level.helmet_picker ) && isAlive( level.helmet_picker ) && level.someone_picked )
        {
            if( distance( level.helmet_picker.origin, helmet_of_fire.origin ) < 50 )
            {
                if( level.helmet_picker useButtonPressed() )
                {
                    helmet_of_fire show();
                    playfxontag( level.myfx[ 6 ], helmet_of_fire, "tag_origin" );
                    break;
                }
            }
        }
        //failsafe if the guy who picked up the head disconnects
        else if( !isdefined( level.helmet_picker ) && !isAlive( level.helmet_picker ) && level.someone_picked  )
        {
            for( i = 0; i < level.players.size; i++ )
            {
                if( distance( level.players[ i ].origin, helmet_of_fire.origin ) < 50 )
                {
                    if( level.players[ i ] useButtonPressed() )
                    {
                        helmet_of_fire show();
                        playfxontag( level.myfx[ 6 ], helmet_of_fire, "tag_origin" );
                        break;
                    }
                }
            }
        }
        wait 0.1;
    }
    //players placed down the helmet at cabin's fireplace
    level notify( "helmet_of_fire_found" );
}

hover_helmet()
{
    level endon( "end_game" );
    level endon( "helmet_hover" );
    self endon( "helmet_hover" );
    while( true )
    {
        self movez( 10, 0.8, 0, 0 );
        self waittill( "movedone" );
        self movez( -10, 0.8, 0, 0 );
        self waittill( "movedone" );
    }
}

sub_player( arg1, arg2, arg3, arg4 )
{
    
}