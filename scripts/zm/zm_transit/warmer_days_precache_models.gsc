//codename: warmer_days_mq_02_meet_mr_s.gsc
//purpose: handles precaching of all the level.myModels models, global models across files
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
    //my model list //"ZMUI_DIFFICULTY_DESC"
    level.myModels = [];
    level.custom_index = 0;
    //my precache models
    level thread precacheModels();

    //level thread ondevs(); //remove from real version
    flag_wait( "initial_blackscreen_passed" );
    wait 3;
    level.dev_time = true;
    wait 0.05;
    if( level.dev_time )
    {
        //level thread printmodelorginfo();
    }
    
}

ondevs()
{
    level endon( "end_game" );
    while( true )
    {
        level waittill( "connected", player );
        player thread spawns_model();
    }
    
}


printmodel_origin_angles_based_on_player()
{
    level endon( "end_game" );
    flag_wait( "initial_blackscreen_passed" );
    wait 3;
    //level.players[ 0 ] thread trackModel();
}

trackModel()
{
    level endon( "end_game" );
    self endon( "disconnect" );

    wait 1;

    level.gekko = spawn( "script_model", self.origin );
    level.gekko setmodel( level.myModels[ level.custom_index ] );
    level.gekko.angles = level.players[ 0 ].angles;
    wait 1;
    is_dead = false;
    level.gekko thread linktoplayerorigin();
    while( true )
    {   
        
        if( level.players[ 0 ] actionslottwobuttonpressed() )
        {
            if( is_dead )
            {
                level.gekko show();
                is_dead = false;
            }

            
            wait 0.05;
            
        }
        else if( !is_dead && level.players[ 0 ] ActionSlotTwoButtonPressed() )
        { level.gekko ghost(); is_dead = true; }
        wait 0.05;
        if( level.gekko.model != level.myModels[ level.custom_index ] )
        {
            iprintln( "New model = " + level.gekko.model );
            level.current_model_to_display setmodel( level.gekko.model );
        }
        else { wait 0.1; }
    }
}

