//not sure yet  if just high thought or what
//but have the player go to town bar
//and theres like 6 different dringks on th e bar counter
//make player dRINK THEM cos he needs to be drunk 
//cos he need to be in state of mind to hear the beeping that reveals
//a secret keycard that is required for pylon to continue
//and the keycard must be in town close
//cos players view and moement is slurred due to alcohol stuff lol
//once they find it
//schruder teleports them underneath the pylon where they can insert it into a machine
//once they do that they suddenly pass out / fade to black
//then wake up and see something different happening dunnno what yet
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
    precachemodel( "collision_player_128x128x128" );
    precachemodel( "collision_clip_64x64x256" );
    precachemodel( "collision_clip_128x128x10" );
    level.powers_restored = 0;
    level.sc_flying_in_progress = false;
    level.sc_doing_loop = false;
    level.s_moves_bank = [];
    level.s_moves_bank_loopable = [];
    level.s_moves_power = [];
    level.s_moves_power_loopable = [];
    level.s_moves_farm = [];
    level.s_moves_farm_loopable = [];
    level.s_moves_diner = [];
    level.s_moves_diner_loopable = [];
    level.power_outtage_active = false;
    level.powerguy_flyer = undefined;
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    level.power_outtage_blocker_diner = ( -3802.2, -7326.63, -59.4137 );
    level.power_outtage_trigger_diner = ( -3538.66, -7302.32, -58.875 );
    level.power_outtage_model_diner = ( -3512.7, -7301.09, -23.8475 );
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    level.power_outtage_blocker_farm = ( 8738.65, -5889.86, 51.3286 );
    level.power_outtage_blocker2_farm = ( 8455.99, -5741.28, 50.4498 );
    level.power_outtage_trigger_farm = ( 8790.66, -5652.11, 50.125 );
    level.power_outtage_model_farm = ( 8805.36, -5635.39, 94.6612 );
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    level.power_outtage_blocker_power = ( 10631.8, 8576.22, -356.864 );
    level.power_outtage_blocker2_power = ( 10615.9, 8196.6, -407.875 ); //angles( 0, -118, 0 );
    level.power_outtage_blocker3_power = ( 10737.1, 8147, -407.875 );
    level.power_outtage_blocker4_power = ( 10944, 8445.54, -404.394 );
    level.power_outtage_trigger_power = ( 10799.7, 8357.99, -407.87 );
    level.power_outtage_model_power = ( 10773.4, 8356.86, -359.048 );
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    level.power_outtage_trigger_bank = ( 882.342, 258.358, -39.875 );
    level.power_outtage_model_bank = ( 921.818, 259.005, 4.27847 );
    level.power_outtage_blocker_bank = ( 1092.36, 470.258, -39.875 );
    level.power_outtage_blocker2_bank = ( 1031.25, -15.3066, -39.875 ); //an gles ( 0, -41, 0 );
    level.power_outtage_blocker3_bank = ( 631.584, 292.822, -39.9108 );
    movable_locations();

    flag_wait( "initial_blackscreen_passed" );
    //level thread wait_players_at_pylon();//debugging for 7/12/2024
    wait 0.1;
    level waittill( "drunk_state_over" );
    level thread do_dialog_about_tunnel_help();
    level thread spawn_all_distance_checkers();
    //level thread spawn_all_triggers();
   
    level thread spawn_tunnel_stuff();
    //level thread spawn_alley_stuff();
    level thread spawn_alley_stuff_better();
    
}

do_dialog_about_tunnel_help()
{
    level endon( "end_game" );
    wait 2.5;
    foreach( p in level.players ){   p thread daytime_preset();  }
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread do_dialog_here( "Hahaa, you've had your fun ha?", "I'm still looking for an ^3Tranceiver^8.", 5, 1 );
    wait 8;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread do_dialog_here( "The ^3Tranceiver ^8has long been gone and yours is broken..", "We might be able to locate the device from another dimension.", 7, 1 );
    wait 9;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread do_dialog_here( "Let me spawn a ^9Back In Time Teleporter^8 for you in the tunnels.", "^8It should be there in a second..", 7, 1 );
    wait 10;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread do_dialog_here( "See if you're able to pick the device up,", "once you have located it.", 7, 1 );
    wait 5;
    PlaySoundAtPosition(level.jsn_snd_lst[ 30 ], level.players[ 0 ].origin );
     PlaySoundAtPosition( "mus_zombie_round_start", level.players[ 0 ].origin );
    level thread scripts\zm\zm_transit\warmer_days_sq_rewards::print_text_middle( "^9Distant Memories", "^8Now this guy want's me to go back in time..", "..thru some sort of teleporter ring?", 6, 0.25 );
}
movable_locations()
{
    level endon( "end_game" );

    level.s_moves_bank[ 0 ] = ( 1464.31, 111.155, 14.4462 ); //initial spawn location
    level.s_moves_bank[ 1 ] = ( 1283.46, -141.564, 104.106 ); //above outside bank door
    level.s_moves_bank[ 2 ] = ( 1074.23, -62.5663, -51.469 ); //on the ground level outside bank door
    level.s_moves_bank[ 3 ] = ( 974.595, 111.774, -15.8663 ); //first inside location, close to table trigger on ground level
    level.s_moves_bank[ 4 ] = ( 1040.46, 407.776, 54.8973 ); //front of second door above
    level.s_moves_bank[ 5 ] = ( 839.248, 319.047, -27.76 ); //middle floor 
    level.s_moves_bank[ 6 ] = ( 643.546, 284.636, 20.5379 ); //front of vault door

    //rest are loopaple spots till the power purge is done on said location
    level.s_moves_bank_loopable[ 0 ] = ( 713.763, -33.6061, 15.3931 );
    level.s_moves_bank_loopable[ 1 ] = ( 890.484, 121.163, 66.5712 );
    level.s_moves_bank_loopable[ 2 ] = ( 684.331, 490.875, 9.17383 );
    level.s_moves_bank_loopable[ 3 ] = ( 1023.15, 386.599, 38.6058 );
    level.s_moves_bank_loopable[ 4 ] = ( 811.61, 405.953, -24.2103 );
    level.s_moves_bank_loopable[ 5 ] = ( 1055.84, 14.6518, 9.95272 );
    level.s_moves_bank_loopable[ 6 ] = ( 1058.32, 269.222, 6.19587 );



    level.s_moves_power[ 0 ] = ( 10481.2, 7661.34, -504.967 ); //initial front of power
    level.s_moves_power[ 1 ] = ( 10810.6, 7798.88, -499.108 ); //outside still but between cars
    level.s_moves_power[ 2 ] = ( 10639.9, 8057.74, -309.086 );
    level.s_moves_power[ 3 ] = ( 10249.7, 8071.65, -536.099 );
    level.s_moves_power[ 4 ] = ( 10699.7, 8241.32, -350.935 );

    level.s_moves_power_loopable[ 0 ] = ( 10889.8, 8222.04, -256.23 );
    level.s_moves_power_loopable[ 1 ] = ( 11080, 8662.01, -417.143 );
    level.s_moves_power_loopable[ 2 ] = ( 11324, 8272.8, -357.275 );
    level.s_moves_power_loopable[ 3 ] = ( 10645.1, 8454.96, -235.52 );
    level.s_moves_power_loopable[ 4 ] = ( 10737.2, 8843.02, -336.239 );
    level.s_moves_power_loopable[ 5 ] = ( 11062.6, 8736.99, -328.278 );




    level.s_moves_farm[ 0 ] = ( 6619.77, -5773.26, -30.8415 );
    level.s_moves_farm[ 1 ] = ( 6958.56, -5518.39, -13.8276 );
    level.s_moves_farm[ 2 ] = ( 7089.39, -5795.07, 87.7156 );
    level.s_moves_farm[ 3 ] = ( 7465.36, -5731.23, -23.5908 );
    level.s_moves_farm[ 4 ] = ( 7953.99, -5542.49, 234.764 );
    level.s_moves_farm[ 5 ] = ( 8767.59, -5733.2, 442.503 );
    level.s_moves_farm[ 6 ] = ( 8738.99, -5734.94, 61.9192 );



    level.s_moves_farm_loopable[ 0 ] = ( 8782.48, -5847.77, 110.129 );
    level.s_moves_farm_loopable[ 1 ] = ( 8478.08, -5746.18, 205.759 );
    level.s_moves_farm_loopable[ 2 ] = ( 8680.94, -5670.54, 195.182 );
    level.s_moves_farm_loopable[ 3 ] = ( 8599.38, -5870.15, 114.497 );




    level.s_moves_diner[ 0 ] = ( -4358.13, -7212.59, -40.0173 );
    level.s_moves_diner[ 1 ] = ( -4105.87, -7169.17, 67.5888 );
    level.s_moves_diner[ 2 ] = ( -4045.84, -7454.3, 3.57285 );
    level.s_moves_diner[ 3 ] = ( -3857.31, -7316.94, -57.4517 );
    level.s_moves_diner[ 4 ] = ( -3542.43, -7370.43, -61.0398 );


    level.s_moves_diner_loopable[ 0 ] = ( -3768.14, -7330.36, -47.0468 );
    level.s_moves_diner_loopable[ 1 ] = ( -3975.11, -7325.36, -35.8016 );
    level.s_moves_diner_loopable[ 2 ] = ( -4094.44, -7481.78, 70.7828 );
    level.s_moves_diner_loopable[ 3 ] = ( -4199.86, -7258.33, -49.1949 );

}


