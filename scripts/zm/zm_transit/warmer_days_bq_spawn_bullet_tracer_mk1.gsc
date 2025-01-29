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
    level thread weapon_mark_1_spawn();
}
raygun_mark_1bullet()
{
    self endon ("disconnect");
    self endon ("death");
    self endon("stopBullets");
    self endon("player_downed");
    level endon("end_game");
    
    while ( true )
    {
        front = anglesToForward( self getPlayerAngles() );
        start = self getEye();
        end = world_dir( front, 9999 );
        
        self waittill( "weapon_fired", weap );
        //weap = self getCurrentWeapon();
         if( weap == "jetgun_zm" ){ wait 0.05; continue;}
        if( weap == "turbine_zm" ){ wait 0.05; continue;}
        if( weap == "equip_turbine_zm" ){ wait 0.05; continue;}
        if( weap == "equip_electrictrap_zm" ){ wait 0.05; continue;}
        if( weap == "electrictrap_zm" ){ wait 0.05; continue;}
        if( weap == "turbine" ){ wait 0.05; continue;}
        if( weap == "electrictrap" ){ wait 0.05; continue;}

        if( weap == "ray_gun_zm" ){ wait 0.05; continue;}
        if( weap == "ray_gun_upgraded_zm" ){ wait 0.05; continue;}
        if( weap == "knife_ballistic_zm" ){ wait 0.05; continue;}
        if( weap == "equip_turbine_zm" ){ wait 0.05; continue;}
        if( weap == "knife_ballistic_upgraded_zm" ){ wait 0.05; continue;}
        if( weap == "knife_ballistic_bowie_zm" ){ wait 0.05; continue;}
        if( weap == "knife_ballistic_bowie_upgraded_zm" ){ wait 0.05; continue;}
        if( weap == "knife_ballistic_no_melee_upgraded_zm" ){ wait 0.05; continue;}
        if( weap == "knife_ballistic_no_melee_zm"  ){ wait 0.05; continue;}
        if( weap == "raygun_mark2_upgraded_zm" ){ wait 0.05; continue;}
        if( weap == "raygun_mark2_zm" ){ wait 0.05; continue;}
        else
        {

            magicbullet( "ray_gun_zm", self gettagorigin( "tag_weapon_left" ), bullettrace( self gettagorigin( "tag_weapon_left" ), self gettagorigin( "tag_weapon_left" ) + AnglesToForward( self getplayerangles() ) * 1000000, 0, self)[ "position" ], self );
        }    
        wait 0.05;                                                         
        
    }
    
}

rotateGunUpgrade()
{
    level endon("end_game");
    wait randomintrange( 2, 10 );
    while ( true )
    {
        self rotateyaw( 360, 2, 0, 0 );
        //self rotateroll( 360, 2, 0, 0 );
        //self rotatePitch( 360, 2, 0, 0 );
        wait 2;
    }
}

