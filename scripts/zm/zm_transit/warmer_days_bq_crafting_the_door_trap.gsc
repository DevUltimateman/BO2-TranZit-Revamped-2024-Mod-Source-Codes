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

//#include scripts\zm\zm_transit\zm_warmer_days_bq_crafting_the_fire_trap;



init()
{
    level.door_base_side_right_location = ( 8111.15, -5415.53, 1.75549 );
    level.door_base_side_right_angles = ( 0, -179.115, 0 );

    level.door_base_side_left_location = ( 8286.42, -5415.53, 1.75549 );
    level.door_base_side_left_angles = ( 0, -179.115, 0 );

    level.door_base_side_trigger_location = ( 8101.83, -4942.4, 48.125 );

    level.door_base_collision_clip_location = ( 7875.72, -5052.77, -8.92751 );
    level.door_base_collision_clip_angles = ( 0, 89.8134, 0 );
    precache_this();
    flag_wait( "initial_blackscreen_passed" );

    level thread collectibs_origins_and_logic();
    level thread initialize_everything_for_side_door();
    level thread spawn_workbench_to_build_side_barricade();
    level thread spawn_collision_and_model();
    precachemodel( "collision_player_128x128x128" );
}


spawn_workbench_to_build_side_barricade()
{
    level endon( "end_game" );
    wait 1;
    org = ( 8101.83, -4942.4, 48.125 ); 
    build_side_door_table = spawn( "script_model", org );
    build_side_door_table setmodel( level.myModels[ 6 ] );
    build_side_door_table.angles = ( 0, 71.8586, 0 );

    build_side_door_table_clip = spawn( "script_model", level.door_base_side_trigger_location );
    build_side_door_table_clip setmodel( "collision_geo_64x64x64_standard" );
    build_side_door_table_clip.angles = ( 0, 71.8586, 0 );

    head_org = ( 8189.51, -4945.98, 88.0626 );
    news_ = org + ( 0, 0, 50 );
    build_side_door_table_clip_head = spawn( "script_model", news_ );
    build_side_door_table_clip_head setmodel( "tag_origin" );
    build_side_door_table_clip_head.angles = ( 0, 0, 0 );

    wait 0.1;
    playFXOnTag( level.myfx[ 2 ], build_side_door_table_clip_head, "tag_origin" );
    wait 0.05;
    playFXOnTag( level.myfx[ 75 ], build_side_door_table_clip, "tag_origin" );
    wait 0.05;
    build_side_door_table_clip_head thread spin_and_move_table_heads();
    
}

spin_and_move_table_heads()
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


initialize_everything_for_side_door()
{
    level endon( "end_game" );
    wait 20;
sglobal_gas_quest_trigger_spawner( level.door_base_side_trigger_location + ( 0,0, 70), "^9[ ^8Workbench requires ^9something ^8that can be collected ^9]", "^9[ ^8Side barricade built ^9]", "", level._effects[48], "side_door_unlocked" );
    
    
}
 
spawn_findable_piece()
{
    //
}

spawn_collision_and_model()
{
    level waittill( "side_door_unlocked" );
    wait 0.1;

    mt = spawn( "script_model", level.door_base_collision_clip_location + ( 0, 0, 64 ) );
    mt setmodel( level.myModels[ 9 ] );
    mt.angles = level.door_base_collision_clip_angles + ( 0, 180, 0 );

    
    wait 0.05;
    //playfxontag( level._effect[ "lght_marker" ], mt, "tag_origin" );
    mt moveZ( -64, 1, 0.1, 0.1 );
    mt waittill( "movedone" );
    xx = mt.origin;
    wait 0.05;
    org = [];
    org[0] = ( 7867.4, -5004.24, 48.125 );
    org[1] = ( 7867.4, -5060.24, 48.125 );
    org[2] = ( 7867.4, -5120.24, 48.125 );

    for( s = 0; s < org.size; s++ )
    {
        temp = spawn( "script_model", org[ s ] );
        temp setmodel( "collision_geo_64x64x64_standard" );
        temp.angles =  temp.angles;
    }
    //mtc = spawn( "script_model", level.door_base_collision_clip_location + (0,0,30)  );
    //mtc setmodel( "collision_player_128x128x128" );
    //mtc.angles = level.door_base_collision_clip_angles + ( 0, 180, 0 );

    wait 0.05;
    //playfxontag( level._effect[ "lght_marker" ], mtc, "tag_origin" );
    //mtc2 = spawn( "script_model", level.door_base_collision_clip_location +( 0, 0, 30 ) );
    //mtc2 setmodel( "collision_player_128x128x128" );
    //mtc2.angles = level.door_base_collision_clip_angles + ( 0, 180, 0 );

    wait 0.1;
    
    guuguu = loadfx( "maps/zombie/fx_zmb_morsecode_traffic_loop" );
    wait 0.05;
    playfx( level.myfx[ 0 ], level.door_base_collision_clip_location + ( 0, -55, 96  ) );
    wait 0.05;
    playfx( level.myfx[ 0 ], level.door_base_collision_clip_location + ( 0, 55, 96 ) );
}
debug_outdoor_triggers()
{
    level endon( "end_game" );

    flag_wait( "initial_blackscreen_passed" );
    iprintln( "LETS PLAY FX ON OUTDOOR TRIGGER" );

    //g 

    //trigger_multiple doesnt set fog
    //
    
    ents =  getentarray();
    wait 1;    
}

