//spirit of sorrow has gone rogue
//a dangeroud poisonous gas is about to roll over to tranzit
//it happens randomly after the first lockdown step
//takes away parts of the map, players must fight inside of safe locations
//till cloud moves and they're able to travel to pick up the suitcase from depo ( step 8 )
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
init()
{
    level thread main_quest_spawn_poisonous_clouds();
    level.arrived_at_base = 0;
    level.moving_to_depo_active = false;
    all_static_poisonous_cloud_locations();
    flag_wait( "initial_blackscreen_passed" );
    //level.subtitle_upper_text = newhudelem(); why the fuck were these taking hud elems here
    //level.subtitle_lower_text = newhudelem();
    //&&/level thread level_cleaner_map_restart(); why the fuck were these taking hud elems here
    //level thread level_cleaner();
    //level thread which_zone_im_in();
    //&&level thread do_it();
}




all_static_poisonous_cloud_locations()
{
     //static on ground locations
    
    level.poisonous_ground_clouds_origins_bdepo = [];
    level.poisonous_ground_clouds_origins_diner = [];
    level.poisonous_ground_clouds_origins_farm = [];
    level.poisonous_ground_clouds_origins_nacht = [];
    level.poisonous_ground_clouds_origins_pstation = [];
    level.poisonous_ground_clouds_origins_cabin = [];
    level.poisonous_ground_clouds_origins_town = [];

    //bus depo
    level.poisonous_ground_clouds_origins_bdepo[ 0 ] = ( -7089.9, 5667.11, -55.875 );
    level.poisonous_ground_clouds_origins_bdepo[ 1 ] = ( -6415.56, 5842.55, -63.875 );
    level.poisonous_ground_clouds_origins_bdepo[ 2 ] = ( -6868.01, 5977.88, -63.875 );
    level.poisonous_ground_clouds_origins_bdepo[ 3 ] = ( -6674.34, 4791.37, -96.875 );
    level.poisonous_ground_clouds_origins_bdepo[ 4 ] = ( -6908.3, 4682.78, -63.875 );
    level.poisonous_ground_clouds_origins_bdepo[ 5 ] = ( -7254.68, 4752.93, -63.875 );
    level.poisonous_ground_clouds_origins_bdepo[ 6 ] = ( -7660.03, 4759.16, -63.875 );
    level.poisonous_ground_clouds_origins_bdepo[ 7 ] = ( -7879.51, 5114.63, -56.456 );

    //diner
    level.poisonous_ground_clouds_origins_diner[ 0 ] = ( -6226.39, -7086.49, -58.8739 );
    level.poisonous_ground_clouds_origins_diner[ 1 ] = ( -5996.65, -6496.94, -39.9383 );
    level.poisonous_ground_clouds_origins_diner[ 2 ] = ( -5656.27, -7160.28, -57.612 );
    level.poisonous_ground_clouds_origins_diner[ 3 ] = ( 5406.73, -7324.39, -63.4695 );
    level.poisonous_ground_clouds_origins_diner[ 4 ] = ( 5194.08, -7572.45, -64.2631 );
    level.poisonous_ground_clouds_origins_diner[ 5 ] = ( -4994.97, -7244, -65.4321 );
    level.poisonous_ground_clouds_origins_diner[ 6 ] = ( -4603.43, -7238.84, -70.1158 );
    level.poisonous_ground_clouds_origins_diner[ 7 ] = ( -4222.44, -7154.12, -72.63 );
    level.poisonous_ground_clouds_origins_diner[ 8 ] = ( -4295.87, -6711.73, -59.7593 );
    level.poisonous_ground_clouds_origins_diner[ 9 ] = ( -6679.3, -7200.85, -62.1788 );
    level.poisonous_ground_clouds_origins_diner[ 10 ] = ( -6834.25, -7583.63, -16.2207 );
    level.poisonous_ground_clouds_origins_diner[ 11 ] = ( -6813.09, -8072.81, 11.2974 );
    level.poisonous_ground_clouds_origins_diner[ 12 ] = ( -6518.13, -8338.17, 31.115 );
    level.poisonous_ground_clouds_origins_diner[ 13 ] = ( -6024.1, -8460.41, 44.0628 );
    level.poisonous_ground_clouds_origins_diner[ 14 ] = ( -5303.89, -8259.04, -13.0317 );
    level.poisonous_ground_clouds_origins_diner[ 15 ] = ( -6247.56, -7976.76, 397.993 );

    //farm
    level.poisonous_ground_clouds_origins_farm[ 0 ] = ( 8158.57, -5673.46, 61.2136 );
    level.poisonous_ground_clouds_origins_farm[ 1 ] = ( 7641.13, -5331.63, 53.9495 );
    level.poisonous_ground_clouds_origins_farm[ 2 ] = ( 7669.42, -4889.88, 52.4578 );
    level.poisonous_ground_clouds_origins_farm[ 3 ] = ( 8091.22, -4378.11, 88.3123 );
    level.poisonous_ground_clouds_origins_farm[ 4 ] = ( 8757.3, -5724.92, 85.668 );
    level.poisonous_ground_clouds_origins_farm[ 5 ] = ( 8765.85, -5279.89, 82.935 );
    level.poisonous_ground_clouds_origins_farm[ 6 ] = ( 8207.93, -5666, 414.44 );
    level.poisonous_ground_clouds_origins_farm[ 7 ] = ( 8527.92, -6570.13, 127.204 );
    level.poisonous_ground_clouds_origins_farm[ 8 ] = ( 8194.85, -6081.46, 193.996 );
    level.poisonous_ground_clouds_origins_farm[ 9 ] = ( 7689.66, -6125.58, 122.756 );
    level.poisonous_ground_clouds_origins_farm[ 10 ] = ( 7638.48, -6592.56, 118.264 );
    level.poisonous_ground_clouds_origins_farm[ 11 ] = ( 8449.41, -5663.72, 278.597 );
    level.poisonous_ground_clouds_origins_farm[ 12 ] = ( 7724.64, -5675.27, -0.555619 );
    
    
    //nacht
    level.poisonous_ground_clouds_origins_nacht[ 0 ] = ( 13352.6, -272.497, -196.734 );
    level.poisonous_ground_clouds_origins_nacht[ 1 ] = ( 13382.6, -969.547, -202.921 );
    level.poisonous_ground_clouds_origins_nacht[ 2 ] = ( 13392.9, -733.548, -44.1839 );
    level.poisonous_ground_clouds_origins_nacht[ 3 ] = ( 13412.9, -359.184, 32.4899 );
    level.poisonous_ground_clouds_origins_nacht[ 4 ] = ( 14082.6, -1021.3, -200.481 );
    level.poisonous_ground_clouds_origins_nacht[ 5 ] = ( -13974.2, -1880.33, -172.19 );
    level.poisonous_ground_clouds_origins_nacht[ 6 ] = ( 13311.3, -1559.72, -196.563 );
    level.poisonous_ground_clouds_origins_nacht[ 7 ] = ( 13439.5, -1870.77, -212.842 );
    level.poisonous_ground_clouds_origins_nacht[ 8 ] = ( 13871.5, -397.188, 254.771 );
    level.poisonous_ground_clouds_origins_nacht[ 9 ] = ( 13871.5, -1070.65, 254.771 );
    level.poisonous_ground_clouds_origins_nacht[ 10 ] = ( 13871.5, -1604.99, 254.771 );

    //pstation
    level.poisonous_ground_clouds_origins_pstation[ 0 ] = ( 10989.9, 7577.98, -588.773 );
    level.poisonous_ground_clouds_origins_pstation[ 1 ] = ( 10604.9, 7990.76, -378.884 );
    level.poisonous_ground_clouds_origins_pstation[ 2 ] = ( 10329.4, 8380.03, -309.72 );
    level.poisonous_ground_clouds_origins_pstation[ 3 ] = ( 10415.4, 8757.06, -313.163 );
    level.poisonous_ground_clouds_origins_pstation[ 4 ] = ( 10318.3, 9338.97, -88.3911 );
    level.poisonous_ground_clouds_origins_pstation[ 5 ] = ( 11305.2, 7940.11, -286.36 );
    level.poisonous_ground_clouds_origins_pstation[ 6 ] = ( 10891, 7943.59, -289.274 );
    level.poisonous_ground_clouds_origins_pstation[ 7 ] = ( 11673.5, 8675.17, -264.228 );
    level.poisonous_ground_clouds_origins_pstation[ 8 ] = ( 10578.2, 8162.52, -211.473 );

    //cabin forest
    level.poisonous_ground_clouds_origins_cabin[ 0 ] = ( 4934.5, 6452.64, -63.875 );
    level.poisonous_ground_clouds_origins_cabin[ 1 ] = ( 5187.79, 6374.36, -62.8991 );
    level.poisonous_ground_clouds_origins_cabin[ 2 ] = ( 5483.89, 6438.58, -68.386 );
    level.poisonous_ground_clouds_origins_cabin[ 3 ] = ( 4894.43, 7224.95, -63.875 );
    level.poisonous_ground_clouds_origins_cabin[ 4 ] = ( 5224.82, 7315.59, -52.9199 );
    level.poisonous_ground_clouds_origins_cabin[ 5 ] = ( 5577.3, 7341.18, -66.8493 );
    level.poisonous_ground_clouds_origins_cabin[ 6 ] = ( 5242.88, 6895.58, 358.961 );


    //town
    level.poisonous_ground_clouds_origins_town[ 0 ] = ( 1647.16, 142.128, -58.6656 );
    level.poisonous_ground_clouds_origins_town[ 1 ] = ( 1290.08, 529.635, -57.2023 );
    level.poisonous_ground_clouds_origins_town[ 2 ] = ( 1302.1, 147.255, -69.875 );
    level.poisonous_ground_clouds_origins_town[ 3 ] = ( 1170.21, -266.964, -57.4518 );
    level.poisonous_ground_clouds_origins_town[ 4 ] = ( 761.861, -341.17, -61.875 );
    level.poisonous_ground_clouds_origins_town[ 5 ] = ( 356.509, -300.036, -62.3585 );
    level.poisonous_ground_clouds_origins_town[ 6 ] = ( 845.616, -592.174, 21.3944 );
    level.poisonous_ground_clouds_origins_town[ 7 ] = ( 1202.26, -617.853, 19.8909 );
    level.poisonous_ground_clouds_origins_town[ 8 ] = ( 1357.97, -963.504, 89.5568 );
    level.poisonous_ground_clouds_origins_town[ 9 ] = ( 1190.29, -1330.15, 50.4468 );
    level.poisonous_ground_clouds_origins_town[ 10 ] = ( 419.842, -1176.27, 199.291 );
    level.poisonous_ground_clouds_origins_town[ 11 ] = ( 901.179, -1607.77, 442.394 );
    level.poisonous_ground_clouds_origins_town[ 12 ] = ( 1682.33, -211.595, -55.8959 );
    level.poisonous_ground_clouds_origins_town[ 13 ] = ( 1916.23, -324.88, -60.9326 );
    level.poisonous_ground_clouds_origins_town[ 14 ] = ( 2236.67, -357.057, -61.875 );
    level.poisonous_ground_clouds_origins_town[ 15 ] = ( 2543.37, -283.283, -61.8476 );
    level.poisonous_ground_clouds_origins_town[ 16 ] = ( 1817.16, 868.387, -57.4196 );
    level.poisonous_ground_clouds_origins_town[ 17 ] = ( 236.077, 587.612, -17.8841 );
}