printmodelorginfo()
{
    level endon( "end_game" );
    while( true )
    {
        iprintln( "Model is currently at: ^1" + level.players[ 0 ].origin );
        wait 0.05;
        iprintln( "Model's angles are currently: ^2" + level.players[ 0 ].angles );
        wait 2;
    }
}
linktoplayerorigin()
{
    level endon( "end_game" );
    while( true )
    {
        level.gekko.origin = level.players[ 0 ].origin;
        level.gekko.angles = level.players[ 0 ].angles;
        wait 0.1;
    }
}
precachemodels()
{
    level endon( "end_game" );

    //p6_zm_sign_diner
    //so how gumps works. 
    //as long as you are standing inside of a gump that the model is loaded in, you can see the model even across the map if placed there
    //but once you leave the gump zone, the model is shrunk even when you would be close to it
    level.myModels[ 0 ] = ( "collision_player_64x64x128" ); // WORKS EVERYWHERE, DOESNT HAVE DISAPPEARING LOD LEAFS   "t5_foliage_tree_burnt03"
    level.myModels[ 1 ] = ( "collision_geo_64x64x64_standard" );  // WORKS EVERYWHERE
    //level.myModels[1] = ( "collision_clip_sphere_64" );
    level.myModels[ 2 ] = ( "p_eb_lg_suitcase" );
    level.myModels[ 3 ] = ( "p_eb_med_suitcase" );
    //level.myModels[ 2 ] = ( "t5_foliage_tree_burnt02" );   // WORKS EVERYWHERE, HAS DISAPPEARING LOD LEAFS
    //level.myModels[ 3 ] = ( "collision_player_32x32x128" );   // WORKS EVERYWHERE
    level.myModels[ 4 ] = ( "t5_foliage_bush05" );  // WORKS EVERYWHERE
    level.myModels[ 5 ] = ( "p6_grass_wild_mixed_med" );  // WORKS EVERYWHERE
    level.myModels[ 6 ] = ( "p6_zm_work_bench" ); //( "foliage_red_pine_stump_lg" );  //WORKS AT CABIN BEFORE TOWN
    level.myModels[ 7 ] = ( "t5_foliage_shrubs02" ); // WORKS EVERYWHERE
    level.myModels[ 8 ] = ( "p6_zm_quarantine_fence_01" ); // WORKS EVERYWHERE, fence with wraps 
    level.myModels[ 9 ] = ( "p6_zm_quarantine_fence_02" ); // WORKS EVERYWHERE, fence with only metal barriers ( see thruable )
    level.myModels[ 10 ] = ( "p6_zm_quarantine_fence_03" );
    level.myModels[ 11 ] = ( "p6_zm_street_power_pole" ); //// WORKS DEPOT, big power telephone pole
    level.myModels[ 12 ] = ( "veh_t6_civ_bus_zombie" ); //BIG BUS WITH BIG PLOW
    level.myModels[ 13 ] = ( "veh_t6_civ_smallwagon_dead" ); // WORKS EVERYWHERE white car
    level.myModels[ 14 ] = ( "p6_zm_brick_clump_red_depot" ); // WORKS dpo, bricks laying on ground
    level.myModels[ 15 ] = ( "p_glo_street_light02_on_light" ); //// WORKS EVERYWHERE tilting downwards, could be a nice light for traps walls
    level.myModels[ 16 ] = ( "p_glo_electrical_pipes_long_depot" ); //long tight pipe lol laying on ground tilted to left from player angles
    level.myModels[ 17 ] = ( "p_glo_powerline_tower_redwhite" ); // WORKS EVERYWHERE big tower
    level.myModels[ 18 ] = ( "mp_m_trash_pile" ); // WORKS dpo  faces forward
 
    //DAY 2 MODELS
    level.myModels[ 19 ] = ( "com_payphone_america" ); // WORKS depo, faces player opposite
    level.myModels[ 20 ] = ( "com_stepladder_large_closed" ); //// WORKS EVERYWHERE
    level.myModels[ 21 ] = ( "dest_glo_powerbox_glass02_chunk03" ); // WORKS EVERYWHERE transpare glass piece
    level.myModels[ 22 ] = ( "hanging_wire_01" ); // WORKS depo
    level.myModels[ 23 ] = ( "hanging_wire_02" );// WORKS de
    level.myModels[ 24 ] = ( "hanging_wire_03" ); // WORKS de 
    level.myModels[ 25 ] = ( "light_outdoorwall01_on" ); // WORKS de
    level.myModels[ 26 ] = ( "lights_indlight_on_depot" ); // WORKS de

    level.myModels[ 27 ] = ( "p_glo_lights_fluorescent_yellow" );
    level.myModels[ 28 ] = ( "p_glo_sandbags_green_lego_mdl" ); // WORKS EVERYWHERE
    level.myModels[ 29 ] = ( "p_glo_tools_chest_short" ); // WORKS EVERYWHERE red hand carriable tool box
    level.myModels[ 30 ] = ( "p_glo_tools_chest_tall" ); // WORKS depo white tool chestE
    level.myModels[ 31 ] = ( "p_jun_caution_sign" ); // WORKS EVERYWHERE enter in the fog sign
    level.myModels[ 32 ] = ( "p_lights_cagelight02_red_off" ); // WORKS EVERYWHERE could be used to blink red light in the safe base
    level.myModels[ 33 ] = ( "p_jun_rebar02_single_dirty" ); // WORKS depo

    //level.myModels[34] = ( "NEXT LIST = p6 MODELS / DNT SPAWN THIS" );
    level.myModels[ 34 ] = ( "p6_lights_club_recessed" ); // WORKS EVERYWHERE white lamp circle on ground good for safe base
    level.myModels[ 35 ] = ( "p6_garage_pipes_1x128" ); // WORKS EVERYWHERE
    level.myModels[ 36 ] = ( "p6_street_pole_sign_broken" ); // WORKS de
    level.myModels[ 37 ] = ( "p6_zm_buildable_battery" ); // WORKS EVERYWHERE good for some pick up stuff
    level.myModels[ 38 ] = ( "p6_zm_buildable_sq_scaffolding" ); // WORKS EVERYWHERE good for building a plank across the safe base?
    level.myModels[ 39 ] = ( "p6_zm_buildable_sq_transceiver" ); // WORKS EVERYWHERE radio for pick up
    level.myModels[ 40 ] = ( "p6_zm_building_rundown_01" ); // WORKS depo maybe put it up on the roof
    level.myModels[ 41 ] = ( "p6_zm_building_rundown_03" ); // WORKS DEPO
    level.myModels[ 42 ] = ( "p6_zm_chain_fence_piece_end" ); // WORKS EVERYWHERE END OF FENCE PIECE RAILING FACEING UP
    level.myModels[ 43 ] = ( "p6_zm_outhouse" ); // WORKS depo shrek house
    level.myModels[ 44 ] = ( "p6_zm_power_station_railing_steps_labs" ); // WORKS EVERYWHERE stairs railing
    level.myModels[ 45 ] = ( "p6_zm_raingutter_clamp" ); // WORKS EVERYWHERE
    level.myModels[ 46 ] = ( "p6_zm_rocks_large_cluster_01" ); // WORKS EVERYWHERE
    level.myModels[ 47 ] = ( "p6_zm_rocks_medium_05" ); // WORKS EVERYWHERE
    level.myModels[ 48 ] = ( "p6_zm_rocks_small_cluster_01" ); // WORKS EVERYWHERE
    level.myModels[ 49 ] = ( "p6_zm_sign_terminal" ); // WORKS depo, terminal gold text
    level.myModels[ 50 ] = ( "p6_zm_sign_restrooms" ); // WORKS de
    level.myModels[ 51 ] = ( "p6_zm_street_power_pole" ); // WORKS depo smaller telephone
    level.myModels[ 52 ] = ( "p6_zm_water_tower" ); // WORKS depo

    level.myModels[ 53 ] = ( "NEXT LIST = CAR MODELS / DNT SPAWN THIS" );
    level.myModels[ 54 ] = ( "test_macbeth_chart_unlit" );
    level.myModels[ 55 ] = ( "test_sphere_silver" );
    level.myModels[ 56 ] = ( "veh_t6_civ_60s_coupe_dead" );
    level.myModels[ 57 ] = ( "veh_t6_civ_microbus_dead" );
    level.myModels[ 58 ] = ( "veh_t6_civ_movingtrk_cab_dead" );

    level.myModels[ 59 ] = ( "NEXT LIST = DIFFERENT COLLISION HIT BOXES / DNT SPAWN THIS" );
    level.myModels[ 60 ] = ( "collision_wall_256x256x10_standard" );
    level.myModels[ 61 ] = ( "collision_geo_32x32x10_standard" );
    level.myModels[ 62 ] = ( "collision_wall_128x128x10_standard" );
    level.myModels[ 63 ] = ( "collision_wall_64x64x10_standard" );
    level.myModels[ 64 ] = ( "collision_wall_512x512x10_standard" );
    level.myModels[ 65 ] = ( "collision_player_32x32x128" );
    level.myModels[ 66 ] = ( "collision_player_256x256x256" );
    level.myModels[ 67 ] = ( "collision_clip_sphere_32" );
    level.myModels[ 68 ] = ( "collision_geo_128x128x10_standard" );
    level.myModels[ 69 ] = ( "collision_player_256x256x10" );
    
    
    level.myModels[ 70 ] = ( "collision_ai_64x64x10" );
    level.myModels[ 71 ] = ( "collision_clip_64x64x256" );
    level.myModels[ 72 ] = ( "collision_clip_ramp" );
    level.myModels[ 73 ] = ( "collision_clip_sphere_64" );
    level.myModels[ 74 ] = ( "collision_physics_64x64x256" );
    level.myModels[ 75 ] = ( "t6_wpn_grenade_frag_world" );
    level.myModels[ 76 ] = ( "c_zom_zombie3_g_rlegspawn" );
    level.myModels[ 77 ] = ( "c_zom_zombie1_body01_g_legsoff" );
    for( i = 0; i < level.myModels.size; i++ )
    {
        precachemodel( level.myModels[ i ] ) ;
    }
}