monitorTrigs()
{
    //self endon( "disconnect" );
    level endon( "end_game" );

    flag_wait( "initial_blackscreen_passed" );
    entt = getentarray();
    
    for( i = 0; i < entt.size; i++ )
    {
            //.classname == trigger_multiple
            //.classname == script_struct
            if( entt[ i ].classname != "" )
            {
                //entt[ i ] thread monitorme();
                iprintln( entt[i].script_noteworthy );
                wait 0.1;
                if( entt[ i ].classname == "info_volume" )
                {
                    iprintln( "TARGETNAME WAS " + entt[ i ].targetname );
                    wait 0.1;

                    if( isdefined( entt[ i ].script_string ) && entt[ i ].script_string != "" )
                    {
                        iprintln( "SCRIPT STRING FOR TARGETNAME WAS " + entt[ i ].script_string );
                        wait 0.1;
                    }
                }

                
                wait 0.1;
            }
    }
    wait 0.1;
    
}

monitorme()
{
    level endon( "end_game" );
    while( true )
    {
        self waittill( "trigger", who );
        {
            if( who == level.players[ 0 ] )
            {
                iprintlnbold( "touching trigger " + self + " " + who.name );
                wait 0.05;
            }
        }
    }
}


monitorsafetyenter()
{
    level endon( "end_game" );
    maps\mp\zm_transit::disable_triggers();
    {
        while( true )
        {
             if( maps\mp\zm_transit::player_entered_safety_zone( level.players[0]) )
            {
                iprintlnbold( "^2PLAYER ENTERED SAFETY ZONE" );

            }
            else 
            {
                iprintlnbold( "^1PLAYER IS NOT IN SAFE ZONE");
            }
            wait 0.2;
        }
       
    }
}

collectibs_origins_and_logic()
{
    all_possible_locs = [];
    all_possible_locs[ 0 ] = ( 2306.12, -701.141, -55.875 ); //next to bowlin ally
    all_possible_locs[ 1 ] = ( 3685.31, 6023.13, -63.875 ); //cabin outside
    all_possible_locs[ 2 ] = ( 11322.8, 7706.78, -541.607 ); //next to ak74
    all_possible_locs[ 3 ] = ( 10431.1, 6847.95, -574.742 ); //before powerstation on  right
    all_possible_locs[ 4 ] = ( 6175.08, -5265.25, -46.005 ); //farm
    all_possible_locs[ 5 ] = ( -10990.1, -349.192, 192.125 ); //tunnel spot
    all_possible_locs[ 6 ] = ( -5590.65, -5612.45, -63.8965 ); //left side of dine ( big open area )

    loc_models = [];
    loc_models[ 0 ] = ( "com_file_cabinets_a_drawer" );
    loc_models[ 1 ] = ( "p_jun_storage_crate_forest2" );
    loc_models[ 2 ] = ( "p_zom_barrel_02_clean" );
    loc_models[ 3 ] = ( "p_zom_barrel_02_clean" );
    loc_models[ 4 ] = ( "com_crate01_farm" );
    loc_models[ 5 ] = ( "com_debris_engine02" );
    loc_models[ 6 ] = ( "p_rus_storage_cabinet" );

    loc_angles = [];
    loc_angles[ 0 ] = ( 0, 45, 0 ); //town
    loc_angles[ 1 ] = ( 0, 280, 0 ); //cabin
    loc_angles[ 2 ] = ( 0, 20, 0 ); //next to ak74
    loc_angles[ 3 ] = ( 0, 140, 0 ); //power
    loc_angles[ 4 ] = ( 0, 180, 0 ); //farm
    loc_angles[ 5 ] = ( 0, 270, 0 ); //tunnel
    loc_angles[ 6 ] = ( 90, 90, 0 ); //diner
    level.side_barrier_has_been_found = false;
    level.random_spawn_value = randomIntRange( 0, loc_angles.size ); 
    wait 0.1;
    for( i = 0; i < all_possible_locs.size; i++ )
    {
        spawn_l = spawn( "script_model", all_possible_locs[ i ] );
        spawn_l setmodel( loc_models[ i ] );
        spawn_l.anlges = loc_angles[ i ];
        spawn_l solid();
        wait 0.1;
        col = spawn( "script_model", spawn_l.origin );
        col setmodel( "collision_geo_64x64x64_standard" );
        col.angles = col.angles;
        playfx( level._effects[17], spawn_l.origin );
        wait 1;
        trig = spawn( "trigger_radius_use", spawn_l.origin + ( 0, 0, 10 ), 0,120,120 );
        trig setHintString( "^9[ ^3[{+activate}] ^8to search location for ^9Safe House^8 items ^9] " );
        trig setCursorHint( "HINT_NOICON" );
        trig TriggerIgnoreTeam();
        trig thread do_search_logic( i );
        trig thread continue_search_logic( i );

    }

}

