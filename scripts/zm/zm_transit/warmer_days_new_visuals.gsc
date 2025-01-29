
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

#include maps\mp\zombies\_zm_craftables;

init()
{
    level thread apply_visuals();
    s_clouds = [];
    s_clouds_angles = [];
    //these clouds try to hide some of tranzit's "pop ins"
    level thread cloud_locations();

    //level.zombie_weapons[ "m14_zm" ].cost = 10000;
    //level.zombie_weapons[ "m14_zm" ].ammo_cost = 50000; 
    flag_wait( "initial_blackscreen_passed" );
    level thread ambers();
   // level thread change_14_wallbuy();
    //level.zombie_weapons[ "m14_zm" ].cost = 10000;
    //level.zombie_weapons[ "m14_zm" ].ammo_cost = 50000; 


    
}


for_each_player_println()
{
    for( s = 0; s < level.players.size; s++ )
    {
        s thread do_println_on_entity_call();
    }
}
do_println_on_entity_call()
{
    self endon( "disconnect" );
    while( isdefined( self ) )
    {
        iprintln( "Player is: " + self.name );
        wait 1;
    }
}
cloud_locations()
{
    
    flag_wait( "initial_blackscreen_passed" );
    //from depo to tunnel
    s_clouds[ 0 ] = ( -9718.66, 3462.69, 169.3 );
    s_clouds_angles[ 0 ] = ( 0, 135, 0 );
    
    s_clouds[ 1 ] = ( -9928.82, 3736.19, 155.345 );
    s_clouds_angles[ 1 ] = ( 0, 122, 0 );

    s_clouds[ 2 ] = ( -10232.5, 2797.41, 192.125 );
    s_clouds_angles[ 2 ] = ( 0, 61, 0 ); //160 below orignially

    s_clouds[ 3 ] = ( -11060.9, 1065.01, 192.125 );
    s_clouds_angles[ 3 ] = ( 0, 61, 0 );

    s_clouds[ 4 ] = ( -10669.4, 2170.68, 192.125 );
    s_clouds_angles[ 4 ] = ( 0, 61, 0 );

    //from tunnel to diner
    s_clouds[ 5 ] = ( -8258.77, -6675.3, 162.642 );
    s_clouds_angles[ 5 ] = ( 0, 140, 0 );
    
    s_clouds[ 6 ] = ( -8901.85, -6415.92, 189.995 );
    s_clouds_angles[ 6 ] = ( 0, 80, 0 );

    s_clouds[ 7 ] = ( -9732.6, -6073.96, 192.125 );
    s_clouds_angles[ 7 ] = ( 0, 145, 0 );

    s_clouds[ 8 ] = ( -10496.4, -5419.58, 196.125 );
    s_clouds_angles[ 8 ] = ( 0, 110, 0 );

    s_clouds[ 9 ] = ( -10486.6, -4437.3, 192.125 );
    s_clouds_angles[ 9 ] = ( 0, 90, 0 );
    
    s_clouds[ 10 ] = ( -10965, -4256.98, 196.125 );
    s_clouds_angles[ 10 ] = ( 0, 40, 0 );

    s_clouds[ 11 ] = ( -10973.6, -2742.41, 192.125 );
    s_clouds_angles[ 11 ] = ( 0, 95, 0 );

    s_clouds[ 12 ] = ( -7375.66, -7728.44, 78.5853 );
    s_clouds_angles[ 12 ] = ( 0, 60, 0 );

    s_clouds[ 13 ] = ( -8008.83, -8723.53, 282.051 );
    s_clouds_angles[ 13 ] = ( 0, 27, 0 );

    s_clouds[ 14 ] = ( -7955, -8196.77, 39.4775 );
    s_clouds_angles[ 14 ] = ( 0, 100, 0 );

    s_clouds[ 15 ] = ( -7012.22, -8499.02, 67.6794 );
    s_clouds_angles[ 15 ] = ( 0, -34, 0 );

    //diner to farm
    s_clouds[ 16 ] = ( -2918.76, -8198.28, -94.582 );
    s_clouds_angles[ 16 ] = ( 0, -42, 0 );

    s_clouds[ 17 ] = ( -4558.53, -7956.13, 198.954 );
    s_clouds_angles[ 17 ] = ( 0, -72, 0 );
    
    s_clouds[ 18 ] = ( -4580.64, -6933.77, -60.0517 );
    s_clouds_angles[ 18 ] = ( 0, 165, 0 );

    s_clouds[ 19 ] = ( -2201.88, -5182.45, -65.875 );
    s_clouds_angles[ 19 ] = ( 0, 90, 0 );
    
    s_clouds[ 20 ] = ( -1473.9, -5416.95, -73.4556 );
    s_clouds_angles[ 20 ] = ( 0, 90, 0 );

    s_clouds[ 21 ] = ( -2735.77, -6584.07, -83.8576 );
    s_clouds_angles[ 21 ] = ( 0, 95, 0 );
    
    s_clouds[ 22 ] = ( -1918.33, -6920.64, -131.216 );
    s_clouds_angles[ 22 ] = ( 0, 95, 0 );

    s_clouds[ 23 ] = ( -1976.48, -6073.6, -114.712 );
    s_clouds_angles[ 23 ] = ( 0, 95, 0 );
    
    s_clouds[ 24 ] = ( 3050.23, -5650.07, -4.42985 );
    s_clouds_angles[ 24 ] = ( 0, 140, 0 );

    s_clouds[ 25 ] = ( 4713.21, -5715.72, -79.1961 );
    s_clouds_angles[ 25 ] = ( 0, 140, 0 );
    
    s_clouds[ 26 ] = ( 6931.21, -7471.42, -98 );
    s_clouds_angles[ 26 ] = ( 0, 50, 0 );

    s_clouds[ 27 ] = ( 9562.81, -4936.59, 28 );
    s_clouds_angles[ 27 ] = ( 0, 140, 0 );
    
    s_clouds[ 28 ] = ( 9309.06, -5483.26, 18.3702 );
    s_clouds_angles[ 28 ] = ( 0, 140, 0 );

    s_clouds[ 29 ] = ( 9593.56, -7058.15, 69.3919 );
    s_clouds_angles[ 29 ] = ( 0, 115, 0 );
    
    s_clouds[ 30 ] = ( 9046.99, -7427.16, -63.3169 );
    s_clouds_angles[ 30 ] = ( 0, 140, 0 );

    //farm to power
    s_clouds[ 31 ] = ( 6912.46, -3669.56, -77.1419 );
    s_clouds_angles[ 31 ] = ( 0, 50, 0 );
    
    s_clouds[ 32 ] = ( 6223.96, -3657.05, -66.7596 );
    s_clouds_angles[ 32 ] = ( 0, 50, 0 );

    s_clouds[ 33 ] = ( 6319.81, -2871.02, -81.0396 );
    s_clouds_angles[ 33 ] = ( 0, 50, 0 );
    
    s_clouds[ 34 ] = ( 8117.48, -1659.82, -204.246 );
    s_clouds_angles[ 34 ] = ( 0, 50, 0 );

    s_clouds[ 35 ] = ( 9986.02, -1908.83, -220.138 );
    s_clouds_angles[ 35 ] = ( 0, 140, 0 );
    
    s_clouds[ 36 ] = ( 11561.7, -850.341, -147.589 );
    s_clouds_angles[ 36 ] = ( 0, 130, 0 );

    s_clouds[ 37 ] = ( 13271.3, -2046.13, -247.138 );
    s_clouds_angles[ 37 ] = ( 0, 140, 0 );
    
    s_clouds[ 38 ] = ( 11224.6, 1171.6, -171.453 );
    s_clouds_angles[ 38 ] = ( 0, 50, 0 );

    //aftercorn
    s_clouds[ 39 ] = ( 8238.97, 1985.01, -90.11 );
    s_clouds_angles[ 39 ] = ( 0, 50, 0 );
    
    s_clouds[ 40 ] = ( 8609.69, 4246.69, -249.211 );
    s_clouds_angles[ 40 ] = ( 0, 50, 0 );

    s_clouds[ 41 ] = ( 11247.1, 4912.77, -569.414 );
    s_clouds_angles[ 41 ] = ( 0, 140, 0 );
    
    s_clouds[ 42 ] = ( 6347.65, 6506.32, -307.448 );
    s_clouds_angles[ 42 ] = ( 0, 50, 0 );

    s_clouds[ 43 ] = ( 7499.03, 7864.62, -461.286 );
    s_clouds_angles[ 43 ] = ( 0, 50, 0 );
    
    s_clouds[ 44 ] = ( 2478.6, 2800.37, -83.1678 );
    s_clouds_angles[ 44 ] = ( 0, 50, 0 );

    //town to depo
    s_clouds[ 45 ] = ( -1040.28, -469.393, -51.6468 );
    s_clouds_angles[ 45 ] = ( 0, 140, 0 );
    
    s_clouds[ 46 ] = ( -2038.54, -450.258, -282.37 );
    s_clouds_angles[ 46 ] = ( 0, 140, 0 );

    s_clouds[ 47 ] = ( -3467.76, -330.595, -36.875 );
    s_clouds_angles[ 47 ] = ( 0, 100, 0 );
    
    s_clouds[ 48 ] = ( -4516.3, 610.547, 139.25 );
    s_clouds_angles[ 48 ] = ( 0, 85, 0 );

    s_clouds[ 49 ] = ( -5330.02, -1782.53, 389.442 );
    s_clouds_angles[ 49 ] = ( 0, 85, 0  );
    
    s_clouds[ 50 ] = ( -5323.78, 2016.67, 143.542 );
    s_clouds_angles[ 50 ] = ( 0, -50, 0 );

    s_clouds[ 51 ] = ( -5080.08, 3426.57, 13.7789 );
    s_clouds_angles[ 51 ] = ( 0,  0, 0 );
    wait 0.1;
    for( s = 0; s < s_clouds.size; s++ )
    {
        if( s % 2 == 0 )
        {
            playfx( level.myfx[ 54 ], s_clouds[ s ] + ( 0, 0, 120 ) );
        }
        wait 0.05;
    }


    /*
    additionals_ = [];
    additionals_[ 0 ] = ( -6787.86, 3452.32, -63.876 );
    additionals_[ 1 ] = ( -5377.04, 6327.72, -55.4404 );
    additionals_[ 2 ] = ( -4485.45, 3228.66, 329.975 );
    additionals_[ 3 ] = ( -4441.17, 4419.55, 289.752 );
    additionals_[ 4 ] = ( -7272.83, 6609.01, -63.875 );
    additionals_[ 5 ] = ( -8759.34, 5877.07, -65.1173 );
    additionals_[ 6 ] = ( -7265.08, 5724.17, -54.7961 );
    additionals_[ 7 ] = ( -9563.83, 4634.34, 69.608 );
    additionals_[ 8 ] = ( -8383.65, 3447.82, 82.7749 );
    additionals_[ 9 ] = ( -8645.03, -7283.45, 169.275 );
    
    additionals_[ 10 ] = ( -7180.52, -5648.57, 222.368 );
    additionals_[ 11 ] = ( -8225.27, -6006.38, 470.84 );
    additionals_[ 12 ] = ( -8806.7, -5885.36, 782.162 );
    additionals_[ 13 ] = ( -7592.25, -8543.07, 85.1153 );
    additionals_[ 14 ] = ( -5835.58, -5358.36, -51.6978 );
    additionals_[ 15 ] = ( -6519.96, -4957.41, 138.277 );
    additionals_[ 16 ] = ( -4493.95, -4400.5, -68.036 );
    additionals_[ 17 ] = ( -3488.6, -4668.05, -72.26171 );
    additionals_[ 18 ] = ( -3879.77, -8010.38, -69.5368 );
    additionals_[ 19 ] = ( -992.585, -4141.89, 76.2352 );
    additionals_[ 20 ] = ( 606.892, -5479.85, -77.2147 );

    additionals_[ 20 ] = ( -171.934, -6208.59, 566.883 );
    additionals_[ 21 ] = ( 2145.04, -4693.16, 239.47 );
    additionals_[ 22 ] = ( 500.026, -2882.91, 43.3997 );
    additionals_[ 23 ] = ( 2540.27, -2269.4, -74.4917 );
    additionals_[ 24 ] = ( 5256.97, -7242, -261.231 );
    additionals_[ 25 ] = ( 7448.39, -6727.46, -142.6316 );
    additionals_[ 26 ] = ( 7376.88, -6286.85, -95.616 );
    additionals_[ 27 ] = ( 6459.99, -2476.53, -77.4951 );
    additionals_[ 28 ] = ( 8241.62, -2518.64, -215.559 );
    additionals_[ 29 ] = ( 13153.9, 349.257, -193.719 );
    additionals_[ 30 ] = ( 11037.8, 28.0244, -228.397 );

    additionals_[ 31 ] = ( 10535.2, -311.953, -212.68 );
    additionals_[ 32 ] = ( 7477.89, 2607.35, -25.43 );
    additionals_[ 33 ] = ( 7678.31, 3909.53, -85.3815 );
    additionals_[ 34 ] = ( 8042.72, 6257.24, -539.968 );
    additionals_[ 35 ] = ( 9897.91, 5673.47, -554.522 );
    additionals_[ 36 ] = ( 9038.15, 7160.91, -448.163 );
    additionals_[ 37 ] = ( 11675.6, 7903.3, -481.263 );
    additionals_[ 38 ] = ( 11160.1, 7146.16, -529.225 );
    additionals_[ 39 ] = ( 8341.64, 9599.88, -559.752 );
    additionals_[ 40 ] = ( 7683.35, 9669.89, -295.262 );

    additionals_[ 41 ] = ( 6925.29, 8656.05, -412.092 );
    additionals_[ 42 ] = ( 8444.47, 8168.17, -560.331 );
    additionals_[ 43 ] = ( 6116.75, 8215.33, -110.227 );
    additionals_[ 44 ] = ( 5742.21, 6984.66, -83.7066 );
    additionals_[ 45 ] = ( 3856.93, 7679.59, 31.8998 );
    additionals_[ 46 ] = ( 3871.5, 6344.07, -67.4809 );
    additionals_[ 47 ] = ( 3123.58, 4642.99, -70.4388 );
    additionals_[ 48 ] = ( 5412.66, 5168.34, 1.54161 );
    additionals_[ 49 ] = ( 5994.37, 3726.11, 108.611 );
    additionals_[ 50 ] = ( 4583.95, 3575.1, 46.5158 );


    additionals_[ 51 ] = ( 888.177, 2348.24, 38.3635 );
    additionals_[ 52 ] = ( 987.791, 3692.94, 88.3667 );
    additionals_[ 53 ] = ( 2523.83, 4091.14, -4.36902 );
    additionals_[ 54 ] = ( 2288.25, 4747.11, 407.878 );
    additionals_[ 55 ] = ( 403.664, 2006.44, 233.062 );
    additionals_[ 56 ] = ( 2437.78, 874.966, -63.875 );
    additionals_[ 57 ] = ( 3159.41, -451.666, -123.456 );
    additionals_[ 58 ] = ( -5585.7, -510.778, 116.344 );
    additionals_[ 59 ] = ( -5886.36, 872.562, 247.875 );
    additionals_[ 60 ] = ( -9235.19, 4189.46, 40.0473 );

    wait 1;
    for( s = 0; s < additionals_.size; s++ )
    {
        if( s % 2 == 0 )
        {
            s = randomint( 10 );
            if( s >= 3 )
            {
                playfx( level.myfx[ 54 ], additionals_[ s ] + ( 0, 0, 65 ) );
            }
            
            wait 0.05;
        }
        
    }
    */
    for( a = 0; a < 2; a++ )
    {
        spaw = spawn( "script_model", ( 2541.46, 2252.9, 69.0502 ) );
        spaw setmodel( "t5_foliage_tree_burnt03" );
        spaw.angles = ( 0, randomint( 180 ), 0 );
        wait 0.1;
    }
}
spawn_fog_on_player()
{
    flag_wait( "initial_blackscreen_passed" );


    while( true )
    {
        if( level.players[ 0 ] adsButtonPressed() && level.players[ 0 ] meleeButtonPressed() )
        {
            iprintlnbold( "YUUUUUUPPPPPPPPPPPPPPPPPPPPP" );
            wait 1;
            mod = spawn( "script_model", level.players[ 0 ].origin );
            mod setmodel( "tag_origin" );
            mod.angles = level.players[ 0 ].angles;
            wait 0.1;
            //playfxontag( level.myFx[ 54 ], mod, "tag_origin" );
            playfxontag( level.myFx[ 59 ], mod, "tag_origin" );
        }
        wait .05;
    }
    
}

