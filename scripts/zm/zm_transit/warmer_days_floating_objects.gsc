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
    preCacheModel( "com_powerline_tower_top2_broken2_forest" );
    precachemodel( "com_powerline_tower_top_broken2" );
    precachemodel( "com_powerline_tower_top2_broken2" );
    precachemodel( "p_glo_powerline_tower_redwhite" );
    precachemodel( "p6_zm_rocks_medium_05" );
    precachemodel( "p6_zm_rocks_small_cluster_01" );
    precachemodel( "vehicle_tractor_2" );
    precachemodel( "p6_zm_rocks_small_cluster_03" );
    precachemodel( "p6_zm_rocks_large_cluster_01" );
    precachemodel( "zombie_bus" );
    precachemodel( "p6_pak_veh_train_boxcar" );
    precachemodel( "veh_t6_civ_microbus_dead" );
    precachemodel( "veh_t6_civ_60s_coupe_dead" );
    precachemodel( "veh_t6_civ_smallwagon_dead" );
    level thread level_power_lines();
    level thread all_floating_objects_around_the_map();
    level thread all_floating_rocks_around_the_map();
    level thread more_trees_to_hide_stuff();
}

more_trees_to_hide_stuff()
{
    locs = [];
    locs[ locs.size ] = ( 7670, -1994, -222 ); //( "t5_foliage_bush05" );
    locs[ locs.size ] = ( 6651, -2610, -119 );
    locs[ locs.size ] = ( 7374, -1666.57, -256 );
    locs[ locs.size ] = ( 8589, -1256, -210 );
    locs[ locs.size ] = (  10404.3, -1882.64, -213.852);
    locs[ locs.size ] = ( 10740, -491, -215 );
    locs[ locs.size ] = (  11400, 441, -216 );
    locs[ locs.size ] = ( -8467, -7677, 37 );
    locs[ locs.size ] = ( -8435, -6229, 226 );

    locs[ locs.size ] = ( 9145.51, 1494, 106 );
    locs[ locs.size ] = ( 9610.8, 1444.16, 255.766 );
    locs[ locs.size ] = ( 9874.78, 1349.28, 212.962 );
    locs[ locs.size ] = ( 7373.72, 2339.02, 124.112 );

    for( s = 0; s < locs.size; s++ )
    {
        spawners = spawn( "script_model", locs[ s ] );
        spawners setmodel( "t5_foliage_tree_burnt03" );
        spawners.angles = ( 0, randomint( 360 ), 0 );
    }
}
player_spawns()
{
    self endon( "disconnect" );
    level endon( "end_game" );
    first_timer = true;
    s = 0;
    ind = [];
    ind[ 0 ] = ( "p6_zm_rocks_medium_05" ); //works in diner forest
    ind[ 1 ] = ( "veh_t6_civ_microbus_dead" ); //works in power station
    ind[ 2 ] = ( "p6_pak_veh_train_boxcar" ); //works in cabin forest
    ind[ 3 ] = ( "veh_t6_civ_60s_coupe_dead" ); //works everywhere
    ind[ 4 ] = ( "veh_t6_civ_smallwagon_dead" );
    self waittill( "spawned_player" );
    while( true )
    {
        if( self useButtonPressed() && self adsButtonPressed() )
        {
            temp = spawn( "script_model", self.origin );
            temp setmodel( ind[ s ] );
            temp.angles = self.angles;
            iprintln(  ind[ s ] );
            s++;
            wait 1;
        }
        wait 0.05;
        if( s > ind.size )
        {
            s = 0;
        }
    }
}

level_power_lines()
{
    powerlines_c = [];
    powerlines_c[ 0 ] = ( -5562, 8978, -71 );
    //powerlines_c[ 1 ] = ( -10600.3, -3215.07, 1582.68 );
    powerlines_c[ 1 ] = ( -6534.32, -9426, 129 );
    //powerlines_c[ 3 ] = ( -6600.09, -3214.48, 1431.52 );
    powerlines_c[ 2 ] = ( -171, -10856, 832 );
    //powerlines_c[ 5 ] = ( -2600.65, -3252.01, 928.588 );
    powerlines_c[ 3 ] = ( -2202, 6234, 831 );
    powerlines_c[ 4 ] = ( 14466.2, 1916, 57 );
    level.pr = [];

    l = [];
    l[ 0 ] = 90;
    l[ 1 ] = 135;
    l[ 2 ] = 45;
    l[ 3 ] = 45;
    l[ 4 ] = 45;
    for( i = 0; i < powerlines_c.size; i++ )
    {
        level.pr[ i ] = spawn( "script_model", powerlines_c[ i ] + ( 0, 0, -50 ) );
        level.pr[ i ] setmodel( "p_glo_powerline_tower_redwhite" );
        level.pr[ i ].angles = ( 0, 85 + l[ i ], 0 );
        wait 0.1;
    }
}