spawn_static_clouds_on_demand_at( location_array, waiter )
{
    level endon( "end_game" );
    if( isdefined( waiter ) && waiter == 1 )
    {
        wait 35;
    }
    on_demand_cloud = [];
    for( s = 0; s < location_array.size; s++ )
    {
        on_demand_cloud[ s ] = spawn( "script_model", location_array[ s ] );
        on_demand_cloud[ s ] setmodel( "tag_origin" );
        on_demand_cloud[ s ].angles = on_demand_cloud[ s ].angles;
        wait 0.05;
        playfxontag( level._effects[ 47 ], on_demand_cloud[ s ], "tag_origin" );
        wait 0.05;
    }
    level waittill( "clean_on_demand_clouds" );
    foreach( s_cloud in on_demand_cloud )
    {
        s_cloud thread fuck_off();

    }
    wait 2;
    for( i = 0; i < level.mq_step_poison_cloud_ent.size; i++ )
    {
        level.mq_step_poison_cloud_ent[ i ] movez( -1200, 3, 1, 0 );
        wait 0.1;
    }
    wait 5;
    foreach( s in level.mq_step_poison_cloud_ent )
    {
        if( isdefined( s ) )
        {
            s delete();
        }
    }
}

fuck_off()
{
    self moveto( self.origin + ( 1900, 2000, 5000 ), 20, 5, 0 );
    self waittill( "movedone" );
    self delete();
}
main_quest_spawn_poisonous_clouds()
{
    level endon( "end_game" );
    //notify players that something is coming. 
    //tell them to go farms farm house
    //if they havent discovered already, this is the main base. 
    //wait here till poisonous clouds arrive. 
    //wait till the poisonous clouud moves to farm - power - town area
    //tell players to pick up a suitcase from depo
    //then they must pick it up and place it infront of each bottle machine till bottle flies into the suitcase
    //they pick it up till all perks collected
    //they then drink the perk bottle to become immune to gas
    
    //level notify( "poisonous_adventure_find_case" ); //
    //level thread applyforplayer();
    //&&initial_poisonous_spawns();
    //if( level.dev_time ){ iprintlnbold( "HACKING TO CLOUD STEP TO SEE WHATS UP" ); }
    level waittill( "lockdown_disabled"); 
    wait 5; //25
    level.moving_to_depo_active = true;
    level thread move_poisonous_clouds_main_quest();
}