spawn_all_distance_checkers()
{
    level endon( "end_game" );
    level waittill( "power_out_talks_completed" );
    wait 0.1;
    dst_diner = spawn( "script_model", level.s_moves_diner[ 0 ] );
    dst_diner setmodel( "tag_origin" );
    dst_diner.angles = ( 0, 0, 0 );
    wait 0.05;
    dst_diner thread monitor_if_close_and_delete( level.s_moves_diner, level.s_moves_diner_loopable );
    //==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/

    wait 0.1;
    dst_farm = spawn( "script_model", level.s_moves_farm[ 0 ] );
    dst_farm setmodel( "tag_origin" );
    dst_farm.angles = ( 0, 0, 0 );
    wait 0.05;
    dst_farm thread monitor_if_close_and_delete( level.s_moves_farm, level.s_moves_farm_loopable );
    //==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/

    wait 0.1;
    dst_power = spawn( "script_model", level.s_moves_power[ 0 ] );
    dst_power setmodel( "tag_origin" );
    dst_power.angles = ( 0, 0, 0 );
    wait 0.05;
    dst_power thread monitor_if_close_and_delete( level.s_moves_power, level.s_moves_power_loopable );
    //==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/

    wait 0.1;
    dst_bank = spawn( "script_model", level.s_moves_bank[ 0 ] );
    dst_bank setmodel( "tag_origin" );
    dst_bank.angles = ( 0, 0, 0 );
    wait 0.05;
    dst_bank thread monitor_if_close_and_delete( level.s_moves_bank, level.s_moves_bank_loopable );
    //==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/
}


nighttime_preset()
{ 
    
    self setclientdvar( "r_lighttweaksuncolor", ( 0.1, 0.4, 1 ) );
    self setclientdvar( "r_sky_intensity_factor0", 0.45 );

}

monitor_if_close_and_delete( which_initial, which_loop )
{
    level endon( "end_game" );
    self endon( "end_game" );
    //level waittill( "bowl_picked_up" );
    while( true )
    {
        //p = level.players;
        for( s = 0; s < level.players.size; s++ )
        {
            if( distance( level.players[ s ].origin, self.origin ) < 440 )
            {
                if( level.sc_flying_in_progress )
                {
                    wait 1;
                    if( level.dev_time ){ iprintlnbold( "CAN'T START NEW PROCESS BEFORE OTHER FLYING PROCESS IS FINISHED" ); }
                    continue;
                }
                else if( !level.sc_flying_in_progress )
                {
                    wait 0.1;
                    if( level.dev_time ){ iprintlnbold( "STARTING A NEW SCHRUDER FLYING IN PROCESS AND FREEZING OTHER MONITOR LOCATIONS");}
                    level thread spawn_s_to_do_stuff( which_initial, which_loop );
                    level.sc_flying_in_progress = true;
                    level.sc_doing_loop = true;
                    wait 1;
                    self delete();
                    break;
                }
                wait 0.1;
            }
            else { wait 0.05; }
        }
        wait 0.05;
        if( !isdefined( self ) )
        {
            wait 0.1;
            if( level.dev_time ){ iprintlnbold( "MONITOR TRIGGER: " + self + " is not defined, breaking out of loop" ); }
            break;
        }
        wait 0.25;
    }
}
spawn_all_triggers()
{
    level endon( "end_game" );

    power_outtage_trigger_diner = spawn( "trigger_radius_use", level.power_outtage_trigger_diner, 0, 58, 58 );
    power_outtage_trigger_diner setCursorHint( "HINT_NOICON" );
    power_outtage_trigger_diner setHintString( "^8[ ^9Restore Power ^8]\n^9[ ^8Requires all survivors to press ^3[{+activate}] ^8at the same time here ^9]" );
    power_outtage_trigger_diner TriggerIgnoreTeam();
    notifier_d = spawn( "script_model", level.power_outtage_model_diner );
    notifier_d setModel( "tag_origin" );
    notifier_d.angles = notifier_d.angles;
    wait 0.05;
    playfxontag( level.myfx[ 2 ], notifier_d, "tag_origin" );
    power_outtage_trigger_diner thread restore_power_on_press( notifier_d );

    //=======================================================================================================================================================//
    power_outtage_trigger_farm = spawn( "trigger_radius_use", level.power_outtage_trigger_farm, 0, 58, 58 );
    power_outtage_trigger_farm  setCursorHint( "HINT_NOICON" );
    power_outtage_trigger_farm  setHintString( "^8[ ^9Restore Power ^8]\n^9[ ^8Requires all survivors to press ^3[{+activate}] ^8at the same time here ^9]");
    power_outtage_trigger_farm  TriggerIgnoreTeam();
    notifier_f = spawn( "script_model", level.power_outtage_model_farm );
    notifier_f setModel( "tag_origin" );
    notifier_f.angles = notifier_f.angles;
    wait 0.05;
    playfxontag( level.myfx[ 2 ], notifier_f, "tag_origin" );
    power_outtage_trigger_farm thread restore_power_on_press( notifier_f );

    //=======================================================================================================================================================//
    power_outtage_trigger_power = spawn( "trigger_radius_use", level.power_outtage_trigger_power, 0, 58, 58 );
    power_outtage_trigger_power setCursorHint( "HINT_NOICON" );
    power_outtage_trigger_power setHintString( "^8[ ^9Restore Power ^8]\n^9[ ^8Requires all survivors to press ^3[{+activate}] ^8at the same time here ^9]");
    power_outtage_trigger_power TriggerIgnoreTeam();
    notifier_p = spawn( "script_model", level.power_outtage_model_power );
    notifier_p setModel( "tag_origin" );
    notifier_p.angles = notifier_p.angles;
    wait 0.05;
    playfxontag( level.myfx[ 2 ], notifier_p, "tag_origin" );
    power_outtage_trigger_power thread restore_power_on_press( notifier_p );

    //=======================================================================================================================================================//
    power_outtage_trigger_bank = spawn( "trigger_radius_use", level.power_outtage_trigger_bank, 0, 58, 58 );
    power_outtage_trigger_bank setCursorHint( "HINT_NOICON" );
    power_outtage_trigger_bank setHintString( "^8[ ^9Restore Power ^8]\n^9[ ^8Requires all survivors to press ^3[{+activate}] ^8at the same time here ^9]");
    power_outtage_trigger_bank TriggerIgnoreTeam();
    notifier_b = spawn( "script_model", level.power_outtage_model_bank );
    notifier_b setModel( "tag_origin" );
    notifier_b.angles = notifier_b.angles;
    wait 0.05;
    playfxontag( level.myfx[ 2 ], notifier_b, "tag_origin" );
    power_outtage_trigger_bank thread restore_power_on_press( notifier_b );
    
}

