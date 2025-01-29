//handles shader drawing when players complete stuff
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
    //level thread debug_shaderdrawing();

    precacheshader( "waypoint_revive_zm" ); //blue circle around quick revie
    precacheshader( "zombies_rank_1" ); //1st main quest start alert
    precacheshader( "zombies_rank_2" ); //2nd main quest start alert
    precacheshader( "zombies_rank_3" ); //3rd main quest start alert
    precacheshader( "zombies_rank_3_ded" ); //4th main quest start alert
    precacheshader( "zombies_rank_4" ); //5th main quest start alert
    precacheshader( "zombies_rank_4_ded" ); //s6th main quest start alert
    precacheshader( "zombies_rank_5" ); //7th main quest start alert
    precacheshader( "zombies_rank_5_ded" ); //8th main quest start alert

    precacheshader( "menu_mp_contract_expired" ); //red triangle, poisonous clouds alert
    precacheshader( "menu_mp_killstreak_select" ); //poisonous clouds are gone check ok
    precacheshader( "menu_mp_party_ease_icon" ); //base needs repairing?
    precacheshader( "menu_mp_weapons_srm" );
    precacheshader( "menu_mp_weapons_870mcs" );
    precacheshader( "menu_mp_weapons_1911" );
    precacheshader( "menu_mp_weapons_ak74u" );
    precacheshader( "menu_mp_weapons_baretta93r" );
    precacheshader( "menu_mp_weapons_dsr1" );
    precacheshader( "menu_mp_weapons_fal" );
    precacheshader( "menu_mp_weapons_five_seven" );
    precacheshader( "menu_mp_weapons_galil" );
    precacheshader( "menu_mp_weapons_hamr" );
    precacheshader( "menu_mp_weapons_hk416" );
    precacheshader( "menu_mp_weapons_judge" );
    precacheshader( "menu_mp_weapons_kard" );
    precacheshader( "menu_mp_weapons_m16" );
    precacheshader( "menu_mp_weapons_m82a" );
    precacheshader( "menu_mp_weapons_mp5" );
    precacheshader( "menu_mp_weapons_olympia" );
    precacheshader( "menu_mp_weapons_qcw" );
    precacheshader( "menu_mp_weapons_rpd" );
    precacheshader( "menu_mp_weapons_rpg" );
    precacheshader( "menu_mp_weapons_saiga12" );
    precacheshader( "menu_mp_weapons_saritch" );
    precacheshader( "menu_mp_weapons_tar21" );
    precacheshader( "menu_mp_weapons_type95" );
    precacheshader( "menu_mp_weapons_xm8" );


    precacheshader( "team_icon_cia" ); //when players unlock sidequests
    precacheshader( "menu_mp_star_rating" ); //sidequest start = white, on going = orange, finished = green. Can be altered.

    precacheshader( "hud_ballistic_knife" );
    precacheshader( "mtl_t6_attach_tritium_red_glo" ); //raygun?
    precacheshader( "menu_mp_star_rating" );
    precacheshader( "menu_mp_star_rating" );
    precacheshader( "menu_mp_star_rating" );
    precacheshader( "menu_mp_star_rating" );

}