applyforplayer()
{
    level endon( "end_game" );
    while( true )
    {
        level waittill( "connected", shit );
        shit thread testingg();
    }
}

initial_poisonous_spawns()
{
    level endon( "end_game" );
    level.mq_step_poison_clouds_origin_spawn = [];
    level.mq_step_poison_cloud_ent = [];
    //mid level
    level.mq_step_poison_clouds_origin_spawn[ 0 ] = ( 11923.9, 3045.88, 767.864 );
    level.mq_step_poison_clouds_origin_spawn[ 1 ] = ( 10933.6, 2944.17, 764.31 );
    level.mq_step_poison_clouds_origin_spawn[ 2 ] = ( 9972.08, 2870.48, 762.216 );
    level.mq_step_poison_clouds_origin_spawn[ 3 ] = ( 9143.72, 2806.99, 760.411 );
    level.mq_step_poison_clouds_origin_spawn[ 4 ] = ( 8650.66, 2769.19, 759.337 );
    level.mq_step_poison_clouds_origin_spawn[ 5 ] = ( 8039.25, 2722.33, 758.005 );

    //BOTTOM
    level.mq_step_poison_clouds_origin_spawn[ 6 ] = ( 11923.9, 3045.88, 200.864 );
    level.mq_step_poison_clouds_origin_spawn[ 7 ] = ( 10933.6, 2944.17, 264.31 );
    level.mq_step_poison_clouds_origin_spawn[ 8 ] = ( 9972.08, 2870.48, 262.216 );
    level.mq_step_poison_clouds_origin_spawn[ 9 ] = ( 9143.72, 2806.99, 260.411 );
    level.mq_step_poison_clouds_origin_spawn[ 10 ] = ( 8650.66, 2769.19, 259.337 );
    level.mq_step_poison_clouds_origin_spawn[ 11 ] = ( 8039.25, 2722.33, 258.005 );


    //TOP
    level.mq_step_poison_clouds_origin_spawn[ 12 ] = ( 11923.9, 3045.88, 1200.864 );
    level.mq_step_poison_clouds_origin_spawn[ 13 ] = ( 10933.6, 2944.17, 1164.31 );
    level.mq_step_poison_clouds_origin_spawn[ 14 ] = ( 9972.08, 2870.48, 1262.216 );
    level.mq_step_poison_clouds_origin_spawn[ 15 ] = ( 9143.72, 2806.99, 1260.411 );
    level.mq_step_poison_clouds_origin_spawn[ 16 ] = ( 8650.66, 2769.19, 1159.337 );
    level.mq_step_poison_clouds_origin_spawn[ 17 ] = ( 8039.25, 2722.33, 1158.005 );







    //new ones
    level.mq_step_poison_clouds_origin_spawn[ 18 ] = ( 8836.39, 2990.79, 734.321 );
    level.mq_step_poison_clouds_origin_spawn[ 19 ] = ( 8522.32, 2990.79, 742.996 );
    level.mq_step_poison_clouds_origin_spawn[ 20 ] = ( 8122.32, 2990.79, 742.996 );

    level.mq_step_poison_clouds_origin_spawn[ 21 ] = ( 7862.32, 2990.79, 742.996 );
    level.mq_step_poison_clouds_origin_spawn[ 22 ] = ( 7462.32, 2990.79, 742.996 );
    level.mq_step_poison_clouds_origin_spawn[ 23 ] = ( 7162.32, 2990.79, 742.996 );

    level.mq_step_poison_clouds_origin_spawn[ 24 ] = ( 6862.32, 2990.79, 742.996 );
    level.mq_step_poison_clouds_origin_spawn[ 25 ] = ( 6462.32, 2990.79, 742.996 );
    level.mq_step_poison_clouds_origin_spawn[ 26 ] = ( 6162.32, 2990.79, 742.996 );

    level.mq_step_poison_clouds_origin_spawn[ 27 ] = ( 5862.32, 2990.79, 742.996  );
    level.mq_step_poison_clouds_origin_spawn[ 28 ] = ( 5462.32, 2990.79, 742.996  );
    level.mq_step_poison_clouds_origin_spawn[ 29 ] = ( 5162.32, 2990.79, 742.996  );

    level.mq_step_poison_clouds_origin_spawn[ 30 ] = ( 4862.32, 2990.79, 742.996 );
    level.mq_step_poison_clouds_origin_spawn[ 31 ] = ( 4462.32, 2990.79, 742.996 );
    level.mq_step_poison_clouds_origin_spawn[ 32 ] = ( 4162.32, 2990.79, 742.996 );

    level.mq_step_poison_clouds_origin_spawn[ 33 ] = (  12123.9, 3045.88, 767.864 );
    level.mq_step_poison_clouds_origin_spawn[ 34 ] = ( 12423.9, 3045.88, 767.864 );
    level.mq_step_poison_clouds_origin_spawn[ 35 ] = ( 12823.9, 3045.88, 767.864 );

    level.mq_step_poison_clouds_origin_spawn[ 36 ] = ( 13123.9, 3045.88, 767.864 );
    level.mq_step_poison_clouds_origin_spawn[ 37 ] = ( 13423.9, 3045.88, 767.864 );
    level.mq_step_poison_clouds_origin_spawn[ 38 ] = ( 13823.9, 3045.88, 767.864 );

    level.mq_step_poison_clouds_origin_spawn[ 39 ] = ( 14123.9, 3045.88, 767.864 );
    level.mq_step_poison_clouds_origin_spawn[ 40 ] = ( 14423.9, 3045.88, 767.864 );
    level.mq_step_poison_clouds_origin_spawn[ 41 ] = ( 14823.9, 3045.88, 767.864 );







    //bottom
    level.mq_step_poison_clouds_origin_spawn[ 42 ] = ( 8836.39, 2990.79, 234.321 );
    level.mq_step_poison_clouds_origin_spawn[ 43] = ( 8522.32, 2990.79, 242.996 );
    level.mq_step_poison_clouds_origin_spawn[ 44 ] = ( 8122.32, 2990.79, 242.996 );

    level.mq_step_poison_clouds_origin_spawn[ 45 ] = ( 7862.32, 2990.79, 242.996 );
    level.mq_step_poison_clouds_origin_spawn[ 46 ] = ( 7462.32, 2990.79, 242.996 );
    level.mq_step_poison_clouds_origin_spawn[ 47 ] = ( 7162.32, 2990.79, 262.996 );

    level.mq_step_poison_clouds_origin_spawn[ 48 ] = ( 6862.32, 2990.79, 222.996 );
    level.mq_step_poison_clouds_origin_spawn[ 49 ] = ( 6462.32, 2990.79, 282.996 );
    level.mq_step_poison_clouds_origin_spawn[ 50 ] = ( 6162.32, 2990.79, 242.996 );

    level.mq_step_poison_clouds_origin_spawn[ 51 ] = ( 5862.32, 2990.79, 252.996  );
    level.mq_step_poison_clouds_origin_spawn[ 52 ] = ( 5462.32, 2990.79, 212.996  );
    level.mq_step_poison_clouds_origin_spawn[ 53 ] = ( 5162.32, 2990.79, 252.996  );

    level.mq_step_poison_clouds_origin_spawn[ 54 ] = ( 4862.32, 2990.79, 212.996 );
    level.mq_step_poison_clouds_origin_spawn[ 55 ] = ( 4462.32, 2990.79, 242.996 );
    level.mq_step_poison_clouds_origin_spawn[ 56 ] = ( 4162.32, 2990.79, 252.996 );

    level.mq_step_poison_clouds_origin_spawn[ 57 ] = (  12123.9, 3045.88, 267.864 );
    level.mq_step_poison_clouds_origin_spawn[ 58 ] = ( 12423.9, 3045.88, 237.864 );
    level.mq_step_poison_clouds_origin_spawn[ 59 ] = ( 12823.9, 3045.88, 267.864 );

    level.mq_step_poison_clouds_origin_spawn[ 60 ] = ( 13123.9, 3045.88, 237.864 );
    level.mq_step_poison_clouds_origin_spawn[ 61 ] = ( 13423.9, 3045.88, 266.864 );
    level.mq_step_poison_clouds_origin_spawn[ 62 ] = ( 13823.9, 3045.88, 236.864 );

    level.mq_step_poison_clouds_origin_spawn[ 63 ] = ( 14123.9, 3045.88, 237.864 );
    level.mq_step_poison_clouds_origin_spawn[ 64 ] = ( 14423.9, 3045.88, 217.864 );
    level.mq_step_poison_clouds_origin_spawn[ 65 ] = ( 14823.9, 3045.88, 227.864 );



    //top
    level.mq_step_poison_clouds_origin_spawn[ 66 ] = ( 8836.39, 2990.79, 1134.321 );
    level.mq_step_poison_clouds_origin_spawn[ 67] = ( 8522.32, 2990.79, 1112.996 );
    level.mq_step_poison_clouds_origin_spawn[ 68 ] = ( 8122.32, 2990.79, 1242.996 );

    level.mq_step_poison_clouds_origin_spawn[ 69 ] = ( 7862.32, 2990.79, 1242.996 );
    level.mq_step_poison_clouds_origin_spawn[ 70 ] = ( 7462.32, 2990.79, 1242.996 );
    level.mq_step_poison_clouds_origin_spawn[ 71 ] = ( 7162.32, 2990.79, 1262.996 );

    level.mq_step_poison_clouds_origin_spawn[ 72 ] = ( 6862.32, 2990.79, 1222.996 );
    level.mq_step_poison_clouds_origin_spawn[ 73 ] = ( 6462.32, 2990.79, 1282.996 );
    level.mq_step_poison_clouds_origin_spawn[ 74 ] = ( 6162.32, 2990.79, 1242.996 );

    level.mq_step_poison_clouds_origin_spawn[ 75 ] = ( 5862.32, 2990.79, 1252.996  );
    level.mq_step_poison_clouds_origin_spawn[ 76 ] = ( 5462.32, 2990.79, 1212.996  );
    level.mq_step_poison_clouds_origin_spawn[ 77 ] = ( 5162.32, 2990.79, 1252.996  );

    level.mq_step_poison_clouds_origin_spawn[ 78 ] = ( 4862.32, 2990.79, 1212.996 );
    level.mq_step_poison_clouds_origin_spawn[ 79 ] = ( 4462.32, 2990.79, 1242.996 );
    level.mq_step_poison_clouds_origin_spawn[ 80 ] = ( 4162.32, 2990.79, 12522.996 );

    level.mq_step_poison_clouds_origin_spawn[ 81 ] = (  12123.9, 3045.88, 1267.864 );
    level.mq_step_poison_clouds_origin_spawn[ 82 ] = ( 12423.9, 3045.88, 1237.864 );
    level.mq_step_poison_clouds_origin_spawn[ 83 ] = ( 12823.9, 3045.88, 1267.864 );

    level.mq_step_poison_clouds_origin_spawn[ 84 ] = ( 13123.9, 3045.88, 1237.864 );
    level.mq_step_poison_clouds_origin_spawn[ 85 ] = ( 13423.9, 3045.88, 1266.864 );
    level.mq_step_poison_clouds_origin_spawn[ 86 ] = ( 13823.9, 3045.88, 1236.864 );

    level.mq_step_poison_clouds_origin_spawn[ 87 ] = ( 14123.9, 3045.88, 1237.864 );
    level.mq_step_poison_clouds_origin_spawn[ 88 ] = ( 14423.9, 3045.88, 1217.864 );
    level.mq_step_poison_clouds_origin_spawn[ 89 ] = ( 14823.9, 3045.88, 1227.864 );
    





















    /*
    level.mq_step_poison_clouds_origin_spawn[ 6 ] = (  );
    level.mq_step_poison_clouds_origin_spawn[ 7 ] = (  );
    level.mq_step_poison_clouds_origin_spawn[ 8 ] = (  );
    level.mq_step_poison_clouds_origin_spawn[ 9 ] = (  );
    level.mq_step_poison_clouds_origin_spawn[ 10 ] = (  );
    level.mq_step_poison_clouds_origin_spawn[ 11 ] = (  );
    level.mq_step_poison_clouds_origin_spawn[ 12 ] = (  );
    */



    level.mq_clouds_goal = [];

    //mid level goal
    level.mq_clouds_goal[ 0 ] = ( 7457.94, -4469.18, 71.0175 );
    level.mq_clouds_goal[ 1 ] = ( 7857.94, -4269.18, 71.0175 );
    level.mq_clouds_goal[ 2 ] = ( 7616.59, -5042.01, 242.025 );
    level.mq_clouds_goal[ 3 ] = ( 7678.46, -5528.11, 237.963 );
    level.mq_clouds_goal[ 4 ] = ( 8112.22, -5577.57, 234.804 );
    level.mq_clouds_goal[ 5 ] = ( 8609.38, -5567.13, 317.203 );

    //bottom level goal
    level.mq_clouds_goal[ 6 ] = ( 7457.94, -4469.18, -100 );
    level.mq_clouds_goal[ 7 ] = ( 7857.94, -4269.18, -250 );
    level.mq_clouds_goal[ 8 ] = ( 7616.59, -5042.01, -100 );
    level.mq_clouds_goal[ 9 ] = ( 7678.46, -5528.11, -54 );
    level.mq_clouds_goal[ 10 ] = ( 8112.22, -5577.57, -130 );
    level.mq_clouds_goal[ 11 ] = ( 8609.38, -5567.13, 12 );

    //top level
    level.mq_clouds_goal[ 12 ] = ( 7457.94, -4469.18, 700 );
    level.mq_clouds_goal[ 13 ] = ( 7857.94, -4269.18, 600 );
    level.mq_clouds_goal[ 14 ] = ( 7616.59, -5042.01, 600 );
    level.mq_clouds_goal[ 15 ] = ( 7678.46, -5528.11, 800 );
    level.mq_clouds_goal[ 16 ] = ( 8112.22, -5577.57, 670 );
    level.mq_clouds_goal[ 17 ] = ( 8609.38, -5567.13, 800 );

}

