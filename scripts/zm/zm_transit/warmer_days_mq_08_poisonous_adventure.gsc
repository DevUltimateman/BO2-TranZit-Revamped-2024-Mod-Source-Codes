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


main()
{
    //replacefunc( ::disable_triggers, ::disable_triggers_custom );
}

disable_triggers_custom()
{
    trig = getentarray( "trigger_Keys", "targetname" );
    for( i = 0; i < trig.size; i++ )
    {
        playfxontag( level.myfx[ 1 ], trig, "tag_origin" );
        trig trigger_on();
    }
}

levelBusLi()
{
    
    //flag_wait( "initial_blackscreen_passed" );
    wait 6;
   // level.the_bus.frontLight 	= SpawnAndLinkFXToOffset( level._effect[ "fx_busInsideLight" ], self, ( 130, 0, 130), ( -90, 0, 0 ) );
	//level.the_bus.centerLight 	= SpawnAndLinkFXToOffset( level._effect[ "fx_busInsideLight" ], self, (   0, 0, 130), ( -90, 0, 0 ) );
	//level.the_bus.backLight 		= SpawnAndLinkFXToOffset( level._effect[ "fx_busInsideLight" ], self, (-130, 0, 130), ( -90, 0, 0 ) );

    level.the_bus thread busFuelTankSetup();
    level.the_bus thread busRoofRailsSetup();
}

busRoofRailsSetup()
{
	roof_rails = GetEntArray("roof_rail_entity", "targetname");
	for ( i = 0; i < roof_rails.size; i++ )
	{
		roof_rails[i] LinkTo( self, "", self worldtolocalcoords(roof_rails[i].origin), roof_rails[i].angles + self.angles);
	}
}


busFuelTankSetup()
{
	script_origin = Spawn( "script_origin", self.origin + ( -193, 75, 48 ) );
	script_origin.angles = ( 0, 180, 0 );
	script_origin LinkTo( self );
	self.fuelTankModelPoint = script_origin;
    wait 0.05; 
    playfxontag( level.myfx[ 1 ], self.fuelTankModelPoint, "tag_origin" );

	script_origin = Spawn( "script_origin", self.origin + ( -193, 128, 48 ) );
	script_origin LinkTo( self );
	self.fuelTankTriggerPoint = script_origin;

    wait 0.05; 
    playfxontag( level.myfx[ 2 ], self.fuelTankTriggerPoint, "tag_origin" );
    wait 0.05;
}

init()
{
    level.shooting_bottles_step_active_again = false;
    all_suitcase_ground_position();
    level thread rise_suitcase();
    //need to have these initialized here for debugging purposes coz we dont pick up the original suitcase now while testiing
    level.suitcase_rise_model = "p_eb_lg_suitcase";
    level.suitcase_land_model = "p_eb_med_suitcase"; 
    level.suitcases_collected = 0;
    precachemodel( "t6_wpn_zmb_perk_bottle_tombstone_world" );
    precache_these_too();

    flag_wait( "initial_blackscreen_passed" );
    
    level thread do_first_dialog();
    level thread spawn_drinkable_step(); //reward and spawn drinkable immunity
    //level thread levelBusLi();

    //for debugging vanilla triggers
}

rise_suitcase()
{
    level waittill( "poisonous_adventure_find_case" );
    wait 8;
    level.suitcase_landing_spot = ( -7198.18, 5144.35, -24.5065 );
    level.suitcase_rise_spot = ( -7323.23, 5103.54, -58.5631 );
    level.suitcase_rise_to_spot = ( -7323.23, 5103.54, 31.3403 );

    level.suitcase_rise_to_spot_angles = ( 0, -114.161, 0 );
    level.suitcase_landing_spot_angles = ( 0, -98.4235, 0 );


    

    wait 1;
    trigger = spawn( "trigger_radius", level.suitcase_rise_spot, 100, 100, 100 );
    trigger setHintString( "" );
    trigger setCursorHint( "HINT_NOICON" );

    wait 0.1;

    suitcase = spawn( "script_model", level.suitcase_rise_spot );
    suitcase setmodel( level.suitcase_rise_model );
    suitcase.angles = level.suitcase_rise_to_spot_angles;

    wait 0.05;
    playfxontag( level.myfx[ 2 ], suitcase, "tag_origin" );
    suitcase playLoopSound( "zmb_spawn_powerup_loop" );
    while( true )
    {
        trigger waittill( "trigger", someone );
        
            level thread moveeverything( suitcase );
            level specific_powerup_drop( "nuke", level.players[ 0 ].origin + ( 0, 0, 20 ) );
            level notify( "monitor_suitcases" );
            wait 0.05;
            trigger delete();
            break;
        
        wait 0.1;
    }
}