ambers()
{
    level endon( "end_game" );
    orgs = [];
    orgs[ 0 ] = ( -5644.66, 4320.76, -34.2929 );
    orgs[ 1 ] = ( -6138.99, 4674.71, -60.8051 );
    orgs[ 2 ] = ( -6942.86, 4410.85, -62.2278 );
    orgs[ 3 ] = ( -7211.82, 4752.48, -63.875 );
    orgs[ 4 ] = ( -8055.31, 4780.03, -54.7853 );
    orgs[ 5 ] = ( -9090.45, 4666.78, 4.00833 );
    orgs[ 6 ] = ( -9421.74, 3686.05, 137.624 );
    orgs[ 7 ] = ( -10206.4, 2441.83, 196.125 );
    orgs[ 8 ] = ( -10826.6, 1154.34, 218.614 );
    orgs[ 9 ] = ( -9387.3, -6327.68, 192.125 );
    orgs[ 10 ] = ( -8149.6, -6613.64, 143.059 );
    orgs[ 11 ] = ( -7761.82, -7633.02, 78.154 );
    orgs[ 12 ] = ( -6980.56, -6829.75, -9.63407 );
    orgs[ 13 ] = ( -6190.02, -7108.59, 110.504 );
    orgs[ 14 ] = ( -6044.8, -6003.77, -58.0455 );
    orgs[ 15 ] = ( -5189.15, -5528.2, -64.4643 );
    orgs[ 16 ] = ( -5090.52, -6645.43, 197.754 );
    orgs[ 17 ] = ( -5119.6, -7628.16, -63.875 );
    orgs[ 18 ] = ( -4116.75, -7308.83, 10.0233 );
    orgs[ 19 ] = ( -4285.81, -6755.2, -50.0769 );
    orgs[ 20 ] = ( -3424.55, -6854.08, -68.2033 );
    orgs[ 21 ] = ( -2069.57, -7574.03, -59.7693 );
    orgs[ 22 ] = ( -1830.38,  -5144.85, -65.875 );
    orgs[ 23 ] = ( -55.1735, -5094.81, 57.9505 );
    orgs[ 24 ] = ( 1026.33, -4376.48, -42.1477 );
    orgs[ 25 ] = ( 1726.23, -3195.17, -3.20987 );
    orgs[ 26 ] = ( 2462.67, -5556.67, 1.69605 );
    orgs[ 27 ] = ( 4390.36, -5315.75, 192.164 );
    orgs[ 28 ] = ( 5182.87, -5971.45, -61.8278 );
    orgs[ 29 ] = ( 6370.35, -5252.07, -48.035 );
    orgs[ 30 ] = ( 7036.18, -5911.33, -23.9099 );
    orgs[ 31 ] = ( 8160.11, -5061.53, 48.125 );
    orgs[ 32 ] = ( 6660.15, -3466.94, -74.9221 );
    orgs[ 33 ] = ( 8491.34, -2270.33, -166.87 );
    orgs[ 34 ] = ( 9815.16, -1656.66, -168.615 );
    orgs[ 35 ] = ( 11298.3, -1775.34, -170.303 );
    orgs[ 36 ] = ( 12225.9, -709.542, 5.78669 );
    orgs[ 37 ] = ( 13354.8, -566.375, -210.329 );
    orgs[ 38 ] = ( 10735.3, 56.2846, -224.839 );
    orgs[ 39 ] = ( 9193.37, 949.191, -152.339 );
    orgs[ 40 ] = ( 7667.69, -485.364, -168.181 );
    orgs[ 41 ] = ( 7309.05, -1183.9, -152.12 );
    orgs[ 42 ] = ( 8286.48, 4253.04, -264.523 );
    orgs[ 43 ] = ( 8745.13, 5488.12, -469.04 );
    orgs[ 44 ] = ( 8155.57, 4492.49, -309.066 );
    orgs[ 45 ] = ( 9739.1, 6596.16, -565.387 );
    orgs[ 46 ] = ( 10493.6, 7165.68, -572.052 );
    orgs[ 47 ] = ( 10974.8, 7789.79, -581.056 );
    orgs[ 48 ] = ( 11022, 8672.02, -366.103 );
    orgs[ 49 ] = ( 10724.5, 8312.12, -281.83 );
    orgs[ 50 ] = ( 9931.71, 9202.29, -568.883 );
    orgs[ 51 ] = ( 5315.51, 7377.68, -50.5582 );
    orgs[ 52 ] = ( 4778.7, 7399.49, -63.875 );
    orgs[ 53 ] = ( 4353.17, 6071.62, -63.875 );
    orgs[ 54 ] = ( 3610.61, 4871.28, -63.875 );
    orgs[ 55 ] = ( 2016.07, 3088.44, -69.8664 );
    orgs[ 56 ] = ( 2794.76, 1345.34, 90.1679 );
    orgs[ 57 ] = ( 2232.9, 367.555, 212.195 );
    orgs[ 58 ] = ( 1477.67, -196.12, -61.875 );
    orgs[ 59 ] = ( 1577.67, -196.12, -61.875 );
    orgs[ 60 ] = ( -158.355, -449.03, -61.875 );
    orgs[ 61 ] = ( -1620.61, -441.824, -11.2746 );
    orgs[ 62 ] = ( -2973.61, -523.609, -103.588 );
    orgs[ 63 ] = ( -4187.3, -449.144, 41.4082 );
    orgs[ 64 ] = ( -4937.33, 1039.05, 206.089 );
    orgs[ 65 ] = ( -6313.36, 244.941, 635.782 );
    
    wait 1;

    for( s = 0; s < orgs.size; s++ )
    {
        if( s % 2 != 0 )
        {
            playfx( level.myFx[ 59 ], orgs[ s ] );
            wait 0.25;
        }
    }
    if( level.dev_time ){ iprintlnbold( "ALL EMBERS FLOATED#"); }
    
}
apply_visuals()
{
    level endon( "end_game" );
    while( true )
    {
        level waittill( "connected", someone );
        someone thread apply_new_initials();
    }
    
}

apply_new_initials()
{
    self endon( "disconnect" );
    while( true )
    {
        self waittill( "spawned_player" );
        self thread tranzit_2024_visuals();
    }
    

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


sky_carousel() //from original tranzit reimagined and tweaked a bit
{
    level endon ( "game_ended" );
    self endon ( "disconnect" );

    poopoo = 0;
    while( true )
    {
        poopoo += 0.05;

        if( poopoo >= 360 ) // sky box rotation == 360 so if the value = 360, return really close to the default value 0 ( this case 0.05 )
        {
            poopoo = 0;
        }
        self setClientDvar( "r_skyrotation", poopoo );

        wait 0.05; //might want to use 0.005 instead
    }
}