testingg()
{
    self endon( "disconnect" );
    level endon( "end_game" );

}

move_poisonous_clouds_main_quest()
{
    level endon( "end_game" );
    //level waittill( "start_moving_towards_farm" );
    
    //for( i = 0; i < level.mq_step_poison_clouds_origin_spawn.size; i++ )
    //{
    //    level.mq_step_poison_cloud_ent[ i ] = spawn( "script_model", level.mq_step_poison_clouds_origin_spawn[ i ] );
   //     level.mq_step_poison_cloud_ent[ i ] setmodel( "tag_origin" );
    //    level.mq_step_poison_cloud_ent[ i ].angles = level.mq_step_poison_cloud_ent[ i ].angles;
   //     wait 0.05;;
   ////    //level.mq_step_poison_cloud_ent[ i ] thread playlighting();
   //}
    
    if( level.dev_time ){ iprintlnbold( "mq_step clouds spawned, waiting to start moving them" ); }

    wait randomfloatrange( 1, 2 );
   // for( s = 0; s < level.mq_step_poison_cloud_ent.size; s++ )
   // {
  //      level.mq_step_poison_cloud_ent[ s ] thread move_to_farmgoal( s );
  //  }
    //two checkpoints that can be hit so that game nows whos at farm and whos not
    level thread farm_checkpoints();
    //notify mq to continue once all at base
    level thread keep_track_of_all_on_farm();
    //spawn on demand cloud fx already on farm
    gue = 1;
    level thread spawn_static_clouds_on_demand_at( level.poisonous_ground_clouds_origins_farm, gue );
   // for( s = 0; s < level.players.size; s++ ){ level.players[ s ] thread fade_to_black_on_impact_self_only(); }
    wait 1.5;
    for( s = 0; s < level.players.size; s++ ){ level.players[ s ] thread fade_to_black_on_impact_self_only(); } 
    wait 1.5;
    foreach( playera in level.players )
    {
        

           playera.surround_cloud = spawn( "script_model", playera.origin + ( 0, 0, -10 ) );
           playera.surround_cloud setmodel( "tag_origin" );
           playera.surround_cloud.angles = playera.angles;
            wait 0.05;
          playfxontag( level._effects[ 47 ], playera.surround_cloud, "tag_origin" );
            wait 0.05;
              playfxontag( level.myfx[ 32 ], playera.surround_cloud, "tag_origin" );
            
        

        wait 0.05;
        playera thread do_damage_cloud();
        //player thread do_big_damage_cloud();
        playera setclientdvar( "r_fog", true );
        playera thread waypoint_set_players();
        playera setclientdvar( "r_dof_enable", true );
        playera setclientdvar( "r_dof_tweak", true );
        playera setclientdvar( "r_dof_farblur", 10 );
        playera setclientdvar( "r_dof_farstart", 10 );
        playera setclientdvar( "r_dof_farend", 2000 );
        
        
        //player.custom_cloud = spawn( "script_model", player.origin );
        //player.custom_cloud setmodel( "tag_origin" );
        //player.custom_cloud.angles = player.angles;
        //wait 0.1;
        //playfxontag( level._effects[ 47 ], player.custom_cloud, "tag_origin" );
        playera PlaySound( level.jsn_snd_lst[ 34 ] );
        wait 0.2;
        playera playsound( level.jsn_snd_lst[ 32 ] );

        playera thread triangle_cloud_follow();
        //player thread which_zone_im_in();
        //player.custom_cloud mover( player );
        playera thread monitor_arrive_farm();


    }

    level thread level_waittill_continue_mq();
}