all_floating_rocks_around_the_map()
{
    flag_wait( "initial_blackscreen_passed" );
    locations = [];
    wait 0.05;
    locations[ 0 ] = ( -5229.73, -9566.76, 1159.11 ); //rock
    locations[ 1 ] = ( -3679.7, -7383.1, 1078.7 ); //rock
    locations[ 2 ] = ( -9552.4, -4960.34, 1012.22 ); //rock
    locations[ 3 ] = ( -7217.4, -9824.66, 475.841 ); //rock
    locations[ 4 ] = ( 341.881, -5416.87, 745.983 ); //rock
    locations[ 5 ] = ( 4463.07, -4171.54, 1207.13 ); //rock
    locations[ 6 ] = ( 4942.17, -7793.8, 1498.47 ); //rock
    locations[ 7 ] = ( 6350.02, -6182.64, 724.3 ); //rock
    locations[ 8 ] = ( 11673.1, -6845.47, 1653.43 ); //rock
    locations[ 9 ] = ( 11352.9, -5641.07, 627.918 ); //rock
    locations[ 10 ] = ( 7259.26, -8490.03, 116.62 ); //rock
    locations[ 11 ] = ( 4654.39, 771.692, 2131.24 ); //rock
    locations[ 12 ] = ( 11199, -1138.23, 896.275 ); //rock
    locations[ 13 ] = ( 14062.1, 177.984, 997.104 ); //rock
    locations[ 14 ] = ( 8652.01, -2498.02, 2825.97 ); //rock
    locations[ 15 ] = ( 12658.2, -2814.18, 771.712 ); //rock
    locations[ 16 ] = ( 6860.23, 3491.43, 2057.09 ); //rock
    locations[ 17 ] = ( 13222.9, 4505.69, 1446.11 ); //rock
    locations[ 18 ] = ( 10973.3, 10323.6, 2131.01 ); //rock
    locations[ 19 ] = ( 11157.9, 8783.25, 208.577 ); //rock
    locations[ 20 ] = ( 12834.3, 7728.93, 479.201 ); //rock
    locations[ 21 ] = ( 9134.79, 12901.2, 998.749 ); //rock
    locations[ 22 ] = ( 851.014, 1766.49, 3038.23 ); //rock
    locations[ 23 ] = ( -142.827, 4431.65, 1888.4 ); //rock
    locations[ 24 ] = ( 174.637, -2627.93, 1154.38 ); //rock
    locations[ 25 ] = ( 3523.11, -1353.26, 1255.27 ); //rock
    locations[ 26 ] = ( 2141.15, 2137.28, 882.507 ); //rock   
    locations[ 27 ] = ( 526.413, 228.658, 1135.42 ); //rock
    locations[ 28 ] = ( -2911.5, -2174.83, 221.669 ); //rock
    locations[ 29 ] = ( -2276.58, 30.4319, 1473.24 ); //rock
    locations[ 30 ] = ( -7591.08, -1720.5, 2695.69 ); //rock
    locations[ 31 ] = ( -5311.87, -3823.47, 1585.67 ); //rock
    locations[ 32 ] = ( -7546.29, 1332.71, 1755.8 ); //rock
    locations[ 33 ] = ( -3721.72, 3291.21, 1513.44 ); //rock
    locations[ 34 ] = ( -10499.3, 6676.18, 1326.1 ); //rock
    locations[ 35 ] = ( -5268.49, 6248.11, 1798.78 ); //rock
    locations[ 36 ] = ( -7746.22, 8884.21, 2835.92 ); //rock
    locations[ 37 ] = ( -5382.2, 1621.52, 1321.18 ); //Rock
    locations[ 38 ] = ( -8005.22, 4185.04, 782.87 ); //rock
    locations[ 39 ] = ( -10591.4, 3073.01, 2898.24 ); //rock
    locations[ 40 ] = ( -10195.5, -8514.29, 2420.54 );
    locations[ 41 ] = ( -10858.1, -461.181, 5683.96 );

    level.bumps = [];
    wait 0.05;
    for( s = 0; s < locations.size; s++ )
    {
        if( s % 2 == 0 )
        {
            level.bumps[ s ] = spawn( "script_model", locations[ s ] + ( 0, 0, 350 ) );

            level.bumps[ s ] setmodel( "p6_zm_rocks_medium_05"/*"p6_zm_rocks_large_cluster_01" */);
            
            level.bumps[ s ].angles = ( 180, randomInt( 360 ), randomintrange( -30, 30 ) );
            wait 0.05;
            level.bumps[ s ] thread playlighting_playembers();
            level.bumps[ s ] thread hover_rocks();
            level.bumps[ s ] thread spin_rocks();
            wait 0.05;
        }
        
    }
}