test_updater()
{
    //self.mq_opening_hud_underline thread update_shader_size_based_on_step( "white", self.mq_opening_hud_underline.height, self.mq_opening_hud_underline.width, self.mq_opening_hud_underline.x, self.mq_opening_hud_underline.y, 2, ( 1, 1 , 1), ( .7, 0, 0 ), 1  );
    //self.mq_opening_hud_step_icon_left thread update_shader_size_based_on_step( "zombies_rank_5_ded", self.mq_opening_hud_step_icon_left.height, self.mq_opening_hud_step_icon_left.width, self.mq_opening_hud_step_icon_left.x, self.mq_opening_hud_step_icon_left.y, 2, ( 1, 1 , 1), ( .7, 0, 0 ), 1 );
    //self.mq_opening_hud_step_icon_right thread update_shader_size_based_on_step( "zombies_rank_5_ded", self.mq_opening_hud_step_icon_right.height, self.mq_opening_hud_step_icon_right.width, self.mq_opening_hud_step_icon_right.x, self.mq_opening_hud_step_icon_right.y, 2, ( 1, 1 , 1), ( .7, 0, 0 ), 1  );
    //self.mq_opening_hud_text thread update_text_size_based_on_step( "Spirit Of Sorrow", 1.8, self.mq_opening_hud_text.x, self.mq_opening_hud_text.y, 2, ( 1, .7 , 0.2 ), ( .7, 0, 0 ), 0.8 );
}
update_shader_size_based_on_step( shader, height, width, x_pos, y_pos, fadetime, initial_color, colorfade, alpha )
{
    self setshader( shader );
    self.height = height;
    self.width = width;
    self.x = x_pos;
    self.y = y_pos;
    self.alpha = 0;
    self.color = initial_color;
    self fadeOverTime ( 2 );
    self.alpha = 1;
    wait 5;
    self fadeovertime( 2 );
    self.color = colorfade;
    wait 5;
    self fadeovertime( 2 );
    self.color = ( .1, .1, .1 );
    self.alpha = 0;
}

update_text_size_based_on_step( shader, fontscale, x_pos, y_pos, fadetime, initial_color, colorfade, alpha )
{
    self.text = shader;
    self.fontscale = fontscale;
    self.x = x_pos;
    self.y = y_pos;
    self.alpha = 0;
    self.color = initial_color;
    self fadeOverTime ( 2 );
    self.alpha = 0.8;
    wait 2;
    self fadeovertime( 2 );
    self.fontscale = fontscale;
    self.color = colorfade;
    wait 5;
    self fadeovertime( 2 );
    self.color = ( .1, .1, .1 );
    self.alpha = 0;
}

