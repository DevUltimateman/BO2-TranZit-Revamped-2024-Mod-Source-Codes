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





init()
{
    precacheshader( "hud_status_dead" );
    level thread for_joining_players();
}

for_joining_players()
{
    level endon( "end_game" );
    while( true )
    {
        level waittill( "connected", player );
        //player thread lerp_from_offset_to_offset();

        //apply back soon
        //player thread on_spawn();
    }
}

on_spawn()
{
    self waittill( "spawned_player" );
    self thread do_weapon_change_offsets();
} 


do_weapon_change_offsets()
{
    level endon( "end_game" );
    self endon( "disconnect" );
    wait 1;
    if( level.dev_time ){ iprintlnbold( "DOING OFFSETTER THREAD" ); }
    
    self thread while_ads( 0.8, 1.6, -1.8 ); //initial spawn m1911 offset
    wait 2;
    while( true )
    {
        self waittill( "weapon_change", weapon );
        //self notify( "stop_ads_track" );
        xw = get_weapon_offsetter_x( weapon );
        xy = get_weapon_offsetter_y( weapon );
        xz = get_weapon_offsetter_z( weapon );
        self thread while_ads( xw, xy, xz );
        self setClientDvar( "cg_gun_x", xw );
        self setclientdvar( "cg_gun_y", xy );
        self setclientdvar( "cg_gun_z", xz );
    }
}

while_ads( x, y, z )
{
    self endon( "end_ads_thread" );
    self endon( "disconnect" );
    self endon( "weapon_change" );
    level endon( "end_game" );
    self.is_adsing = false;
    while( true )
    {
        wait 0.05;
        //if( !self isOnGround() )
        if( self isreloading() )
        {
            //TRY THIS FAILSAFE
            self setClientDvar( "cg_gun_x", x );
            self setclientdvar( "cg_gun_y", y );
            self setclientdvar( "cg_gun_z", z );
            continue;
        }
        if( self isreloading() && self adsButtonPressed() )
        {
            self setClientDvar( "cg_gun_x", x );
            self setclientdvar( "cg_gun_y", y );
            self setclientdvar( "cg_gun_z", z );
            continue;
        }
        if( self IsSwitchingWeapons() )
        {
            continue;
        }
        if( self adsButtonPressed() )
        {
            self.is_adsing = true;
            self setclientdvar( "cg_gun_x", 2.5 );
            self setclientdvar( "cg_gun_y", 0 );
            self setclientdvar( "cg_gun_z", 0 );
            while( self adsButtonPressed() )
            {
                wait 0.05;
            }
            self.is_adsing = false;
        }
        else if( !self adsbuttonpressed() && !self.is_adsing )
        {
            if( getDvar( "cg_gun_x" ) != x ) { self setclientdvar( "cg_gun_x", x );}// if( level.dev_time ){ iprintln( "SETTING NEW OFFSET FOR WEAPON" ); }  }
            if( getDvar( "cg_gun_y" ) != y ) { self setclientdvar( "cg_gun_y", y );}// if( level.dev_time ){ iprintln( "SETTING NEW OFFSET FOR WEAPON" ); } }
            if( getDvar( "cg_gun_z" ) != z ) { self setclientdvar( "cg_gun_z", z );} //if( level.dev_time ){ iprintln( "SETTING NEW OFFSET FOR WEAPON" ); } }
        }
    }
}
lerp_weapon_offsets( x_target, y_target, z_target )
{
    self endon( "weapon_change" );
    self endon( "disconnect" );
    self endon( "death" );

    x_goal = false;
    y_goal = false;
    z_goal = false;
    self.lerper = true;
    x_dvar_current = getDvar( "cg_gun_x" );
    y_dvar_current = getdvar( "cg_gun_y" );
    z_dvar_current = getdvar( "cg_gun_z" );

    iprintln( "OFFSETS CURRENT : : : " + x_dvar_current + "  " + y_dvar_current + "  " + z_dvar_current );
    iprintln( "OFFSETS TARGET : : : " + x_target + "  " + y_target + "  " + z_target );

    first_up = false;
    second_up = false;
    third_up = false;
    while( true )
    {

    }
    if( !first_up )
    {
        if( x_dvar_current > x_target )
        {
            first_up = false;
        }
        else { first_up = true; }
    }

    if( !second_up )
    {
        if( y_dvar_current > y_target )
        {
            second_up = false;
        }
        else { second_up = true; }
    }

    if( !third_up )
    {
        if( z_dvar_current > z_target )
        {
            third_up = false;
        }
        else { third_up = true; }
    }
    while( self.lerper )
    {
        //if dvars are currently higher than the target value
        if( !first_up && !x_goal )
        {
            get_current = getdvar( "cg_gun_x" );
            get_current -= 0.1;
            self setclientdvar( "cg_gun_x", get_current );
            if( get_current == x_target )
            {
                x_goal = true;
            }
        }

        if( first_up && !x_goal )
        {
            get_current = getdvar( "cg_gun_x" );
            get_current += 0.1;
            self setclientdvar( "cg_gun_x", get_current );
            if( get_current == x_target )
            {
                x_goal = true;
            }
        }

        //if dvars are currently higher than the target value
        if( !second_up && !y_goal )
        {
            get_current = getdvar( "cg_gun_y" );
            get_current -= 0.1;
            self setclientdvar( "cg_gun_y", get_current );
            if( get_current == y_target )
            {
                y_goal = true;
            }
        }

        if( second_up && !y_goal )
        {
            get_current = getdvar( "cg_gun_y" );
            get_current += 0.1;
            self setclientdvar( "cg_gun_y", get_current );
            if( get_current == y_target )
            {
                y_goal = true;
            }
        }

        //if dvars are currently higher than the target value
        if( !third_up && !z_goal )
        {
            get_current = getdvar( "cg_gun_z" );
            get_current -= 0.1;
            self setclientdvar( "cg_gun_z", get_current );
            if( get_current == z_target )
            {
                z_goal = true;
            }
        }

        if( third_up && !z_goal )
        {
            get_current = getdvar( "cg_gun_z" );
            get_current += 0.1;
            self setclientdvar( "cg_gun_z", get_current );
            if( get_current == z_target )
            {
                z_goal = true;
            }
        }

        if( first_up && second_up && third_up && self.lerper )
        {
            wait 1;
            iprintlnbold( "WEAPON LERPING COMPLETE" );
            wait 0.05;
            self.lerper = false;
            break;
        }


        wait 0.05;
    }
}