world_dir( angles, multiplier )
{
    x = angles[ 0 ] * multiplier;
    y = angles[ 1 ] * multiplier;
    z = angles[ 2 ] * multiplier;
    return ( x, y, z );
}
//void_lod0
//viewmodel_default_lod0
weapon_mark_1_spawn()
{
    level endon("end_game");
    self endon("disconnect");

    level waittill("initial_blackscreen_passed");
    debugOrigin = ( 8118.79, -4821.86, 100 );
    gunOrigin = ( 8118.79, -4821.86, 100 );
    trigger = spawn( "trigger_radius", gunOrigin, 26, 68, 68 );
    block = spawn( "script_model", gunOrigin );
    block setmodel("collision_player_64x64x128");
    block.angles = block.angles;
    wait 0.05;
    
    trigger SetCursorHint("HINT_NOICON");
    trigger setHintString( "^8[ ^9[{+activate}] ^8to upgrade you bullet type to ^2Ala-Hoopin ^8]\n^8Cost: ^915 000" );
    //level thread LowerMessage( "Custom Perks", "Hold ^6[{+activate}] ^7to upgrade your ^6bullet type^7 [Cost:^6 20000^7]" );
    //trigger setLowerMessage( trigger, "Custom Perks"  );

    paploc = ( 59872.7, 141818, 88737.5 );

    gun = spawn("script_model", gunOrigin );
    gun setModel("weapon_usa_ray_gun");
    gun.angles = ( -45, 0, 0 );
    wait .1;
    gun thread rotateGunUpgrade();
    //playfx(level._effect[ "powerup_on"], gunOrigin + ( 0, 0, -4 ) );
    playfxontag( level.myFx[ 26 ], gun, "tag_origin" );
    gun playLoopSound( "zmb_spawn_powerup_loop" );

    portal = spawn( "script_model", gunOrigin + ( 0, 0, -55 ) );
    portal setmodel("p6_zm_screecher_hole" );
    portal.angles = ( 0, 180, 0 );
    wait 0.1;
    playfx( level.myFx[ 44 ] , portal.origin );
    playfx( level.myFx[ 26 ], gun.origin );
    playFXOnTag( level._effect[ "screecher_vortex" ], portal, "tag_origin" );
    portal playLoopSound( "zmb_screecher_portal_loop", 2 );

    spas = spawn( "script_model", portal.origin + ( 0, 0, -1000 ) );
    spas.angles = (0,0,0);
    spas setmodel( "tag_origin" );
    wait 0.05;
    playfxontag( level._effect[ "screecher_hole" ], spas, "tag_origin" );
    level.bullet_type_upgrade_cost_1 = 15000; //15000
    trigger thread waittill_price_reduce_mk1();
    player.hasused = false;
    while ( true )
    {
        trigger waittill( "trigger", player ); //continue from this point tommorow. 9 hours work on this shit today, tired..
        if ( player useButtonPressed() && player.score >= level.bullet_type_upgrade_cost_1 && player getCurrentWeapon() )
        {
            wait .1;
            if ( player usebuttonpressed() )
            {
                
                player.score -= level.bullet_type_upgrade_cost_1;
                player playsound( "zmb_cha_ching" );
                player disableWeapons();
                spas moveto( portal.origin, 0.1, 0, 0 );
                gun movez( -180, 1, 0.2, 0.2 );
                wait 1;
                playfx( level.myFx[ 9 ], portal.origin );
                player enableWeapons();
                player notify( "stopBullets" );
                wait 0.1;
                player thread raygun_mark_1bullet(); //monitorWeapon(); //permament bonus perk, only disappears if player gets rid of the weapon
                player thread drawGunInfo();
                wait 0.5;
                gun movez( 180, 1, 0.1, 0.4 );
                spas movez( -1000, 5, 0, 0 );
                wait 5;
            }

        }
    }
}

waittill_price_reduce_mk1()
{
    level endon( "end_game" );
    level waittill( "alter_prices" );
    wait 1;
    level.bullet_type_upgrade_cost_1 = 7500;
    wait 1;
    self setHintString( "^8[ ^9[{+activate}] ^8to upgrade your bullet type to ^2Ala-Hoopin ^8]\n^8Cost: ^9" + level.bullet_type_upgrade_cost_1 );
}
drawGunInfo()
{
    self endon("disconnect");
    level endon("end_game");

    self iPrintLnBold( "^8You've aquired ^2Ala-Hoopin ^8Bullet Upgrade!" );
    wait 3;
    self iPrintLnBold( "^8Buying another set of Bullet Upgrades or going down will make you lose your Bullet Upgrades." );
}
drawGunTextAgain()
{
    self endon ("disconnect");
    level endon("end_game");
    self hide();
}
drawGunTextAgainNEW()
{
    level endon("end_game");
    self endon("disconnect");
    self show();
}
guncheck()
{
    self endon("disconnect");
    level endon("end_game");
    self endon( "player_downed" );
    self endon( "death" );
}