restore_power_on_press( n )
{
    level endon( "end_game" );
    self endon( "end_game" );

    while( true )
    {
        self waittill( "trigger", who );
        if( level.sc_doing_loop )
        {
            wait 0.05;
            self setHintString( "^8[ ^9Doctor Schruder is waiting you at another location ^8]" );
            wait 3.5;
            self sethintstring( "^8[ ^9Restore Power ^8]\n^9[ ^8Requires all survivors to press ^3[{+activate}] ^8at the same time here ^9]" );
            wait 0.05;
            continue;
        }
        else 
        {
            if( is_player_valid( who ) )
            {
                if( self.origin == level.power_outtage_trigger_diner )
                {
                    level thread scripts\zm\zm_transit\warmer_days_sq_rewards::reward_mini_quest_avogadro_zombies();
                    self setHintString( "^8[ ^2Power Restoring Started... ^8]" );
                    level thread do_power_restoring_lockdown( level.power_outtage_blocker_diner );
                    level thread power_store_visuals();
                    level.sc_flying_in_progress = true;
                    level.sc_doing_loop = true;
                    level.powers_restored++;
                    Earthquake( .5, 4,  self.origin, 1000 );
                    playfx( level.myFx[ 9 ], self.origin );
                    n movez( 150, 0.25, 0.1, 0 );
                    wait 0.3;
                    n delete();
                    wait 1;
                    self delete();
                    break;
                }
                else if( self.origin == level.power_outtage_trigger_farm )
                {
                    self setHintString( "^8[ ^2Power Restoring Started... ^8]" );
                    level thread scripts\zm\zm_transit\warmer_days_sq_rewards::reward_mini_quest_avogadro_zombies();
                    level thread do_power_restoring_lockdown( level.power_outtage_blocker_farm );
                    level thread power_store_visuals();
                    level.sc_flying_in_progress = true;
                    level.sc_doing_loop = true;
                    level.powers_restored++;
                    Earthquake( .5, 4,  self.origin, 1000 );
                    playfx( level.myFx[ 9 ] , self.origin );
                    n movez( 150, 0.25, 0.1, 0 );
                    wait 0.3;
                    n delete();
                    wait 1;
                    self delete();
                    break;
                }
                else if( self.origin == level.power_outtage_trigger_power )
                {
                    self setHintString( "^8[ ^2Power Restoring Started... ^8]" );
                    level thread scripts\zm\zm_transit\warmer_days_sq_rewards::reward_mini_quest_avogadro_zombies();
                    level thread do_power_restoring_lockdown( level.power_outtage_blocker_power );
                    level thread power_store_visuals();
                    level.sc_flying_in_progress = true;
                    level.sc_doing_loop = true;
                    level.powers_restored++;
                    Earthquake( .5, 4,  self.origin, 1000 );
                    playfx( level.myFx[ 9 ] , self.origin );
                    n movez( 150, 0.25, 0.1, 0 );
                    wait 0.3;
                    n delete();
                    wait 1;
                    self delete();
                    break;
                }
                else if( self.origin == level.power_outtage_trigger_bank )
                {
                    self setHintString( "^8[ ^2Power Restoring Started... ^8]" );
                    level thread scripts\zm\zm_transit\warmer_days_sq_rewards::reward_mini_quest_avogadro_zombies();
                    level thread do_power_restoring_lockdown( level.power_outtage_blocker_bank );
                    level thread power_store_visuals();
                    level.sc_flying_in_progress = true;
                    level.sc_doing_loop = true;
                    level.powers_restored++;
                    Earthquake( .5, 4,  self.origin, 1000 );
                    playfx( level.myFx[ 9 ], self.origin );
                    n movez( 150, 0.25, 0.1, 0 );
                    wait 0.3;
                    n delete();
                    wait 1;
                    self delete();
                    break;
                }
            }
        }
        wait 0.05;
    }
}
daytime_preset()
{ 
    //PlaySoundAtPosition(level.jsn_snd_lst[ 49 ], ( 0, 0, 0 ) );
    self setclientdvar( "r_lighttweaksuncolor", ( 0.62, 0.52, 0.46 ) );
    self setclientdvar( "r_sky_intensity_factor0", 2.4 );

}
waittill_powers_restored()
{
    level endon( "end_game" );
    while( level.powers_restored < 4 )
    {
        wait 1;
    }
    wait 5;
    level notify( "all_powered" );
    foreach( p in level.players ){   p thread daytime_preset();  }
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread do_dialog_here( "Excellent work!", "The power has been restored.", 5, 1 );
    wait 8;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread do_dialog_here( "Let's try meeting up again at the ^3Pylon^8.", "^8I'll be waiting for you there!", 7, 1 );
    wait 8;
    level notify( "stop_mus_load_bur" );


    //level notify( "spawn_mrs_for_final_time" );

}
do_power_restoring_lockdown( which_spot )
{

    level endon( "end_game" );
    if( which_spot == level.power_outtage_blocker_bank )
    {
        //do everything like this later
        blocker0 = spawn( "script_model", level.power_outtage_blocker_bank );
        blocker0 setmodel( "collision_player_128x128x128" );
        blocker0.angles = blocker0.angles;
        wait 0.05;
        playfxontag( level.myFx[ 78 ], blocker0, "tag_origin" );    
        wait 0.05;
        blocker1 = spawn( "script_model", level.power_outtage_blocker2_bank );
        blocker1 setmodel( "collision_player_128x128x128" );
        blocker1.angles = blocker0.angles;
        wait 0.05;
        playfxontag( level.myFx[ 78 ], blocker1, "tag_origin" );

        blocker2 = spawn( "script_model", level.power_outtage_blocker3_bank );
        blocker2 setmodel( "collision_player_128x128x128" );
        blocker2.angles = blocker0.angles;
        wait 0.1;
        //playfx( level.myfx[ 77 ], blocker0.origin );
        //playfx( level.myfx[ 77 ], blocker1.origin );
        //playfx( level.myfx[ 77 ], blocker2.origin );
        wait 0.05;
        wait 0.05;
        playfxontag( level.myFx[ 78 ], blocker2, "tag_origin" );
        level.sc_doing_loop = true;
        wait 45;
        playfx( level.myFx[ 94 ], blocker0.origin );
        playfx( level.myFx[ 94 ], blocker1.origin );
        playfx( level.myFx[ 94 ], blocker2.origin );
        blocker0 movez( -5000, 1, 0, 0 );
        blocker1 movez( -5000, 1, 0, 0 );
        blocker2 movez( -5000, 1, 0, 0 );
        wait 2;
        blocker0 delete();
        blocker1 delete();
        blocker2 delete();
        level.sc_doing_loop = false;
        level.sc_flying_in_progress = false;
        level notify( "stop_avogadro_shit" );
    }
    
    else if( which_spot == level.power_outtage_blocker_diner )
    {
        blocker0 = spawn( "script_model", level.power_outtage_blocker_diner );
        blocker0 setmodel( "collision_player_128x128x128" );
        blocker0.angles = blocker0.angles;
        wait 0.1;
        playfx( level.myfx[ 77 ], blocker0.origin );
        wait 0.05;
        playfxontag( level.myFx[ 78 ], blocker0, "tag_origin" );
        level.sc_doing_loop = true;
        wait 45;
        playfx( level.myFx[ 94 ], blocker0.origin );
        blocker0 movez( -5000, 1, 0, 0 );
        wait 2;
        blocker0 delete();
        level.sc_doing_loop = false;
        level.sc_flying_in_progress = false;
        level notify( "stop_avogadro_shit" );
    }

    else if( which_spot == level.power_outtage_blocker_power )
    {
        blocker0 = spawn( "script_model", level.power_outtage_blocker_power );
        blocker0 setmodel( "collision_player_128x128x128" );
        blocker0.angles = blocker0.angles;

        blocker1 = spawn( "script_model", level.power_outtage_blocker2_power );
        blocker1 setmodel( "collision_player_128x128x128" );
        blocker1.angles = blocker0.angles;

        blocker2 = spawn( "script_model", level.power_outtage_blocker3_power );
        blocker2 setmodel( "collision_player_128x128x128" );    
        blocker2.angles = blocker0.angles;
            
        wait 0.1;

        blocker3 = spawn( "script_model", ( 10948.2, 8446.59, -403.875 ) );
        blocker3 setmodel( "collision_player_128x128x128" );
        blocker3.angles = ( 0, 0, 0 );
        wait 0.1;
        playfx( level.myFx[ 94 ], blocker0.origin );
        playfx( level.myFx[ 94 ], blocker1.origin );
        playfx( level.myFx[ 94 ], blocker2.origin );
        playfx( level.myfx[ 94 ], blocker3.origin );
        wait 0.05;
        playfxontag( level.myFx[ 78 ], blocker0, "tag_origin" );
        playfxontag( level.myFx[ 78 ], blocker1, "tag_origin" );
        playfxontag( level.myFx[ 78 ], blocker2, "tag_origin" );
        playfxontag( level.myFx[ 78 ], blocker3, "tag_origin" );
        level.sc_doing_loop = true;
        wait 45;
        playfx( level.myFx[ 94 ], blocker0.origin );
        playfx( level.myFx[ 94 ], blocker1.origin );
        playfx( level.myFx[ 94 ], blocker2.origin );
        blocker0 movez( -5000, 1, 0, 0 );
        blocker1 movez( -5000, 1, 0, 0 );
        blocker2 movez( -5000, 1, 0, 0 );
        blocker3 movez( -5000, 1, 0, 0 );
        wait 2;
        blocker0 delete();
        blocker1 delete();
        blocker2 delete();
        blocker3 delete();
        level.sc_doing_loop = false;
        level.sc_flying_in_progress = false;
        level notify( "stop_avogadro_shit" );
    }


    if( which_spot == level.power_outtage_blocker_farm )
    {
        blocker0 = spawn( "script_model", level.power_outtage_blocker_farm );
        blocker0 setmodel( "collision_player_128x128x128" );
        blocker0.angles = blocker0.angles;
        blocker1 = spawn( "script_model", level.power_outtage_blocker2_farm );
        blocker1 setmodel( "collision_player_128x128x128" );
        blocker1.angles = blocker0.angles;
        wait 0.1;
        playfx( level.myFx[ 94 ], blocker0.origin );
        playfx( level.myFx[ 94 ], blocker1.origin );
        wait 0.05;
        playfxontag( level.myFx[ 78 ], blocker0, "tag_origin" );
        playfxontag( level.myFx[ 78 ], blocker1, "tag_origin" );
        level.sc_doing_loop = true;
        wait 45;
        playfx( level.myFx[ 94 ], blocker0.origin );
        playfx( level.myFx[ 94 ], blocker1.origin );
        blocker0 movez( -5000, 1, 0, 0 );
        blocker1 movez( -5000, 1, 0, 0 );
        wait 2;
        blocker0 delete();
        blocker1 delete();
        level.sc_doing_loop = false;
        level.sc_flying_in_progress = false;
        level notify( "stop_avogadro_shit" );
    }

    
}


