//codename: warmer_days_mq_08_leash_chaos.gsc
//purpose: handles the round 115 change & zombie logic
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

//#include scripts\zm\zm_transit\warmer_days_quest_firenade;

init()
{
	level thread survivors_called_help();
	//level thread debugger();
	//level thread waittill_ender();
}


debugger()
{
	flag_wait( "initial_blackscreen_passed" );
	xx = 100;
	for( i = 0; i < xx; i++ )
	{
		wait 1;
		iprintln( i );
	}
	level notify( "chaos_ensues_from_calling_help" );
}
survivors_called_help()
{
	level endon( "end_game" );
	level waittill( "chaos_ensues_from_calling_help" );
	wait 3;
	/*
	//debug:
	foreach( p in level.players )
	{
		p setOrigin( ( 7457.21, -431.969, -195.816 ) + ( 20, 10, randomIntRange( 50, 120 ) )) ;
	}
	*/
	//dialogue schruder says they sorry
	//but end is coming now
	//schruder tried to keep you not from calling help by giving u nice things
	//now game is going to become last stand fuck
	PlaySoundAtPosition(level.jsn_snd_lst[ 30 ], level.players[ 0 ].origin );
	wait 0.05;
	PlaySoundAtPosition("bik_zm_tomb_ee_c", level.players[0].origin );
	foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread do_dials( "My friend!", "The time has come, huh.", 6, 1 );
	wait 8;
	foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
	level thread do_dials( "You've been such a great survivor..", "..a true accomplisher.", 5, 1 );
	wait 7;
	foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
	level thread do_dials( "However, I must tell you something else too at this point.", "You're not getting out alive from here.", 5, 1 );
	wait 7;
	foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
	level thread do_dials( "You're part of a ^9test scenario, and so am I.", "You're just a subject that ceases to exist after this experience.", 9, 1 );
	wait 11;
	foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
	level thread do_dials( "You will be deleted,", "once the higher ups realize that you have no will to survive..", 7, 1 );
	wait 9;
	foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
	level thread do_dials( "But don't be misinformed. ", "I was always rooting for you..", 6, 1 );
	wait 8;
	foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
	level thread do_dials( "I will buy you some time, so that you can start running.", "", 4, 1 );
	wait 6;
	foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
	wait 1;
	level thread chaos_begins();
	level thread do_dials( "At last,", "Goodbye my ^9friend.", 4, 1 );
	wait 11; //perfect wait timer to start playing laughs and chaos
	level notify( "start_chaos" );
	wait 2;
	randomintranger = randomIntRange( 500, 1500 );
	PlaySoundAtPosition( "mus_zombie_round_start", level.players[ 0 ].origin );
    level thread scripts\zm\zm_transit\warmer_days_sq_rewards::print_text_middle( "^9Till I Cease To Exist", "^8Test Scenario ^3#" + randomintranger + "^8 has come to an end.", "^1Terminating Scenario^8.", 6, 0.25 );
    wait 1.5;

}

chaos_begins()
{

	level waittilL( "start_chaos" ); 
	earthquake( .6, 6, level.players[ 0 ].origin, 1000 );
	foreach( players in level.players )
	{
		players playsound( level.jsn_snd_lst[ 17 ] );
	}
	PlaySoundAtPosition(level.jsn_snd_lst[ 30 ], level.players[ 0 ].origin );
	wait 14.5;
	level thread exposure_flash();
	PlaySoundAtPosition(level.jsn_snd_lst[ 17 ], level.players[ 0 ].origin );
	foreach( p in level.players )
	{
		p playsound( level.jsn_snd_lst[ 30 ] );
		p setclientdvar( "r_skyColorTemp", 2800 );	
		p setclientdvar( "r_sky_intensity_factor0", 4 );
		p setclientdvar( "vc_rgbh", "1 0.2 0 0" );
		p setclientdvar( "vc_yl", "0.3 0.3 0.3 0" );
		p setclientdvar( "vc_rgbl", "1 0 0 0" );
		
	}
	wait 3;
	if( level.dev_time ){ iprintlnbold( "METEORS START HITTING NOW" ); }
	level thread meteor_shower_on_player();

}

