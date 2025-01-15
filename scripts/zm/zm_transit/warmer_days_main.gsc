//codename: wamer_days_quest_firenade.gsc
//purpose: handles the basic setups
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

//TODO FIXING
//ACID GAT TO NOT DO THE GRENADE FX <done>
//MAKE THE INITIAL FIRE NADE COUNT OF THROWING AT ZOMBIES SMALLER <done>
//FIX COST OF BULLET UPGRADES AFTER COMPLETING EE <done>
//FIX CUSTOM WEAPON PICK UP NOT PICKIN UP AMMO BUY <done>
//FIX CUSTOM HINTSTRINGS FOR SAFE HOUSE SIDE ENTRANCE PICK UP LOCATION AFTER PICKING UP <done>
//FIX UPGRADED SNIPER BULLETS NOT WORKING WITH MARTYRS EXPLOSIVES <done>
//FIX GRENADE HUD INDICATOR <done>

init()
{
    //units
    how_far_can_i_see = 15000; 

    //cull distance
    
    setCullDist( how_far_can_i_see );

    //disable annoying monkeys
    level.is_player_in_screecher_zone = false;// ::screecher_hooker;
    level.player_out_of_playable_area_monitor = 0;

    //foce non client dvars to be applied
    setdvar( "player_backspeedscale", 1 );
    setdvar( "player_strafespeedscale", 1 );
    setdvar( "player_sprintstrafespeedscale", 1 );
    setdvar( "dtp_post_move_pause", 0 );
    setdvar( "dtp_exhaustion_window", 100 );
    setdvar( "dtp_startup_delay", 50 ); //100
    setDvar( "scr_screecher_ignore_player", 1 );

    //upon connecting
    level thread player_waiter();

    //ghetto screechers off
    flag_wait( "initial_blackscreen_passed" );
    //level thread scripts\zm\zm_transit\warmer_days_sq_rewards::print_text_middle( "^6PHD Flopper ^8Reward Unlocked", "^8" + "Players can now take explosive damage", "^8" + "without losing any health health.", 6, 0.25 );
    level thread make_trees_hide_some();
    level thread make_smoke_hide_some();

    //debug why upgraded sniper not getting name set properly
    //level.players[ 0 ] thread print_weapon_name();
    //level.players[ 0 ].score += 999999;
}

print_weapon_name()
{
    level endon( "end_game" );
    self endon( "disconnect" );
    while( true )
    {
        iprintln( self getCurrentWeapon() );
        gi = self getWeaponsListPrimaries();
        iprintln( gi[ 1 ] );
        wait 1;
    }
}

player_waiter()
{
    level endon( "end_game" );
    while( true )
    {
        level waittill( "connected", newguy );
        newguy thread tranzit_2024_visuals();
    }
}

screecher_hooker()
{
    level endon( "end_game" );
    
        return 0;
    
    
}

print_origin_angles( /* who, loop_time */ )
{
    level endon( "end_game" );
    while( true )
    {
        iprintln( "Origin of: ^3" + level.players[ 0 ] + " ^7is: " + level.players[ 0 ].origin );
        //if( getdvar( "developer_script" ) == 1 || true )
        //{
         //   iprintln( "Angles of: ^2" + who + " ^7is: " + who.angles );
        //}
        wait 1;
    }
}
dev_visuals()
{
    self endon( "disconnect" );
    level endon( "end_game" );

    self waittill( "spawned_player" );
    self setclientdvar( "r_lighttweaksuncolor", "0.62 0.52 0.46" );
    self setclientdvar( "r_lighttweaksunlight", 12  );
    self setclientdvar( "r_filmusetweaks", true );
    self setclientdvar( "r_lighttweaksundirection",( -45, 210, 0 ) );
    self setclientdvar( "r_bloomtweaks", 1  );
    self setclientdvar( "cg_usecolorcontrol", 1 );
    self setclientdvar( "cg_colorscale", "1 1 1"  );
    self setclientdvar( "sm_sunsamplesizenear", 1.4  );
    self setclientdvar( "wind_global_vector", ( 200, 250, 50 )  );
    self setclientdvar( "r_fog", 0  );
    self setclientdvar( "r_lodbiasrigid", -1000  );
    self setclientdvar( "r_lodbiasskinned", -1000 );
    self setclientdvar( "cg_fov_default", 80 );
    self setclientdvar( "cg_fov", 80 );
    self setclientdvar( "vc_fsm", "1 1 1 1" );
    //self setclientdvar( "",  );

}