spawn_s_to_do_stuff( which_location, which_location_loop )
{
    level endon( "end_game" );
    wait 0.1;
    sc = spawn( "script_model", which_location[ 0 ] + ( 0, 0, 10 ) );
    sc setmodel( level.automaton.model );
    sc.angles = ( -10, 0,  0 );
    wait 0.1;
    degree_tagger = spawn( "script_model", sc.origin );
    degree_tagger setmodel( "tag_origin" );
    degree_tagger.angles = ( 180, 0, 0 );

    playfxontag( level._effect[ "screecher_hole" ], degree_tagger, "tag_origin" );
    wait 0.1;
    playfxontag( level._effect[ "screecher_vortex" ], degree_tagger, "tag_origin" );

    degree_tagger enablelinkto();
    degree_tagger linkto( sc );
    _blocker = spawn( "script_model", sc.origin  );
    _blocker setmodel( "collision_geo_64x64x64_standard" );
    _blocker.angles = sc.angles;
    _blocker enableLinkTo();
    _blocker linkto( sc );
    Earthquake( .5, 4,  sc.origin, 1000 );
    playfxontag( level.myfx[ 2 ], sc, "tag_origin" ); 
    wait 0.1;
    playfxontag( level.myFx[ 86 ], sc, "tag_origin" );
    //sc thread move_and_delete();
    playfx( level.myFx[ 85 ], sc.origin );
    playfxontag( level._effect[ "screecher_vortex" ], sc, "tag_origin" );
    
    playfx( level.myfx[ 82 ], sc.origin );
    PlaySoundAtPosition( level.jsn_snd_lst[ 3 ], sc.origin );
    sc playLoopSound( "zmb_screecher_portal_loop", 2 );

    //do_initial_moves
    for( i = 0; i < which_location.size; i++ )
    {
        if( i == 1 )
        {
            playfxontag( level._effect[ "screecher_vortex" ], sc, "tag_origin" );
        }
        if( level.dev_time ) { iprintlnbold( "DOCTOR IS MOVING TO NEW INITIAL LOCATION" ); }
        sc moveto( which_location[ i ], 2, 1, 0.5 );
        sc rotateyaw( randomintrange( -250, 250 ), 2, 1, 0.5 );
        wait 2;
        playfx( level.myFx[ 94 ], sc.origin );
        PlaySoundAtPosition( level.jsn_snd_lst[ 4 ], sc.origin );
        if( level.dev_time ){ iprintlnbold( "DOCTOR HAS ROTATED, WAITING FOR PLAYER TO BE CLOSE"); }
        wait 0.05;
    }

    wait 0.05;
    if( level.dev_time ) { iprintlnbold( "DOCTOR IS MOVING TO LOOP LOCATIONS" ); } 

    sc moveto( which_location_loop[ 0 ] + ( 0, 0, 20 ), 3, 1, 0.2 );
    playfx( level.myFx[ 85 ], sc.origin );
    sc waittill( "movedone" );
    level.sc_doing_loop = false;
    level.sc_flying_in_progress = false;
    if( level.sc_doing_loop == false )
    {
        while( level.sc_doing_loop == false )
        {
            sc movez( 30, 1.5, 0.25, 0.25 );
            wait 1.5;
            sc movez( -30, 1.5, 0.25, 0.25 );
            wait 1.5;
        }
    }
    first_time = true;
    while( level.sc_doing_loop || level.sc_flying_in_progress  )
    {
        for( a = 0; a < which_location_loop.size; a++ )
        {
            playfx( level.myFx[ 85 ], sc.origin );
            sc moveto( which_location_loop[ a ], 2, randomfloatrange( 0.3, 0.6 ), randomfloatrange( 0.2, 0.4 ) );
            PlaySoundAtPosition(level.jsn_snd_lst[ 4 ], sc.origin );
            sc rotateyaw( randomintrange( -250, 250 ), 2, 1, 0.5 );
            sc waittill( "movedone" );
            if( !level.sc_doing_loop || !level.sc_flying_in_progress  )
            {
                break;
            }
            for( i = 0; i < 2; i++ )
            {
                playfx( level.myFx[ 94 ], sc.origin );
                sc movez( 35, 1.5, 0.25, 0.25 );
                sc rotateYaw( randomintrange( -150, 150 ), 1.5, 0.25, 0.25 );
                sc waittill( "movedone" );
                if( !level.sc_doing_loop || !level.sc_flying_in_progress  )
                {
                    break;
                }
                sc movez( -35, 1.5, 0.25, 0.25 );
                sc rotateYaw( randomintrange( -150, 150 ), 1.5, 0.25, 0.25 );
                sc waittill( "movedone" );
                if( !level.sc_doing_loop || !level.sc_flying_in_progress  )
                {
                    break;
                }
            }
            playfx( level._effects[ 94 ], sc.origin );
            wait 0.05;
        }
    }
    playfx( level.myFx[ 85 ], sc.origin );
    sc movez( -10000, 0.2, 0, 0 );
    level.sc_doing_loop = false;
    level.sc_flying_in_progress = false;
    wait 2;
    sc delete();
    degree_tagger delete();
}