meteor_shower_on_player()
{
	level endon( "end_game" );
	
	foreach( playa in level.players )
	{
		playa thread follow_meteor_rain();
	}
}

follow_meteor_rain()
{
	level endon( "end_game" );
	self endon( "disconnect" );

	meteors = [];
	blocks = [];
	meteors[ 0 ] = spawn( "script_model", self.origin + ( 0, 0, 10000 ) );
	meteors[ 0 ] setmodel( "p6_zm_rocks_medium_05" );
	meteors[ 0 ].angles = ( randomintrange( 0, 350 ), randomintrange( 0, 350 ), randomintrange( 0, 350 ) );
	blocks[ 0 ] = spawn( "script_model", self.origin + ( 0, 0, 10000 ) );
	blocks[ 0 ] setmodel( "collision_player_128x_128x_128x" );
	blocks[ 0 ].angles = meteors[ 0 ].angles;
	blocks[ 0 ] enableLinkTo();
	blocks[ 0 ] linkto( meteors[ 0 ] );
	wait 0.1;
	playfxontag( level._effects[ 47 ], meteors[ 0 ], "tag_origin" );
	meteors[ 1 ] = spawn( "script_model", self.origin + ( 0, 0, 10000 ) );
	meteors[ 1 ] setmodel( "p6_zm_rocks_medium_05" );
	meteors[ 1 ].angles = ( randomintrange( 0, 350 ), randomintrange( 0, 350 ), randomintrange( 0, 350 ) );
	wait 0.1;
	blocks[ 1 ] = spawn( "script_model", self.origin + ( 0, 0, 10000 ) );
	blocks[ 1 ] setmodel( "collision_player_128x_128x_128x" );
	blocks[ 1 ].angles = meteors[ 1 ].angles;
	blocks[ 1 ] enableLinkTo();
	blocks[ 1 ] linkto( meteors[ 1 ] );
	playfxontag( level._effects[ 47 ], meteors[ 1 ], "tag_origin" );
	meteors[ 2 ] = spawn( "script_model", self.origin + ( 0, 0, 10000 ) );
	meteors[ 2 ] setmodel( "p6_zm_rocks_medium_05" );
	meteors[ 2 ].angles = ( randomintrange( 0, 350 ), randomintrange( 0, 350 ), randomintrange( 0, 350 ) );
	wait 0.1;
	blocks[ 2 ] = spawn( "script_model", self.origin + ( 0, 0, 10000 ) );
	blocks[ 2 ] setmodel( "collision_player_128x_128x_128x" );
	blocks[ 2 ].angles = meteors[ 2  ].angles;
	blocks[ 2 ] enableLinkTo();
	blocks[ 2 ] linkto( meteors[ 2   ] );
	playfxontag( level._effects[ 47 ], meteors[ 2 ], "tag_origin" );
	meteors[ 3 ] = spawn( "script_model", self.origin + ( 0, 0, 10000 ) );
	meteors[ 3 ] setmodel( "p6_zm_rocks_medium_05" );
	meteors[ 3 ].angles = ( randomintrange( 0, 350 ), randomintrange( 0, 350 ), randomintrange( 0, 350 ) );
	wait 0.1;
	blocks[ 3 ] = spawn( "script_model", self.origin + ( 0, 0, 10000 ) );
	blocks[ 3 ] setmodel( "collision_player_128x_128x_128x" );
	blocks[ 3 ].angles = meteors[ 3 ].angles;
	blocks[ 3 ] enableLinkTo();
	blocks[ 3 ] linkto( meteors[3  ] );
	playfxontag( level._effects[ 47 ], meteors[ 3 ], "tag_origin" );
	meteors[ 4 ] = spawn( "script_model", self.origin + ( 0, 0, 10000 ) );
	meteors[ 4 ] setmodel( "p6_zm_rocks_medium_05" );
	meteors[ 4 ].angles = ( randomintrange( 0, 350 ), randomintrange( 0, 350 ), randomintrange( 0, 350 ) );
	wait 0.1;
	blocks[ 4 ] = spawn( "script_model", self.origin + ( 0, 0, 10000 ) );
	blocks[ 4 ] setmodel( "collision_player_128x_128x_128x" );
	blocks[ 4 ].angles = meteors[ 4 ].angles;
	blocks[ 4 ] enableLinkTo();
	blocks[ 4 ] linkto( meteors[ 4 ] );
	playfxontag( level._effects[ 47 ], meteors[ 4 ], "tag_origin" );
	meteors[ 5 ] = spawn( "script_model", self.origin + ( 0, 0, 10000 ) );
	meteors[ 5 ] setmodel( "p6_zm_rocks_medium_05" );
	meteors[ 5 ].angles = ( randomintrange( 0, 350 ), randomintrange( 0, 350 ), randomintrange( 0, 350 ) );
	
	wait 0.1;
	blocks[ 5 ] = spawn( "script_model", self.origin + ( 0, 0, 10000 ) );
	blocks[ 5 ] setmodel( "collision_player_128x_128x_128x" );
	blocks[ 5 ].angles = meteors[ 5 ].angles;
	blocks[ 5 ] enableLinkTo();
	blocks[ 5 ] linkto( meteors[ 5 ] );
	playfxontag( level._effects[ 47 ], meteors[ 5 ], "tag_origin" );
	for( i = 0; i < meteors.size; i++ )
	{
		meteors[ i ] thread track_and_movetohit_player( self );
		wait randomFloatRange( 0.5, 3 );
	}
	wait 1;
	if( level.dev_time) { iprintlnbold( "ROCKS ARE TRACKING PLAYER AND ORBITING TO HIT" ); }
}

