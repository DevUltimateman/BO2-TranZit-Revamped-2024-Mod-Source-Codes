//::purpose
//
//  after poisonous clouds have pushed players to farm and clouds have disappeared
//  this script handles the spawning of initial suitcase at bus depo
// this script then does the locate suitcases near perk machines logic
// each location has a shootable perk bottle step that players must complete
//  upon completion a potion spawns inside of labs and players can take a zip from it and become immune to poisonous clouds

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

//idea
//wait till players picked up mixing elixir
//spawn 3 generators at town center
//all players in the game have to nade the generator group with upgraded nades of fires
//generators start flowing up
//then explode up in ari
//spawn 3 generators around map
//they require kill boxes
//once box is done
//have players together nade the generator again till it teleports next to pylon at corn
//once all gens at pylon

init()
{
    //initial amount that touches genes
    level.close_to_size = 0;
    level.rocks_at_pylon = 0;

    level.kills_to_move_generators = 0;
    level.kills_to_move_generators_reach = 75;
    forest_zones(); //global zones for zombie speed up
    //for d bug
    level thread cheat_();
    precache_these();
    level.rock_summoning_step_active = false;
    level.forest_zones = [];
    level.forest_zones[ 0 ] = ( "zone_trans_2b" );
    level.forest_zones[ 1 ] = ( "zone_trans_2" );
    level.forest_zones[ 2 ] = ( "zone_trans_4"  );
    level.forest_zones[ 3 ] = ( "zone_amb_forest" );
    level.forest_zones[ 4 ] = ( "zone_trans_10" );
    level.forest_zones[ 5 ] = ( "zone_trans_5" );
    level.forest_zones[ 6 ] = ( "zone_trans_6" );
    level.forest_zones[ 7 ] = ( "zone_trans_7" );
    level.forest_zones[ 8 ] = ( "zone_trans_pow_ext1" );
    level.forest_zones[ 9 ] = ( "zone_trans_8" );
    level.forest_zones[ 10 ] = ( "zone_amb_power2town" );
    level.forest_zones[ 11 ] = ( "zone_trans_9" );
    level.forest_zones[ 12 ] = ( "zone_trans_11" );
    level.forest_zones[ 13 ] = ( "zone_amb_bridge" );
    level.forest_zones[ 14 ] = ( "zone_trans_1" );
    level.forest_zones[ 15 ] = ( "zone_amb_cornfield" );


    level.r0_kills = 0;
    level.r1_kills = 0;
    level.r2_kills = 0;
    level.required_rock_summoning_kills = 25; //25 for release
    level.cabin_summoning = false;
    level.diner_summoning = false;
    level.corn_summoning = false;
    level.first_time_texter = false;
    
    level.rock_summoning_active = false;    
    level.rock_summoning_stage_active = false;


    level.rifts_disabled_for_while = false;
    


    flag_wait( "initial_blackscreen_passed" );

    level thread print_middle_when_speeds_alter(); //print stuff when zombie speeds etc change
    level thread level_round_10_speed_change();
    //level thread change_speed();
    if( level.dev_time && getdvar( "developer_script" ) == 1 )
    {
        level thread print_debug_zone();
    }
    level waittill( "do_it" ); //for debugging, enable back later
    level thread rocks_at_town_talk();
    level thread rocks_at_pylon();
    level thread spawn_generators();
    level thread generators_disappear();

    

    level thread all_rocks_done();
    //level thread track_count_and_move_underneath_pylon();
    //precache_these();
     //for zombie death callbacks while level.summoninglevel true
    //register_zombie_death_event_callback( ::get_souls_for_zombas );
}

print_debug_zone()
{
    level endon( "end_game" );
    flag_wait( "initial_blackscreen_passed" );
    while( true )
    {
        zones = level.players[ 0 ] get_zone_name();
        iprintlnbold( "player is touching zone ^1" + zones );
        wait 1;
    }
}
change_speed()
{
    level endon( "end_game" );
    flag_wait( "initial_blackscreen_passed" );
    wait 31;
    playables = getentarray( "player_volume", "script_noteworthy" );
    while( true )
    {
        z = getAIArray( level.zombie_team );
        for( s = 0; s < z.size; s++ )
        {
            for( a = 0; a < playables.size; a++ )
            {
                if( isDefined( z[ s ] ) && !isdefined(z[s].Sprinter) && z[ s ] isTouching( playables[ a ] ) && z[s] && z[s].completed_emerging_into_playable_area == 1 && !isdefined(z[s].Sprinter) )
                {
                    z [s].sprinter = true;
                    z [s] set_zombie_run_cycle( "super_sprint" );
                }
                else 
                { 
                    iprintln( "zombies ^9" + z[ s ] + "^7 is not touching any safe volumes" ); 
                }
            }
        }
        wait 0.05;
    }
}

