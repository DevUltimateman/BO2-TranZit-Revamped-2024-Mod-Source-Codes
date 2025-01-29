//codename: wamer_days_mq_03_spirit_of_sorrow
//purpose: handles the first real main quest step ( players must follow schruder's light bulb )
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




init()
{
    //level thread do_intro_text();
}
intro_scene()
{
    start_loc = ( -5420.02, 3671.22, 13.7533 );
    end_loc = ( -6513.58, 4896.42, 116.736 );
    end_angles = ( 0, 143.646, 0 );
    start_angles = ( 0, 125, 0 );


    flag_wait( "initial_blackscreen_passed" );
    wait 5;

}
/*

do_intro_text()
{
    flag_wait( "initial_blackscreen_passed" );
    //intro_camera_text = newclienthudelem();

    intro_camera_text.x = 0;
    intro_camera_text.y = -15;//-22.5;
    intro_camera_text.alignx = "center";
    intro_camera_text.aligny = "center";
    intro_camera_text.horzalign = "user_center";
    intro_camera_text.vertalign = "user_center";
    intro_camera_text.alpha = 0;
    intro_camera_text.foreground = true;
    intro_camera_text.hidewheninmenu = true;
    intro_camera_text.fontscale = 2.8;
    intro_camera_text.color = ( 1, 1, 1 );
    intro_camera_text setText( "^3Tranzit ^7Reimagined" );
    

    intro_camera_text_lower = newclienthudelem();

    intro_camera_text_lower.x = 0;
    intro_camera_text_lower.y = 15;//-22.5;
    intro_camera_text_lower.alignx = "center";
    intro_camera_text_lower.aligny = "center";
    intro_camera_text_lower.horzalign = "user_center";
    intro_camera_text_lower.vertalign = "user_center";
    intro_camera_text_lower.alpha = 0;
    intro_camera_text_lower.foreground = true;
    intro_camera_text_lower.hidewheninmenu = true;
    intro_camera_text_lower.fontscale = 2.2;
    intro_camera_text_lower.color = ( 1, 1, 1 );
    intro_camera_text_lower setText( "Warmer Days" );


    wait 1;

    intro_camera_text fadeOverTime( 2.5 );
    intro_camera_text.alpha = 0.8;
    wait 3;
    intro_camera_text_lower fadeovertime( 2.5 );
    intro_camera_text_lower.alpha = 0.8;
    wait 4;
    intro_camera_text fadeOverTime( 2 );
    intro_camera_text_lower fadeovertime( 2  );
    intro_camera_text.color = ( 1, 0.1, 0 );
    intro_camera_text_lower.color = ( 1, 0.1, 0 );
    wait 3.2;
    intro_camera_text_lower fadeovertime( 2.5 );
    intro_camera_text fadeOverTime( 2.5 );
    intro_camera_text_lower.alpha = 0;
    intro_camera_text.alpha = 0;
    wait 6;

    intro_camera_text_lower destroy();
    intro_camera_text destroy();
    //intro_camera_text_lower.color = ( 1, 0.6, 0.2 );
}

*/