track_and_movetohit_player( plr )
{
	level endon( "end_game" );
	first_time = true;
	while( isdefined( self ) )
	{
		//initial sky move
		if( first_time )
		{
			i_x = randomintrange( -1000, 1000 );
			i_y = randomintrange( -1000, 1000 );
			i_z = randomintrange( 4500, 7000 );
			self moveto( plr.origin + ( i_x, i_y, i_z ), 1, 0.1, 0 );
			
			wait 1;
			p_x = randomintrange( -450, 450 );
			p_y = randomintrange( -400, 400 );
			p_z = randomintrange( -100, -40 );
			player_spot = plr.origin + ( p_x, p_y, p_z );
			playfxontag( level.myFx[ 91 ], self, "tag_origin" );
			self moveto( player_spot, 1.5, 0, 0.1 );
			PlaySoundAtPosition(level.jsn_snd_lst[ 4 ], self.origin );
			self waittill( "movedone" );
			PlaySoundAtPosition(level.jsn_snd_lst[ 2 ], self.origin );
			for( i = 0; i < level.players.size; i++ )
			{
				if( distance( level.players[ i ].origin, self.origin ) < 150 )
				{
					level.players[ i ] dodamage( level.players[ i ].health + 500, level.players[ i ].origin );
					
				}
				else if( distance( level.players[ i ].origin, self.origin ) < 250 )
				{
					level.players[ i ] dodamage( level.players[ i  ].health / 2, level.players[ i ].origin );

				}
				else{ wait 0.05; }
			}
			earthquake( 0.5, 4, self.origin, 1000 );
			wait 0.5;	
			self movez( -300, 5, 0.5, 0.5 );
			PlaySoundAtPosition(level.jsn_snd_lst[ 27 ], self.origin );
			self waittill( "movedone" );
			wait 0.1;
			self.origin = plr.origin + ( 0, 0, 10000 );
			first_time = false;
		}
		else if( !first_time )
		{
			i_x = randomintrange( -1000, 1000 );
			i_y = randomintrange( -1000, 1000 );
			i_z = randomintrange( 4500, 6000 );
			self moveto( plr.origin + ( i_x, i_y, i_z ), 1, 0.1, 0 );
			PlaySoundAtPosition(level.jsn_snd_lst[ 4 ], self.origin );
			wait 1;
			p_x = randomintrange( -450, 450 );
			p_y = randomintrange( -400, 400 );
			p_z = randomintrange( -100, -40 );
			player_spot = plr.origin + ( p_x, p_y, p_z );
			playfxontag( level.myFx[ 91 ], self, "tag_origin" );
			self moveto( player_spot, 1.5, 0, 0.1 );
			self waittill( "movedone" );
			PlaySoundAtPosition(level.jsn_snd_lst[ 2 ], self.origin );
			for( i = 0; i < level.players.size; i++ )
			{
				if( distance( level.players[ i ].origin, self.origin ) < 150 )
				{
					level.players[ i ] dodamage( level.players[ i ].health + 500, level.players[ i ].origin );
					
				}
				else if( distance( level.players[ i ].origin, self.origin ) < 250 )
				{
					level.players[ i ] dodamage( level.players[ i  ].health / 2, level.players[ i ].origin );

				}
				else{ wait 0.05; }
			}
			earthquake( 0.5, 4, self.origin, 1000 );
			wait 0.1;	
			self movez( -300, 5, 0.5, 0.5 );
			self waittill( "movedone" );
			wait 0.1;
			self.origin = plr.origin + ( 0, 0, 10000 );
		}
		wait 0.05;
	}
}