update_hud_elems_to_correct_top_place()
{
    //self.mq_opening_hud_underline.x =  self.mq_opening_hud_underline.x - 100;
    self.mq_opening_hud_underline.y = self.mq_opening_hud_underline.y - 200;

    //self.mq_opening_hud_step_icon_right.x =  self.mq_opening_hud_step_icon_right.x - 100;
    self.mq_opening_hud_step_icon_right.y = self.mq_opening_hud_step_icon_right.y - 200;

    //self.mq_opening_hud_step_icon_left.x =  self.mq_opening_hud_step_icon_left.x - 100;
    self.mq_opening_hud_step_icon_left.y = self.mq_opening_hud_step_icon_left.y - 200;

    //self.mq_opening_hud_text.x = self.mq_opening_hud_text.x - 100;
    self.mq_opening_hud_text.y = self.mq_opening_hud_text.y - 200;
    
}
construct_main_quest_shader_logic()
{
    
    //self.mq_opening_hud_underline = newclienthudelem( self );
    //self.mq_opening_hud_step_icon_right = newclienthudelem( self );
   // self.mq_opening_hud_step_icon_left = newclienthudelem( self );
   // self.mq_opening_hud_text = newClientHudElem( self );

    self.mq_opening_hud_text.x = 0;
    self.mq_opening_hud_text.y = -22.5;
    self.mq_opening_hud_text.alignx = "center";
    self.mq_opening_hud_text.aligny = "center";
    self.mq_opening_hud_text.horzalign = "user_center";
    self.mq_opening_hud_text.vertalign = "user_center";
    self.mq_opening_hud_text.alpha = 0;
    self.mq_opening_hud_text.foreground = true;
    self.mq_opening_hud_text.hidewheninmenu = true;
    self.mq_opening_hud_text.fontscale = 2;
    self.mq_opening_hud_text setText( "Meeting the Mr. Schruder" );
    self.mq_opening_hud_text.color = ( 1, 0.6, 0.2 );




    self.mq_opening_hud_underline.x = 30;
    self.mq_opening_hud_underline.y = 0;
    self.mq_opening_hud_underline.alignx = "center";
    self.mq_opening_hud_underline.aligny = "center";
    self.mq_opening_hud_underline.horzalign = "user_center";
    self.mq_opening_hud_underline.vertalign = "user_center";
    self.mq_opening_hud_underline.alpha = 0;
    self.mq_opening_hud_underline.foreground = true;
    self.mq_opening_hud_underline.hidewheninmenu = true;
    self.mq_opening_hud_underline_ht = 2;
    self.mq_opening_hud_underline_wt = 200;
    self.mq_opening_hud_underline setshader( "white",  self.mq_opening_hud_underline_wt, self.mq_opening_hud_underline_ht );
    self.mq_opening_hud_underline.color = ( 1, 1, 1 );
    self.mq_opening_hud_underline.foreground = ( 1, 1, 1 );
    self.mq_opening_hud_underline.background = ( 1, 1, 1 );



    self.mq_opening_hud_step_icon_right.x = 80;
    self.mq_opening_hud_step_icon_right.y = -22.5;
    self.mq_opening_hud_step_icon_right.alignx = "center";
    self.mq_opening_hud_step_icon_right.aligny = "center";
    self.mq_opening_hud_step_icon_right.horzalign = "user_center";
    self.mq_opening_hud_step_icon_right.vertalign = "user_center";
    self.mq_opening_hud_step_icon_right.alpha = 0;
    self.mq_opening_hud_step_icon_right.foreground = true;
    self.mq_opening_hud_step_icon_right.hidewheninmenu = true;
    self.mq_opening_hud_step_icon_right_ht = 15;
    self.mq_opening_hud_step_icon_right_wt = 15;
    self.mq_opening_hud_step_icon_right setshader( "zombies_rank_1", self.mq_opening_hud_step_icon_right_ht, self.mq_opening_hud_step_icon_right_wt );



    self.mq_opening_hud_step_icon_left.x = -80;
    self.mq_opening_hud_step_icon_left.y = -22.5;
    self.mq_opening_hud_step_icon_left.alignx = "center";
    self.mq_opening_hud_step_icon_left.aligny = "center";
    self.mq_opening_hud_step_icon_left.horzalign = "user_center";
    self.mq_opening_hud_step_icon_left.vertalign = "user_center";
    self.mq_opening_hud_step_icon_left.alpha = 0;
    self.mq_opening_hud_step_icon_left.foreground = true;
    self.mq_opening_hud_step_icon_left.hidewheninmenu = true;
    self.mq_opening_hud_step_icon_left_ht = 15;
    self.mq_opening_hud_step_icon_left_wt = 15;
    self.mq_opening_hud_step_icon_left setshader( "zombies_rank_1", self.mq_opening_hud_step_icon_left_ht, self.mq_opening_hud_step_icon_left_wt );



    update_hud_elems_to_correct_top_place();

}


debug_shaderdrawing()
{
    level endon( "end_game" );
    flag_wait("initial_blackscreen_passed");
    wait 2;
    for( i = 0; i < level.players.size; i++ )
    {
        //level.players[ i ] thread construct_main_quest_shader_logic();
        //update_hud_elems_to_correct_top_place();
    }

    wait 5;
    for( s = 0; s < level.players.size; s++ )
    {
        //level.players[ s ] thread test_updater();
    }
    
}

debug_f_shader_style()
{
    shaderdw = newClientHudElem( self );
    shaderdw.x = 0;
    shaderdw.y = 0;

    shaderdw.alignx = "center";
    shaderdw.aligny = "center";

    shaderdw.horzalign = "user_center";
    shaderdw.vertalign = "user_center";

    shaderdw.alpha = 0;
    shaderdw.foreground = true;
    shaderdw.hidewheninmenu = true;

    shaderdw_ht = 50;
    shaderdw_wt = 50;

    shaderdw.color = ( 0, 1, 0 );
    shaderdw setshader( "mtl_t6_attach_tritium_red_glo", shaderdw_ht, shaderdw_wt );
    shaderdw.color = ( 0, 1, 0 );
    shaderdw.foreground = ( 0, 1, 0 );
    shaderdw.background = ( 0, 1, 0 );
    shaderdw fadeOverTime( 2 );
    shaderdw.alpha = 1;
}