power_store_visuals()
{
    level endon( "end_game" );
    foreach( p in level.players )
    {
        p thread fade_to_black_on_impact_self_only();
    }
    wait 2;
    foreach( p in level.players )
    {
        p setClientDvar( "cg_colorsaturation", 0 );
    }
    while( level.sc_doing_loop )
    {
        wait 0.1;
    }
    
    foreach( p in level.players )
    {
        p thread fade_to_black_on_impact_self_only();
    }
    wait 2;
    foreach( p in level.players )
    {
        p setClientDvar( "cg_colorsaturation", 1 );
    }

}
monitor_if_sc_can_move_again()
{

    level endon( "end_game" );
    self endon( "can_move_agains" );
    while( isdefined( self ) )
    {
        for( s = 0; s <level.players.size; s++ )
        {
            if( distance( level.players[ s ].origin, self.origin ) < 150 )
            {
                wait 0.05;
                self notify( "can_move_again" );
                self notify( "can_move_agains");
            }
        }
        self movez( 25, 1, 0.2, 0.2 );
        wait 1;
        self movez( -25, 1, 0.2, 0.2 );
        wait 1;
    }
}







spawn_tunnel_stuff()
{
    level endon( "end_game" );

    teleporter_location = ( -11773.2, -2499.67, 228.125 );
    angs = ( 0, -90, 0 );

    //teleporter
    portal = spawn( "script_model", teleporter_location  );
    portal setmodel("p6_zm_screecher_hole" );
    portal.angles = angs;
    wait 0.1;
    playfx( level.myFx[ 44 ], portal.origin );

    side_portal = spawn( "script_model", ( -11773.2, -2536.48, 228.125 ) + ( 0, 0, 45 )   );
    side_portal setmodel( "tag_origin" );
    side_portal.angles = ( -90, -90, 0 );
    wait 0.1;
    playfxontag( level._effect[ "screecher_vortex" ], side_portal, "tag_origin" );
    //playfxontag( level.myFx[ 26 ], gun, "tag_origin" );
    //layfxontag( level.myFx[ 26 ], gun, "tag_origin" );
    playFXOnTag( level._effect[ "screecher_vortex" ], portal, "tag_origin" );
    portal playLoopSound( "zmb_screecher_portal_loop", 2 );
    playfxontag( level._effect[ "screecher_hole" ], portal, "tag_origin" );


    portal_blocker = spawn( "script_model", ( -11773.2, -2576.48, 228.125 ) + ( 0, 0, 45 )  );
    portal_blocker setmodel( "collision_geo_64x64x64_standard" );
    portal_blocker.angles = ( 0, 0, 0 );
    wait 0.1;




    //trigger notifier for portal
    trig = spawn( "trigger_radius_use", portal.origin, 350, 350, 350 );
    trig setCursorHint( "HINT_NOICON" );
    trig setHintString( "^9[ ^8All survivors must jump in the ^3Portal ^8at the same time ^9]" );
    trig TriggerIgnoreTeam();
    one_plus = 0;
    while( true )
    {
        for( s = 0; s < level.players.size; s++ )
        {
            if( distance( level.players[ s ].origin, portal.origin ) < 50  && !isdefined( level.players[ s ].has_this ) )
            {
                one_plus++;
            }
            wait 0.05;
        }
        if( one_plus >= level.players.size )
        {
            foreach( players in level.players )
            {
                players thread fade_to_black_on_impact_self_only();
                players freezeControls( true );
                players thread waiting_to_();
                players.has_this = true;
            }
            wait 2;
            trig delete();
            portal delete();
            portal_blocker delete();
            side_portal delete();
        }
        wait 0.1;
        one_plus = 0;
        wait 0.05;
    }
}

waiting_to_()
{
    level endon( "end_game" );
    wait 2;
    self thread back_in_time_visual_runner();
    wait 1;
    get_teleported_from_tunnel = ( 1855.54, -902.446, -40.0131 );
    get_teleported_from_tunnel_angs = ( 0, 0, 0 );
    self setorigin( get_teleported_from_tunnel + ( 0, 0, 15 ) );
    self setPlayerAngles( get_teleported_from_tunnel_angs );
    self freezeControls( false );
}
spawn_alley_stuff_better()
{
    level endon( "end_game" );

    //mod = spawn( "script_model", level.players[ 0 ].origin );
    //mod setmodel( level.mymodels[ 9 ] );
    //mod.angles = level.players[ 0 ].angles;
    /*
    while( true )
    {
        mod.origin = level.players[ 0 ].origin;
        mod.angles = level.players[ 0 ].angles;
        wait 0.05;
    }
    */
    
    fence_angs = [];
    fence_orgs = [];
    block_orgs = [];

    fence_orgs[ 0 ] = ( 2205.43, -1019.21, -49.9754 );
    fence_orgs[ 1 ] = ( 2281.93, -1086.66, -49.875 );

    fence_orgs[ 2 ] = ( 2314.24, -1210.47, -49.875 );
    fence_orgs[ 3 ] = ( 2314.34, -1366.61, -49.875 );
    fence_orgs[ 4 ] = ( 2314.34, -1492.31, -49.875 );
    fence_orgs[ 5 ] = ( 2361.27, -1481.52, -50.7598 );
    fence_orgs[ 6 ] = ( 2424.86, -1605.48, -49.875 );
    fence_orgs[ 7 ] = ( 2520.14, -1650.71, -49.875 );
    fence_orgs[ 8 ] = ( 2657.55, -1619.49, -49.875 );
    fence_orgs[ 9 ] = ( 2748.48, -1575.5, -47.875 );




    block_orgs[ 0 ] = ( 2205.43, -950.21, -49.9754 );
    block_orgs[ 1 ] = ( 2281.93, -1030.66, -49.875 );

    block_orgs[ 2 ] = ( 2352.24, -1210.47, -49.875 );
    block_orgs[ 3 ] = ( 2314.34, -1366.61, -49.875 );
    block_orgs[ 4 ] = ( 2314.34, -1492.31, -49.875 );
    block_orgs[ 5 ] = ( 2361.27, -1481.52, -50.7598 );
    block_orgs[ 6 ] = ( 2454.86, -1585.48, -49.875 );
    block_orgs[ 7 ] = ( 2550.14, -1620.71, -49.875 );
    block_orgs[ 8 ] = ( 2657.55, -1589.49, -49.875 );
    block_orgs[ 9 ] = ( 2748.48, -1545.5, -47.875 );




    fence_angs[ 0 ] = ( 0, -180, 0 );
    fence_angs[ 1 ] = ( 0, 125, 0 );

    fence_angs[ 2 ] = ( 0, 97, 0 );
    fence_angs[ 3 ] = ( 0, 90, 0 );
    fence_angs[ 4 ] = ( 0, 90, 0 );
    fence_angs[ 5 ] = ( 0, 110, 0 );
    fence_angs[ 6 ] = ( 0, 125, 0 );
    fence_angs[ 7 ] = ( 0, 177, 0 );
    fence_angs[ 8 ] = ( 0, -159, 0 );
    fence_angs[ 9 ] = ( 0, -155, 0 );
    //fence_angs[  ] = (  );
    //fence_angs[  ] = (  );
    //collision_clip_64x64x256

    s = fence_orgs.size;
    e = 0;
    real_id = 0;
    while( e < s )
    {
        piece_of_spawn[ real_id ] = spawn( "script_model", fence_orgs[ e ] );
        piece_of_spawn[ real_id ] setmodel( level.mymodels[ 9 ] );
        piece_of_spawn[ real_id ].angles = fence_angs[ e ];
        wait 0.05;
        real_id++;
        piece_of_spawn[ real_id ] = spawn( "script_model", block_orgs[ e ] );
        piece_of_spawn[ real_id ] setmodel( "collision_player_128x128x128" );
        piece_of_spawn[ real_id ].angles = fence_angs[ e ];
        e++;
        real_id++;
        wait 0.05;
    }
    


    
    get_teleported_from_tunnel = ( 1855.54, -902.446, -40.0131 );
    get_teleported_from_tunnel_angs = ( 0, 0, 0 );
    teleport_from = ( 2093.36, -1150.5, -51.2762 );
    fx_angs = ( 0, 0, 0);
    teleport_to = ( 2160.9, -1154.84, -49.875 );
    teleport_to_angs = ( 0, 10, 0 );

    washer_trigger_org = ( 2049.35, -914.738, -55.375 );

    washers_fx_orgs = [];
    washers_fx_orgs[ 0 ] = ( 2067.66, -917.076, -18.1618 );
    washers_fx_orgs[ 1 ] = ( 2067.47, -864.201, -18.2755 );
    washers_fx_orgs[ 2 ] = ( 2067.57, -817.785, -18.3318 );
    washers_fx_orgs[ 3 ] = ( 2067.75, -968.983, -18.4758 );
    washers_fx_orgs[ 4 ] = ( 2067.02, -1018.21, -18.5355 );
    fx_ags = ( 0, 0, 0 );

    wait 0.2;

    trig_ = spawn( "trigger_radius_use", ( 2049.36, -913.019, -55.375 ), 0, 48, 48 );
    trig_ setCursorHint( "HINT_NOICON" );
    trig_ setHintString( "^9[ ^3[{+activate}] ^8to spin ^3Laundry ^9]" );
    trig_ TriggerIgnoreTeam();

    while( true )
    {
        trig_ waittill( "trigger", who );
        if( !is_player_valid( who ) )
        {
            wait 0.05;
            continue;
        }
        else 
        {
            trig_ thread washers_( washers_fx_orgs, teleport_from, teleport_to );
            level notify( "washers_active" );
            PlaySoundAtPosition(level.jsn_snd_lst[ 30 ],who.origin );
            wait 0.1;
            trig_ delete();
            break;
        }
    }
    


}

