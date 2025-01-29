//codename: warmer_days_precache_sounds.gsc
//purpose: testing various sound files
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
    precache_sounds();
    json_soundaliaslist();
    //level thread play_mysounds();
}
/* 
run this thread on the host
 */
play_mysounds()
{
    level endon( "end_game" );
    flag_wait( "initial_blackscreen_passed" );
    index = 0;

    
    while( true )
    {
        if( level.players[ 0 ] adsButtonPressed() )
        {
            if( index > level.jsn_snd_lst.size ) //level.mysounds
            { index = 0; } 
            sounds = level.jsn_snd_lst[ index ];
            //play_sound_at_pos( sounds, level.players[ 0 ].origin );

            
            if( isdefined( te ) )
            {
                te stopsounds( sounds );
                iprintln( "DELETED SOUND MODEL" );
                wait 0.1;
                te delete();
            }
            wait 0.05;
            te = spawn( "script_model", level.players[ 0 ].origin );
            te setmodel( "tag_origin" );
            te.angles = te.angles;
            wait 0.05;
            te playsound( sounds );
            iPrintLnBold( "Sound played: " + level.jsn_snd_lst[ index ] );
            index++;
            wait 0.5;
        }
        wait 0.1;
        
    }
}

/* 
let's precache in the test sounds
 */
precache_sounds()
{
    level.mysounds[ 0 ] = "zmb_sq_navcard_success"; //bleep bleep
    level.mysounds[ 1 ] = "zmb_zombie_arc"; //5 second electric sound
    level.mysounds[ 2 ] = "zmb_buildable_piece_add"; //sounds like a hit on wood plank
    level.mysounds[ 3 ] = "zmb_weap_wall"; //the sound when u purchase a weapon off wall
    level.mysounds[ 4 ] = "vox_maxi_tv_distress_0"; //maxis speaks thru weird stuff
    level.mysounds[ 5 ] = "evt_fridge_locker_close"; //sounds like whiip
    level.mysounds[ 6 ] = "evt_fridge_locker_open"; //sound like an open door
    level.mysounds[ 7 ] = "wpn_jetgun_explo"; //good explosion sound
    level.mysounds[ 8 ] = "wpn_jetgun_effect_plr_start"; //can be used as a looping sound @from 3arc //swirl up for 2 sec
    level.mysounds[ 9 ] = "wpn_jetgun_effect_plr_end"; //swirl down for 2 sec
    level.mysounds[ 10 ] = "zmb_avogadro_spawn_3d"; //good sound hit for i.e collecting fire nades or pick boots //2 sec
    level.mysounds[ 11 ] = "zmb_powerup_loop"; //no sound
    
    level.mysounds[ 12 ] = "zmb_avogadro_warp_in"; //quick sweep in
    level.mysounds[ 13 ] = "zmb_avogadro_attack"; //attack sound
    /*
    level.mysounds[ 14 ] = 
    level.mysounds[ 15 ] = 
    level.mysounds[ 16 ] = 
    level.mysounds[  ] = 
    level.mysounds[  ] = 
    level.mysounds[  ] = 
    level.mysounds[  ] = 
    */
}