level_round_10_speed_change()
{
    level endon( "end_game" );
    wait 31;
    level thread change_zombie_speed10();
}

change_zombie_speed10()
{
    level endon( "end_game" );
    playables = getentarray( "player_volume", "script_noteworthy" );
    while( true )
    {
        zo = getAIArray( level.zombie_team ); 

        for( s = 0; s < zo.size; s++ )
        {
            if( isdefined(zo[ s ].is_allowed_to_apply_movement_thread ) && zo[ s ].is_allowed_to_apply_movement_thread )
            {
                wait 0.05;
                continue;
            }
            else if( !isdefined( zo[ s ].is_allowed_to_apply_movement_thread ) && !zo[ s ].is_allowed_to_apply_movement_thread )
            {
                zo[ s ].is_allowed_to_apply_movement_thread = true;
                zo[ s ] thread apply_movement_monitor();
            }
        }
        wait 1;
    }     
    
}

apply_movement_monitor()
{
    self endon( "death" );
    self.has_marked_for_thread = true;
    if( !self.completed_emerging_into_playable_area )
    {
        while( !self.completed_emerging_into_playable_area )
        {
            wait 0.5;
        }
    }
    wait 0.2;
    
    temp = false;
    r1 = "super_sprint";
    r2 = "sprint";
    
    if( level.spirit_step_active ) 
    {
        playfx( level._effects[ 77 ], self.origin );
        self set_zombie_run_cycle( "walk" );
        return;
    }

    if( level.moving_to_depo_active )
    {
        playfx( level._effects[ 77 ], self.origin );
        self set_zombie_run_cycle( r1 );
        return;
    }

    if( level.rock_summoning_active )
    {
        playfx( level._effects[ 77 ], self.origin );
        self set_zombie_run_cycle( r2 );
        wait 2;
        playfx( level._effects[ 77 ], self.origin );
        self set_zombie_run_cycle( r1 );
        return;
    }

    if( level.rift_step_active )
    {
        playfx( level._effects[ 77 ], self.origin );
        self set_zombie_run_cycle( r2 );
        wait 2;
        playfx( level._effects[ 77 ], self.origin );
        self set_zombie_run_cycle( r1 );
        return;
    }

    if( level.lock_down_enabled )
    {
        playfx( level._effects[ 77 ], self.origin );
        self set_zombie_run_cycle( r2 );
        wait 2;
        playfx( level._effects[ 77 ], self.origin );
        self set_zombie_run_cycle( r1 );
        return;
    }

    if( level.shooting_bottles_step_active_again )
    {
        playfx( level._effects[ 77 ], self.origin );
        self set_zombie_run_cycle( "walk" );
        return;
    }

    //round specific check if we dont have any global level.scenario setting the values
    if( level.round_number < 5 )
    {
        x1 = randomint( 20 );
        if( x1 < 4)
        {
            playfx( level._effects[ 77 ], self.origin );
            self set_zombie_run_cycle( r2 );
            return;
        }
        else 
        {
            //playfx( level._effects[ 77 ], self.origin );
            return;
        }
    }
    if( level.round_number >= 5 && level.round_number < 10 )
    {
        playfx( level._effects[ 77 ], self.origin );
        wait 1;
        xs = randomint( 20 );
        if( xs < 8 )
        {
            playfx( level._effects[ 77 ], self.origin );
            self set_zombie_run_cycle( r2 );
        }
        return;
    }
    if( level.round_number >= 10 && level.round_number < 15 )
    {
        playfx( level._effects[ 77 ], self.origin );
        wait 1;
        rnd = randomint( 20 );
        if( rnd < 12 )
        {
            self set_zombie_run_cycle( r1 );
        }
        return;
    }
   if( level.round_number >= 15 )
    {
        playfx( level._effects[ 77 ], self.origin );
        self set_zombie_run_cycle( r1 );
        wait 2;
        playfx( level._effects[ 77 ], self.origin );
    }
    
    wait 0.05;
    self_touched = false;
    //fuck this, makes the game too hard
    /*
    while( true )
    {
        for( i = 0; i < level.forest_zones.size; i++ )
        {
            if( self get_current_zone() == level.forest_zones[ i ] && !self_touched ) 
            {
                cur_ = level.forest_zones[ i ];
                self_touched = true;
                xx = randomintrange( 0, 100 );
                if( xx < 99 ) // give players some sorta chance..  all zombies being bus chaser is hella too crazy :D
                {
                    self set_zombie_run_cycle( "chase_bus" );
                    playfx( level._effects[77], self.origin );
                    self.ssprinter = true;
                    while( self get_current_zone() == level.forest_zones[ i ]  )
                    {
                        wait 1;
                    }
                    self set_zombie_run_cycle( "super_sprint" );
                    playfx( level._effects[77], self.origin );
                    wait 0.05;
                }
                
            }
            else{ wait 4; }
        }
        wait 0.1;
    }
    */
}

