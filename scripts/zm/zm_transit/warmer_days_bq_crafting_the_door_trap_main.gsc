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

init()
{
    setdvar( "ragdoll_explode_upbias", 6 );
    setdvar( "ragdoll_explode_force", 100 );
    precachemodel( "p6_wood_plank_rustic01_2x12_96" );
    flag_wait( "initial_blackscreen_passed" );
    level thread for_connecting_players();
    level.door_base_main_right_location = ( 8111.67, -5425.17, 48.125 );
    level.door_base_main_left_location = ( 8272.36, -5425.29, 48.125 );

    level.door_base_main_trigger_location = ( 8492.35, -5215.87, 48.125 );
    
    level.door_base_main_left_collision_location = ( 8230.3, -5423.62, 48.125 );
    level.door_base_main_right_collision_location = ( 8151.49, 5423.62, 48.125 );

    level.open_air_lock_door_origin = ( 8193.19, -5431.71, 47.9033 );

    level.m_door_opening = false;

    level.door_health_ = 750;
    level.door_health_fixed_ = 750;

    level.players_have_pieces = 0;

    level.pieces_added_to_door = 0;
    
    level.random_base_piece = [];

    //level.random_base_piece_locations = [];
    
    level.door_needs_repairing = false; 

    level.m_door_opening = false;

    //airlock door pieces that needs to be found = 2 total
    level.collected_door_pieces = 0;
    /*
    level.random_base_piece_locations[ 0 ] = ( -7497.26, 4912.35, -55.875 ); //outside of b depo power door
    level.random_base_piece_locations[ 1 ] = ( -6247.48, 4134.22, -44.875 ); //below the hut roof b depo shack
    level.random_base_piece_locations[ 2 ] = ( 2076.57, -1396.17, -53.0825 ); //next to box and trash town
    level.random_base_piece_locations[ 3 ] = ( 683.194, -44.8365, -39.875 ); //inside of bank corner tiwb
    level.random_base_piece_locations[ 4 ] = ( 11181.1, 8102.69, -572.589 ); //p station, behind a truck
    level.random_base_piece_locations[ 5 ] = ( 11116.7, 8901.82, -575.875 ); //p station, next to lava pit ledge where u can die at
    level.random_base_piece_locations[ 6 ] = ( 6598.41, -6213.3, -67.5996 ); //farm, when u come from the forest to farm., outsie
    level.random_base_piece_locations[ 7 ] = ( 8272.08, -6656.33, 152.312 ); //farm, inside of house on the counter next to ref
    level.random_base_piece_locations[ 8 ] = ( 1314.57, -2158.48, -61.8679 ); //shortcut to town, next to the truck before slope
    level.random_base_piece_locations[ 9 ] = ( -6308.03, -5649.59, -34.7311 ); //diner, behind the foresty area next to gated fence
    level.random_base_piece_locations[ 10 ] = ( -6345.25, -7544.87, 40.3869 ); //diner, on the table inside of kitchen
    level.random_base_piece_locations[ 11 ] = ( -10849.3, -1519.92, 196.125 ); //tunnel, middle next to a huge lava pit
    level.random_base_piece_locations[ 12 ] = ( -10910.5, -168.188, 192.125 ); //tunnel, when u enter from depo to tunnel, turn left when in  safe area
    */

    //spawns the airlock origin checker that checks if players are touching the door zone to open / close it
    level thread airlocking_doors();


    //this spawns the trigger to build main door upgrade
    level thread level_spawns_main_door_stuff();

    //this only spawns the worbench model and fx where player must build the safehouse upgrade
    level thread spawn_workbench_to_build_main_entrance();
    wait 1;

    //this spawns 2 pieces that players must find to build the main door for safe  house ( air locking door )
    level thread spawn_collectables_for_bench();
    wait 15;

    //this spawns the initial door anims + locations then it continues to thread if players are close and it also runs move door func
    level thread do_the_door();
    //( "main_door_unlocked" );
    
}


airlocking_doors()
{
    level endon( "end_game" );
    
    level.airlock_origin = spawn( "script_model", level.open_air_lock_door_origin );
    level.airlock_origin setmodel( "tag_origin" );
    level.airlock_origin.angles = ( 0, 0, 0 );

    if( level.dev_time ) { iprintln( "AIRLOCKING DOOR CHECK SPAWNED" );}
}
for_connecting_players()
{
    level endon( "end_game" );
    while( true )
    {
        level waittill( "connected", p );
        p thread applyOnSpawn();
    }
}

applyOnSpawn()
{
    self waittill( "spawned_player" );
    self.has_bar_piece = 0;
}