get_weapon_offsetter_x( weapon_type )
{
    switch( weapon_type )
    {
        case "python_zm":
            return -3.25;
        case "m1911_zm":
            return -2.4;

        case "mp5k_zm":
            return -2;
        
        case "m14_zm":
            return -2.8;

        case "judge_zm":
        return -3.35;

        case "kard_zm":
            return -3.35;

        case "m1911_upgraded_zm":
            return -3.35;
        case "fiveseven_zm":
            return -3.35;

        case "beretta93r_zm":
            return -3.35;


        case "fivesevendw_zm":
            return -3.35;

            case "ak74u_zm":
            return -2.15;

        case "qcw05_zm":
            return -3.25;
        case "870mcs_zm":
            return -2.4;

        case "rottweil72_zm":
            return -2;

        case "saiga12_zm":
        return -2.4;

        case "srm1216_zm":
        return -4;

        case "saritch_zm":
        return -2;
        
        case "m16_zm":
        return -2.4;

        case "m16_zm_gl":
        return -2.4;

        case "xm8_zm":
        return -2.15;

        case "type95_zm":
        return -2;

        case "tar21_zm":
        return -2.7;

        case "galil_zm":
        return -1.8;

        case "fnfal_zm":
        return -2.2;

        case "dsr50_zm":
        return -3.6;
        case "barretm82_zm":
        return -2.5;

        case "rpd_zm":
        return -4;

        case "hamr_zm":
        return -1.2;

        case "usrpg_zm":
        return -1;

        case "m32_zm":
        return -2.4;

        case "ray_gun_zm":
        return -5;

        case "knife_ballistic_zm":
        return -3;

        case "knife_ballistic_bowie_zm":
        return -3;

        case "raygun_mark2_zm":
        return -6;

        //everything else gets a default offset
        default:
            return 0;
    }
}
get_weapon_offsetter_y( weapon_type )
{
    switch( weapon_type )
    {
        case "python_zm":
            return 1.75;
        case "usrpg_zm":
        return 1;
        case "rpd_zm":
        return 2.45;
        case "dsr50_zm":
        return 1.8;
        case "m1911_zm":
            return  2.3;
        case "mp5k_zm":
            return 2.45;
        
        case "m14_zm":
            return 3.4;
        
        case "judge_zm":
        return 1.65;
        case "kard_zm":
            return 1.85;    


        case "fiveseven_zm":
            return 1.55;

        case "m1911_upgraded_zm":
            return .25;    
        case "beretta93r_zm":
            return 1.65;


        case "fivesevendw_zm":
            return .25;

        case "ak74u_zm":
            return 2;

        case "qcw05_zm":
            return 2.5;
        case "870mcs_zm":
            return 2;
        case "rottweil72_zm":
            return 2.15;

        case "saiga12_zm":
        return 2.25;
        case "srm1216_zm":
        return 2.25;
        case "saritch_zm":
        return 1.65;
        case "m16_zm":
        return 2.1;
        case "m16_zm_gl":
        return 2.1;

        case "xm8_zm":
        return 2;

        case "type95_zm":
        return 1.75;

         case "tar21_zm":
        return .8;
        case "galil_zm":
        return 1.75;
        case "fnfal_zm":
        return 2;
        case "barretm82_zm":
        return 1.85;

        case "hamr_zm":
        return 1.85;

        case "m32_zm":
        return 1.3;

        case "ray_gun_zm":
        return 2;

        case "knife_ballistic_zm":
        return 1;
        case "knife_ballistic_bowie_zm":
        return 1;
        case "raygun_mark2_zm":
        return 3.3;

         //everything else gets a default offset
        default:
            return 0;
    }
}
get_weapon_offsetter_z( weapon_type )
{
    switch( weapon_type )
    {
        case "python_zm":
            return .45;
        case "m32_zm":
        return .5;
        case "usrpg_zm":
        return -1;

        case "hamr_zm":
        return .3;
        case "rpd_zm":
        return 1;
        case "barretm82_zm":
        return .3;
        case "dsr50_zm":
        return .2;
        case "fnfal_zm":
        return .65;
        case "m1911_zm":
            return -0.3;
        case "mp5k_zm":
            return 0.75;
        case "m14_zm":
            return 0.7;

        case "judge_zm":
        return -.75;
        case "kard_zm":
            return .85; 

    
        case "fiveseven_zm":
            return .45;
        case "beretta93r_zm":
            return .2;

        case "m1911_upgraded_zm":
            return .9;   


        case "fivesevendw_zm":
            return .9;
        case "ak74u_zm":
            return .75;
            case "qcw05_zm":
            return .75;

        case "870mcs_zm":
            return .5;
        case "rottweil72_zm":
            return .7;
        case "saiga12_zm":
        return .25;
        case "srm1216_zm":
        return 1;

        case "saritch_zm":
        return .65;
        case "m16_zm":
        return .66;
        case "m16_zm_gl":
        return .66;
        case "xm8_zm":
        return 0.75;

        case "type95_zm":
        return 0.65;

        case "tar21_zm":
        return .66;

        case "galil_zm":
        return .45;



        case "ray_gun_zm":
        return .5;

        case "knife_ballistic_zm":
        return 0.5;

        case "knife_ballistic_bowie_zm":
        return 0.5;

        case "raygun_mark2_zm":
        return 0.8;

         //everything else gets a default offset
        default:
            return 0;
    }
}

