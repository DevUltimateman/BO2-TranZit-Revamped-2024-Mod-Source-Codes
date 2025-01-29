//this script is responsible for the tranzit 2.0 v2 player's personal challenges
//few challenges that player can complete during a game
//adds some small benefits.

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
    //global variables for challenges
    level.challenge_kills = 750; //give 3 weapon limit without mule?
    level.challenge_heads = 115; //give dead shot daiguiri upgrades?
    level.challenge_downs = 2; //give player 3 hit system until game ends?
    level.challenge_revives = 5; //give player super revive ( coop only )?
    level.challenge_grenades = 10; //give player something offhand?
    level.challenge_melee_kills_1 = 25; //give player galvas?
    level.challenge_melee_kills_2 = 50; //give player infinite dmg galvas?
    level.challenge_total_shots = 10000; //give player double sized clips for all weapons?

    //move these into afunction that alters these
    level.zombie_vars["zombie_powerup_insta_kill_time"] = 45; //30
    level.zombie_vars["zombie_powerup_fire_sale_time"] = 60; //30
    level.zombie_vars["zombie_powerup_point_doubler_time"] = 60; //30
    /*
    set_zombie_var( "zombie_insta_kill", 0, undefined, undefined, 1 );
    set_zombie_var( "zombie_point_scalar", 1, undefined, undefined, 1 );
    set_zombie_var( "zombie_drop_item", 0 );
    set_zombie_var( "zombie_timer_offset", 350 );
    set_zombie_var( "zombie_timer_offset_interval", 30 );
    set_zombie_var( "zombie_powerup_fire_sale_on", 0 );
    set_zombie_var( "zombie_powerup_fire_sale_time", 30 );
    set_zombie_var( "zombie_powerup_bonfire_sale_on", 0 );
    set_zombie_var( "zombie_powerup_bonfire_sale_time", 30 );
    set_zombie_var( "zombie_powerup_insta_kill_on", 0, undefined, undefined, 1 );
    set_zombie_var( "zombie_powerup_insta_kill_time", 30, undefined, undefined, 1 );
    set_zombie_var( "zombie_powerup_point_doubler_on", 0, undefined, undefined, 1 );
    set_zombie_var( "zombie_powerup_point_doubler_time", 30, undefined, undefined, 1 );
    set_zombie_var( "zombie_powerup_drop_increment", 2000 );
    set_zombie_var( "zombie_powerup_drop_max_per_round", 4 );
    */
    //good modifiers
    //player_sustainammo
    //player_sprintunlimited
    //player_sprinttime
    //player_lean_rotate 2.25 2.25
    //player_lean_rotate_crouch 3 3
    //player_view_pitch_up 90
    //player_view_pitch_down 90

    level thread apply_challenges_to_players();
}

apply_challenges_to_players()
{
    level endon( "end_game" );
    while( true )
    {
        level waittill( "connected", challenger );
        challenger thread initial_spawn_reset();
    }
}

initial_spawn_reset()
{
    level endon( "end_game" );
    self endon( "disconnect" );

    self waittill( "spawned_player" );
    wait 1;
    //reset these and track these for challenges
    self.kills = 0; //goal 750
    self.headshots = 0; //goal 115
    self.downs = 0; //"goal" 2
    self.grenade_kills = 0;  //goal 10
    self.melee_kills = 0; //goal 50
    self.revives = 0; //goal 5


}