continue_search_logic( original_value )
{
    level endon( "end_game" );
    level waittill( "change_search_hintstring" );
    wait 0.25;
    self setHintString( "^9[ ^8Something valuable was found. ^9]" );
    wait 2.5;
    self setHintString( "^9[ ^8Something valuable has already been found. ^9]" );
    level waittill( "continue_search_logic_for_old_triggers" ); //forever waittill

}

do_search_logic( maxss )
{
    level endon( "stop_first_search_logic" );
    self waittill( "trigger", who );
    if( level.random_spawn_value == maxss && !level.side_barrier_has_been_found )
    {
        wait 0.1;
        who playsound( "evt_nuke_flash" );
        level.side_barried_has_been_found = true;
        level notify( "change_search_hintstring" );
        level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says( "^9" + who.name + " ^8found a piece that allows upgrading ^9Safe House's ^8side entrance to have a zombie barrier!", "", 8, 1  );
        wait 10;
        level notify( "stop_first_search_logic" );
    }
    else { 
        who playsound( "zmb_perks_packa_deny" );
        self setHintString( "^9[ ^8Nothing valuable was found. ^9]" );}

}
precache_this()
{
    precachemodel( "p_glo_bucket_metal" );// only works in cabin woods

    precachemodel( "p_rus_storage_cabinet" ); //diner model
    precachemodel( "com_crate01_farm" ); //farm
    precachemodel( "p_jun_storage_crate_forest2" ); //cabin
    precachemodel( "p_glo_trashcan_diner" );
    precachemodel( "com_file_cabinets_a_drawer" ); //town
    precachemodel( "p6_monsoon_crate_01_shell" ); //ak74
    precachemodel( "p_zom_barrel_02_clean" ); //pstation
}
sglobal_gas_quest_trigger_spawner( location, text1, text2, fx1, fx2, notifier )
{
    level endon( "end_game" );

    tr = spawn( "trigger_radius_use", location, 0, 48, 48 );
    tr setCursorHint( "HINT_NOICON" );
    tr setHintString( text1 );
    tr triggerignoreteam();
    wait 0.05;
    i_m = spawn( "script_model", tr.origin );
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
    level waittill( "change_search_hintstring" );
    tr setHintString( "^9[ ^3[{+activate}] ^8to build ^3Side Entrance Blocker ^9 ]" );
    wait 1;
    while( true )
    {
        tr waittill( "trigger", me );
        if( isplayer( me ) && is_player_valid( me ) )
        {
            
            me playsound( "zmb_sq_navcard_success" );

            if( tr.origin == level.gas_pour_location )
            {
                if( isdefined( text2 ) && text2 != "" )
                {
                    tr setHintString( text2 );
                }
            }
            if( tr.origin == level.door_base_collision_clip_location )
            {
                if( isdefined( text2 ) && text2 != "" )
                {
                    tr setHintString( text2 );
                }
            }
            if( tr.origin == level.gas_fire_pick_location + ( 0, 0, 60 ) )
            {
                tr setHintString("");
            }
            me thread playlocal_plrsound();
            current_w = me getCurrentWeapon();
            me giveWeapon( "zombie_builder_zm" );
            me switchToWeapon( "zombie_builder_zm" );
            waiter = 3.5;
            wait waiter;
            me maps\mp\zombies\_zm_weapons::switch_back_primary_weapon( current_w );
            me takeWeapon( "zombie_builder_zm" );
            if( tr.origin == level.gas_pour_location )
            {
                //wait extra second to read the text
                wait 1;
            }
            wait 0.1;
            if( isdefined( notifier ) && notifier != "" )
            {
                wait 0.05;
                level notify( notifier );
                coop_print_base_find_or_fortify_door_trap( notifier, me );
                wait 0.05;
                if( isdefined( tr ) )
                {
                    //tr delete();
                    tr setHintString( "^9[ ^8Side Entrance Blocker has been built ^9]");
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

playlocal_plrsound()
{
    self endon( "disconnect" );
    self playsound( level.mysounds[ 12 ] );
    wait 0.05;
    self playsound( level.mysounds[ 8 ] );
    wait 0.6;
    self playsound( level.mysounds[ 9 ] );
}

playloop_electricsound()
{
    level endon( "end_game" );
    while( true )
    {
        PlaySoundAtPosition( level.mysounds[ 1 ], level.gas_pour_location );
        wait 5;
    }
}


coop_print_base_find_or_fortify_door_trap( which_notify, who_found )
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


flyby( element )
{
    level endon( "end_game" );
    x = 0;
    on_right = 640;

    while( element.x < on_right )
    {
        element.x += 200;
        /*
        //if( element.x < on_right )
        //{
            
            //waitnetworkframe();
        //    wait 0.01;
        //}
        //if( element.x >= on_right )
        //{
        //    element destroy();
        //}
        */
        wait 0.05;
    }
    if( isdefined( element ) )
    {
        element destroy_hud();
    }
    
    
}