bowlable_step()
{
    level endon( "end_game" );

    shootable_origin = ( 2536.14, -1367.14, 164.103 );
    

    fences = [];
    ang = ( 0, 180, 0 );
    fences[ 0 ] = ( 2655.78, -1956.29, -51.0492 );
    fences[ 1 ] = ( 2530, -1956.29, -51.0492 );
    fences[ 2 ] = ( 2404, -1956.29, -51.0492 );
    fences[ 3 ] = ( 2284, -1956.29, -51.0492 );


    wait 1; 
    blobs_ = [];
    for( s = 0; s < fences.size; s++ )
    {
        blops_[ s ] = spawn( "script_model", fences[ s ] );
        blops_[ s ]setmodel( level.mymodels[ 9 ] );
        blops_[ s ].angles = ( 0, 180, 0 );
        wait 0.1;
    }
    
    spawn_lighter = spawn( "script_model",  shootable_origin + ( 0, 0, 5 ) );
    spawn_lighter setmodel( "tag_origin" );
    spawn_lighter.angles = ( 5, 10, 0 );
    playfxontag( level.myFx[ 41 ], spawn_lighter, "tag_origin" );

    spawn_lighter thread waittill_someone_blows();
    wait 3;
    playfxontag( level.myFx[ 41 ], spawn_lighter, "tag_origin" );
    //next spawn the grenable object then move it to spot
    //then add trig for player to pick it  up
    // should be tranceiver or something as model wise..
    //after that players go under pylon to call help till everything breaks and theyre left to fight end game and not survive.
    //this is the idea, less than 2 days for release.. 
    //continue tomorrow

    level waittill( "bowl_picked_up" );
    wait 2.5;
    foreach( b in blops_ )
    {
        b delete();
    }

}

waittill_someone_blows()
{
    level endon( "end_game ");
    self endon( "end_game" );

    d_t = spawn( "trigger_damage", self.origin,  80, 80, 80 );
    
    d_t.health = 20;
    d_t setcandamage( true );
    playfxontag( level.myFx[ 0 ], self, "tag_origin" );
    d_t waittill( "damage" ); //don't define attacker so that only nades can hurt it
    playfx( level.myFx[ 92 ], self.origin );
    PlaySoundAtPosition(level.jsn_snd_lst[ 29 ], d_t.origin ); 
    d_t playloopsound( level.mysounds[ 11 ], 2 );
    self thread start_moving_strike_play();
    if( level.dev_time ){ iprintlnbold( "^5MOVING TO DO STRIKE PLAY PART" ); }
    wait 0.05;
    d_t delete();

}

start_moving_strike_play()
{
    self endon( "end_game" );
    level endon( "end_game" );

    landing_first = ( 2533.56, -1745.08, 26.1517 );
    landing_second = ( 2536.4, -1866.77, -34.9271 );
    landing_pickup = ( 2536.4, -2022.66, -14.3599 );


    Earthquake( .5, 4,  self.origin, 1000 );
    self moveto( landing_first, 2.5, 1, 0 );
    self waittill( "movedone" );
    self moveto( landing_second, 1.25, 0, 0.5 );
    self waittill( "movedone" );
    Earthquake( .1, 4,  self.origin, 1000 );
    playfxontag( level.myfx[ 2 ], self, "tag_origin" );
    self moveto( landing_pickup, 0.5, 0, 0.125 );
    self waittill( "movedone" );
    if( level.dev_time ){ iprintlnbold( "BOWL CAN BE PICKED UPPP" ); }

    self thread waittill_someone_picks_it();
}

waittill_someone_picks_it()
{
    self endon( "end_game" );
    level endon( "end_game" );
    level endon( "stop_this_waittill" );
    level thread fade_back_to_regular_tranzit();
    while( true )
    {
        for( s = 0; s < level.players.size; s++ )
        {
            if( distance( level.players[ s ].origin, self.origin ) < 75 )
            {
                wait 0.05;
                if( level.players[ s ] useButtonPressed() )
                {
                    PlaySoundAtPosition(level.mysounds[ 3 ], self.origin );
                    wait 0.05;
                    self delete();
                    level notify( "bowl_picked_up" );
                    level thread do_meet_at_pylon_text();
                    wait 0.05;
                    level notify( "stop_this_waittill" );
                    break;
                }
            }
            wait 0.05;
        }
        wait 0.05;
    }
}

do_meet_at_pylon_text()
{
    level endon( "end_game" );
    wait 4.5;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread do_dialog_here( "^8Fantastic! You received the ^9Tranceiver!", "^8Let's meet underneath the pylon.", 8, 1 );
    wait 11;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread do_dialog_here( "^8We can call help once we've applied the ^9Tranceiver ^8to the ^9Pylon^8.", "^8Be quick, I'll be waiting for you. No hurries tho haha!", 10, 1 );
    wait 12;
    level thread wait_players_at_pylon();

    level thread spawn_all_triggers();
}