playlighting_playembers()
{
    level endon( "end_game" );

    //playfxontag( level._effects[33], self, "tag_origin" );   
    while( isdefined( self ) )
    {
        wait 0.05;
        playfxontag( level._effects[72], self, "tag_origin" );
        wait randomIntRange( 36, 120 );
    }
    
}

test_fx_play()
{
    level waittill( "initial_blackscreen_passed" );
    wait 3;
    playfx( level._effects[ 72 ], level.players[ 0 ].origin );
}
hover_rocks()
{
    level endon( "end_game" );
    wait randomint( 8 );
    ra = randomint( 10 );
    cols = false;
    if( ra < 5 )
    {
        cols = true;
        f = 1050;
    }
    while( isdefined( self ) )
    {
        w = 14;
        if( cols )
        {
            self.origin = self.origin + ( 0, 0, f );
            wait 0.1;
            self movez( -1050, w, 6, 4 );
            cols = false;
            wait w + 0.05;
        }
        self movez( 1050, w, 4, 4 );
        wait w + 0.05;
        self movez( -1050, w, 4, 4 );
        wait w;
    }
}

spin_rocks()
{
    level endon( "end_game" );
    wait randomintrange( 1, 5 );
    defined_rand = randomintrange( 0, 10 );
    if( defined_rand > 5 ) { dir = ( -360 ); }
    else if ( defined_rand <= 5 ) { dir = 360; }
    wait randomFloat( 6 );
    while( isdefined( self ) )
    {
        self rotateYaw( dir, 12, 0, 0 );
        wait 12;
    }
}

roll_rocks()
{
    level endon( "end_game" );
    wait randomintrange( 1, 5 );
    defined_rand = randomintrange( 0, 10 );
    if( defined_rand > 5 ) { dir = ( -360 ); }
    else if ( defined_rand <= 5 ) { dir = 360; }
    wait randomFloat( 6 );
    while( isdefined( self ) )
    {
        self rotatePitch( dir, 12, 0, 0 );
        wait 12;
    }
}