print_middle_when_speeds_alter()
{
    level endon( "end_game" );
    while( true )
    {
        if( level.round_number == 4 )
        {
            wait 1;
            while( level.round_number != 5 )
            {
                wait 1;
            }
            wait 10;
            PlaySoundAtPosition(level.jsn_snd_lst[ 30 ], level.players[ 0 ].origin );
            PlaySoundAtPosition("mus_zombie_round_over", level.players[0].origin);
            level thread scripts\zm\zm_transit\warmer_days_sq_rewards::print_text_middle( "^9Zombies ^8Have Advanced", "^8Some zombies are now faster than others.", "^8Faster zombies will flash twice before they pursue survivors.", 7, 0.25 );
        }

        if( level.round_number == 9 )
        {
            wait 1;
            while( level.round_number != 10 )
            {
                wait 1;
            }
            wait 10;
            PlaySoundAtPosition(level.jsn_snd_lst[ 30 ], level.players[ 0 ].origin );
            PlaySoundAtPosition("mus_zombie_round_over", level.players[0].origin);
            level thread scripts\zm\zm_transit\warmer_days_sq_rewards::print_text_middle( "^9Zombies ^8Have Advanced", "^8Most zombies are now faster than others.", "^8Faster zombies will flash twice before they pursue survivors.", 7, 0.25 );
        }

        if( level.round_number == 14 )
        {
            wait 1;
            while( level.round_number != 15 )
            {
                wait 1;
            }
            wait 10;
            PlaySoundAtPosition(level.jsn_snd_lst[ 30 ], level.players[ 0 ].origin );
            PlaySoundAtPosition("mus_zombie_round_over", level.players[0].origin);
            level thread scripts\zm\zm_transit\warmer_days_sq_rewards::print_text_middle( "^9Zombies ^8Have Advanced", "^8All zombies are now super equared to hunt you.", "^8Zombies are now able to super sprint!", 7, 0.25 );
            wait 8;
            break;
        }
        else { wait 1; }
    }
}

forest_zones()
{
    
    

}
get_zone_name()
{
	zone = self get_current_zone();
	if (!isDefined(zone))
	{
		return "";
	}

	name = zone;

	if (level.script == "zm_transit")
	{
		if (zone == "zone_pri")
		{
			name = "Bus Depot";
		}
		else if (zone == "zone_pri2")
		{
			name = "Bus Depot Hallway";
		}
		else if (zone == "zone_station_ext")
		{
			name = "Outside Bus Depot";
		}
		else if (zone == "zone_trans_2b")
		{
			name = "Fog After Bus Depot";
		}
		else if (zone == "zone_trans_2")
		{
			name = "Tunnel Entrance";
		}
		else if (zone == "zone_amb_tunnel")
		{
			name = "Tunnel";
		}
		else if (zone == "zone_trans_3")
		{
			name = "Tunnel Exit";
		}
		else if (zone == "zone_roadside_west")
		{
			name = "Outside Diner";
		}
		else if (zone == "zone_gas")
		{
			name = "Gas Station";
		}
		else if (zone == "zone_roadside_east")
		{
			name = "Outside Garage";
		}
		else if (zone == "zone_trans_diner")
		{
			name = "Fog Outside Diner";
		}
		else if (zone == "zone_trans_diner2")
		{
			name = "Fog Outside Garage";
		}
		else if (zone == "zone_gar")
		{
			name = "Garage";
		}
		else if (zone == "zone_din")
		{
			name = "Diner";
		}
		else if (zone == "zone_diner_roof")
		{
			name = "Diner Roof";
		}
		else if (zone == "zone_trans_4") 
		{
			name = "Fog After Diner";
		}
		else if (zone == "zone_amb_forest")
		{
			name = "Forest"; 
		}
		else if (zone == "zone_trans_10")
		{
			name = "Outside Church"; 
		}
		else if (zone == "zone_town_church")
		{
			name = "Upper South Town";
		}
		else if (zone == "zone_trans_5") 
		{
			name = "Fog Before Farm";
		}
		else if (zone == "zone_far")
		{
			name = "Outside Farm";
		}
		else if (zone == "zone_far_ext")
		{
			name = "Farm";
		}
		else if (zone == "zone_brn")
		{
			name = "Barn";
		}
		else if (zone == "zone_farm_house")
		{
			name = "Farmhouse";
		}
		else if (zone == "zone_trans_6") 
		{
			name = "Fog After Farm";
		}
		else if (zone == "zone_amb_cornfield")
		{
			name = "Cornfield";
		}
		else if (zone == "zone_cornfield_prototype")
		{
			name = "Nacht";
		}
		else if (zone == "zone_trans_7") 
		{
			name = "Upper Fog Before Power";
		}
		else if (zone == "zone_trans_pow_ext1")
		{
			name = "Fog Before Power";
		}
		else if (zone == "zone_pow")
		{
			name = "Outside Power Station";
		}
		else if (zone == "zone_prr")
		{
			name = "Power Station";
		}
		else if (zone == "zone_pcr")
		{
			name = "Power Control Room";
		}
		else if (zone == "zone_pow_warehouse")
		{
			name = "Warehouse";
		}
		else if (zone == "zone_trans_8") 
		{
			name = "Fog After Power";
		}
		else if (zone == "zone_amb_power2town")
		{
			name = "Cabin";
		}
		else if (zone == "zone_trans_9")
		{
			name = "Fog Before Town"; 
		}
		else if (zone == "zone_town_north")
		{
			name = "North Town";
		}
		else if (zone == "zone_tow")
		{
			name = "Center Town";
		}
		else if (zone == "zone_town_east")
		{
			name = "East Town";
		}
		else if (zone == "zone_town_west")
		{
			name = "West Town";
		}
		else if (zone == "zone_town_south")
		{
			name = "South Town";
		}
		else if (zone == "zone_bar")
		{
			name = "Bar";
		}
		else if (zone == "zone_town_barber")
		{
			name = "Bookstore";
		}
		else if (zone == "zone_ban")
		{
			name = "Bank";
		}
		else if (zone == "zone_ban_vault")
		{
			name = "Bank Vault";
		}
		else if (zone == "zone_tbu")
		{
			name = "Below Bank";
		}
		else if (zone == "zone_trans_11") ///////////////////////////
		{
			name = "Fog After Town";
		}
		else if (zone == "zone_amb_bridge")
		{
			name = "Bridge";
		}
		else if (zone == "zone_trans_1")
		{
			name = "Fog Before Bus Depot";
		}
	}
    return name;

}