tranzit_2024_visuals()
{
    self setclientdvar( "r_filmusetweaks", true );
    self setclientdvar( "r_bloomtweaks", 1  );
    self setclientdvar( "cg_usecolorcontrol", 1 );
    self setclientdvar( "r_fog", 0  );
    self setclientdvar( "sm_sunsamplesizenear", 1.4  );
    self setclientdvar( "wind_global_vector", ( 200, 250, 50 )  );
    self setclientdvar( "vc_fsm", "1 1 1 1" );    
    self setclientdvar( "cg_colorscale", "1 1 1"  );
    self setclientdvar( "r_lodbiasrigid", -1000  );
    self setclientdvar( "r_lodbiasskinned", -1000 );
    self setclientdvar( "r_dof_bias", 0.5 );
    self setclientdvar( "r_dof_enable", true );
    self setclientdvar( "r_dof_tweak", true  );
    self setclientdvar( "r_dof_viewmodelStart", 2 );
    self setclientdvar( "r_dof_viewmodelend", 2.4 );
    self setclientdvar( "r_dof_farblur", 1.25 );
    self setclientdvar(  "r_dof_farStart", 3000 );
    self setclientdvar(  "r_dof_farend", 7000 );
    self setclientdvar(  "r_dof_nearstart", 10 );
    self setclientdvar(  "r_dof_nearend", 15 );
    self setclientdvar(  "r_sky_intensity_factor0", 2.4 );
    self setclientdvar(  "r_sky_intensity_factor1", 2.4 );
    self setclientdvar(  "r_skyColorTemp", 2000 );
    self setclientdvar(  "r_skyRotation", 125 );
    self setclientdvar(  "r_skyTransition", true );
    self setclientdvar( "cg_drawcrosshair", 0 );
    self setclientdvar( "cg_cursorhints", 2 );
    self setclientdvar( "vc_yl", "0 0 0 0" );
    self setclientdvar( "vc_yh", "0 0 0 0" );
    self setclientdvar( "cg_fov", 85 );
    self setclientdvar( "cg_fovscale", 1.15 );
    self setclientdvar( "r_lighttweaksunlight", 12 );
    self setclientdvar( "r_lighttweaksuncolor", ( 0.62, 0.52, 0.46) );
    self setclientdvar( "r_lighttweaksundirection", ( -155, 63, 0 ) );

    self setclientdvar( "vc_rgbh", "0.3 0.2 0.2 0" );
   self setclientdvar( "vc_rgbl", "0.1 0.05 0.05 0" );
}



make_trees_hide_some()
{
    locs = [];

    //din
    locs[ locs.size ] = ( -7901.59, -7559.07, 83.4541 );
    locs[ locs.size ] = ( -7722.85, -7735.9, 53.2281 );
    locs[ locs.size ] = ( 7484.35, -7725.78, 62.0928 );
    locs[ locs.size ] = ( -7594.29, -8049.54, 30.4262 );
    locs[ locs.size ] = ( -7183.91, -7619.72, 31.9997 );
    locs[ locs.size ] = ( -8362.86, -7468.88, 113.468 );

    //farm
    locs[ locs.size ] = ( 7540, -6203.95, 42.5817 );
    locs[ locs.size ] = ( 7472.84, -6114.09, 8.45713 );
    locs[ locs.size ] = ( 7306.34, -6185.79, -95.6539 );
    locs[ locs.size ] = ( 7547.45, -5873.21, -73.8581 );
    locs[ locs.size ] = ( 7512.56, -5919.39, 23.8992 );
    locs[ locs.size ] = ( 7710.79, -5821.44, -15.7865 ); //also spawn collision with this 1
    locs[ locs.size ] = ( 6948.67, -5530.28, -133.472 );
    //locs[  ] = (  );

    for( s = 0; s < locs.size; s++ )
    {
        spawning = spawn( "script_model", locs[ s ] );
        spawning setmodel( "t5_foliage_tree_burnt03" );
        spawning.angles = ( 0, randomint( 360 ), 0 );
        wait 0.1;
    }

    oo = spawn( "script_model", locs[ 10 ] );
    oo setmodel( "collision_player_128x128x128" );
    oo.angles = ( 0, 0, 0 );

}


make_smoke_hide_some()
{
    smokes = [];
    smokes[  smokes.size ] =  ( 9227.48, 1874.04, 417.567 );
    smokes[ smokes.size  ] =  ( 9197.59, 2514.9, 334.256 );
    smokes[ smokes.size  ] =  ( 9506.4, 4711.39, -451.493 );
    smokes[ smokes.size ] =  ( 6646.28, 868.357, 417.024 );
    smokes[  smokes.size ] =  ( 7317.45, 1251.19, 366.293 );
    smokes[  smokes.size ] =  ( 7182.14, 2337.19, 317.971 );
    smokes[  smokes.size ] =  ( 7072.38, -1945.53, -174.008 );
    smokes[ smokes.size  ] =  ( -5496.9, -4646.62, 27.227 );
    smokes[  smokes.size ] =  ( -9112.71, -7551.7, 379.639 );
    smokes[  smokes.size ] =  ( -8626.08, 6244.98, -83.4548 );


    for( a = 0; a < smokes.size; a++ )
    {
        playfx( level._effects[28], smokes[ a ] + ( 0, 0, 180 )  );
        wait 0.25;
    }


}