do_the_door()
{
    level endon( "end_game" );

    level waittill( "main_door_unlocked" );
    level thread square_fx_lights();
    level.right_blocker = spawn( "script_model", ( 8132.66, -5428.57, 48.125 ) );
    level.right_blocker setmodel( "collision_geo_64x64x64_standard" );
    level.right_blocker.angles = ( 0, 180, 0 );

    level.mid_blocker = spawn( "script_model", ( 8210.66, -5426.57, 48.125 ) );
    level.mid_blocker setmodel( "collision_geo_64x64x64_standard" );
    level.mid_blocker.angles = ( 0, 180, 0 );

    level.left_blocker = spawn( "script_model", ( 8258.66, -5426.57, 48.125 ) );
    level.left_blocker setmodel( "collision_geo_64x64x64_standard" );
    level.left_blocker.angles = ( 0, 180, 0 );
    //level waittill( "m_door_done" );
    wait 0.05;
    level.main_door_base_right = spawn( "script_model", level.door_base_main_right_location + ( 0, 0, 64 ) );
    level.main_door_base_right setmodel( level.myModels[ 9 ] );
    level.main_door_base_right.angles = ( 0, 180, 0 );

    wait 0.2;

    level.main_door_base_left = spawn( "script_model", level.door_base_main_left_location + ( 0, 0, 64 ) );
    level.main_door_base_left setmodel( level.myModels[ 9 ] );
    level.main_door_base_left.angles = ( 0, 180, 0 );

    wait 0.1;

    level.main_door_base_right rotateyaw( 360, 0.3, 0, 0.1 );
    level.main_door_base_left rotateyaw( 360, 0.3, 0, 0.1 );

    level.main_door_base_right moveto( level.door_base_main_right_location + ( 0,0, -44 ), 0.6, 0, 0.2 ); 
    level.main_door_base_left moveto( level.door_base_main_left_location + ( 0, 0, -44 ), 0.6, 0, 0.2 );

    level.main_door_base_left waittill( "movedone" );
    /*
    level.m_collisions = [];
    level.m_collisions[ 0 ] = ( level.door_base_main_right_location + ( 0, 0, -44 ) );
    level.m_collisions[ 1 ] = ( level.door_base_main_right_location + ( 0, 0, -44 ) );

    level.m_collisions[ 2 ] = ( level.door_base_main_left_location + ( 0, 0, -44 ) );
    level.m_collisions[ 3 ] = ( level.door_base_main_left_location + ( 0, 0, -44 )  );

    level.col_models = [];
    for( i = 0; i < level.m_collisions.size; i++ )
    {
        level.col_models[ i ] = spawn( "script_model", level.m_collisions[ i ] );
        level.col_models[ i ] setmodel( "collision_geo_64x64x64_standard" );
        level.col_models[ i ].angles = level.main_door_base_left.angles;
        wait 0.05;    
    }
    */
    wait 1;
    //monitor if players are close
    level thread monitorMovement();
    level thread monitorDoorHealth();

}