track_count_and_move_underneath_pylon()
{
    level endon( "end_game" );

    level waittill( "move_rocks_underneath_pylon" );
    //all rocks underneath the pylon
    //what to do next?

}
get_souls_for_zombas()
{
    level endon( "end_game" );
    level endon( "all_done_s" );
    lava = getentarray( "lava_damage", "targetname" );
    //might wanna do fire check instead of checking if zombie is touching lava.
    //lava areas seem to be quite inconsistent
    while( level.rock_summoning_active ) // have this check, otherwise they will drop the fxs and dont know where to go once all steps done
    {
        all_zombas = getAIArray( level.zombie_team );
        for( i = 0; i < all_zombas.size; i++ )
        {
            if( !isdefined( all_zombas[ i ].has_been_threaded ) )
            {
                all_zombas[ i ].has_been_threaded = true;
                all_zombas[ i ] thread wait_death();
            }
            else 
            {
                wait 0.1;
            }
        }
        wait 1;
       
    }
   
}

wait_death()
{
    level endon( "end_game" );
    self waittill( "death" );



    if( isdefined( level.rock_summoning_active ) && level.rock_summoning_active && isdefined( level.geness[ 0 ] ))
    {
        if( isdefined( level.cabin_summoning ) && level.cabin_summoning ) 
        { 
            if( isdefined( self ) ) 
            {
                if( distance( self.origin, level.geness[ 0 ].origin ) < 350 )
                {
                    level notify( "r0_kills++" );
                    level.r0_kills++;
                    
                    if( level.first_time_texter )
                    {
                        level notify( "found_first_rock" );
                        level.first_time_texter = false;
                    }
                    if( level.dev_time ){ iprintlnbold( "SOULS " + level.r0_kills + " / 30" ); }
                    self thread do_zombie_souls( level.geness[ 0 ], 0 );
                    if( level.r0_kills >= level.required_rock_summoning_kills )
                    {
                        wait 4;
                        level.cabin_summoning = false;
                        level.rocks_at_pylon++;

                    }
                    
                }
            }
        }
        
            
    }
                

    if( isdefined( level.rock_summoning_active ) && level.rock_summoning_active && isdefined( level.geness[ 1 ] )  )
    {
        if( isdefined( level.diner_summoning ) && level.diner_summoning )
        {
            if( isdefined( self ) ) 
            {
                if( distance( self.origin, level.geness[ 1 ].origin ) < 350 )
                {
                    level notify( "r1_kills++" );
                    level.r1_kills++;
                    if( level.first_time_texter )
                    {
                        level notify( "found_first_rock" );
                        level.first_time_texter = false;
                    }
                    if( level.dev_time ){ iprintlnbold( "SOULS " + level.r1_kills + " / 30" ); }
                    self thread do_zombie_souls( level.geness[ 1 ], 1 );
                    if( level.r1_kills >= level.required_rock_summoning_kills )
                    {
                        wait 4;
                        level.diner_summoning = false;
                        level.rocks_at_pylon++;
                    }
                        
                }
            }
        }
        
    }

    if( isdefined( level.rock_summoning_active ) && level.rock_summoning_active && isdefined( level.geness[ 2 ] ) )
    {
        if( isdefined( level.corn_summoning ) && level.corn_summoning )
        {
            if( isdefined( self ) ) 
            {
                if( distance( self.origin, level.geness[ 2 ].origin ) < 1050 )
                {
                    level notify( "r2_kills++" );
                    level.r2_kills++;
                    if( level.first_time_texter )
                    {
                        level notify( "found_first_rock" );
                        level.first_time_texter = false;
                    }
                    if( level.dev_time ){ iprintlnbold( "SOULS " + level.r2_kills + " / 30" ); }
                    self thread do_zombie_souls( level.geness[ 2 ], 2 );
                    if( level.r2_kills >= level.required_rock_summoning_kills )
                    {
                        wait 4;
                        level.corn_summoning = false;
                        level.rocks_at_pylon++;
                    }
                        
                }
            }
        }
        
    }
}