exposure_flash()
{
	//level.jsn_snd_lst[ 17 ] // hahahahaha demon laugh
	//level.jsn_snd_lst[ 27 ] //thoombs sound
	//level.jsn_snd_lst[ 29 ] // ring nuked sound

	foreach( p in level.players )
	{
		p playsound( level.jsn_snd_lst[ 29 ] );

	}
	wait 0.1;
	foreach( p in level.players )
	{
		p playsound( level.jsn_snd_lst[ 27 ] );

	}
	wait 0.05;
	PlaySoundAtPosition(level.jsn_snd_lst[ 17 ], level.players[ 0 ].origin );
	foreach( s in level.players )
	{
		s setclientdvar( "r_exposuretweak", true );
	}
	wait 0.1;
	for( s = 0; s < level.players.size; s++ )
	{
		earthquake( 0.5, 4, level.players[ s ].origin, 2500 );
	}
	
	foreach( playa in level.players )
	{
		playa thread flash_me();
	}
	
}


flash_me()
{
	level endon( "end_game" );
	self endon( "disconnect" );
	self setclientdvar( "r_exposuretweak", true );
	for( i = 0; i < 4; i++ )
	{
		
		self setclientdvar( "r_exposurevalue", 2.8 );
		wait 0.08;
		self setclientdvar( "r_exposurevalue", 1.8 );
		wait 0.1;
		self setclientdvar( "r_exposurevalue", 2.5 );
		wait 0.05;
		self setclientdvar( "r_exposurevalue", .8 );
		wait 0.07;
		self setclientdvar( "r_exposurevalue", 2.8 );
		wait 0.1;
		self setclientdvar( "r_exposurevalue", .4 );
		wait 0.05;
		self setclientdvar( "r_exposurevalue", 3 );
		wait 0.1;
	}
	self setclientdvar( "r_exposuretweak", false );
}