monitorMovement()
{
    level endon( "end_game" );
    
    first_time_hit = false;
    while( true )
    {
        if( level.door_health_ < 5 )
        {
            wait 1;
            continue;
        }
        if( level.m_door_opening == false )
        {
             //DO THE DOOR OPEN IF PLAYERS ARE WITHIN THE AREA
            for( i = 0; i < level.players.size; i++ )
            {
                if( distance2d( level.players[ i ].origin, level.airlock_origin.origin ) < 60 )
                {
                    if( level.players[ i ].origin[ 2 ] < 115  )
                    {
                        level.m_door_opening = true;
                        first_time_hit = true;
                        wait 0.05;
                    }
                }
                else 
                {
                    level.m_door_opening = false;
                    wait 0.05;
                }
            }
        }
       
        else if ( level.m_door_opening )
        {
            if( first_time_hit )
            {
                PlaySoundAtPosition(level.jsn_snd_lst[ 97  ], level.main_door_base_left.origin );
                PlaySoundAtPosition(level.jsn_snd_lst[ 97  ], level.main_door_base_right.origin );
                level.mid_blocker movez( -180, 0.5, 0, 0 );
                level.right_blocker movez( -180, 0.5, 0, 0 );
                level.left_blocker movez( -180, 0.5, 0, 0 );
                //level.col_models[ 0 ] moveto( level.m_collisions[ 0 ] + ( -150, 0, -44 ), 1, 0.2, 0.2 );
                //level.col_models[ 1 ] moveto( level.m_collisions[ 1 ] + ( -150, 0, -44 ), 1, 0.2, 0.2 );        
                //level.col_models[ 2 ] moveto( level.m_collisions[ 2 ] + ( 150, 0, -44 ), 1, 0.2, 0.2 );
                //level.col_models[ 3 ] moveto( level.m_collisions[ 3 ] + ( 150, 0, -44 ), 1, 0.2, 0.2 ); 
                level.main_door_base_left moveto( level.door_base_main_left_location + ( 150, 0, -44 ), 1, 0.2, 0.2 );
                level.main_door_base_right moveto( level.door_base_main_right_location + ( -150, 0, -44 ), 1, 0.2, 0.2 );    
                level.main_door_base_right playsound( level.mysounds[ 8 ] );
                level.main_door_base_left playsound( level.mysounds[ 8 ] );
                level.main_door_base_right waittill( "movedone" );
                level.main_door_base_right playsound( level.mysounds[ 9 ] );
                level.main_door_base_left playsound( level.mysounds[ 9 ] );

                first_time_hit = false;
            }
            if( level.m_door_opening && someone_is_touching_the_main_area() )
            {
                if( level.dev_time )
                {
                    iprintlnbold( "SOMEONE IS TOUCHING THE MAIN BASE TRIGGER AREA AND WE DONT SHUT THE DOORS BECAUSE OF IT" );
                }
                wait 1;
            }

            if ( level.m_door_opening && !someone_is_touching_the_main_area() && level.main_door_base_right.origin != level.door_base_main_right_location )
            {
                level.mid_blocker movez( 180, 0.5, 0, 0 );
                level.right_blocker movez( 180, 0.5, 0, 0 );
                level.left_blocker movez( 180, 0.5, 0, 0 );
                PlaySoundAtPosition(level.jsn_snd_lst[ 97  ], level.main_door_base_left.origin );
                PlaySoundAtPosition(level.jsn_snd_lst[ 97  ], level.main_door_base_right.origin );
                level.main_door_base_right moveto( level.door_base_main_right_location + ( 0, 0, -44 ), 0.6, 0, 0.2 );
                level.main_door_base_left moveto( level.door_base_main_left_location + ( 0,0, -44 ), 0.6, 0, 0.2 );
                level.main_door_base_right playsound( level.mysounds[ 8 ] );
                level.main_door_base_left playsound( level.mysounds[ 8 ] );
                level.main_door_base_left waittill( "movedone" );
                //level.col_models[ 0 ] moveto( level.m_collisions[ 0 ] + ( 0, 0, -44 ), 0.1, 0, 0 );
                //level.col_models[ 1 ] moveto( level.m_collisions[ 1 ] + ( 0, 0, -44 ), 0.1, 0, 0 );
                //level.col_models[ 2 ] moveto( level.m_collisions[ 2 ] + ( 0, 0, -44 ), 0.1, 0, 0 );
                //level.col_models[ 3 ] moveto( level.m_collisions[ 3 ] + ( 0, 0, -44 ), 0.1, 0, 0 );
                level.main_door_base_right playsound( level.mysounds[ 9 ] );
                level.main_door_base_left playsound( level.mysounds[ 9 ] );

                //safe timer to wait for doors closing
                wait( 0.7 );
                level.m_door_opening = false;
            }
        }
        
        wait 0.1;
        
    }
}

someone_is_touching_the_main_area()
{
    level endon( "end_game" );
    level endon( "end_this_touching" );

    for( i = 0; i < level.players.size; i++ )
    {
        if( distance2d( level.players[ i ].origin, level.open_air_lock_door_origin ) < 75 )
        {
            return true;
        }
        else 
        { 
            return false; 
        }
    }
}
level_spawns_main_door_stuff()
{
    wait 0.1;
    level thread base_fxs();
    sglobal_gas_quest_trigger_spawner( level.door_base_main_trigger_location, "^9[ ^3[{+activate}] ^8to build ^3Main Entrance Blocker ^9]", "^9[ ^8Main Entrance Blocker ^8has been built ^9]", "", level._effects[48], "main_door_unlocked" );
}

//10
//11
//12
//13 = with small flies
//level._effects[ 11 ] for safehouse entrance lights point upwards

//left side lamp = look from outside
//8083.96, -5463.78, 43.2023
//righ sidee 8300.14, -5448.42, 42.9963


//other door script
//outside lookin
//left
//7842.77, -4984.68, 44.64.23
//right
//7844.62, -5124.6, 43.2751


//firetrap curve light spawns 
//lookin at window from left to right
//8428.1, -5172.75, 264.125
//8419.41, -5228.11, 264.125
//8407.34, -5298, 264.125
//8378.76, -5354.92, 264.125
//8321.37, -5401.48, 264.125

//possible light bulb hangin
//8182.29, -5086.54, 389.636
//7985.66, -4735.01, 455.078
//8426.28, -4842.27, 472.34
//8021.4, -5290.2, 447.812