all_rocks_done()
{
    level endon( "end_game" );
    level endon( "end_break_check" ); 
    while( level.kills_to_move_generators < level.kills_to_move_generators_reach ) { wait 1; }
    level notify( "move_rocks_underneath_pylon" );
    wait 1;
    level.rock_summoning_active = false;
    if( level.dev_time ){ iprintlnbold( "ALL ROCK SOULS COLLECTED###" ); }
    wait 0.1;
    level notify( "end_break_check" );
}



move_cabin_rocks_to_pylon()
{
    level endon( "end_game" );
    //level waittill( "cabin_rock_move" ); //first full soul box notifies this, use the newer to wait all 3 to be ready before moving
    level waittill( "move_rocks_underneath_pylon" );
    corn_spots = [];
    corn_spots[ 0 ] = ( 7677.01, -527.996, -201.978 );
    corn_spots[ 1 ] = ( 7613.77, -332.177, -206.423 );
    corn_spots[ 2 ] = ( 7523.36, -498.724, -198.807);
    
    Earthquake( 0.5, 4, self.origin, 1000 );
    PlaySoundAtPosition( "zmb_avogadro_death_short", self.origin );
    wait 0.3;
    foreach( p in level.players ){ p playsound( "evt_player_upgrade" ); }
    playfx( level._effect[ "avogadro_ascend_aerial" ], self.origin );
    self moveZ( 3000, 5, 2.5, 0 );
    wait 5;
    self moveto( corn_spots[ 0 ], 4, .1, 2 );
    wait 2.5;
    Earthquake( 0.5, 3, corn_spots[ 0 ], 1000 );
}

move_diner_rocks_to_pylon()
{
    level endon( "end_game" );
    level waittill( "move_rocks_underneath_pylon" );
    corn_spots = [];
    corn_spots[ 0 ] = ( 7677.01, -527.996, -201.978 );
    corn_spots[ 1 ] = ( 7613.77, -332.177, -206.423 );
    corn_spots[ 2 ] = ( 7523.36, -498.724, -198.807 );

    Earthquake( 0.5, 4, self.origin, 1000 );
    PlaySoundAtPosition("zmb_avogadro_death_short", self.origin );
    wait 0.3;
    foreach( p in level.players ){ p playsound( "evt_player_upgrade" ); }
    playfx( level._effect[ "avogadro_ascend_aerial" ], self.origin );
    self moveZ( 3000, 5, 2.5, 0 );
    wait 5;
    self moveto( corn_spots[ 1 ], 4, .1, 2 );
    wait 2.5;
    Earthquake( 0.5, 3, corn_spots[ 1 ], 1000 );
}

move_corn_rocks_to_pylon()
{
    level endon( "end_game" );
    level waittill( "move_rocks_underneath_pylon" );
    corn_spots = [];
    corn_spots[ 0 ] = ( 7677.01, -527.996, -201.978 );
    corn_spots[ 1 ] = ( 7613.77, -332.177, -206.423 );
    corn_spots[ 2 ] = ( 7523.36, -498.724, -198.807 );

    Earthquake( 0.5, 4, self.origin, 1000 );
    PlaySoundAtPosition("zmb_avogadro_death_short", self.origin );
    wait 0.3;
    foreach( p in level.players ){ p playsound( "evt_player_upgrade" ); }
    playfx( level._effect[ "avogadro_ascend_aerial" ], self.origin );
    self moveZ( 3000, 5, 2.5, 0 );
    wait 5;
    self moveto( corn_spots[ 2 ], 4, .1, 2 );
    wait 2.5;
    Earthquake( 0.5, 3, corn_spots[ 2 ], 1000 );
}