wait_players_at_pylon()
{
    level endon( "end_game" );
    outburst = 0;
    location = ( 7457.21, -431.969, -195.816 );
    zone_to_touch = getent( "sq_common_area", "targetname" );
    ss = spawn( "trigger_radius_use", location, 0, 48, 48 );
    ss setcursorhint( "HINT_NOICON" );
    ss sethintstring( "^9[ ^3[{+activate}] ^8to apply your ^3Tranceiver^8 to the transmitter ^9]" );
    ss triggerignoreteam();
    wait 0.1;
    sa = spawn( "script_model", ss.origin + ( 0, 0, 50 ) );
    sa setmodel( "tag_origin" );
    sa.angles = ( 5, 10, 0 );
    
    wait 1;
    //sa playloopsound( "zmb_screecher_portal_loop", 2 );

    //go into power outtage with this
    while( true )
    {
        ss waittill( "trigger", who );
        if( is_player_valid( who ) )
        {
            ss sethintstring( "^8[ ^2Tranceiver ^8was added ^8]" );
            PlaySoundAtPosition(level.jsn_snd_lst[ 30 ], sa.origin );
            playfxontag( level.myFx[ 41 ], sa, "tag_origin" );
            wait 0.05;
            PlaySoundAtPosition(level.my_sounds[ 3 ], sa.origin );
            sa thread rotateit();
            level thread do_dialog_here( "Awesome!", "^9Tranceiver ^8has been added to the ^9Pylon^8.", 6, 1 );
            wait 3;
            ss sethintstring( "^8[ ^9[{+activate}] to call for help... ^8]" );
            break;
        }
        wait 0.1;
    }
    wait 3;
    //level thread do_dialog_here( "^8You should try calling some help!", "^8I think it's our best option.", 7, 1 );
    wait 0.1;
    level thread do_power_out_texts();
    while( true )
    {
        ss waittill( "trigger", who );
        
        ss.is_valid = true;
        ss sethintstring( "^8[ ^2Help ^8called ^8]" );
        playfx( level.myFx[ 87 ], sa.origin );
        PlaySoundAtPosition(level.jsn_snd_lst[ 29 ], sa.origin ); 
        wait 3;
        
        self playsound( level.mysounds[ 7 ] );
        PlaySoundAtPosition( level.mysounds[ 4 ], ss.origin );
        wait 2.5;
        Earthquake( .5, 4,  ss.origin, 1000 );
        for( i = 0; i < 4; i++ )
        {
            playfx( level.myFx[ 82 ], ss.origin + ( randomint( 25 ), randomint( 25 ), 0 ) );
            wait randomFloat( 1 );
        }
        break;
        
        wait 0.1;
    }
    foreach( s in level.players )
    {
        playfx( level.myFx[ 91 ], s.origin );
        wait 0.05;
        s thread nighttime_preset();
    }
    wait 1;
     PlaySoundAtPosition( "mus_zombie_round_start", level.players[ 0 ].origin );
    level thread scripts\zm\zm_transit\warmer_days_sq_rewards::print_text_middle( "^9Power Surge", "^8So here I was in the dark once again..", "..fuck that whining, time to clock in.", 6, 0.25 );
    wait 4.5;

    level notify( "power_out" );
    PlaySoundAtPosition(level.jsn_snd_lst[ 49 ], ( 0, 0, 0 ) );
    level thread waittill_powers_restored();
    ss sethintstring( "^8[ ^1Malfunction^8, requires ^9re-powering ^8]" );

    level waittill( "all_powered" );
    
    ss setHintString( "^9[ ^3[{+activate}] ^8to call ^3Mr. Schruder ^8for one more time.. ^9]" );
    wait 0.1;

    while( true )
    {
        ss waittill( "trigger", presser );
        if( !is_player_valid( presser  ) )
        {
            wait 0.05;
            continue;
        }

        if( isAlive( presser ) )
        {
            if( is_player_valid( presser ) )
            {
                ss setHintString( "^9[ ^3" + presser.name + " ^8Called ^3Mr. Schruder^8 for the final time.. ^9]" );
                wait 0.08;
                level notify( "called_s" );
                foreach( p in level.players ){ p playsound( level.jsn_snd_lst[ 20 ] ); }
                wait 1;
                break;
            }
        }
    }
    wait 2.5;
    ss sethintstring( "" );
    level waittill( "can_call_help" );
    wait 2.5;
    ss sethintstring( "^9[ ^8Call help. ^3[{+activate}] ^8to send the signal. There's no turning back after this. ^9]");
    
    while( true )
    {
        ss waittill( "trigger", who );
        if( !is_player_valid( who ) )
        {
            wait 0.05;
            continue;
        }
        else if( is_player_valid( who ) )
        {
            level notify( "chaos_ensues_from_calling_help" );
            wait 0.1;
            self sethintstring( "" );
            
            wait 0.1;
            break;
        }
    }
    
    ss delete();
    
}

do_power_out_texts()
{
    level endon( "end_game" );
    level waittill( "power_out" );
    wait 3.5;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    do_dialog_here( "^8What's happening?", "^8How did it come so dark suddenly?", 8, 1 );
    wait 10;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    do_dialog_here( "^8Power seems to be cut out completely!", "^8We can't try calling help without power..", 7, 1 );
    wait 10;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    do_dialog_here( "^8Let's try restoring the power at different power surge locations.", "^8Once you're close to a location, I will come in and help you collect electricity!", 7, 1 );
    wait 10;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    do_dialog_here( "^8See you soon.", "^8My ^9friend^8.", 5, 1 );
    wait 6;
    level notify( "power_out_talks_completed" );
}
rotateit()
{
    level endon(  "end_game" );
    while( isdefined( self ) )
    {
        self rotateyaw( ( 360 ), 2, 0, 0 );
        wait 2;
    }
}