hover_lamper()
{
    level endon( "end_game" );
    while( isdefined( self ) ) 
    {
        self movez( 20, 5, 1, 1 );
        self waittill( "movedone" );
        self movez( -20, 5, 1, 1 );
        self waittill( "movedone" );
    }
}

precache_s()
{
    precachemodel( "p_lights_lantern_hang_on" );
}
base_fxs()
{
    level endon( "end_game" );

    //firetrap light curve
    curved_lights_origins =[];
    curved_lights_origins[ 0 ] = ( 8428.1, -5172.75, 264.125 );
    curved_lights_origins[ 1 ] = ( 8419.41, -5228.11, 264.125 );
    curved_lights_origins[ 2 ] = ( 8407.34, -5298, 264.125 );
    curved_lights_origins[ 3 ] = ( 8378.76, -5354.92, 264.125 );
    curved_lights_origins[ 4 ] = ( 8321.37, -5401.48, 264.125 );
    
    for( a = 0; a < curved_lights_origins.size; a++ )
    {
        light = spawn( "script_model", curved_lights_origins[ a ] );
        light setmodel( "p_lights_lantern_hang_on" );
        light.angles = light.angles;
        wait 0.05;
        light thread hover_lamper();
        playfx( level._effects[ 13 ], curved_lights_origins[ a ] );
        wait 1;
        playfx( level._effects[ 18 ], curved_lights_origins[ a ] );
        wait 0.05;
    }

    //hanging light bulbs
    hanging_bulb_origins = [];
    hanging_bulb_origins[ 0 ] = ( 8182.29, -5086.54, 389.636 );
    hanging_bulb_origins[ 1 ] = ( 7985.66, -4735.01, 455.078 );
    hanging_bulb_origins[ 2 ] = ( 8426.28, -4842.27, 472.34 );
    hanging_bulb_origins[ 3 ] = ( 8021.4, -5290.2, 447.812 );

    for( i = 0; i < hanging_bulb_origins.size; i++ )
    {
        //playfx( level._effects[ 9 ], hanging_bulb_origins[ i ] );
        wait 0.05;
        playfx( level._effects[ 18 ], hanging_bulb_origins[ i ] );
    }

    //outside lights upwards
    outside_lights_origins = [];
    outside_lights_origins[ 0 ] = ( 8083.96, -5463.78, 43.2023 );
    outside_lights_origins[ 1 ] = ( 8300.14, -5448.42, 42.9963 );
    outside_lights_origins[ 2 ] = ( 7842.77, -4984.68, 44.6423 );
    outside_lights_origins[ 3 ] = ( 7844.62, -5124.6, 43.2751 );

    for( z = 0; z < outside_lights_origins.size; z++ )
    {
        playfx( level._effects[ 12 ], outside_lights_origins[ z ] );
        wait 1;
        //playfx( level._effects[ 14 ], outside_lights_origins[ z ] );
        //playfx( level._effects[ 16 ], outside_lights_origins[ z ] );
        playfx( level._effects[ 18 ], outside_lights_origins[ z ] );
        wait 0.05;
    }
    
}
monitorDoorHealth()
{
    level endon( "end_game" );
    self_has_targeted = false;
    while( true )
    {
        zombies_ = getAIArray( level.zombie_team );
        if( level.door_health < 5 && !self_has_targeted )
        {
            for( i = 0; i < zombies_.size; i++ )
            {
                if( distance2d( zombies_[ i ].origin, level.airlock_origin.origin ) < 65 )
                {
                    wait randomfloatrange( 0.05, 0.45 );
                    zombie_hits_door = randomIntRange( 5, 25 );
                    rnd = randomint( 50 );
                    if( rnd < 15 )
                    {
                        playfxontag( level.myfx[ 9 ], zombies_[ i ], "j_elbow_le" );
                    }
                    
                    level.door_health_ -= zombie_hits_door;
                    if( level.dev_time ) { iprintln( "ZOMBIE hit main door and did ^1" + zombie_hits_door + " ^8amount of damage. ") ;
                    iprintln( "MAIN DOOR HEALTH IS AT: ^3" + level.door_health_ + " ^8/ ^3750" ); }
                }
            }
        }
        
        //zombies did enough damage to the door
        if( level.door_health_ < 5 && !level.door_needs_repairing )
        {
            level.main_door_tr setHintString( "^9[ ^8Door requires repairing ^9]" );
            //level notify( "main_door_has_been_broken" );
            level.door_needs_repairing = true;
            if( level.dev_time ){ iprintln( "ZOMBIE DOOR BROKE!" ); }
            self_has_targeted = true;
            level thread blast_doors_wide_open();
            level thread spawn_rebuildable_pieces();


            while( !base_has_been_rebuilt() )
            {
                wait 1;
            }
            wait 0.05;
            level thread blast_doors_wide_close();
            level.main_door_tr sethintstring( "^9[ ^8Door health: ^9" + level.door_health_ + " ^8/ ^9" + level.door_health_fixed_ + " ^9]" );
            if( level.dev_time )
            { 
                iprintln( "ZOMBIE MAIN DOOR BARRICADE HAS BEEN REBUILT" );
            }
            self_has_targeted = false;
            wait 0.1;
        }
        wait randomFloatRange( 0.5, 2.5 );
    }
}