spawns_model()
{
    self endon( "disconnect" );
    level endon( "end_game" );
	self waittill( "spawned_player" );
	level.custom_index = 0;

    
	/*
    s1 = actionslotonebuttonpressed();
    s2 = actionsslottwobuttonpressed();
    s3 = actionslotthreebuttonpressed();
    s4 = actionslotfourbuttonpressed();
    */

    
    while( true )
    {
        if ( self actionslotonebuttonpressed() )
        {
            
            /*
            if( index < level.x_models.size  )
            {
                index++;
				if( level.dev_time ){ iPrintLnBold( "INDEX: = " + index ); }
            }
			if( index == 0 )
			{
				if( level.dev_time ){ iprintlnbold( "Index is already at " +  index ); }
				wait 0.1;
			}
            wait 0.5;


            */

            if( level.custom_index < level.myModerls.size  )
            {
                level.custom_index++;
				if( level.dev_time ){ iPrintLnBold( "INDEX: = " + level.custom_index ); }
            }

            if( level.custom_index > level.myModels.size )
            {
                level.custom_index = 0;
            }
			if( level.custom_index == 0 )
			{
				if( level.dev_time ){ iprintlnbold( "Index is already at " +  level.custom_index ); }
				wait 0.1;
			}
            wait 0.5;  
        }
            
		/*
        if( self actionslottwobuttonpressed() )
        {
            if( index > 1 )
            {
                index--;
				if( level.dev_time ){ iPrintLnBold( "INDEX: = " + index ); }
            }
			if( index == 0 )
			{
				if( level.dev_time ){ iprintlnbold( "Index is already at " +  index ); }
				continue;
			}
            wait 0.08;
        }
		*/
            

        if( self actionslotthreebuttonpressed() )
        {
            if( self JumpButtonPressed() )
            {
                if( isdefined( level.gekko ) )
                {
                    level.gekko delete();
                }
            }
            
            /*
            gekko = spawn( "script_model", self.origin );
            gekko setmodel( level.x_models[ index ] );
            gekko.angles = level.players[ 0 ].angles;
			if( level.dev_time ){ iprintlnbold( "Played a model: ^3" + level.x_models   [ index ] ); }
            */
            if( !isdefined( level.gekko ) )
            {
                level.gekko = spawn( "script_model", self.origin );
                level.gekko setmodel( level.myModels[ level.custom_index ] );
                level.gekko.angles = level.players[ 0 ].angles;
            }

            gek = spawn( "script_model", self.origin );
            gek setmodel( level.myModels[ level.custom_index ] );
            gek.angles = level.players[ 0 ].angles;
            
			if( level.dev_time ){ iprintlnbold( "Played a model: ^3" + level.myModels[ level.custom_index ] ); }
            
        }
		/*
        if( self actionslotfourbuttonpressed() )
        {
            mover = spawn( "script_model", self.origin + 200, 0, 30 );
            mover setmodel( "tag_origin" );
            mover.angles = ( 0, 0, 0 );
            wait 0.05; 
            playfxontag( level.myFx[ index ], mover, "tag_origin" );
			xx = self actionslotthreebuttonpressed();
			while( self meleeButtonPressed() )
			{
				if( level.dev_time )
				{
					iprintlnbold( "Remember to hit melee after " + xx );
				}
				wait 0.1;
			}

            //mover moveto( self getPlayerAngles( anglesToForward( self ) / 4 ), 2, 0.1, 0.1 );
            wait 2;
            mover delete();
            wait 0.08;
        }
*/
        wait 0.1;
    }
}