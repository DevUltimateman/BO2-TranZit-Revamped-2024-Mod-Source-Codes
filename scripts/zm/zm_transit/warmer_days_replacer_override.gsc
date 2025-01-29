//codename: warmer_days_mq_02_meet_mr_s.gsc
//purpose: handles the logic behind overwritten def functions
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


main()
{
    //make the zombie nuke logic better
    //replacefunc( _zm_powerups::nuke_powerup, ::NukePowerUp_re )
    //make the max ammo refill clips too
    //replacefunc( _zm_powerups::full_ammo_powerup, ::FullAmmo_re );
    //busopening window so that they cant climb in after players have upgraded the bus
    //replacefunc( zm_transit_bus::busAddOpening, ::BussAddOpening_re );


    //make zombies run pretty fast if the bus is not being used from point a to b
    
}

init()
{
    //replacefunc( maps\mp\zm_transit_openings::busInitMantle, ::busInitMantle_re );
    //
    //
    //
}

busInitMantle_re()
{
    level endon( "end_game" );

    
	
    if( level.dev_time ){ iPrintLnBold( "WE ARE HOPPING INTO MANTLEBRUSHES" ); }
    /*
    
	if( IsDefined(mantleBrush) && mantleBrush.size > 0 )
	{
		for( i = 0; i < mantleBrush.size; i++)
		{
			
			//mantleBrush[i] Delete(); //*T6 TEMP Delete
			mantleBrush[i] linkto( self, "", self worldToLocalCoords(mantleBrush[i].origin), (0,0,0) );
			mantleBrush[i] SetMovingPlatformEnabled( true );
		}

        if( level.dev_time ) { iprintlnbold( "MANTLEBRUSH POOL SIZE: " + mantleBrush.size ); }
        temp = mantleBrush.size;
        wait 0.1;
        if( level.dev_time ){ iprintlnbold( "OK, PLAYING A FX ON THE BRUSHES NOW" ); }
        for( s = 0; s < temp; s++ )
        {
            playfx( level.myFx[ 1 ], mantleBrush[ s ].origin );
            //playfxontag( level.myFx[ 1 ], mantleBrush[ s ], "" );
            wait 0.05;
        }
	}
    */
}


FullAmmo_re( drop_item, player )
{
    //players = get_players( player.team );
    pl = level.players;
    if ( isdefined( level._get_game_module_players ) )
    {
        pl = [[ level._get_game_module_players ]]( player );
    }

    for ( i = 0; i < pl.size; i++ )
    {
        if ( pl[ i ] maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
        {
            continue;
        }

        
        primary_weapons = pl[ i ] getweaponslist( 1 );
        pl[ i ] notify( "zmb_max_ammo" );
        pl[ i ] notify( "zmb_lost_knife" );
        pl[ i ] notify( "zmb_disable_claymore_prompt" );
        pl[ i ] notify( "zmb_disable_spikemore_prompt" );

        for ( x = 0; x < primary_weapons.size; x++ )
        {
            if ( level.headshots_only && is_lethal_grenade( primary_weapons[ x ] ) )
            {
                continue;

            }
               
            if ( isdefined( level.zombie_include_equipment ) && isdefined( level.zombie_include_equipment[ primary_weapons[ x ] ] ) )
            {
                continue;
            }
                

            if ( isdefined( level.zombie_weapons_no_max_ammo ) && isdefined( level.zombie_weapons_no_max_ammo[ primary_weapons[ x ] ] ) )
            {
                continue;
            }
                

            if ( pl[ i ] hasweapon( primary_weapons[ x ] ) )
            {
                pl[ i ] setWeaponAmmoClip( primary_weapons[ x ], 30 );
                pl[ i ] givemaxammo( primary_weapons[ x ] );
            }
                
        }
    }

    level thread full_ammo_on_hud( drop_item, player.team );
}

NukePowerUp_re( drop_item, p_team )
{
    drop_loc = drop_item.origin;
    playfx( drop_item.fx, drop_loc );

    level thread nuke_flash( p_team );
    wait 0.1;

    zombies = getaiarray( level.zombie_team );
    zombies = arraysort( zombies, drop_loc );
    zombies_nuked = [];

    i = 0;
    while( i < zombies.size )
    {
        if( isDefined( zombies[ i ].ignore_nuke ) && zombies[ i ].ignore_nuke )
        {
            continue;
        }

        if( isDefined( zombies[ i ].marked_for_death ) && zombies[ i ].marked_for_death )
        {
            continue;
        }

        if( isDefined( zombies[ i ].nuke_damage_func ) )
        {
            zombies[ i ] thread [ [ zombies[ i ].nuke_damage_func ] ]();
            continue;
        }

        if( is_magic_bullet_shield_enabled( zombies[ i ] ) )
        {
            continue;
        }

        zombies[ i ].marked_for_death = 1;
        zombies[ i ].nuked = 1;
        zombies_nuked[ zombies_nuked.size ] = zombies[ i ];
        
        i++;
        wait 0.05;
    }

    for( s = 0; s < zombies_nuked.size; s++ )
    {
        wait 0.05;

        if ( !isdefined( zombies_nuked[ s ] ) )
            continue;

        if ( is_magic_bullet_shield_enabled( zombies_nuked[ s ] ) )
            continue;

        if ( s < zombies_nuked.size && !zombies_nuked[ s ].isdog )
            zombies_nuked[ s ] thread maps\mp\animscripts\zm_death::flame_death_fx();

        if ( !zombies_nuked[ s ].isdog )
        {
            if ( !( isdefined( zombies_nuked[ s ].no_gib ) && zombies_nuked[ s ].no_gib ) )
                zombies_nuked[ s ] maps\mp\zombies\_zm_spawner::zombie_head_gib();

            zombies_nuked[ i ] playsound( "evt_nuked" );
        }

        zombies_nuked[ s ] dodamage( zombies_nuked[ s ].health + 1337, zombies_nuked[ s ].origin );
    }

    pl = level.players.size;
    for( p = 0; p < pl; p++ )
    {
        pl[ p ] maps\mp\zombies\_zm_score::player_add_points( "nuke_powerup", 800 );
    }
}