blast_doors_wide_open()
{
    level endon( "end_game" );
    //level.col_models[ 0 ] moveto( level.m_collisions[ 0 ] + ( -150, 0, -54 ), 1, 0.2, 0.2 );
    //level.col_models[ 1 ] moveto( level.m_collisions[ 1 ] + ( -150, 0, 0 ), 1, 0.2, 0.2 );        
    //level.col_models[ 2 ] moveto( level.m_collisions[ 2 ] + ( 150, 0, -54 ), 1, 0.2, 0.2 );
    //level.col_models[ 3 ] moveto( level.m_collisions[ 3 ] + ( 150, 0, 0 ), 1, 0.2, 0.2 ); 
    level.main_door_base_left moveto( level.door_base_main_left_location + ( 150, 0, -54 ), 1, 0.2, 0.2 );
    level.main_door_base_right moveto( level.door_base_main_right_location + ( -150, 0, -54 ), 1, 0.2, 0.2 );   
    level.mid_blocker movez( -200, 0.5, 0, 0 );
    level.right_blocker movez( -200, 0.5, 0, 0 );
    level.left_blocker movez( -200, 0.5, 0, 0 ); 
    level.main_door_base_right playsound( level.mysounds[ 8 ] );
    level.main_door_base_left playsound( level.mysounds[ 8 ] );
    level.main_door_base_right waittill( "movedone" );
    level.main_door_base_right playsound( level.mysounds[ 9 ] );
    level.main_door_base_left playsound( level.mysounds[ 9 ] );
}

blast_doors_wide_close()
{
    level endon( "end_game" );
    level.main_door_base_right moveto( level.door_base_main_right_location + ( 0, 0, -54 ), 0.6, 0, 0.2 );
    level.main_door_base_left moveto( level.door_base_main_left_location + ( 0,0, -54 ), 0.6, 0, 0.2 );
    level.main_door_base_right playsound( level.mysounds[ 8 ] );
    level.main_door_base_left playsound( level.mysounds[ 8 ] );
    level.main_door_base_left waittill( "movedone" );
    //level.col_models[ 0 ] moveto( level.m_collisions[ 0 ] + ( 0, 0, -54 ), 0.1, 0, 0 );
    //level.col_models[ 1 ] moveto( level.m_collisions[ 1 ], 0.1, 0, 0 );
    //level.col_models[ 2 ] moveto( level.m_collisions[ 2 ] + ( 10, 0, -54 ), 0.1, 0, 0 );
    //level.col_models[ 3 ] moveto( level.m_collisions[ 3 ], 0.1, 0, 0 );
    level.mid_blocker movez( 200, 0.5, 0, 0 );
    level.right_blocker movez( 200, 0.5, 0, 0 );
    level.left_blocker movez( 200, 0.5, 0, 0 ); 
    level.main_door_base_right playsound( level.mysounds[ 9 ] );
    level.main_door_base_left playsound( level.mysounds[ 9 ] );
}
base_has_been_rebuilt()
{
    level endon( "end_game" );
    if( level.door_health_ >= level.door_health_fixed_ )
    {
        return true;
    }
    return false;
}


spawn_rebuildable_pieces()
{
    if( level.players_have_pieces > 0 )
    {
        return;
    }

    possible_origins[ 0 ] = ( -4573.98, 958.331, 175.547 ); //bridge
    possible_origins[ 1 ] = ( 8241.56, 8257.77, -554.781 ); //train
    possible_origins[ 2 ] = ( 13303.2, 62.6599, -191.906 ); //corn nnacht
    possible_origins[ 3 ] = ( -7791.01, 5276.51, -57.5811 ); //farm 8721.38, -6511.89, 112.125; this needs changing. //currently behind bus depo ( opposite side of nav card pick up depo)
    possible_origins[ 4 ] = ( 1609.28, -4479.94, -66.4735 ); //shortcut
    possible_origins[ 5 ] = (5234.69, 8060.26, -50.8346 ); //cabin

    possible_origins_angles[ 0 ] = ( 0, 113, 0 );
    possible_origins_angles[ 1 ] = ( 0, 167, 0 );
    possible_origins_angles[ 2 ] = ( 0, 355, 0 );
    possible_origins_angles[ 3 ] = ( 0, -7, 0 );
    possible_origins_angles[ 4 ] = ( 0, 265, 0 );
    possible_origins_angles[ 5 ] = ( 0, -35, 0 );

    spawn_amount = possible_origins.size;
    
    for( s = 0; s < spawn_amount; s++ )
    {
        fence = spawn( "script_model", possible_origins[ s ] );
        fence setmodel( level.mymodels[ 9 ] );
        fence.angles = possible_origins_angles[ s ];
        wait 0.1;
        playfxontag( level.myfx[ 48 ], fence, "tag_origin" ); 
        fence thread letPlayerPickUp();
    }
}