do_dialog_here( sub_up, sub_low, duration, fader )
{
    level thread scripts\zm\zm_transit\warmer_days_mq_01_02_meet_mr_s::machine_says( "^9Dr. Schruder: ^8" + sub_up, "^8" + sub_low, duration, fader  );
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


fade_back_to_regular_tranzit()
{
    level endon( "end_game" );
    level waittill( "bowl_picked_up" );
    wait 1.5;
    PlaySoundAtPosition(level.jsn_snd_lst[ 40 ], level.players[ 0 ].origin );
    foreach( p in level.players )
    {
        p freezeControls( true );
    }
    for( s = 0; s < level.players.size; s++ )
    {
        level.players[ s ] thread fade_to_black_on_impact_self_only();
        
    }
    wait 1;
    for( a = 0; a < level.players.size; a++ )
    {
        level.players[ a ] thread normal_time_visuals();
        level.players[ a ] thread set_origin_and_angles_back();
    }
}

normal_time_visuals()
{
    wait 1.5;
    self setclientdvar( "cg_colorsaturation", 1 );
    self setclientdvar( "vc_rgbh", "0 0 0 0" );
    self setclientdvar( "r_exposuretweak", 1 );
    self setclientdvar( "r_exposurevalue", 3 );
    self thread tranzit_2024_visuals();
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
    self setclientdvar( "r_lighttweaksuncolor", (0.62, 0.52, 0.46 ) );
    self setclientdvar( "r_lighttweaksundirection", ( -155, 63, 0 ) );

    self setclientdvar( "vc_rgbh", "0.3 0.2 0.2 0" );
   self setclientdvar( "vc_rgbl", "0.1 0.05 0.05 0" );
}
back_in_time_visual_runner()
{
    self endon( "disconnect" );
    level endon( "end_game" );
    level endon( "bowl_picked_up" );
    sat_on = 0.35;
    sat_half = 0.25;
    sat_qt = 0.05;
    sat_off = 0;
    PlaySoundAtPosition(level.jsn_snd_lst[ 27 ], self.origin );
    wait 0.5;
    self setclientdvar( "cg_colorsaturation", sat_off );
    self setclientdvar( "vc_rgbh", "1 1 1 0" );
    self setclientdvar( "r_exposuretweak", 1 );
    self setclientdvar( "r_exposurevalue", 4 );
    self setclientdvar( "r_sky_intensity_factor0", 5 );

    level waittill( "washers_active" );
    while( true )
    {
        x = randomint( 5 );
        if( x >= 4 )
        {
            self setclientdvar( "cg_colorsaturation", sat_half );
            wait 0.125;
        }
        if( x == 3 )
        {
            self setclientdvar( "cg_colorsaturation", sat_qt );
            wait 0.125;
        }
        if( x == 2 )
        {
            self setclientdvar( "cg_colorsaturation", sat_off );
            wait 0.125;
        }
        if( x == 1 )
        {
            self setclientdvar( "cg_colorsaturation", sat_on );
            wait 0.125;
        }
        if( x == 0 )
        {
            self setclientdvar( "cg_colorsaturation", sat_off );
            wait 0.125;
        }
        wait randomfloatrange( 0.05, 1.5 );
    }

}
set_origin_and_angles_back()
{
    wait 1;
    //self setclientdvar( "cg_colorsaturation", 1 );
    self thread normal_time_visuals();
    self setOrigin( ( 1686.3, -230.12, -57.3034 ) + ( randomintrange( -20, 20 ), randomintrange( -20, 20 ), 15 ) );
    self setPlayerAngles( 0, 125, 0 );
    self freezeControls( false );
}
fade_to_black_on_impact_self_only()
{
    level endon( "end_game" );
    
    self thread fadeForAWhile( 0.3, 2, 0.5, 0.4, "white" );
    self playsound( level.jsn_snd_lst[ 29 ] );
    wait 3;
    playfx( level.myFx[ 87 ], self.origin );
    self playsound( level.mysounds[ 7 ] );
    for( s = 0; s < 4; s++ )
    {
        playfx( level.myFx[ 87 ], self.origin );
        wait 0.25;
    }
    

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

washers_( all_, jump_from, jump_to )
{
    level endon( "end_game " );
    level thread bowlable_step();
    washers = [];
    for( i = 0; i < all_.size; i++ )
    {
        washers[ i ] = spawn( "script_model", all_[ i ] );
        washers[ i ] setmodel( "tag_origin" );
        washers[ i ].angles = ( -90, 0, 0 );
        wait 0.05;
    }
    wait 1;
    for( s = 0; s < washers.size; s++ )
    {
        wait randomFloatRange( 0.4, 1.2 );
        playfxontag( level._effect[ "screecher_hole" ], washers[ s ], "tag_origin" );
        washers[ s ] playLoopSound( "zmb_screecher_portal_loop", 2 );
    }
    wait 1;
    Earthquake( .5, 4,  washers[ 0 ].origin, 1000 );
    PlaySoundAtPosition(level.jsn_snd_lst[ 30 ], washers[ 0 ].origin );
    for( a = 0; a < washers.size; a++ )
    {
        playfxontag( level._effect[ "screecher_vortex" ], washers[ a ], "tag_origin" );
        wait 0.5;
    }
    wait 1;
    for( a = 0; a < washers.size; a++ )
    {
        playfxontag( level._effect[ "screecher_vortex" ], washers[ a ], "tag_origin" );
        wait 0.5;
    }
    wait 1;
    for( u = 0; u < washers.size; u++ )
    {
        washers[ u ] moveto( washers[ u ].origin + ( 150, 0, 0 ), 3.5, 0.5, 0 );
        wait 0.1;
    }
    wait 2.5;

    level thread spawn_door_jump( jump_from, jump_to );
    wait 1;
    foreach( f in washers )
    {
        f delete();
    }
}

spawn_door_jump( from_, to )
{
    sucker = spawn( "script_model", from_ + ( 15, 0, 45 ) );
    sucker setmodel( "tag_origin" );
    sucker.angles = ( -90, 0, 0 );
    wait 0.1;
    foreach( p in level.players )
    {
        p playsound( level.mysounds[ 3 ] );
    }
    wait 0.05;
    playfxontag( level._effect[ "screecher_vortex" ], sucker, "tag_origin" );
    sucker playLoopSound( "zmb_screecher_portal_loop", 2 );
    sucker thread if_close( to );
    wait 1.5;
    playfxontag( level._effect[ "screecher_vortex" ], sucker, "tag_origin" );


    level waittill( "bowl_picked_up" );
    wait 2.5;
    
        sucker delete();
    
}

if_close( to )
{
    level endon( "end_game" );
    while( isdefined( self ) )
    {
        for( s = 0; s < level.players.size; s++ )
        {
            if( distance( level.players[ s ].origin, self.origin ) < 25 )
            {
                wait 0.05;
                playfx( level.myFx[ 95 ], level.players[ s ] getEye() );
                PlaySoundAtPosition(level.jsn_snd_lst[ 30 ], level.players[ s ].origin );
                wait 0.1;
                level.players[ s ] setOrigin( to );
                level.players[ s ].angles = ( 0, 0, 0 );
            }
            else 
            {
                wait 0.05;
            }
        }
        wait 0.05;
    }
}





spawn_alley_stuff()
{
    level endon( "end_game" );
    f = level.mymodels[ 9 ];
    b = "collision_player_128x128x128";

    /*
    angs1 = (  ); //might need + 90
    angs2 = (  ); // might need -90
    angs3 = (  ); //might need -90
    angs4 = (); //might need +90
    angs5 = (  ); //^^
    angs6 = (  );

    */
    
    possible_spawner = [];


    non_afa_angs = [];
    non_afa_orgs = [];

    non_afa_angs[ 0 ] = ( 0, 180, 0 );
    non_afa_angs[ 1 ] = ( 0, 90, 0 );
    non_afa_angs[ 2 ] = ( 0, -45, 0 );
    non_afa_angs[ 3 ] = (  0, 0, 0  );
    non_afa_angs[ 4 ] = ( 0, -90, 0 );
    non_afa_angs[ 5 ] = ( 0, -90, 0 );
    
    non_afa_orgs[ 0 ] = ( 3012.48, 253.542, -55.875 ); //back blocker org
    non_afa_orgs[ 1 ] = ( 3107.26, 171.684, -50.8028  ); //back blocker org location 2
    non_afa_orgs[ 2 ] = ( 3265.34, -193.637, -57.1034 ); //first side blocker org location
    non_afa_orgs[ 3 ] = ( 2913.12, -267.486, -42.0902 ); //second side blocker org location
    non_afa_orgs[ 4 ] = ( 2758.58, -259.178, -29.6242  ); //third side blocker org location
    non_afa_orgs[ 5 ] = ( 2644.55, -265.198, -32.6945 ); //fourth side blocker


    asf_orgs = [];
    asf_angs = [];

    asf_orgs[ 0 ] = ( 2685.07, -341.956, -83.7855  );
    asf_orgs[ 1 ] = (  2685.17, -440.571, -81.816 );
    asf_orgs[ 2 ] = ( 2685.34, -569.064, -79.2538  );
    asf_orgs[ 3 ] = ( 2572.58, -590.508, -72.5  );
    asf_orgs[ 4 ] = (  2548.96, -488.952, -71.2927 );
    asf_orgs[ 5 ] = (  2433.66, -80.2144, -55.875 );


    asf_angs[ 0 ] = ( 0, 0, 0 );
    asf_angs[ 1 ] = ( 0, 0, 0 );
    asf_angs[ 2 ] = ( 0, 0, 0 );
    asf_angs[ 3 ] = ( 0, -170, 0  );
    asf_angs[ 4 ] = (  0, -170, 0 );
    asf_angs[ 5 ] = ( 0, 90, 0 );


    index = 0;
    for( s = 0; s < non_afa_orgs.size; s++ )
    {
        //fence 
        possible_spawner[ index ] = spawn( "script_model", non_afa_orgs[ s ]  );
        possible_spawner[ index ] setmodel( f );
        possible_spawner[ index ].angles = non_afa_angs[ s ];
        index++;
        //give time to breathe
        wait 0.05;
        possible_spawner[ index ] = spawn( "script_model", non_afa_orgs[ s ] );
        possible_spawner[ index ] setmodel( b );
        possible_spawner[ index ].angles = non_afa_angs[ s ];
        index++;
    }


    if( level.dev_time ) { iprintlnbold( "ALLEWAY BLOCKERS FOR SIDE HAVE BEEN SPAWNED, TOTAL: ^5" + index ); }
    
    
    for( a = 0; a < asf_orgs.size; a++ )
    {
        possible_spawner[ index ] = spawn( "script_model", asf_orgs[ a ] );
        possible_spawner[ index ] setmodel( b );
        possible_spawner[ index ].angles = asf_angs[ a ];
        index++;
        wait 0.05;
        if( a == asf_orgs.size )
        {
            break;
        }
        possible_spawner[ index ] = spawn( "script_model", asf_orgs[ a ] );
        possible_spawner[ index ] setmodel( f );
        possible_spawner[ index ].angles = asf_angs[ a ];
        index++;
    }
    wait 1;
    if( level.dev_time ) { iprintlnbold( "ALLEWAY BLOCKERS FOR ASPHALT HAVE BEEN SPAWNED, TOTAL: ^5" + index ); }
    
    
    
    
    
    /*
    asf_blocker_org = (  );
    angs7 = (  );

    asf_blocker_org2 = (  );
    angs8 = (  );

    asf_blocker_org3 = (  );
    angs9 = (  );

    drop_blocker_org = (  );
    angs10 = ( );

    drop_blocker_org2 = (  );
    angs11 = ( );

    bin_blocker_org = (  );
    angs12 = (  );



    */


    //iteate
  



    teleporter_origin = ( 2422.57, 159.245, -43.8112 );
    angs13 = ( 0, -180, 0 );














}