waypoint_set_players()
{
    level endon( "end_game" );
    self thread farm_waypoint(); 
}
farm_waypoint()
{
    locx = ( 8198.16 );
    locy = ( -5042.4 );
    locz = ( 48.125 );
	shader = newClientHudElem( self );
	shader.x = locx;
	shader.y = locy;
	shader.z = locz + 40;
	shader.alpha = 1;
	shader.color = ( 1, 1, 1 );
	shader.hidewheninmenu = 1;
	shader.fadewhentargeted = 1;
	shader setShader( "specialty_tombstone_zombies", 3, 3 );
	shader setWaypoint( 1 );
    shader thread change_icon();
    self waittill( "stop_all_shaders" );
    shader fadeOverTime( 2 );
    shader.alpha = 0;
    wait 2.1;
	shader destroy();
}

change_icon()
{
    level endon( "end_game" );
    while( isdefined( self ) )
    {
        self setshader( "menu_mp_party_ease_icon", 3, 3 );
        self.color = ( 1, 1, 0 );
        self setWaypoint( true );
        wait 0.25;
        self setshader( "menu_mp_killstreak_select", 3, 3 );
        self setWaypoint( true );
        self.color = ( 1, 1, 0 );
        wait 0.25;
        self setshader( "specialty_tombstone_zombies", 3, 3 );
        self setWaypoint( true );
        self.color = ( 1, 1, 0 );
        wait 0.25;
    }
}

do_damage_cloud()
{
    self endon( "stop_damage_clouds" );
    self endon( "disconnect" );
    level endon( "end_game" );
    while( true )
    {
        previous_origin = self.origin;
        wait 2.5;
        if( distance( self.origin, previous_origin ) < 100 )
        {
            self doDamage( 5, self.origin );
            if( level.dev_time )
            {
                iprintln( "did 10 damage to " + self.name + " due to not moving fast enough.." );
            }
            wait 2;
        }
    }
}