letPlayerPickUp()
{
    level endon( "end_game" );
    wait 0.05;
    p_t = spawn( "trigger_radius_use", self.origin, 48, 48, 48 );
    p_t setCursorHint( "HINT_NOICON" );
    p_t setHintString( "^9[ ^3[{+activate}] ^8to pick up some repair materials for ^9Safe House ^9]" );
    p_t TriggerIgnoreTeam();

    while( true )
    {
        p_t waittill( "trigger", who );
        who playsound( "evt_player_upgrade" );
        level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says( "^9" + who.name + " ^8found an upgrade piece that belongs to ^9Safe House", "", 8, 2.5  );
        //who playsound( "zmb_perks_packa_deny" );
        p_t setHintString( "^9[ ^8You found some repair materials to ^9Safe House ^9]" );
        who.has_bar_piece++;
        self delete();
        wait 2;
        p_t delete();
        level.players_have_pieces++;
        wait 0.1;
        break;
    }
}
sglobal_gas_quest_trigger_spawner( location, text1, text2, fx1, fx2, notifier )
{
    level endon( "end_game" );

    level.main_door_tr = spawn( "trigger_radius_use", location, 0, 48, 48 );
    level.main_door_tr setCursorHint( "HINT_NOICON" );
    level.main_door_tr sethintstring( "^9[ ^8Workbench requires more ^9Fence Pieces ]" );    
    level.main_door_tr triggerignoreteam();
    wait 0.05;
    i_m = spawn( "script_model", level.main_door_tr.origin );
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
    wait 0.05;
    
    level waittill( "found_all_door_pieces" );
    level.main_door_tr setHintString( text1 );
    while( true )
    {
        level.main_door_tr waittill( "trigger", me );
        if( isplayer( me ) && is_player_valid( me ) )
        {
            
            me playsound( "zmb_sq_navcard_success" );

            if( level.main_door_tr.origin == level.gas_pour_location )
            {
                if( isdefined( text2 ) && text2 != "" )
                {
                    level.main_door_tr setHintString( text2 );
                }
            }
            if( level.main_door_tr.origin == level.door_base_collision_clip_location )
            {
                if( isdefined( text2 ) && text2 != "" )
                {
                    level.main_door_tr setHintString( text2 );
                }
            }
            if( level.main_door_tr.origin == level.gas_fire_pick_location + ( 0, 0, 60 ) )
            {
                level.main_door_tr setHintString("");
            }
            me playsound( "evt_player_upgrade" );
            //who playsound( "zmb_perks_packa_deny" );
            me thread playlocal_plrsound();
            current_w = me getCurrentWeapon();
            me giveWeapon( "zombie_builder_zm" );
            me switchToWeapon( "zombie_builder_zm" );
            waiter = 3.5;
            wait waiter;
            me maps\mp\zombies\_zm_weapons::switch_back_primary_weapon( current_w );
            me takeWeapon( "zombie_builder_zm" );
            if( level.main_door_tr.origin == level.gas_pour_location )
            {
                //wait extra second to read the text
                wait 1;
            }
            wait 0.1;
            if( isdefined( notifier ) && notifier != "" )
            {
                wait 0.05;
                level notify( notifier );
                coop_print_base_notify_trap_main( notifier, me );
                wait 0.05;
                if( isdefined( level.main_door_tr ) )
                {
                    level.main_door_tr thread monitorAfterWards();
                    level.main_door_tr thread playlocal_plrsound();
                    
                    //level.main_door_tr delete();
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

monitorAfterWards()
{
    level endon( "end_game" );
    current_val = level.door_health_;
    while( true )
    {
        if( level.door_health_ > 5 && !level.door_needs_repairing )
        {
            self sethintstring( "^9[ ^8Door health: ^9" + level.door_health_ + " ^8/ ^9" + level.door_health_fixed_ + " ^9]" );
            wait 0.05;
            while( level.door_health_ > 5 )
            {
                current_val = level.door_health_;
                if( current_val > level.door_health_ )
                {
                    self setHintString( "^9[ ^8Door health: ^9" + level.door_health_ + " ^8/ ^9" + level.door_health_fixed_ + " ^9]" );
                    current_val = level.door_health_;
                }
                wait 1;                         
            }
        }
        
        if( level.door_needs_repairing )
        {
            self sethintstring( "^9[ ^3[{+activate}] ^8to repair the door ^9]" );
            self waittill( "trigger", who );
            if( level.door_health_ < 5 && level.pieces_added_to_door < 3 )
            {
                if( who.has_bar_piece == 0 )
                {
                    self sethintstring( "^9[ ^8You don't have any repair parts. ^9]" );
                    wait 2;
                    self sethintstring( "^9[ ^3[{+activate}] ^8to repair the door ^9]" );
                    wait 0.05;
                }
                if( who.has_bar_piece > 0 )
                {
                    self sethintstring( "^9[ ^8You've added a barricade piece to the door. ^9]" );
                    level.pieces_added_to_door++;
                    if( level.players_have_pieces > 0 )
                    {
                        level.players_have_pieces--;
                    }
                    
                    
                    
                    who.has_bar_piece --;
                    if( who.has_bar_piece < 0 )
                    {
                        who.has_bar_piece = 0;
                    }
                    wait 1;
                    //is this a good notify sound?
                    self playlocal_plrsound();
                    if( level.pieces_added_to_door >= 3 )
                    {
                        wait 0.1;
                        self sethintstring( "^9[ ^8The door is functional again ^9]" );
                        level.pieces_added_to_door = 0;
                        level.door_health_ = level.door_health_fixed_;
                        level.door_needs_repairing = false;
                    }
                }
            }
        }
        wait 1.5;
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



coop_print_base_notify_trap_main( which_notify, who_found )
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

_someone_unlocked_something( text, text2, duration, fadetimer )
{
    level endon( "end_game" );
	level thread Subtitle( text, text2, duration, fadetimer );
}

square_fx_lights()
{
    level endon( "end_game" );
    //level waittill( "spawn_main_door_square" );
    squares = [];
    squares[ 0 ] = ( 8292.12, -5378.92, 48.125 );
    squares[ 1 ] = ( 8292.12, -5337.67, 48.125 );
    squares[ 2 ] = ( 8292.12, -5307.34, 48.125 );
    squares[ 3 ] = ( 8192.12, -5284.94, 48.125 );
    squares[ 4 ] = ( 8238.31, -5284.12, 48.125 );
    squares[ 5 ] = ( 8186.74, -5284.12, 48.125 );
    squares[ 6 ] = ( 8118.62, -5284.12, 48.125 );
    squares[ 7 ] = ( 8097.09, -5330.5, 48.125 );

    for( s = 0; s < squares; s++ )
    {
        playfx( level._effects[ 13 ], squares[ s ] );
        wait 0.5;
        //playfx( level._effects[ 18 ], squares[ s ] );
        //wait 0.1;
    }
}
spawn_collectables_for_bench() //works well now
{
    level endon( "end_game" );
    wait 2;

    
    level thread while_check();

    possible_origins = [];
    possible_origins_angles = [];
    wait 1;

    possible_origins[ 0 ] = ( -4573.98, 958.331, 175.547 ); //bridge
    possible_origins[ 1 ] = ( 8241.56, 8257.77, -554.781 ); //train
    possible_origins[ 2 ] = ( 13303.2, 62.6599, -191.906 ); //corn nnacht
    possible_origins[ 3 ] = ( -7791.01, 5276.51, -57.5811 ); //farm 8721.38, -6511.89, 112.125; this needs changing. //currently behind bus depo ( opposite side of nav card pick up depo)
    possible_origins[ 4 ] = ( 1609.28, -4479.94, -66.4735 ); //shortcut

    possible_origins_angles[ 0 ] = ( 0, 113, 0 );
    possible_origins_angles[ 1 ] = ( 0, 167, 0 );
    possible_origins_angles[ 2 ] = ( 0, 355, 0 );
    possible_origins_angles[ 3 ] = ( 0, -7, 0 );
    possible_origins_angles[ 4 ] = ( 0, 265, 0 );
    //door spawns
    value_right = randomIntRange( 0, possible_origins.size );
    door_right_find = possible_origins[ value_right ];
    door_right_find_angles = possible_origins_angles[ value_right ];

    find_door_r = spawn( "script_model", door_right_find );
    find_door_r setmodel( level.mymodels[ 9 ] );
    find_door_r.angles = door_right_find_angles;

    wait 1;
    ArrayRemoveIndex( possible_origins, value_right );
    wait 1;
    value_left = randomintrange( 0, possible_origins.size );
    
    door_left_find = possible_origins[ value_left ];
    door_left_find_angles = possible_origins_angles[ value_left ];

    find_door_l = spawn( "script_model", door_left_find );
    find_door_l setmodel( level.mymodels[ 9 ] );
    find_door_l.angles = door_left_find_angles;
    
    wait 1;
    playfxontag( level.myFx[ 48 ], find_door_l, "tag_origin" );
    playfxontag( level.myFx[ 48 ], find_door_r, "tag_origin" );

    wait 1;

    trig_l = spawn( "trigger_radius_use", find_door_l.origin, 48, 48, 48 );
    trig_l setHintString( "^9 ^3[{+activate}] ^8to pick up an upgrade piece for ^9Safe House ]" );
    trig_l setCursorHint( "HINT_NOICON" );
    trig_l TriggerIgnoreTeam();
    wait 0.1;
    trig_r = spawn( "trigger_radius_use", find_door_r.origin, 48, 48, 48 );
    trig_r setHintString( "^9 ^3[{+activate}] ^8to pick up an upgrade piece for ^9Safe House ]" );
    trig_r setCursorHint( "HINT_NOICON" );
    trig_r TriggerIgnoreTeam();
    wait 1;
    trig_r thread waittill_pickup( "door_r", find_door_r );
    wait 0.05;
    trig_l thread waittill_pickup( "door_l", find_door_l );
}

while_check()
{
    level endon( "end_game" );
    while( level.collected_door_pieces < 2 )
    {
        wait 1;
    }
    level notify( "can_build_doors_for_airlock" );
    level notify( "found_all_door_pieces" );
}
waittill_pickup( switcher, model_to_delete )
{
    level endon( "end_game ");
    while( true )
    {
        self waittill( "trigger", who );
        if( is_player_valid( who ) )
        {
            
            if( switcher == "door_r" )
            {
                level.collected_door_pieces++;
                level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says( "^9" + who.name + " ^8found an upgrade piece that belongs to ^9Safe House", "", 8, 2.5  );
                wait 0.05;
                playfx( level._effect[ "fx_zmb_blackhole_trap_end" ], self.origin );
                PlaySoundAtPosition( level.mysounds[ 3 ], self.origin );
                wait 0.05;
                if( isdefined( self ) )
                {
                    self delete();
                }
                if( isdefined( model_to_delete ) )
                {
                    model_to_delete delete();
                }
                break;
            }
            else if( switcher == "door_l" )
            {
                level.collected_door_pieces++;
                level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says( "^9" + who.name + " ^8found an upgrade piece that belongs to ^9Safe House", "", 8, 2.5   );
                wait 0.05;
                playfx( level._effect[ "fx_zmb_blackhole_trap_end" ], self.origin );
                PlaySoundAtPosition( level.mysounds[ 3 ], self.origin );
                wait 0.05;
                if( isdefined( self ) )
                {
                    self delete();
                }
                if( isdefined( model_to_delete ) )
                {
                    model_to_delete delete();
                }
                break;
            }
            
        }
        wait 0.05;
    }
   
    
    

}
spawn_workbench_to_build_main_entrance()
{
    level endon( "end_game" );
    wait 1;
    org = ( 8505.35, -5215.87, 48.125 );
    build_maind_door_table = spawn( "script_model", level.door_base_main_trigger_location );
    build_maind_door_table setmodel( level.myModels[ 6 ] );
    build_maind_door_table.angles = ( 0, 0.337615, 0 );

    build_maind_door_table_clip = spawn( "script_model", org );
    build_maind_door_table_clip setmodel( "collision_geo_64x64x64_standard" );
    build_maind_door_table_clip.angles = ( 0, 0.337615, 0 );

    head_org = ( 8499.34, -5286.22, 88.2415 );
    new_loc_for_stupid_people = org + ( 0, 0, 40 );
    wait 0.1;
    build_maind_door_table_clip_head = spawn( "script_model", new_loc_for_stupid_people );
    build_maind_door_table_clip_head setmodel( "tag_origin" );
    build_maind_door_table_clip_head.angles = ( 0, 0, 0 );
    
    playFXOnTag( level.myfx[ 2 ], build_maind_door_table_clip_head, "tag_origin" );
    wait 0.05;
    //playfxontag( level.myfx[ 75 ], build_maind_door_table_clip, "tag_origin" );
    build_maind_door_table_clip_head thread spin_and_move_table_headm();
    
}

spin_and_move_table_headm()
{
    level endon( "end_game" );
    while( true )
    {
        self movez( 25, 0.8, 0.2, 0.2 );
        self rotateyaw( 360, 0.8, 0.2, 0.2 );
        self waittill( "movedone" );
        self movez( -25, 0.8, 0.2, 0.2 );
        self rotateyaw( 360, 0.8, 0.2, 0.2 );
        self waittill( "movedone" );
    }
}