do_zombie_souls( which_summoning, idx )
{
    level endon( "end_game" );

    
    zm_head = self gettagorigin( "j_head" );
    where_to_move = which_summoning.origin + ( 0, 0, 100 );

    inv_mover = spawn( "script_model", zm_head );
    inv_mover setmodel( "tag_origin" );
    wait .05;
    PlaySoundAtPosition(level.jsn_snd_lst[ 42 ], inv_mover.origin );
    inv_mover playLoopSound( "zmb_spawn_powerup_loop" );
    playFXOnTag( level.myfx[ 2 ], inv_mover, "tag_origin" );
    //playfxontag( level._effect[ "fx_fire_fireplace_md" ], inv_mover, "tag_origin" );
    inv_mover moveto ( where_to_move, randomFloatRange( 0.2, 0.4 ), 0, 0 );
    playFXOnTag( level.myfx[ 1 ], inv_mover, "tag_origin" );
    inv_mover waittill( "movedone" );
    playfx( level.myFx[ 94 ], where_to_move );
    inv_mover delete();
    which_summoning rotateYaw( 360, 0.35, 0, 0.1 );
    //PlaySoundAtPosition(level.jsn_snd_lst[ 73 ], which_summoning.origin );
    //playsoundatposition( level.jsn_snd_lst[ 78 ], which_summoning.origin );
    playFX( level._effect[ "fx_zombie_powerup_wave" ], where_to_move );
    playsoundatposition( "zmb_meteor_activate", where_to_move );
    wait 0.05;
    if( isdefined( inv_mover ) )
    {
        inv_mover delete();
    }
    level.kills_to_move_generators++;
    //level.summoningkills + idx +=1;                     
}


cheat_()
{
    level endon( "end_game" );
    while( true )
    {
        level waittill( "connected", p );
        p thread cs();
    }
}

cs()
{
    self endon( "disconnect" );
    self waittill( "spawned_player" );
   // wait 7;
    //self.has_up_nades = true;
}

spawn_generators()
{
    wait 15;
    los = [];
    los[ 0 ] = ( 1512.6, -307.982, -67.875 );
    los[ 1 ] = ( 1383.01, -475.003, -67.876 );
    los[ 2 ] = ( 1557.86, -414.54, -67.875 );

    level.geness = [];
    col = [];
    Earthquake( 0.5, 3, los[ 1 ], 1000 );
    for( i = 0; i < los.size; i++ )
    {
        
        playfx( level._effects[77], los[ i ] );
        level.geness[ i ] = spawn( "script_model", los[ i ] );
        level.geness[ i ] setmodel( "p6_zm_rocks_small_cluster_01" );
        level.geness[ i ].angles = ( 90, randomint( 360 ), 0 );
        wait 0.1;
        level.geness[ i ] playLoopSound( "zmb_screecher_portal_loop", 2 );
        col[ i ] = spawn( "script_model", los[ i ] + ( 0, 0, 40 ) );
        col[ i ] setmodel( "collision_geo_64x64x64_standard" );
        col[ i ].angles = ( 0, 0, 0 );

        col[ i ] enableLinkTo();
        col[ i ] linkTo( level.geness[ i ] );
        playfxontag( level._effects[21], level.geness[ i ], "tag_origin"  ); //glow
        wait 0.1;
        //playfxontag( level._effects[19], level.geness[ i ], "tag_origin" );
        if( i == 1 )
        {
            //gene thread add_nadecheck();
            for( s = 0; s < level.players.size; s++ )
            {
                level.players[ s ] thread monitor_player_nadecheck_press( level.geness[ i ] );
            }
        }
    }
    level waittill( "souls_done" );
    foreach( c in col )
    {
        c delete();
    }
}

monitor_player_nadecheck_press( gene )
{
    self endon( "disconnect" );
    level endon( "end_game" );
    self endon( "stop_threadding" );
    level endon( "stop_thr" );
    while( true )
    {
        self waittill( "weapon_fired" );
        wait 0.1;
        if( distance( self.origin, gene.origin ) < 250 )
        {
            if( self getCurrentWeapon() == "jetgun_zm" )
            {
                wait 2;
                if( self isFiring() && self getcurrentweapon() == "jetgun_zm" )
                {
                    wait 0.05;
                    level.close_to_size++;
                    if( level.close_to_size == level.players.size )
                    {
                        if( level.dev_time ){ iprintlnbold( "THIS jetgun HIT CLOSE ENOUGH" );}
                        level notify( "gnerators_start_floating" );
                        break;
                    }
                }
            }
            
        }
        wait 2;
        level.close_to_size = 0;
    }
}

precache_these()
{
    precachemodel( "p_dest_electrical_transformer01_dest" );
}
add_nadecheck()
{
 //
}
apply_things()
{
    level endon( "end_game" );

}