do_big_damage_cloud() //this does big damage if player does not head to farm
{
    self endon( "stop_damage_clouds" );
    self endon( "disconnect" );
    level endon( "end_game" );
    /*
    sizes = level.mq_step_poison_cloud_ent;
    while( true )
    {
        for( i = 0; i < sizes.size; i++ )
        {
            if( distance( self.origin, sizes[ i ].origin ) < 250 )
            {
                self doDamage( 30, self.origin );
                if( level.dev_time ){ iprintln( "did big damage to " + self.name + " coz touching big clouds.." ); }
                wait 2.5;
            }
            wait 0.05;
        }
    }
    */
}
do_it()
{
    level endon( "end_game" );
    
}
//disables cloud fxs from player when player arrives to farm
monitor_arrive_farm()
{
    level endon( "end_game ");
    self endon( "disconnect" );
    //self.surround_cloud = [];
    while( true )
    {
        if( distance( self.origin, level.farmcheckpoint_ent[ 0 ].origin  ) < 200  || distance( self.origin, level.farmcheckpoint_ent[ 1 ].origin ) < 200  )
        {
            if( level.dev_time )
            {
                iprintlnbold( "PLAYER ARRIVED AT BASE" );
            }
            
            level.arrived_at_base++;
            
            self notify( "stop_following_clouds" );
            self notify( "stop_damage_clouds" );
            self.surround_cloud.origin = self.origin + ( 0, 0, -800 );
            self notify( "stop_all_shaders" );
            wait 1;
            if( isdefined( self.surround_cloud ) )
            {
                self.surround_cloud delete();
            }
            
            break;
        }
        else { wait 0.2; }
    }
}

keep_track_of_all_on_farm()
{
    level endon( "end_game" );
    while( level.arrived_at_base < level.players.size )
    {
        wait 1;
    }
    if( level.dev_time ){ iprintln( "SOMEONE AT BASE!!! ^2######################" );}
    level notify( "everyone_at_base" );
    level notify( "delete_checkpoints" );
    PlaySoundAtPosition(level.jsn_snd_lst[ 30 ], level.players[ 0 ].origin );

    if( level.round_number < 25 )
    {
        level thread scripts\zm\zm_transit\warmer_days_sq_rewards::print_text_middle( "^9Call Of Juarez ^8Reward Unlocked", "^8Survivors now pack twice the heat on their magazine.", "^8Survivor's ammo pouche capacity has been increased.", 6, 0.25 );
        setdvar( "player_clipSizeMultiplier", 2.0 ); 
        foreach( playa in level.players )
        {
            playa playsound( "evt_player_upgrade" );
            playa setclientdvar( "player_clipsizemultiplier", 2.0 );
            playa giveMaxAmmo( playa getcurrentweapon() );
            playa.weapon_ammo setValue( playa getWeaponAmmoClip( playa getCurrentWeapon() ) );
        }
    }
    
    
    level notify( "continue_main_quest_farm" );
    wait 10;
    level notify("clean_on_demand_clouds"  );
    
}
level_cleaner()
{
    level waittill( "end_game" );
    foreach( lol in level.mq_step_poison_cloud_ent )
    {
        if( isdefined( lol ) )
        {
            lol delete();
        }
    }
}

level_cleaner_map_restart()
{
    level waittill( "map_restart" );
    foreach( lol in level.mq_step_poison_cloud_ent )
    {
        if( isdefined( lol ) )
        {
            lol delete();
        }
    }
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
			name = "Bus Depot";
		else if (zone == "zone_pri2")
			name = "Bus Depot Hallway";
		else if (zone == "zone_station_ext")
			name = "Outside Bus Depot";
		else if (zone == "zone_trans_2b")
			name = "Fog After Bus Depot";
		else if (zone == "zone_trans_2")
			name = "Tunnel Entrance";
		else if (zone == "zone_amb_tunnel")
			name = "Tunnel";
		else if (zone == "zone_trans_3")
			name = "Tunnel Exit";
		else if (zone == "zone_roadside_west")
			name = "Outside Diner";
		else if (zone == "zone_gas")
			name = "Gas Station";
		else if (zone == "zone_roadside_east")
			name = "Outside Garage";
		else if (zone == "zone_trans_diner")
			name = "Fog Outside Diner";
		else if (zone == "zone_trans_diner2")
			name = "Fog Outside Garage";
		else if (zone == "zone_gar")
			name = "Garage";
		else if (zone == "zone_din")
			name = "Diner";
		else if (zone == "zone_diner_roof")
			name = "Diner Roof";
		else if (zone == "zone_trans_4")
			name = "Fog After Diner";
		else if (zone == "zone_amb_forest")
			name = "Forest";
		else if (zone == "zone_trans_10")
			name = "Outside Church";
		else if (zone == "zone_town_church")
			name = "Upper South Town";
		else if (zone == "zone_trans_5")
			name = "Fog Before Farm";
		else if (zone == "zone_far")
			name = "Outside Farm";
		else if (zone == "zone_far_ext")
			name = "Farm";
		else if (zone == "zone_brn")
			name = "Barn";
		else if (zone == "zone_farm_house")
			name = "Farmhouse";
		else if (zone == "zone_trans_6")
			name = "Fog After Farm";
		else if (zone == "zone_amb_cornfield")
			name = "Cornfield";
		else if (zone == "zone_cornfield_prototype")
			name = "Nacht";
		else if (zone == "zone_trans_7")
			name = "Upper Fog Before Power";
		else if (zone == "zone_trans_pow_ext1")
			name = "Fog Before Power";
		else if (zone == "zone_pow")
			name = "Outside Power Station";
		else if (zone == "zone_prr")
			name = "Power Station";
		else if (zone == "zone_pcr")
			name = "Power Control Room";
		else if (zone == "zone_pow_warehouse")
			name = "Warehouse";
		else if (zone == "zone_trans_8")
			name = "Fog After Power";
		else if (zone == "zone_amb_power2town")
			name = "Cabin";
		else if (zone == "zone_trans_9")
			name = "Fog Before Town";
		else if (zone == "zone_town_north")
			name = "North Town";
		else if (zone == "zone_tow")
			name = "Center Town";
		else if (zone == "zone_town_east")
			name = "East Town";
		else if (zone == "zone_town_west")
			name = "West Town";
		else if (zone == "zone_town_south")
			name = "South Town";
		else if (zone == "zone_bar")
			name = "Bar";
		else if (zone == "zone_town_barber")
			name = "Bookstore";
		else if (zone == "zone_ban")
			name = "Bank";
		else if (zone == "zone_ban_vault")
			name = "Bank Vault";
		else if (zone == "zone_tbu")
			name = "Below Bank";
		else if (zone == "zone_trans_11")
			name = "Fog After Town";
		else if (zone == "zone_amb_bridge")
			name = "Bridge";
		else if (zone == "zone_trans_1")
			name = "Fog Before Bus Depot";
	}
	return name;
}