do_dials( sub_up, sub_low, duration, fader )
{
    level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says( "^9Dr. Schruder: ^8" + sub_up, "^8" + sub_low, duration, fader );
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

set_round_and_chaos()
{

	/*
    if( level.dev_time )
    { 
        upperm = "Be prepared to meet your worst haha!";
        lowerm = "Your time has come you fools!";
        duration = 5;
        fadetime = 1;
        level thread mac_say( "^3Dr. Schrude: ^7" + upperm, lowerm, duration, fadetime );
    }
	*/
	wait(5);

	target_round = 115 ;	
	level.devcheater = 1;
	level.zombie_total = 0;
	maps\mp\zombies\_zm::ai_calculate_health( target_round / 8 );
   // if( level.dev_time ){ iprintlnbold( "zombies health: " + maps\mp\zombies\_zm::ai_calculate_health( target_round / 8 ), "upcoming round: " + target_round );}
	level.round_number = target_round - 1;

	level notify( "kill_round" );

	//iprintln( "Jumping to round: " + target_round );
	wait( 1 );
	
	// kill all active zombies
	zombies = getAIArray( level.zombie_team );

	if ( IsDefined( zombies ) )
	{
		for (i = 0; i < zombies.size; i++)
		{
			if ( is_true( zombies[i].ignore_devgui_death ) )
			{
				continue;
			}
			zombies[i] dodamage(zombies[i].health + 666, zombies[i].origin);
		}
	}

    wait 3;
    level.zombie_total = 10000;
    if( level.dev_time ){ iprintlnbold( "ZOMBIE TOTAL = " + level.zombie_total ); }

    //level thread create_zombie_escape_spot();
	
}


create_zombie_escape_spot()
{

	//escape spot array
	level._cont_spots = getstructarray("zcon_escape_spot","targetname");	
    //playfx( level._effect[ "lght_marker"], level._cont_spots.origin );
	level._current_cont_spot = getstruct("zcon_start","script_noteworthy");
    //playfx( level._effect[ "lght_marker"], level._current_cont_spot.origin );
	
	//wait(5);
	
	//set up the effect & trigger
	level.escape_spot_fx = spawn("script_model",level.players[0].origin );		
	level.escape_spot_fx setmodel("TAG_ORIGIN");
	wait(.1);
	
	trace = bullettrace(level.escape_spot_fx.origin + (0,0,50),level.escape_spot_fx.origin + (0,0,-60),0,undefined);
	level.escape_spot_fx rotateTo( vectortoangles( trace["normal"] ), 0.1 );	
		
	playfxontag(level._effect["escape"],level.escape_spot_fx,"TAG_ORIGIN");
	playfxontag(level._effect["escape_tail"],level.escape_spot_fx,"TAG_ORIGIN");	
	
	if(isDefined(level._effect[ "black_hole_bomb_portal_exit" ]))
	{
		playfxontag(level._effect[ "black_hole_bomb_portal_exit" ],level.obj_spot,"tag_origin");
	}
	
	level.escape_spot = spawn("trigger_radius", level.escape_spot_fx.origin , 9, 48, 48*2);
	
	//this runs on the trigger and waits for zombies
	//level.escape_spot thread wait_for_zombie_to_esacpe();
    
    
    who = level.players[0];
	org = who.origin;
    playsoundatposition ("lightning_l",org );
	if(isDefined(level._effect[ "black_hole_bomb_zombie_destroy" ]))
        {
            PlayFX( level._effect[ "black_hole_bomb_zombie_destroy" ], org  );
        }
	//create the point of interest for the zombies
	//level.escape_spot_fx create_zombie_point_of_interest( undefined, 30, 0, false );
	//level.escape_spot_fx thread create_zombie_point_of_interest_attractor_positions( 4, 45 );
	level.current_poi = level.escape_spot_fx;
	
    
		
	Objective_Add(1, "current", "Prevent zombies from escaping", level.obj_spot);
	//Objective_Set3D(1, true, (1, 1, 1), "Defend");
	
	
	
}
rotate_sam()
{
	z = 0;
	while(1)
	{
		self.angles = self.angles + (0,1,0);
		wait(.05);
	}
}


lets_test_spawn()
{
	
	iprintln( "DOING A MEAT FXS TEST UP IN 3 SECONDS" );
	iprintln( "WE HAVE " + level.fx_betas.size + " many beta fxs!" );
	listvalue = 0;

	player = getplayers()[0];
	iprintln( "PLAYER 0 IS " + player.name );
	while( true )
	{
		//level.fx_betas.size
		//FIRST 12 = BETAS FOR NOW
		for( listvalue = 0; listvalue < 12; listvalue++ )
		{
			playfx( level.myfx[ listvalue ], player.origin ); 
			iprintln( "Played fx: " + level.myfx[ listvalue ] );
			wait 0.8;
		}
		wait 0.05;
	}
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