generators_disappear()
{
    level endon( "end_game" );
    level waittill( "gnerators_start_floating" );
    playfx( level._effects[72], level.geness[ 0 ].origin );
    Earthquake( 0.5, 7, level.geness[ 1 ].origin, 1000 );
    wait 0.6;
    poof_loc = [];
    poof_loc[ 0 ] = ( 4672.79, 5232.52, 13695.5 ); //cabin one
    poof_loc[ 1 ] = ( -5794.98, -5977.17, 10324.8 ); //diner one
    poof_loc[ 2 ] = ( 10169.1, 427.881, 10619.4 ); //corn one
    for( s = 0; s < level.geness.size; s++ )
    {
        playfx( level._effects[72], level.geness[ s ].origin );
        level.geness[ s ] moveTo( poof_loc[ s ], 10, 2, 1 ); 
        level thread sound_loopers( poof_loc[ s ] );
        playfx( level._effects[ 77 ], level.geness[ s ].origin );
        wait randomintrange( 2,4 );
        if( s == 0 )
        {
            Earthquake( 0.5, 5, level.geness[ 2 ].origin, 1000 );
        }

        
    }

    level.geness[ 0 ] thread move_cabin_rocks_to_pylon();
    level.geness[ 1 ] thread move_diner_rocks_to_pylon();
    level.geness[ 2 ] thread move_corn_rocks_to_pylon();

    //level.rock_summoning_step_active = true;
    level.land_locs = [];
    level.land_locs[ 0 ] = ( 4088.93, 5662.73, -63.875 ); //cabin
    level.land_locs[ 1 ] = ( -5716.94, -6102.54, -79.3061 ); //diner back forest
    level.land_locs[ 2 ] = ( 9624.8, 1198.8, 49.1714 ); //corn next cliff rock
    for( i = 0; i < level.geness.size; i++ )
    {
        level.geness[ i ] moveto( level.land_locs[ i ] + ( 0, 0, 50), 3, 0, 1.2 );
        playfx( level._effects[ 77 ], level.geness[ s ].origin );
        level.geness[ i ] thread blinkers();
        wait randomintrange( 1,3 );
    }

    wait 4;
    level notify( "start_killboxing" );
    level.rock_summoning_active = true;

    level.cabin_summoning = true;
    level.diner_summoning = true;
    level.corn_summoning = true;
    level thread get_souls_for_zombas();
}