moveeverything( suit_case )
{
    level endon( "end_game" );
    suit_case thread spin_me_around_mq_first_time_pick_up();
    wait 0.05;
    suit_case moveto( level.suitcase_rise_to_spot, 1.5, 0.3, 0.2 );
    suit_case waittill( "movedone" );
    suit_case notify( "stop_spinning" );

    playfx( level.myfx[ 58 ], suit_case.origin );
    suit_case rotateyaw( 360, 0.2, 0, 0 );
    suit_case waittill( "rotatedone" );
    suit_case rotateyaw( -200, 0.3, 0, 0 );
    suit_case waittill( "rotatedone" );
    suit_case moveto( level.suitcase_landing_spot, 1.5, 0.2, 0.6 );
    suit_case rotateto( level.suitcase_landing_spot_angles, 1.5, 0.2, 0.6 );
    suit_case waittill( "movedone" );
    suit_case setmodel( level.suitcase_land_model );
    playfxontag( level.myFx[ 44 ], suit_case, "tag_origin" );

    wait 0.1;

    trigu = spawn( "trigger_radius_use", suit_case.origin, 48, 48, 48 );
    trigu setCursorHint( "HINT_NOICON" );
    trigu setHintString( "^9[ ^3[{+activate}] ^8to pick up Mixing Container ^9]" );
    trigu TriggerIgnoreTeam();
    wait 0.1;
    while( true )
    {
        trigu waittill( "trigger", who );
        who playsound( "zmb_sq_navcard_success" );
        trigu sethintstring( "^8[ You picked up ^9Mixing Container ^8]" );
        suit_case notify( "stop_spinning" );
        suit_case delete();
        wait 2.5;

        trigu delete();
        
        level notify( "someone_picked_up_poison" );
        
        wait 0.1;
        break;
    }
    
    //THIS SUITCASE STEP STILL IN PLACE?
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

do_first_dialog()
{

    level waittill( "someone_picked_up_poison" );
    level.moving_to_depo_active = false;
    level.rifts_disabled_for_while = false;
    wait 3;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says( "^9Dr. Schruder^8: " + "^8Excellent!", "^8" + "You've found the mixing container^8..", 5, 1 );
    wait 10;
    level notify( "stop_mus_load_bur" ); 
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says( "^9Dr. Schruder^8: " + "^8The container will spawn next to a soda machine once you're close to it.", "^8" + "Feel free to locate a soda machine next.", 8, 1 );
    wait 11;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says( "^9Dr. Schruder^8: " + "^8I'll let you figure out what to do after that..", "^8" + "Don't disappoint me!", 6, 1 );
    wait 9;
    PlaySoundAtPosition(level.jsn_snd_lst[ 30 ], level.players[ 0 ].origin );
     PlaySoundAtPosition( "mus_zombie_round_start", level.players[ 0 ].origin );
    level thread scripts\zm\zm_transit\warmer_days_sq_rewards::print_text_middle( "^9Master Of Mixing", "^8This whole idea feels so weird.", "Collect soda bottles and stuff.. what?!", 6, 0.25 );
    level thread are_players_close_to_spawn_suitcase();
    wait 5;
    level waittill( "all_suitcases_collected" );
    wait 0.35;
    wait 2.8;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says( "^9Dr. Schruder^8: " + "^8Haha, impressive!", "^8" + "You're quite a sharp shooter.", 6, 1 );
    wait 9;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says( "^9Dr. Schruder^8: " + "^8The container is now full of different sodas.", "^8" + "You could try your luck next at ^6labs^8..", 6, 1 );
    level notify( "stop_mus_load_bur" );
    wait 10;
    level waittill( "crafting_serum" );
    wait 1;
    //needs a 10 second wait so we dont have overlapping text
    wait 12;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says( "^9Dr. Schruder^8: " +  "^8Fantastic, how did it taste like?", "^8" + "Funny face you got ha!", 6, 1 );
    wait 9;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says( "^9Dr. Schruder^8: " +  "^8Hahaa you know what, I'm just teasing you now.. ", "^8" + "", 5, 1 );
    wait 9;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says( "^9Dr. Schruder^8: " +  "^8I am so proud of you.. we should ^6celebrate^8 a bit..", "^8" + "Meet me at ^9Moe's Pub^8!", 7, 1 );
    level notify( "wait_for_bar_meetup" );
    level.step_9_possible = true;
    wait 11;

    //continue from here
    //continue from here
    //continue from here
    //continue from here
    //continue from here
    //continue from here
    //continue from here
    //continue from here
    //continue from here
    //continue from here
    //continue from here
    //continue from here
    //do_dialog_here( "Brilliant, have you already colleceted your ^3Fire Grenades^8?", "You'll be needing them next.", 7, 1 );
    
    
}

wait_kill()
{
    wait 12;
    level notify( "stop_mus_load_bur" );
}
spin_me_around_mq_first_time_pick_up() 
{
    level endon( "end_game" );
    self endon( "death" );
    self endon( "stop_spinning" );
    while( true )
    {
        self rotateyaw( 360, 0.5, 0, 0 );
        wait 0.5;
    }
}

spin_me_around_mq() 
{
    level endon( "end_game" );
    self endon( "death" );
    self endon( "stop_spinning" );
    while( true )
    {
        self rotateyaw( 360, 0.5, 0, 0 );
        wait 0.5;
    }
}

all_suitcase_ground_position()
{
    
    level.suitcase_ground_positions = [];
    //quick
    level.suitcase_ground_positions[ 0 ] = ( -6704.51, 5039.83, -45.875 );
    //speed
    level.suitcase_ground_positions[ 1 ] = ( -5530.7, -7865.11, 25.125 );
    //dtap
    level.suitcase_ground_positions[ 2 ] = ( 8038.52, -4657.54, 284.125 );
    //toomb
    //level.suitcase_ground_positions[ 3 ] = ( 10863, 8290.47, -407.875 );
    //jugg
    level.suitcase_ground_positions[ 3 ] = ( 1038.92, -1490.15, 148.125 );


}

are_players_close_to_spawn_suitcase()
{
    level endon( "end_game" );
    //level waittill( "monitor_suitcases" ); //enable back later
    level.current_suitcase_location = undefined;
    wait 5;
    while( true )
    {
        if( level.suitcases_collected == 4 )
        {
            if( level.dev_time ){ iprintlnbold( "ALL SUITCASES COLLECTED" ); }
            break;
        }
        for( i = 0; i < level.players.size; i++ )
        {
            for( s = 0; s < level.suitcase_ground_positions.size; s++ )
            {
                if( distance( level.players[ i ].origin, level.suitcase_ground_positions[ s ] ) < 140 && level.current_suitcase_location != level.suitcase_ground_positions[ s ] )
                {
                    wait 0.1;
                    level.suitcases_collected++;
                    level.current_suitcase_location = level.suitcase_ground_positions[ s ];
                    if( level.dev_time ){ iprintlnbold( "^9SUITCASE LOCATED, SPAWNING IT" ); }
                    level thread spawn_suitcase_perka( level.suitcase_ground_positions[ s ] );

                    wait 0.1;
                    ArrayRemoveIndex(level.suitcase_ground_positions, s );
                    break;
                }
            }
        }
        if( level.suitcases_collected > 4 ) //was >= 4, might have to have it like that, but played the ldialog one pickup too earlyh
        {
            level notify( "all_suitcases_collected" );
            wait 0.1;
            break;
        }
        wait 0.1;
        
    }
}


spawn_suitcase_perka( location )
{
    level endon( "end_game" );
    PlaySoundAtPosition( level.jsn_snd_lst[ 3 ], m_suitcase.origin );
    earthquake( 0.25, 10, m_suitcase.origin, 1050 );
    wait 1;
    m_suitcase = spawn( "script_model", location ); 
    m_suitcase setmodel( level.suitcase_rise_model );
    m_suitcase.angles = m_suitcase.angles;
    wait 0.05;
    playfxontag( level._effect[ "lght_mrker" ], m_suitcase, "tag_origin" );
    PlaySoundAtPosition(level.jsn_snd_lst[ 8 ], m_suitcase.origin );
    earthquake( 0.25, 10, location, 1050 );
    playfxontag( level.myfx[ 2 ], m_suitcase, "tag_origin" );
    m_suitcase thread do_show_and_flying( location );
    m_suitcase thread rotate_me();

    level waittill( "bottle_has_been_returned" );
    m_suitcase.is_on_ground_now = false;
    m_suitcase thread rotate_me();
    PlaySoundAtPosition( level.jsn_snd_lst[ 3 ], m_suitcase.origin );
    earthquake( 0.25, 10, m_suitcase.origin, 1050 );
    wait 1;

    m_suitcase movez( 200, 2.2, 0.5, 0 );
    m_suitcase waittill( "movedone" );
    playfx( level.myFx[ 91 ], m_suitcase.origin );

    wait 1;
    m_suitcase delete();
    level notify( "delete_all_suitcase_related" );

}

precache_these_too()
{
    precachemodel( "p_rus_electric_boxes4" );
    precachemodel( "p_rus_pipes_modular_valve" );
}

hover_drinkable_location()
{
    while( isdefined( self ) )
    {
        self movez( 6, 2, 0.5, 0.5 );
        //self rotateYaw( 360, 4, 0, 0 );
        wait 2;
        self movez( -6, 2, 0.5, 0.5 );
        wait 2;
    }
}

spin_drinkable_location()
{
    while( isdefined( self ) )
    {
        self rotateYaw( 360, 2, 0, 0 );
        wait 2;
    }
}
spawn_drinkable_step()
{
    level endon( "end_game" );
    level waittill( "all_suitcases_collected" );
    wait 1;
    origin_lo = ( 1159.12, 1185.97, -260.295 );
    spawnable_drink = spawn( "script_model", origin_lo + ( 0, 0, 15 ) );
    spawnable_drink setmodel( "t6_wpn_zmb_perk_bottle_tombstone_world" );
    spawnable_drink.angles = ( 4, 10, 0 );

    wait 1;

    spawnable_lighter = spawn( "script_model", origin_lo + ( 0, 0, 5 ) );
    spawnable_lighter setmodel( "tag_origin" );
    spawnable_lighter.angles = ( 5, 10, 0 );
    playfxontag( level.myFx[ 41 ], spawnable_lighter, "tag_origin" );
    wait 1;
    spawnable_case = spawn( "script_model", origin_lo );
    spawnable_case setmodel( "p_rus_electric_boxes4" );
    spawnable_case.angles = ( 90, 270, 0 );

    
    //spawnable_case thread hover_drinkable_location();
    wait 0.05;
    playfx( level.myfx[ 2 ], spawnable_case.origin );
    wait 1;
    playfxontag( level.myFx[ 41 ], spawnable_lighter, "tag_origin" );
    anim_trig = spawn( "trigger_radius_use", origin_lo + ( 0, 0, 0 ), 1, 12, 12 );
    anim_trig setCursorHint( "HINT_NOICON" );
    anim_trig sethintstring( "^9[ ^8Come back later ^9]" );
    anim_trig TriggerIgnoreTeam();
    
    spawnable_case.angles = ( 0, 180, 90 );
    //level waittill( "all_suitcases_collected" );
    wait 0.1;
    foreach( playa in level.players )
    {
        playa.has_immunity = false;
        playa.has_immunity_health = 1000;
    }
    wait 0.05;
    
    
    initial_hit = true;
    
    anim_trig sethintstring( "^9[ ^3[{+activate}] ^8to take a zip of ^9Immunity Drink ^9]" );
    while( true )
    {
        anim_trig waittill( "trigger", who ); 
        if( initial_hit  )
        {
            initial_hit = false;
            earthquake( 0.25, 10, spawnable_drink.origin, 1050 );
            spawnable_lighter thread spin_drinkable_location();
            wait 1;
            spawnable_drink thread hover_drinkable_location();
            spawnable_drink thread spin_drinkable_location();
            level notify( "crafting_serum" );

        }
        
        if( who.has_immunity ) 
        {
            anim_trig setHintString( "^9[ ^8You already have an ^9Immunity Drink^8 effect ^9]" );
            wait 2.5;
            anim_trig sethintstring( "^9[ ^3[{+activate}] ^8to take a sip of ^9Immunity Drink ^9]" );
            wait 2.5;
        }
        if( is_player_valid( who ) )
        {
            if( isdefined( level.subtitles_on_so_have_to_wait ) &&  level.subtitles_on_so_have_to_wait )
            {
                wait 1;
                continue;
            }
            if(  isdefined( who.has_immunity ) && !who.has_immunity  )
            {
                anim_trig setHintString( "^9[ Mixing ^9Immunity Drink^8 ^9]" );
                who.has_immunity = true;
                if( !isdefined( who.has_immunity_health ) )
                {
                    who.has_immunity_health = 1000;
                }

                
                who playsound( "zmb_sq_navcard_success" );
                who thread playlocal_plrsound();
                current_w = who getCurrentWeapon();
                who giveWeapon( "zombie_builder_zm" );
                who switchToWeapon( "zombie_builder_zm" );
                waiter = 3.5;
                wait waiter;
                who maps\mp\zombies\_zm_weapons::switch_back_primary_weapon( current_w );
                who takeWeapon( "zombie_builder_zm" );
                wait 0.1;
                anim_trig sethintstring( "^9[ ^9Immunity Drink ^8is ready to be consumed ^9]" );
                wait 0.05;
                who giveWeapon( "zombie_perk_bottle_tombstone" );
                who switchToweapon( "zombie_perk_bottle_tombstone" );
                wait 2;
                who playsound( "vox_plr_0_exert_burp_0" );
                wait 1.5;
                who maps\mp\zombies\_zm_weapons::switch_back_primary_weapon( current_w );
                who takeWeapon( "zombie_perk_bottle_tombstone" );
                who playsound( "evt_bottle_dispense" );
                foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
                level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says( "^9" + who.name + "^8 took a sip from the potion.", "^8" + "", 5, 1 );
                wait 0.1;
                anim_trig sethintstring( "^9[ ^3[{+activate}] ^8to take a zip of ^3Potion ^9]" );
            }
            if( who.has_immunity == false && who.has_immunity_health < 50 )
            {
            }

            if( isdefined( who.has_immunity ) && who.has_immunity_health < 100 )
            {
                anim_trig setHintString( "^9[ ^8Mixing ^9Immunity Drink^9 ]" );
                who playsound( "zmb_sq_navcard_success" );
                
                who.has_immunity_health = 1000;
                who thread playlocal_plrsound();
                current_w = who getCurrentWeapon();
                who giveWeapon( "zombie_builder_zm" );
                who switchToWeapon( "zombie_builder_zm" );
                waiter = 3.5;
                wait waiter;
                who maps\mp\zombies\_zm_weapons::switch_back_primary_weapon( current_w );
                who takeWeapon( "zombie_builder_zm" );
                if( level.dev_time ){ iprintln( "^3 PLAYER HAS IMMUNITY HEALTHA AT ^8" + who.has_immunity_health ); }
                anim_trig sethintstring( "^9[ ^3[{+activate}] ^8to take a sip of ^9Immunity Drink ^9]" );
                
                
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


rotate_me()
{
    
    while( true )
    {
        if( !isdefined( self ) )
        {
            break;
        }
        if( self.is_on_ground_now == true )
        {
            self rotateyaw( 360, 0.9, 0, 0.7 );
            wait 0.9;
            break;
        }
        self rotateYaw( 360, 0.9, 0, 0 );
        //self rotatePitch( 360, 0.4, 0, 0 );
        wait 0.9;
    }
}

do_show_and_flying( landing_spot )
{
    level endon( "end_game" );
    self.is_on_ground_now = false;
    playfx( level.myFx[ 81 ], self.origin ); //paper windy slow
    wait 0.05;
    playfxontag( level.myfx[ 2 ], self, "tag_origin" );
    self moveto( self.origin + ( 40, -10, 55 ), 0.8, 0.2, 0 );
    self waittill( "movedone" );
    PlaySoundAtPosition(level.jsn_snd_lst[ 8 ], self.origin );

    self moveto( self.origin + ( -20, 70, 40 ), 1, 0, 0 );
    PlaySoundAtPosition(level.jsn_snd_lst[ 5 ], self.origin );
    self waittill( "movedone" );
    PlaySoundAtPosition(level.jsn_snd_lst[ 4 ], self.origin );
    self moveto( self.origin + ( 15, 15, 15 ), 0.8, 0, 0 );
    self waittill( "movedone" );

    self moveto( landing_spot + ( 0, 0, -10 ), .3, 0, 0 );
    self waittill( "movedone" );
    playfx( level.myFx[ 95 ], self.origin + ( 0, 0, 20 ) );
    self setmodel(  level.suitcase_land_model );

    level thread spn_out_bottles( landing_spot );
    self.is_on_ground_now = true;
}

spn_out_bottles( perk_landing )
{
    level endon( "end_game" );
    for( s = 0; s < 32; s++ )
    {
        bottles[ s ] = spawn( "script_model", perk_landing + ( 0, -20 , 10 ) );
        bottles[ s ] setmodel( "t6_wpn_zmb_perk_bottle_tombstone_world" );
        bottles[ s ].angles = ( 0, 180, 90 );
        wait 0.05;
        playfxontag( level.myFx[ 20 ], bottles[ s ], "tag_origin" );
        bottles[ s ] thread tilt();
        bottles[ s ] thread animate();
    }

    level notify( "spawn_rogue_bottle" );
    level thread spawn_rogue_bottle( perk_landing );
    level waittill( "delete_all_suitcase_related" );
    foreach( bs in bottles )
    {
        bs delete();
    }
}

playsoundlooper()
{
    while( isdefined( self  ) )
    {
        PlaySoundAtPosition(level.mysounds[ 12 ], self.origin );
        wait randomFloatRange( 2, 4 );
    }
}

spin_all_over_yaw()
{
    level endon( "end_game" );
    self.angles = ( -90, 0, 0 );
    while( isdefined( self ) )
    {
        self rotateYaw( 360, 1, 0, 0 );
        wait 1;
    }
}

spin_all_over_roll()
{
    level endon( "end_game" );
    while( isdefined( self ) )
    {
        self rotateRoll( 360, 2, 0, 0 );
        wait 2;
    }
}

spin_all_over_pitch()
{
    level endon( "end_game" );
    while( isdefined( self ) )
    {
        self rotatePitch( 360, 2, 0, 0 );
        wait 2;
    }
}
spawn_rogue_bottle( location )
{
    level endon( "end_game" );
    level.shooting_bottles_step_active_again = true;
    mq_shooting_bottle = spawn( "script_model", location );
    mq_shooting_bottle setmodel( "t6_wpn_zmb_perk_bottle_tombstone_world" );
    mq_shooting_bottle.angles = ( randomintrange( 35, 90 ), randomint( 180 ), 0 );
    wait 0.05;
    mq_shooting_bottle playLoopSound(  level.jsn_snd_lst[ 26 ] );
    mq_shooting_bottle thread playsoundlooper();
    mq_trigger_shot = spawn( "trigger_damage", location, 50, 50, 50 );
    mq_trigger_shot setHintString( "" );
    mq_trigger_shot setCursorHint( "HINT_NOICON" );
    mq_trigger_shot SetVisibleToAll();
    mq_shooting_bottle thread spin_all_over_yaw();
   // mq_shooting_bottle thread spin_all_over_pitch();
   // mq_shooting_bottle thread spin_all_over_roll();
    mq_trigger_shot setCanDamage( true );
    
    wait 0.1;
    mq_trigger_shot enablelinkto();
    
    mq_trigger_shot linkto( mq_shooting_bottle );
    if( level.dev_time ){ iprintln( "TRIGGER ORG: ^9" + mq_trigger_shot.origin + " ^8\nBOTTLE ORG: ^9" + mq_shooting_bottle.origin ); }
    playfxontag( level.myfx[ 1 ], mq_shooting_bottle, "tag_origin" );
    wait 0.05;
    playfxontag( level.myFx[ 34 ], mq_shooting_bottle, "tag_origin" );
    wait 0.05;
    initial_moves = [];
    suitcase_locs = [];
    speed_here_next = [];

    PlaySoundAtPosition( level.jsn_snd_lst[ 70 ], mq_trigger_shot.origin );
    playsoundatposition( level.jsn_snd_lst[ 91 ], mq_shooting_bottle.origin );
    suitcase_locs[ 0 ] = ( -6704.51, 5039.83, -45.875 ); //quick
    suitcase_locs[ 1 ] = ( -5530.7, -7865.11, 25.125 ); //speed
    suitcase_locs[ 2 ] = (  8038.52, -4657.54, 284.125 ); //dtap
    suitcase_locs[ 3 ] = ( 1038.92, -1490.15, 148.125 ); //jugg
    
    //bus depo / revive
    if( location == suitcase_locs[ 0 ] )
    {
        initial_moves[ 0 ] = ( -6714.11, 5000.25, 41.3182 );
        initial_moves[ 1 ] = ( -6710.76, 5154.51, 83.8797 );
        initial_moves[ 2 ] = ( -6557.36, 5244.08, -27.2726 );
        initial_moves[ 2 ] = ( -6646.91, 5512.69, 25.937 );
        initial_moves[ 3 ] = ( -6821.92, 5449.45, -7.61107 );

        speed_here_next[ 0 ] = ( -6962.61, 5185.69, 67.5095 );
        speed_here_next[ 1 ] = ( -7112.4, 5411.83, -7.1482 );
        speed_here_next[ 2 ] = ( -6651.42, 5404.02, 88.2427 );
        speed_here_next[ 3 ] = ( -6546.44, 5133.73, -19.5703 );
        speed_here_next[ 4 ] = ( -6458.99, 5565.77, 70.2642 );
        speed_here_next[ 5 ] = ( -6890.43, 5575.94, -24.1671 );
    }

    //diner / speedcola
    if( location == suitcase_locs[ 1 ] )
    {
        initial_moves[ 0 ] = ( -5582.81, -7913.1, 73.4702 );
        initial_moves[ 1 ] = ( -5627.35, -7848.69, 56.5499 );
        initial_moves[ 2 ] = ( -5752.32, -7666.93, 56.7257 );
        initial_moves[ 2 ] = ( -5560.73, -7669.82, 21.1548 );
        initial_moves[ 3 ] = ( -5530.96, -7783.97, 103.966 );

        speed_here_next[ 0 ] = ( -5794.35, -7814.55, 42.9144 );
        speed_here_next[ 1 ] = ( -6035.39, -7537.24, 7.56216 );
        speed_here_next[ 2 ] = ( -6449.57, -7942.64, 44.9581 );
        speed_here_next[ 3 ] = ( -6661.28, -7592.77, 43.144 );
        speed_here_next[ 4 ] = ( -6044.07, -7412.59, 48.0143 );
        speed_here_next[ 5 ] = ( -5676.97, -7607.33, 24.6354 );
    }



    //farm / dtap
    if( location == suitcase_locs[ 2 ] )
    {
        initial_moves[ 0 ] = ( 8038.52, -4657.54, 464.125 );
        initial_moves[ 1 ] = ( 7944.04, -4755.14, 394.782 );
        initial_moves[ 2 ] = ( 8164.06, -4942.67, 250.788 );
        initial_moves[ 2 ] = ( 8421.76, -4758.49, 424.573 );
        initial_moves[ 3 ] = ( 8478.01, -4977.29, 273.032 );

        speed_here_next[ 0 ] = ( 8369.62, -5165.18, 394.973 );
        speed_here_next[ 1 ] = ( 8194.24, -5499.25, 366.946 );
        speed_here_next[ 2 ] = ( 8118.66, -5077.78, 239.292 );
        speed_here_next[ 3 ] = ( 8368.06, -5313.82, 84.5687 );
        speed_here_next[ 4 ] = ( 8189.15, -4538.1, 146.291 );
        speed_here_next[ 5 ] = ( 8170.38, -4476.42, 356.048 );
        speed_here_next[ 6 ] = ( 8064.32, -4725.57, 315.313 );
        

    }

    //town / jugg
    if( location == suitcase_locs[ 3 ] )
    {
        initial_moves[ 0 ] = ( 1034.38, -1513.6, 251.053 );
        initial_moves[ 1 ] = ( 876.068, -1483.1, 137.595 );
        initial_moves[ 2 ] = ( 935.746, -1332.83, 324.934 );
        initial_moves[ 2 ] = ( 1002.54, -1228.56, 200.671 );
        initial_moves[ 3 ] = ( 892.121, -1393.99, 155.566 );

        speed_here_next[ 0 ] = ( 917.207, -1340.73, 270.436 );
        speed_here_next[ 1 ] = ( 1120.07, -1217.03, 218.252 );
        speed_here_next[ 2 ] = ( 1276.07, -643.25, 73.8733 );
        speed_here_next[ 3 ] = ( 867.41, -911.584, 204.835 );
        speed_here_next[ 4 ] = ( 735.281, -1063.95, 221.801 );
        speed_here_next[ 5 ] = ( 971.751, -1248.05, 147.405 );
    }

    mq_shooting_bottle thread add_veryfastfx();
    for( s = 0; s < initial_moves.size; s++ )
    {
        mq_shooting_bottle moveto( initial_moves[ s ], 1, 0.2, 0.2 );
        mq_shooting_bottle waittill( "movedone" );
        PlaySoundAtPosition( level.jsn_snd_lst[ 70 ], mq_shooting_bottle.origin );
        playfxontag( level.myFx[ 46 ], mq_shooting_bottle, "tag_origin" );
    }

    if( level.dev_time ){ iprintlnbold( "WAITING FOR INTERACTING" ); }
    mq_shooting_bottle  thread mover_updown();
    mq_shooting_bottle.health = 5;
    mq_shooting_bottle setcandamage( true );
    while( true )
    {
        mq_trigger_shot waittill(  "damage", amount, attacker );
        if( isplayer( attacker ) )
        {
            playfx( level.myFx[ 96 ], mq_shooting_bottle.origin );
            playfxontag( level.myFx[ 94 ], mq_shooting_bottle, "tag_origin");
            PlaySoundAtPosition(level.jsn_snd_lst[ 43 ] , mq_trigger_shot.origin );
            mq_shooting_bottle notify( "stop_hovers" );
            break;
        }
        
    }
    mq_shooting_bottle thread playfiretrails();
    for( x = 0; x < speed_here_next.size; x++ )
    {
        randomtime = randomfloatrange( 0.8, 1.4 );
        mq_shooting_bottle moveto( speed_here_next[ x ], randomtime, ( randomtime / 4 ), ( randomtime / 2 ) );
        wait randomtime + 0.05;
        mq_shooting_bottle thread mover_updown();
        mq_trigger_shot waittill( "damage", amount, attacker );
        if( isplayer( attacker ) )
        {
            playfx( level.myFx[ 87 ], mq_shooting_bottle.origin );
            //playfx( level.myFx[ 92 ], mq_shooting_bottle.origin );
            if( level.dev_time )
            { 
                iprintlnbold( "MOVING BOTTLE AGAIN" );
            }
            level thread add_spark_fx_then_delete( mq_shooting_bottle );
            PlaySoundAtPosition(level.jsn_snd_lst[ 43 ] , mq_trigger_shot.origin );
            //playfxontag( level.myFx[ 94 ], mq_shooting_bottle, "tag_origin");
           // playfx( level.myFx[ 96 ], mq_shooting_bottle.origin );
            playFXOnTag( level.myFx[ 33 ], mq_shooting_bottle, "tag_origin" );
            mq_shooting_bottle notify( "stop_hovers" );


        }
    }

    mq_shooting_bottle moveto( location, 3, 1, 1.5 ); 
    playfx( level.myFx[ 91 ], mq_shooting_bottle.origin );
    mq_shooting_bottle waittill( "movedone" );
    level thread loop_big_fxs( mq_shooting_bottle.origin );
    mq_shooting_bottle moveto( location + ( 0, 0, 90 ), 2, 0.4, 0.5 );
    mq_shooting_bottle waittill( "movedone" );  
    level thread fxsfxs( location + ( 0, 0, 90 ) );
    //iprintlnbold( "DAMAGE GIVEN NADE" );    
    level notify( "bottle_has_been_returned" );
    wait 1;
    playfxontag( level._effect[ "avogadro_ascend_aerial" ], mq_shooting_bottle, "tag_origin" );
    
    
   // playfxontag( level.myFx[ 92 ], mq_shooting_bottle, "tag_origin" );
    if( isdefined( mq_trigger_shot ) )
    {
        playfx( level.myFx[ 90 ], mq_trigger_shot.origin );
        mq_trigger_shot delete();
    }

    if( isdefined( mq_shooting_bottle ) )
    {
        playfx( level.myFx[ 90 ], mq_shooting_bottle.origin );
        mq_shooting_bottle delete();
    }
    level.shooting_bottles_step_active_again = false;
    wait 2;
    if( level.suitcases_collected == 4 )
    {
        wait 1;
        level notify( "all_suitcases_collected" );
    }
    

}
 
loop_big_fxs( here )
{
    level endon( "end_game" );
    for( i = 0; i < 12; i++ )
    {
        playfx( level.myFx[ 3 ], here );
        wait randomfloatrange( 0.08, 0.9 );
    }
}

do_dialog_here( sub_up, sub_low, duration, fader )
{

    durations = duration;
    fadetimer = fader;
    level thread machine_says( "^9Dr. Schruder: ^8" + sub_up, "^8" + sub_low, durations, fadetimer );
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



add_veryfastfx()
{
    for( i = 0; i < 3; i++ )
    {
        playFXOnTag( level.myFx[ 47 ], self, "tag_origin" );
        wait randomfloatrange( 0.1, 0.45 );
    }
    
}

add_spark_fx_then_delete( selfie )
{
    temp = spawn( "script_model", selfie.origin );
    temp setmodel( "tag_origin" );
    temp.angles = temp.angles;
    wait 0.05;
    playfxontag( level.myFx[ 44 ], temp, "tag_origin" );
    wait 0.05;
    playfxontag( level.myFx[ 44 ], temp, "tag_origin"  );
    wait 2;
    temp delete();
}
playfiretrails()
{
    s = 0;
    while( isdefined( self ) )
    {
        playfxontag( level.myFx[ 43 ], self, "tag_origin" );
        wait 6;
        if( s > 4 )
        {
            break;
        }
        s++;
    }
}
fxsfxs( here )
{
    for( i = 0; i < 25; i++ )
    {
        playfx( level.myFx[ 94 ], here );
        wait 0.08;
    }
}

















do_initial_move_in( which_bottle_location, mq_shooting_bottle )
{
    level endon( "end_game" );
    //what_location = return_initial_move_in_spots( which_bottle_location );
    if( level.dev_time ){ iprintlnbold( "LOCATION FOR SUITCASE MOVE IN = " + level.current_suitcase_location ); }


    if( level.current_suitcase_location == level.suitcase_ground_positions[ 0 ] )
    {
        level thread initial_mover_quickrevive(  mq_shooting_bottle  );
    }
    /*
    if( level.current_suitcase_location == level.suitcase_ground_positions[ 1 ] )
    {
         level thread initial_mover_speedcola(  mq_shooting_bottle  );
    }
    if( level.current_suitcase_location == level.suitcase_ground_positions[ 2 ] )
    {
         level thread initial_mover_dtap(  mq_shooting_bottle  );
    }
    else if( level.current_suitcase_location == level.suitcase_ground_positions[ 3 ] )
    {
        level thread initial_mover_jugg(  mq_shooting_bottle  );
    }
    */
}

initial_mover_quickrevive( who )
{
    level endon( "end_game" );
    locations = [];
    locations[ 0 ] = ( -7720.93, 4165.48, 56.849 );
    locations[ 1 ] = ( -5748.13, 7279.16, 1.36866 );
    locations[ 2 ] = ( 6311.64, 4354.8, 12.9813 );
    locations[ 3 ] = ( -6969.74, 5231.99, -2.49943 );
    locations[ 4 ] = ( -5823.07, 3171.74, 59.1614 );
    locations[ 5 ] = ( -6890.17, 5237.41, 72.2193 );
    wait 0.05;
    //who thread spin_me_around_mq();
    
    for( i = 0; i < locations.size; i++ )
    {
        timer = randomfloatrange( 2, 3 );
        who moveto( locations[ i ], timer, 0, 0 );
        wait timer + 0.05;
    }
    who thread mover_updown();

}

initial_mover_speedcola( who )
{
    level endon( "end_game" );
    locations = [];
    locations[ 0 ] = ( -6720.93, 5165.48, 56.849 );
    locations[ 1 ] = ( -6748.13, 5279.16, 1.36866 );
    locations[ 2 ] = ( 6911.64, 5354.8, 12.9813 );
    locations[ 3 ] = ( -6969.74, 5231.99, -2.49943 );
    locations[ 4 ] = ( -6823.07, 5171.74, 59.1614 );
    locations[ 5 ] = ( -6890.17, 5237.41, 72.2193 );
    who thread spin_me_around_mq();
    who thread mover_updown();
    for( i = 0; i < locations.size; i++ )
    {
        timer = randomfloatrange( 0.2, 0.4 );
        who moveto( locations[ 0 ], timer, 0, timer / 2 );
        wait timer;
    }

}

initial_mover_dtap( who )
{
    level endon( "end_game" );
    locations = [];
    locations[ 0 ] = ( -6720.93, 5165.48, 56.849 );
    locations[ 1 ] = ( -6748.13, 5279.16, 1.36866 );
    locations[ 2 ] = ( 6911.64, 5354.8, 12.9813 );
    locations[ 3 ] = ( -6969.74, 5231.99, -2.49943 );
    locations[ 4 ] = ( -6823.07, 5171.74, 59.1614 );
    locations[ 5 ] = ( -6890.17, 5237.41, 72.2193 );
    who thread spin_me_around_mq();
    who thread mover_updown();
    for( i = 0; i < locations.size; i++ )
    {
        timer = randomfloatrange( 0.2, 0.4 );
        who moveto( locations[ 0 ], timer, 0, timer / 2 );
        wait timer;
    }

}

initial_mover_jugg( who )
{
    level endon( "end_game" );
    locations = [];
    locations[ 0 ] = ( -6720.93, 5165.48, 56.849 );
    locations[ 1 ] = ( -6748.13, 5279.16, 1.36866 );
    locations[ 2 ] = ( 6911.64, 5354.8, 12.9813 );
    locations[ 3 ] = ( -6969.74, 5231.99, -2.49943 );
    locations[ 4 ] = ( -6823.07, 5171.74, 59.1614 );
    locations[ 5 ] = ( -6890.17, 5237.41, 72.2193 );
    who thread spin_me_around_mq();
    who thread mover_updown();
    for( i = 0; i < locations.size; i++ )
    {
        timer = randomfloatrange( 0.2, 0.4 );
        who moveto( locations[ 0 ], timer, 0, timer / 2 );
        wait timer;
    }

}

mover_updown()
{
    level endon( "end_game" );
    self endon( "stop_hovers" );
    while( true )
    {
        if( isdefined( self ) )
        {
            self movez( 100, 1, 0.1, 0.1 );
            wait 1;
            self movez( -100, 1, 0.1, 0.1 );
            wait 1;
        }
    }
}
/*
initial_mover_quickrevive( who )
{
    level endon( "end_game" );
    locations = [];
    locations[ 0 ] = (  );
    locations[ 1 ] = (  );
    locations[ 2 ] = (  );
    locations[ 3 ] = (  );
    locations[ 4 ] = (  );
    locations[ 5 ] = (  );

}

initial_mover_quickrevive( who )
{
    level endon( "end_game" );
    locations = [];
    locations[ 0 ] = (  );
    locations[ 1 ] = (  );
    locations[ 2 ] = (  );
    locations[ 3 ] = (  );
    locations[ 4 ] = (  );
    locations[ 5 ] = (  );

}

initial_mover_quickrevive( who )
{
    level endon( "end_game" );
    locations = [];
    locations[ 0 ] = (  );
    locations[ 1 ] = (  );
    locations[ 2 ] = (  );
    locations[ 3 ] = (  );
    locations[ 4 ] = (  );
    locations[ 5 ] = (  );

}
*/


animate()
{
    level endon( "end_game" );
    old_org = self.origin;
    while( isdefined( self ) )
    {
        randoms = randomfloatrange( 0.9, 1.9 );
        self moveto( old_org, 0, 0, 0 ); 
        wait 0.05;
        //&&randoms = randomfloatrange( 0.9, 1.9 );
        self moveto( self.origin + ( 0, randomintrange( 20, 300 ), randomintrange( 190, 200 ) ), randoms, 0, 0 );
        wait randoms + 0.05;
        self.origin = old_org;
    }
}



tilt()
{
    level endon( "end_game" );
    while( true )
    {
        self rotatePitch( 360, 1, 0, 0 );
        self rotateYaw( 360, 1, 0, 0 );
        if( !isdefined( self ) )
        {
            break;
        }
        wait 1;
    }
}