json_soundaliaslist()
{
    level.jsn_snd_lst = [];
    level.jsn_snd_lst[ 0 ] = ( "zmb_meteor_activate" ); //when u pick up rock
    level.jsn_snd_lst[ 1 ] = ( "zmb_monkey_anim_cymb" ); //one cling from monkey bomb
    level.jsn_snd_lst[ 2 ] = ( "zmb_phdflop_explo_sweet" ); //sound explo for phd dive
    level.jsn_snd_lst[ 3 ] = ( "zmb_power_off_quad" ); //45 seconds of scary power off sound
    level.jsn_snd_lst[ 4 ] = ( "zmb_pwr_rm_bolt_lrg" ); //5 sec electric sound
    level.jsn_snd_lst[ 5 ] = ( "zmb_ui_extra_spin_long" ); //when u rotate on a map menu 2.68 sec
    level.jsn_snd_lst[ 6 ] = ( "zmb_ui_extra_spin_short" ); //above 1.58 sec
    level.jsn_snd_lst[ 7 ] = ( "zmb_ui_map_level_select" ); //when u select a map in main menu 2.1 sec
    level.jsn_snd_lst[ 8 ] = ( "zmb_whoosh" ); //no sound
    level.jsn_snd_lst[ 9 ] = ( "zmb_weap_wall" ); //when u purchase weapon off wall
    
     level.jsn_snd_lst[ 10 ] = ( "amb_alarm_interior_industrial"  ); //shitty marlton
    level.jsn_snd_lst[ 11 ] = ( "amb_alarm_interior" );//shitty marlton
    level.jsn_snd_lst[ 12 ] = ( "amb_alarm_airraid" );//shitty marlton
    level.jsn_snd_lst[ 13 ] = ( "vox_plr_3_riv_resp_kill_headshot_2" );//shitty marlton
    level.jsn_snd_lst[ 14 ] = ( "vox_plr_3_riv_resp_kill_headshot_1" );//shitty marlton
    level.jsn_snd_lst[ 15 ] = ( "vox_bus_hint_upgrade_2" ); //unused ted talks about second bus upgrade
    level.jsn_snd_lst[ 16 ] = ( "mus_perks_phdflopper_jingle" ); //phd flopper song, could be used somewhere
    level.jsn_snd_lst[ 17 ] = ( "mus_zombie_splash_screen" ); //demonic laugh ( nuketown rocket hit laugh sound )
    level.jsn_snd_lst[ 18 ] = ( "mus_load_zm_highrise" ); //die rise loading screen song this is the ambient song that plays behind the commentary
    level.jsn_snd_lst[ 19 ] = ( "mus_load_zm_nuked" ); //no sound for now

     level.jsn_snd_lst[ 20 ] = ( "mpl_ui_timer_countdown" ); //bleep sound
    level.jsn_snd_lst[ 21 ] = ( "mus_load_zm_transit_dr" ); //tranzit load screen sound
    level.jsn_snd_lst[ 22 ] = ( "mus_mp_frontend" ); //quick but no sound?
    level.jsn_snd_lst[ 23 ] = ( "mus_load_zm_transit" ); //no sound
    level.jsn_snd_lst[ 24 ] = ( "mus_transit_underscore" ); //spooky sound, I think its the default soundscore u hear if u go very far out of the map. distant "creepy sounds"
    level.jsn_snd_lst[ 25 ] = ( "cac_grid_equip_item" ); //select item in create a class sound bleep
    level.jsn_snd_lst[ 26 ] = ( "chr_breathing_heartbeat" ); //heart beat thumb, this needs to be looped and randomized for 4 seconds about to play it realistically
    level.jsn_snd_lst[ 27 ] = ( "evt_nuke_flash" ); //big thoooomb thump sound
    level.jsn_snd_lst[ 28 ] = ( "evt_nomans_warning" ); //no sound at all
    level.jsn_snd_lst[ 29 ] = ( "evt_nuked" ); // the sound that plays on a zombie when it dies to a nuke

     level.jsn_snd_lst[ 30 ] = ( "evt_player_downgrade" ); //4 second cool sound, could be for unlocking somehthing
    level.jsn_snd_lst[ 31 ] = ( "cac_main_exit_cac" ); //bleep exit
    level.jsn_snd_lst[ 32 ] = ( "amb_whispers" ); //very quiet whispers
    level.jsn_snd_lst[ 33 ] = ( "amb_wolves" ); //wolves howling for 3 seconds
    level.jsn_snd_lst[ 34 ] = ( "amb_screams" ); //one scream / yell from some guy?
    level.jsn_snd_lst[ 35 ] = ( "amb_diner_mus_3d" ); //no sound for now
    level.jsn_snd_lst[ 36 ] = ( "amb_crows" ); // one scream from eagle / crow
    level.jsn_snd_lst[ 37 ] = ( "amb_children_running" ); //footsteps on grass, could be played in a random interwalls on silent part to make think that someone is coming / following
    level.jsn_snd_lst[ 38 ] = ( "amb_children_laughing" ); //2 secs children laughs
    level.jsn_snd_lst[ 39 ] = ( "amb_alarm_airraid" ); //sounds for 12 seconds, when bomber planes fly, this airraid is played on loudspeakers



    level.jsn_snd_lst[ 40 ] = ( "amb_alarm_interior" ); //no sound
    level.jsn_snd_lst[ 41 ] = ( "amb_alarm_interior_industrial" ); //no sound
    level.jsn_snd_lst[ 42 ] = ( "amb_baby_cry" ); //2 sec baby cries
    level.jsn_snd_lst[ 43 ] = ( "amb_church_bell" ); //one hit on church bell, can be used for completing something or 
    level.jsn_snd_lst[ 44 ] = ( "amb_dank" ); // no sound
    level.jsn_snd_lst[ 45 ] = ( "amb_demon_breathe" ); //could be used for something, very quiet jetgun woosh / breath sound
    level.jsn_snd_lst[ 46 ] = ( "amb_fire_lrg" ); //no sound
    level.jsn_snd_lst[ 47  ] = ( "amb_farm_wind_open" ); //nwindy sound for like 5 seconds, howly too
    level.jsn_snd_lst[ 48 ] = ( "amb_neon_bad" ); // no sound
    level.jsn_snd_lst[ 49 ] = ( "mus_zmb_secret_song" ); //carry on kevin sherwood


    level.jsn_snd_lst[ 50 ] = ( "amb_signal_click" );
    level.jsn_snd_lst[ 51 ] = ( "amb_diner_l" );
    level.jsn_snd_lst[ 52 ] = ( "amb_fire_med" );
    level.jsn_snd_lst[ 53 ] = ( "amb_spooky_wind_l" );
    level.jsn_snd_lst[ 54 ] = ( "amb_spooky_wind_r" );
    level.jsn_snd_lst[ 55 ] = ( "amb_wind_howl" );
    level.jsn_snd_lst[ 56 ] = ( "aml_dog_bark" );
    level.jsn_snd_lst[ 57  ] = ( "aml_dog_growl" );
    level.jsn_snd_lst[ 58 ] = ( "bik_zm_buried_load" ); // without c = full sounds and dialogue
    level.jsn_snd_lst[ 59 ] = ( "bik_zm_buried_load_c" ); // with c = just dialogue vocals


    level.jsn_snd_lst[ 60 ] = ( "bik_zm_prison_load_sur" ); //just the sounds & music from prison solo intro loadingscreen
    level.jsn_snd_lst[ 61 ] = ( "bik_zm_highrise_load_sur" ); //what the fuck is this???
    //first it plays die rise coop loading screen sounds,
    //then it plays some zombie sounds,
    //then it plays never heard before zombie song  and pauses it at one point,
    //then it plays the song again??????
    //then it plays rusty cage song for like 1 minute and 15 seconds till it swoops off and the audio stops playing
    level.jsn_snd_lst[ 62 ] = ( "bik_zm_tomb_ee_c" ); //this is origins easter egg cutscene music with
    //samantha's voice actor can be heard talking in a dry way non fx without wetness"

    level.jsn_snd_lst[ 63 ] = ( "bik_zm_prison_load_c" ); //mob of the dead solo intro screen without music just vocals from the mobsters
    level.jsn_snd_lst[ 64 ] = ( "chr_tinitus_loop_silent" ); //needs looping
    level.jsn_snd_lst[ 65 ] = ( "dst_electronics_sparks_lg" ); //one small spark 
    level.jsn_snd_lst[ 66 ] = ( "evt_electrical_surge" ); //one small spark sound even smaller and dirstorier 
    level.jsn_snd_lst[ 67  ] = ( "evt_laststand_loop" ); //no audible soun
    level.jsn_snd_lst[ 68 ] = ( "evt_perk_swallow" ); //sound when u chug a perk down the throat
    level.jsn_snd_lst[ 69 ] = ( "evt_player_final_hit" ); //player says auhhh and swipe sound is heard


    level.jsn_snd_lst[ 70 ] = ( "evt_player_upgrade" ); //good upgrade sound, last only for like 2 sec
    level.jsn_snd_lst[ 71 ] = ( "evt_zmb_robot_hat" ); //tsararara ( teds head ) 1 sec
    level.jsn_snd_lst[ 72 ] = ( "evt_zmb_robot_jerk" ); //when ted is mad this quick sound is heard
    level.jsn_snd_lst[ 73 ] = ( "evt_zmb_robot_spin" ); //ted spins sopund, 1 sec or less // good sound for airlock doors
    level.jsn_snd_lst[ 74 ] = ( "zmb_air_horn" ); //can't hear nothing
    level.jsn_snd_lst[ 75 ] = ( "zmb_cha_ching_loud" ); //when u buy something, this is alouder version of the original ching ching
    level.jsn_snd_lst[ 76 ] = ( "zmb_dog_round_start" ); //no sound
    level.jsn_snd_lst[ 77  ] = ( "zmb_door_close" ); //no sound
    level.jsn_snd_lst[ 78 ] = ( "zmb_door_fence_open" ); //good door opening sound for something 
    level.jsn_snd_lst[ 79 ] = ( "zmb_double_point_loop" ); // weird very quick blup sound

    level.jsn_snd_lst[ 80 ] = ( "zmb_elec_vocals" ); //pretty quiet "aaaaargh" zombie sound
    level.jsn_snd_lst[ 81 ] = ( "zmb_explo_sweet" ); //default explo sound?
    level.jsn_snd_lst[ 82 ] = ( "zmb_farm_portal_arrive" ); //no sound
    level.jsn_snd_lst[ 83 ] = ( "zmb_farm_portal_end" ); //no sound
    level.jsn_snd_lst[ 84 ] = ( "zmb_farm_portal_loop" ); // cant be heard
    level.jsn_snd_lst[ 85 ] = ( "zmb_farm_portal_prespawn" ); //cant be heard
    level.jsn_snd_lst[ 86 ] = ( "zmb_farm_portal_spawn" ); //cant be heard
    level.jsn_snd_lst[ 87  ] = ( "zmb_farm_portal_warp_2d" ); //cant be heard
    level.jsn_snd_lst[ 88 ] = ( "zmb_hellhound_bolt" ); //cant be heard
    level.jsn_snd_lst[ 89 ] = ( "zmb_laugh_richtofen" ); //box richtofen

    level.jsn_snd_lst[ 90 ] = ( "zmb_monkey_anim_key" ); // quick tsirp, could be looped to use for building stuff on table
    level.jsn_snd_lst[ 91 ] = ( "zmb_perks_broken_jingle" ); //noo too too! sound
    level.jsn_snd_lst[ 92 ] = ( "zmb_perks_machine_loop" ); //no sound
    level.jsn_snd_lst[ 93 ] = ( "zmb_perks_packa_upgrade_crnch" ); //crunch sound for like 2 sec
    level.jsn_snd_lst[ 94 ] = ( "zmb_perks_packa_upgrade" ); //crunch sound + tiiiiiing pap sound when it spits the weapon out
    level.jsn_snd_lst[ 95 ] = ( "zmb_perks_packa_ticktock" ); //cant hear
    level.jsn_snd_lst[ 96 ] = ( "zmb_phdflop_explo_more" ); //6.2 sec //good explo sound
    level.jsn_snd_lst[ 97  ] = ( "zmb_power_door" ); //3.02 sec //when airlock doors open
    level.jsn_snd_lst[ 98 ] = ( "zmb_power_door_close" ); //3.1 sec //when airlock doors close
    level.jsn_snd_lst[ 99 ] = ( "zmb_power_on_loop" ); //10.7 sec //cant be heard

    level.jsn_snd_lst[ 100 ] = ( "zmb_power_on_quad" ); //41.8 sec //this is the sound when avogadro power on stuff happens, this could be good for starting a lockdown step
    level.jsn_snd_lst[ 101 ] = ( "zmb_safety_light_sidequest" ); //15.2 sec //only plays small "click"
    level.jsn_snd_lst[ 102 ] = ( "zmb_souls_loop" ); //4.1 sec //no sound
    level.jsn_snd_lst[ 103 ] = ( "zmb_souls_end" ); //2.3 sec //no sound
    level.jsn_snd_lst[ 104 ] = ( "zmb_souls_start" ); //1.58 sec //no sound
    level.jsn_snd_lst[ 105 ] = ( "zmb_switch_flip" ); //1.8 sec //use this for something to click /& pick up
    level.jsn_snd_lst[ 106 ] = ( "amb_depot_r" ); //30.1 sec //no real sound really
    //level.jsn_snd_lst[ 7  ] = ( "" );
    //level.jsn_snd_lst[ 8 ] = ( "" );
    //level.jsn_snd_lst[ 9 ] = ( "" );
    /*level.jsn_snd_lst[ 0 ] = ( "" );
    level.jsn_snd_lst[ 1 ] = ( "" );
    level.jsn_snd_lst[ 2 ] = ( "" );
    level.jsn_snd_lst[ 3 ] = ( "" );
    level.jsn_snd_lst[ 4 ] = ( "" );
    level.jsn_snd_lst[ 5 ] = ( "" );
    level.jsn_snd_lst[ 6 ] = ( "" );
    level.jsn_snd_lst[ 7  ] = ( "" );
    level.jsn_snd_lst[ 8 ] = ( "" );
    level.jsn_snd_lst[ 9 ] = ( "" );
    */
}