print_zone()
{

    while( true )
    {
        self iprintln( "Im in : ^9" + self get_zone_name() );
        wait 1.5;
    }
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
do_guide_blockers_dialog()
{
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says(  "^9Dr. Schruder: ^8" + "Are you guys able to hear me?", "^8" + "What was that?!", 7, 1 );
    wait 10;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says(  "^9Dr. Schruder: ^8" + "Those toxic clouds seem to be gone for now.", "^8" + "There's only minor mist still present.", 7, 1  );
    wait 10;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says(  "^9Dr. Schruder: ^8" + "You should locate the mixing container from ^9Bus Depot^8.", "^8" + "We should craft an potion after that.", 8, 1 );

    wait 10;
     PlaySoundAtPosition( "mus_zombie_round_start", level.players[ 0 ].origin );
    level thread scripts\zm\zm_transit\warmer_days_sq_rewards::print_text_middle( "^9Long Way A Cross The Town", "^8Seems like it's as safe as it can be on the outside again..", "I should get going.", 6, 0.25 );

}
level_waittill_continue_mq()
{
    level waittill( "continue_main_quest_farm" );
    level thread do_guide_blockers_dialog();
    foreach( p in level.players ) { p setclientdvar( "r_fog", 1 ); p setclientdvar( "r_sky_intensity_factor0", 0.8 ); }
    //clouds have now disappeared and players must pick up suit case
    //this notifies warmer_days_mq_08_poisonous_adventure script function and starts new logic from there
    level notify( "poisonous_adventure_find_case" );
    wait 1;
    level waittill( "someone_picked_up_poison" );
    
    foreach( playe in level.players )
    {
        playe setclientdvar( "r_fog", false );
        playe thread tranzit_2024_visuals();
    }
    if( level.dev_time ) { iprintlnbold( "someone_picked_up_poison_suitcase" ); }

    
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
    self setclientdvar( "cg_fovscale", 1.15  );
    self setclientdvar( "r_lighttweaksunlight", 12 );
    self setclientdvar( "r_lighttweaksuncolor", ( 0.62, 0.52, 0.46 ) );
    self setclientdvar( "r_lighttweaksundirection", ( -155, 63, 0 ) );

    self setclientdvar( "vc_rgbh", "0.3 0.2 0.2 0" );
   self setclientdvar( "vc_rgbl", "0.1 0.05 0.05 0" );
}
level_guide_players_to_depo_blockers()
{
    level endon( "end_game" );
    level notify( "start_find_suitcase_dialog" );
    guide_blockers = [];
    guide_blockers[ 0 ] = ( 201.949, -5322.47, -73.5151 );
    guide_blockers[ 1 ] = ( 130.762, -5055.91, -67.0904 );
    guide_blockers[ 2 ] = ( 83.4722, -4793.89, -75.0449 );
    guide_blockers[ 3 ] = ( 53.9489, -4521.84, -59.4534 );
    guide_blockers[ 4 ] = ( 54.2209, -4279.18, -48.2064 );
    //dont spawn this twice, only once
    guide_blockers[ 5 ] = ( 64.9275, -4089.67, 31.6345  );

    //upper
    guide_blockers[ 6 ] = ( 201.949, -5322.47, 144.5151 );
    guide_blockers[ 7 ] = ( 130.762, -5055.91, 142.0904 );
    guide_blockers[ 8 ] = ( 83.4722, -4793.89, 141.0449 );
    guide_blockers[ 9 ] = ( 53.9489, -4521.84, 159.4534 );
    guide_blockers[ 10 ] = ( 54.2209, -4279.18, 158.2064 );
    

    //other
    guide_blockers[ 11 ] = ( 1922.09, -663.276, -47.7975 );
    guide_blockers[ 12 ] = ( 1736.21, -459.981, -48.3843 );
    guide_blockers[ 13 ] = ( 1589.84, -352.884, -78.6383 );
    guide_blockers[ 14 ] = ( 1404.16, -254.213, -78.5652 );
    guide_blockers[ 15 ] = ( 1250.67, -196.04, -78.5483 );
    guide_blockers[ 16 ] = ( 1250.66, -114.62, -78.5439 );

    guide_blockers[ 17 ] = ( 538.329, -842.583, -47.261 );
    

    //upper
    guide_blockers[ 18 ] = ( 201.949, -5322.47, 273.5151 );
    guide_blockers[ 19 ] = ( 130.762, -5055.91, 267.0904 );
    guide_blockers[ 20 ] = ( 83.4722, -4793.89, 275.0449 );
    guide_blockers[ 21 ] = ( 53.9489, -4521.84, 259.4534 );
    guide_blockers[ 22 ] = ( 53.9489, -4521.84, 259.4534 );
    guide_blockers[ 23 ] = ( 201.949, -5322.47, 244.5151 );
    guide_blockers[ 24 ] = ( 130.762, -5055.91, 242.0904 );
    guide_blockers[ 25 ] = ( 83.4722, -4793.89, 341.0449 );
    guide_blockers[ 26 ] = ( 53.9489, -4521.84, 359.4534 );
    guide_blockers[ 27 ] = ( 54.2209, -4279.18, 358.2064 );
    guide_blockers[ 28 ] = ( 1922.09, -663.276, 247.7975 );
    guide_blockers[ 29 ] = ( 1736.21, -459.981, 248.3843 );
    guide_blockers[ 30 ] = ( 1589.84, -352.884, 278.6383 );
    guide_blockers[ 31 ] = ( 1404.16, -254.213, 278.5652 );
    guide_blockers[ 32 ] = ( 1250.67, -196.04, 278.5483 );
    guide_blockers[ 33 ] = ( 1250.66, -114.62, 278.5439 );
    guide_blockers[ 34 ] = ( 538.329, -842.583, 247.261 );

    temp = [];
    wait 0.1;
    for( i = 0; i < guide_blockers.size; i++ )
    {
        temp[ i ] = spawn( "script_model", guide_blockers[ i ] );
        temp[ i ] setmodel( level.myModels[ 0 ] );
        temp[ i ].angles = temp[ i ].angles;
        wait 0.05;
        playfxontag( level._effects[ 47 ], temp[ i ], "tag_origin" );
        if( i < 5 )
        {
            romps = spawn( "script_model", temp[ i ].origin );
            romps setmodel(  "collision_geo_64x64x64_standard" );
            romps.angles = temp[ i ].angles;
        }

        if( i > 10 && i < 18 )
        {
            romps = spawn( "script_model", temp[ i ].origin );
            romps setmodel(  "collision_geo_64x64x64_standard" );
            romps.angles = temp[ i ].angles;
        }
        wait 0.1;
        playfxontag( level._effects[ 42], temp[ i ], "tag_origin" );
        wait 0.05;
        if( randomint( 50 ) > 20 )
        {
            playfxontag( level._effects[ 70 ], temp[ i ], "tag_origin" );
        }
        
    }
    if( level.dev_time ){ iprintln( "ALL BLOCKERS SPAWNED" ); }
    level waittill( "someone_picked_up_poison" );
    foreach( model in temp )
    {
        model movez( -900, 6, 3, 0 );
        wait randomfloatrange( 0.05, 0.2 );
    }
    wait 10;
    level notify( "deleted_new_clouds_now" );
    foreach( s in temp )
    {
        s delete();
    }
    //notify warmer_days_mq_08_poisonous_adventure.gsc to start running its logic
   
}
fade_to_black_on_impact_self_only()
{
    level endon( "end_game" );
    
    self thread fadeForAWhile( 0.3, 2, 0.5, 0.4, "black" );
    self playsound( level.jsn_snd_lst[ 29 ] );
    wait 5;
    self playsound( level.mysounds[ 7 ] );
    playfx( level.myFx[ 87 ], self.origin );

}
fadeForAWhile( startwait, blackscreenwait, fadeintime, fadeouttime, shadername, n_sort ) //is used now
{
    if ( !isdefined( n_sort ) )
        n_sort = 50;

    wait( startwait );

    if ( !isdefined( self ) )
        return;

    if ( !isdefined( self.blackscreen ) )
        self.blackscreen = newclienthudelem( self );

    self.blackscreen.x = 0;
    self.blackscreen.y = 0;
    self.blackscreen.horzalign = "fullscreen";
    self.blackscreen.vertalign = "fullscreen";
    self.blackscreen.foreground = 0;
    self.blackscreen.hidewhendead = 0;
    self.blackscreen.hidewheninmenu = 1;
    self.blackscreen.sort = n_sort;

    if ( isdefined( shadername ) )
        self.blackscreen setshader( shadername, 640, 480 );
    else
        self.blackscreen setshader( "black", 640, 480 );

    self.blackscreen.alpha = 0;

    if ( fadeintime > 0 )
        self.blackscreen fadeovertime( fadeintime );

    self.blackscreen.alpha = 1;
    wait( fadeintime );

    if ( !isdefined( self.blackscreen ) )
        return;

    wait( blackscreenwait );

    if ( !isdefined( self.blackscreen ) )
        return;

    if ( fadeouttime > 0 )
        self.blackscreen fadeovertime( fadeouttime );

    self.blackscreen.alpha = 0;
    wait( fadeouttime );

    if ( isdefined( self.blackscreen ) )
    {
        self.blackscreen destroy_hud();
        self.blackscreen = undefined;
    }
}

farm_checkpoints()
{
    level.farmcheckpoint = [];
    level.farmcheckpoint[ 0 ] = ( 8179.02, -5640.17, 34.0229 );
    level.farmcheckpoint[ 1 ] = ( 7727.43, -5056.48, 37.5927 );
    level.farmcheckpoint_ent = [];
    for( i = 0; i < level.farmcheckpoint.size; i++ )
    {
        level.farmcheckpoint_ent[ i ] = spawn( "script_model", level.farmcheckpoint[ i ] );
        level.farmcheckpoint_ent[ i ] setmodel( "tag_origin" );
        level.farmcheckpoint_ent[ i ].angles = level.farmcheckpoint_ent[ i ].angles;
    }

    level waittill( "delete_checkpoints" );
    foreach( ls in level.farmcheckpoint_ent )
    {
        ls delete();
    }
}
which_zone_im_in()
{   
    level endon( "end_game" );
    my_zones = [];
    my_zones[ 0 ] = "";
    my_zones[ 1 ] = "";
    my_zones[ 2 ] = "";
    my_zones[3] = "zone_far";
    my_zones[4] = "zone_pow";
    my_zones[5] = "zone_trans_1";
    my_zones[6] = "zone_trans_2";
    my_zones[7] = "zone_trans_3";
    my_zones[8] = "zone_trans_4";
    my_zones[9] = "zone_trans_5";
    my_zones[10] = "zone_trans_6";
    my_zones[11] = "zone_trans_7";
    my_zones[12] = "zone_trans_8";
    my_zones[13] = "zone_trans_9";
    my_zones[14] = "zone_trans_10";
    my_zones[15] = "zone_trans_11";
    my_zones[16] = "zone_amb_tunnel";
    my_zones[17] = "zone_amb_forest";
    my_zones[18] = "zone_amb_cornfield";
    my_zones[19] = "zone_amb_power2town";
    my_zones[20] = "zone_amb_bridge";
    playable_area = getentarray("player_volume", "script_noteworthy");
    while( true )
    {
       // level.players[ 0 ] notify( "stop_fog" );
       // iprintln( "FOG STOP" );
       // iprintln( level.players[ 0 ] get_current_zone(1)  );
        wait 1;
    }
}

get_current_zone( return_zone )
{
    //&&flag_wait( "zones_initialized" );

    for ( z = 0; z < level.zone_keys.size; z++ )
    {
        zone_name = level.zone_keys[z];
        zone = level.zones[zone_name];

        for ( i = 0; i < zone.volumes.size; i++ )
        {
            if ( self istouching( zone.volumes[i] ) )
            {
                if ( isdefined( return_zone ) && return_zone )
                    return zone;

                return zone_name;
            }
        }
    }

    return undefined;
}

triangle_cloud_follow()
{
    self endon( "disconnect" );
    self endon( "death" );
    self endon( "stop_following_clouds" );

    
    wait 2;
    offset_ = 5;  
    offsetn_ = -270;
    while( true )
    {
        self.surround_cloud.origin = self.origin + ( offset_, 0, -80 );
        wait 0.05;
    }
}

mover( move_with_this )
{
    self endon( "disconnect" );
    self.origin = move_with_this.origin + ( 0, 0, -800 );
    wait 10;
    self moveto( move_with_this.origin, 1, 0, 0 );
    self waittill( "movedone" );
    while( true )
    {
        self.origin = move_with_this.origin;
        wait 0.05;
    }

}


playlighting()
{
    level endon( "end_game" );
    while( true )
    {
        playfx( level.myFx[ 92 ], self.origin );
        wait randomintrange( 7, 16 );
    }
}
move_to_farmgoal( value ) //max time to move = 70 seconds from spawn to farm
{
    level endon( "end_game" );

    timer = randomintrange( 130, 150 );
    self moveto( level.mq_clouds_goal[ value ], timer, 5, 10 );
    self waittill( "movedone" );
    self thread hover_me_around();
}

hover_me_around()
{
    level endon( "end_game" );
    level endon( "start_moving_me_away" );

    while( true )
    {
        self movez( 150, 10, 2, 2 );
        self waittill( "movedone" );
        self movez( -150, 10, 2, 2 );
        self waittill( "movedone" );
    }
}