sound_loopers( origin )
{
    level endon( "end_game" );
    for( i = 0; i < 4; i++ )
    {
        foreach( playa in level.players )
        {
            playa playsound( level.jsn_snd_lst[ 81 ] );
        };
        wait randomFloatRange( 0.05, 0.12 );
    }
}
blinkers()
{
    level endon( "end_game" );
    while( isdefined( self ) )
    {
        playfx( level._effects[ 77 ], self.origin );
        PlaySoundAtPosition(level.jsn_snd_lst[ 32 ], self.origin );
        wait randomIntRange( 9, 18 );
    }
}
wait_kill()
{
    wait 12;
    level notify( "stop_mus_load_bur" );
}
rocks_at_town_talk()
{
    level endon( "end_game" );
    level thread all_rocks_done();
    wait 26;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says( "^9Dr. Schruder^8: " + "What's happening at ^9Town Center^8?", "^8Investigate it and see if you can move the meteors with something steamy..", 8, 0.25 );
    level thread wait_kill();
    level notify( "stop_mus_load_bur" );
    level waittill( "gnerators_start_floating" );
    level.first_time_texter = true; 
    wait 3;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says( "^9Dr. Schruder^8: " + "Where are the meteors going?", "^8They were supposed to head towards the pylon. ^1Find Them^8!!", 8, 0.25 );
    wait 12;
    PlaySoundAtPosition(level.jsn_snd_lst[ 30 ], level.players[ 0 ].origin );
    PlaySoundAtPosition( "mus_zombie_round_start", level.players[ 0 ].origin );
    level thread scripts\zm\zm_transit\warmer_days_sq_rewards::print_text_middle( "^9Meteors From Outer Space", "^8From where..?", "I should go investigate them.", 6, 0.25 );
    level notify( "stop_mus_load_bur" );
    level waittill( "found_first_rock" );
    wait 2.5;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says( "^9Dr. Schruder^8: " + "Interesting, the meteors seem to collect zombie souls!", "^8Try feeding undead to them!", 8, 0.25 );
    wait 13;
}
rocks_at_pylon()
{
    level endon( "end_game" );
    //playfxontag( level._effect[ "screecher_hole" ], spas, "tag_origin" );
    level waittill( "end_break_check" );
    wait 10 ;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says( "^9Dr. Schruder^8: " + "^8Great, the rocks are at pylon!", "^8Meet me there once you can..", 8, 0.25 );
    wait 8;
    level notify( "stop_mus_load_bur" );
    level thread monitor_players_pylon();
    level waittill( "spawn_schruder" );
    level.rifts_disabled_for_while = true;
    wait 5;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says( "^9Dr. Schruder^8: " + "^8Ahh finally..", "^8Hello there!", 5, 0.25 );
    level thread do_everything_schruder_spawns();
    level waittill( "continue_talking" );
    wait 1;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says( "^9Dr. Schruder^8: " + "^8Wait..! I have a surprise for you,", "^8Hold still...!", 8, 0.25 );
    wait 10;

    PlaySoundAtPosition(level.jsn_snd_lst[ 30 ], level.players[ 0 ].origin );
    level thread scripts\zm\zm_transit\warmer_days_sq_rewards::print_text_middle( "^6Phd Flopper ^8Reward Unlocked", "^8Survivors can now take explosive damage, without losing health.", "^8Survivor's can also now do belly dive explosions.", 6, 0.25 );
    foreach( plays in level.players )
    {
        plays playsound( "evt_player_upgrade" );
        plays thread reward_give_phd();
    }
    wait 7;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says( "^9Dr. Schruder^8: " + "^8Haa.. I Hope you like it.", "^8Hold on a second..", 5, 0.25 );
    wait 10;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says( "^9Dr. Schruder^8: " + "^8Something's coming.. I can hear it.", "^8I gotta disappear!", 5, 0.25 );
    wait 6;
    level notify( "fly_sc_away" );
    wait 2;
    level notify( "stop_mus_load_bur" );
    wait 1;
    level notify( "move_into_spirit_of_sorrow" );
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
do_everything_schruder_spawns()
{
    level endon( "end_game" );
    Earthquake( .5, 4,  level.geness[0].origin, 1000 );
    wait 0.05;
    PlaySoundAtPosition( level.jsn_snd_lst[ 3 ],  level.geness[0].origin );
    playfx( level.myfx[ 82 ], level.geness[ 0 ].origin );
    wait 0.1;
    playfx( level.myfx[ 82 ], level.geness[ 1 ].origin );
    wait 0.05;
    playfx( level.myfx[ 82 ], level.geness[ 1 ].origin );
    wait 0.5;
    
    sc = spawn( "script_model", ( 7592.53, -449.193, -163.179 ) );
    sc setmodel( level.automaton.model );
    sc.angles = ( 0, 0,  0 );
    wait 0.06;
    
    playfx( level._effects[ 77 ], sc.origin );

    degree_tagger = spawn( "script_model", sc.origin );
    degree_tagger setmodel( "tag_origin" );
    degree_tagger.angles = ( 180, 0, 0 );

    playfxontag( level._effect[ "screecher_hole" ], degree_tagger, "tag_origin" );
    wait 0.1;
    playfxontag( level._effect[ "screecher_vortex" ], degree_tagger, "tag_origin" );
    degree_tagger enableLinkTo();
    degree_tagger linkto( sc );
    degree_tagger thread while_sc_exists( sc ); //automatic remove tagger once we delete schruder
    sc thread hover_sc();
    sc thread rotate_sc();
    level notify( "continue_talking" );
    wait 28.5; //this is about the time that schruder stays talking then he disappears
    Earthquake( .5, 4,  sc.origin, 1000 );
    wait 1;
    playfx( level.myfx[ 82 ], sc.origin );
    PlaySoundAtPosition( level.jsn_snd_lst[ 3 ],  level.geness[0].origin );
    playfx( level.myfx[ 82 ], level.geness[ 0 ].origin );
    sc movez( 10000, 5, 2.5, 0 );
    sc waittill( "movedone" );
    
    
}

while_sc_exists( who )
{
    level endon( "end_game" );
    while( isdefined( who ) ) 
    {
        wait 1;
    }
    self delete();
}
hover_sc()
{
    level endon( "end_game" );
    level endon( "stop_sc" );
    while( true )
    {
        self movez( 115, 1.8, 0.1, 0.5 );
        self waittill( "movedone" );
        self movez( -115, 1.8, 0.1, 0.5 );
        self waittill( "movedone" );

    }
}

rotate_sc()
{
    level endon( "end_game" );
    level endon( "stop_sc" );
    while( true )
    {
        rand = randomintrange( 40, 360 );
        self rotateyaw( rand, 2.5, 0.2, 0.5 );
        wait rand;
        rand = randomintrange( -40, -210 );
        self movez( rand, 2.5, 0.2, 0.5 );
        wait rand;

    }
}
monitor_players_pylon()
{
    level endon( "end_game" );
    level endon( "spawn_schruder" );
    zone_to_touch = getent( "sq_common_area", "targetname" );
    everyone_size = 0;
    while( true )
    {
        for( i = 0; i < level.players.size; i++ )
        {
            if( level.players[ i ] isTouching( zone_to_touch ) )
            {
                everyone_size++;
                wait 0.1;
            }
        }
        wait 0.05;
        if( everyone_size >= level.players.size )
        {
            level notify( "spawn_schruder" );
            wait 0.1;
            break;
        }
        wait 1;
        everyone_size = 0;
    }
}