all_floating_objects_around_the_map()
{
    flag_wait( "initial_blackscreen_passed" );
    locations = [];
    //diner
    wait 0.1;
    locations[ 0 ] = ( -4026.32, -9363.15, 1222.83 ); //car
    locations[ 1 ] = ( -3092.88, -7890.37, 244.974 ); //car
    locations[ 2 ] = ( -6256.67, -4693.42, 1028.65 ); //car
    locations[ 3 ] = ( -7670.37, -10576.6, 426.748 );
    //forest to farm
    locations[ 4 ] = ( -1913.1, -7543.29, 838.141 ); //car
    locations[ 5 ] = ( 2061.01, -5853.24, 414.203 ); //car
    locations[ 6 ] = ( 3402.77, -5907.4, 768.823 ); //car
    //farm
    locations[ 7 ] = ( 8803.17, -5671.77, 1300.07 ); //car //tractor
    locations[ 8 ] = ( 9476.59, -4675.69, 2404.98 ); //car
    //farm to corn to power
    locations[ 9 ] = ( 6095.86, -2405.41, 1806.93 ); // car
    locations[ 10 ] = ( 9588.75, -380.851, 806.636 ); //car
    locations[ 11 ] = ( 11869.7, 566.133, 669.234 ); //car
    locations[ 12 ] = ( 9300.39, 2019.45, 1248.17 ); //car
    locations[ 13 ] = ( 7845.8, 5566.89, 293.314 ); // car
    locations[ 14 ] = ( 8361.72, 6662.67, 774.136 ); //ca
    //power to cabin to town
    locations[ 15 ] = ( 7822.82, 9218.15, 809.442 ); //train or car
    locations[ 16 ] = ( 8181.26, 8117.87, 177.991 ); //train
    locations[ 17 ] = ( 8399.98, 10304.9, 509.746 ); //train
    locations[ 18 ] = ( 3854.31, 2776.82, 1860.22 ); //car
    locations[ 19 ] = ( 3007.48, -1596.98, 2226.55 ); //car
    locations[ 20 ] = ( 1349.29, -566.074, 604.159 ); //car
    locations[ 21 ] = ( -1100.09, 451.172, 682.676 ); //car 
    locations[ 22 ] = ( -6293.09, 3994.09, 680.11 ); //car
    locations[ 23 ] = ( -6080.68, 6031.41, 512.544 ); //car
    locations[ 24 ] = ( -8397.78, 6168.9, 338.816 ); //car
    locations[ 25 ] = ( -8046.71, 6530.09, 65.8968 ); //car
    locations[ 26 ] = ( -8759.11, 7903.17, 474.596 ); //car
    bumps = [];
    wait 0.05;
    for( s = 0; s < locations.size; s++ )
    {
        bumps[ s ] = spawn( "script_model", locations[ s ] );
        if( s == 15 || s == 16 || s == 17 )
        {
            bumps[ s ] setmodel( "p6_zm_rocks_small_cluster_01" );//"p6_zm_rocks_medium_05" );
            bumps[ s ].angles = ( randomint( 360 ), randomint( 360 ), randomint( 25 ) );
            bumps[ s ] thread hover_rocks();
            bumps[ s ] thread spin_rocks();
        }
        if( s == 7 )
        {
            bumps[ s ] setmodel( "vehicle_tractor_2" );
            bumps[ s ].angles = ( randomint( 360 ), randomint( 360 ), randomint( 25 ) );
            bumps[ s ] thread hover_rocks();
            bumps[ s ] thread spin_rocks();
        }

        if( s == 18 || s == 9 || s == 0 || s == 12 || s == 22 || s == 8 || s == 9 || s == 14 )
        {
            bumps[ s ] setmodel( "p6_zm_rocks_medium_05" );
            bumps[ s ].angles = ( randomint( 360 ), randomint( 360 ), randomint( 25 ) );
            bumps[ s ] thread hover_rocks();
            bumps[ s ] thread spin_rocks();
        }
        else 
        {
            num = randomint( 4 );
            switch( num )
            {
                case 0:
                bumps[ s ] setmodel( "p6_zm_rocks_medium_05" );
                bumps[ s ].angles = ( randomInt( 360 ), randomInt( 360 ), randomInt( 360 ) );
                bumps[ s ] thread hover_rocks();
                bumps[ s ] thread spin_rocks();
                break;

                case 1:
                bumps[ s ] setmodel( "p6_zm_rocks_medium_05" );
                bumps[ s ].angles = ( randomInt( 360 ), randomInt( 360 ), randomInt( 360 ) );
                bumps[ s ] thread hover_rocks();
                bumps[ s ] thread spin_rocks();
                break;

                case 2:
                bumps[ s ] setmodel( "p6_zm_rocks_small_cluster_01"  );
                bumps[ s ].angles = ( randomInt( 360 ), randomInt( 360 ), randomInt( 360 ) );
                bumps[ s ] thread hover_rocks();
                bumps[ s ] thread spin_rocks();
                break;
                case 3:
                bumps[ s ] setmodel( "p6_zm_rocks_medium_05" );
                bumps[ s ].angles = ( randomInt( 360 ), randomInt( 360 ), randomInt( 360 ) );
                bumps[ s ] thread hover_rocks();
                bumps[ s ] thread spin_rocks();
                break;
                default:
                bumps[ s ] setmodel("p6_zm_rocks_small_cluster_01" );
                bumps[ s ].angles = ( randomint(360 ), randomInt( 360 ), randomInt( 360 ) );
                bumps[ s ] thread hover_rocks();
                bumps[ s ] thread spin_rocks();
            }
            
        }
        
        wait 0.05;
    }

    for( a = 0; a < 10; a++ )
    {
        buster = spawn( "script_model", locations[ a ] );
        buster setmodel( "p6_zm_rocks_small_cluster_01" );
        buster.angles = ( randomint(360 ), randomInt( 360 ), randomInt( 360 ) );
        wait 0.05;
        playfxontag( level._effects[17], buster, "tag_origin" );
        buster thread find_and_moveto();
        wait 1;
    }

}
spin_me_fast()
{
    level endon( "end_game" );
    defined_rand = randomintrange( 0, 10 );
    if( defined_rand > 5 ){ dir = ( -360 ); }
    else if ( defined_rand <= 5 ){ dir = 360; }
    wait randomFloat( 6 );
    while( isdefined( self ) )
    {
        self rotateYaw( dir, 2.5, 0, 0 );
        wait 2.5;
    }
}


find_and_moveto()
{
    level endon( "end_game" );
    self thread spin_me_fast();
    while( isdefined( self ) )
    {
        rnd = randomint( level.bumps.size );
        rnd_time = randomIntrange( 14, 24 );
        self moveto( level.bumps[ rnd ].origin, rnd_time, 3, 3  );
        //self rotateto( level.bumps[ rnd ], rnd_time );
        wait rnd_time + 0.05;
        if( self.origin != level.bumps[ rnd ].origin )
        {
            self moveto( level.bumps[ rnd ].origin, 1, 0.1, 0.1 );
            wait 1;
        }
        playfx( level.myFx[ 94 ], self.origin );
        wait 0.05;
        //power pulse, might cause too much stress on the game
        //playfx( level._effects[70], self.origin );

        //stay stuck on the rock for a while
        for( i = 0; i < 4; i++ )
        {
            self moveto( level.bumps[ rnd].origin, 0.1, 0, 0 );
            wait 0.1;
           
        }
        //playfx( level._effects[77], self.origin );
        wait 0.08;
    }
}