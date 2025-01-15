#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;
#include clientscripts\mp\zombies\_zm_gump;

#include clientscripts\mp\zombies\_zm_weapons;
#include clientscripts\mp\zombies\_zm;
#include clientscripts\mp\zombies\_zm_game_mode_objects;
#include clientscripts\mp\_ambientpackage;
#include clientscripts\mp\_music;
#include clientscripts\mp\_audio;


init()
{
    //2025 fix?
    //noticed that some fxs stopped playing from game
    //replacefunc( clientscripts\mp\zm_transit_fx::precache_scripted_fx, ::precache_scripted_fx_new );
    //replacefunc( clientscripts\mp\zm_transit_fx::precache_createfx_fx, ::precache_createfx_fx_new );
    //replacefunc( clientscripts\mp\zombies\_zm_utility::init_fog_vol_to_visionset_monitor, ::init_fog_vol_to_visionset_monitor_new );
   // replacefunc( clientscripts\mp\zm_transit::init_fog_vol_to_visionset, ::lollipopvol );
  // replacefunc( clientscripts\mp\zombies\_zm::zombie_highest_vision_set_apply, ::newest_vision_set );
   // replacefunc( clientscripts\mp\_visionset_mgr::init_fogvols, ::do_this_ );
    //replacefunc( clientscripts\mp\_visionset_mgr::finalize_type_clientfields, ::clientfielders );
    //replacefunc( clientscripts\mp\zombies\_zm::zombie_vision_set_apply, ::zanew );
    //replacefunc( clientscripts\mp\zm_transit::main, ::main_new );
   //level thread try_to_alter_heavyinfos();
   //level thread loop_fog_value();
   //level thread apply_force();
}

apply_force()
{
    waitforclient( 0 );
    me = getlocalplayers();
    while( true )
    {
        me[ 0 ] thread zanew( "zm_transit_diner_ext", 0, 0 ); 
        wait 0.05;
        println( "APPLIED NEW VALUES" );
    }
}
zanew( str_visionset, int_priority, flt_transition_time, int_clientnum )
{

    self endon( "death" );
    self endon( "disconnect" );

    if ( !isdefined( self._zombie_visionset_list ) )
        self._zombie_visionset_list = [];

    if ( !isdefined( str_visionset ) || !isdefined( int_priority ) )
        return;

    if ( !isdefined( flt_transition_time ) )
        flt_transition_time = 1;

    if ( !isdefined( int_clientnum ) )
    {
        if ( self islocalplayer() )
            int_clientnum = self getlocalclientnumber();

        if ( !isdefined( int_clientnum ) )
            return;
    }

    already_in_array = 0;

    if ( self._zombie_visionset_list.size != 0 )
    {
        for ( i = 0; i < self._zombie_visionset_list.size; i++ )
        {
            if ( isdefined( self._zombie_visionset_list[i].vision_set ) && self._zombie_visionset_list[i].vision_set == str_visionset )
            {
                already_in_array = 1;

                if ( self._zombie_visionset_list[i].priority != int_priority )
                    self._zombie_visionset_list[i].priority = int_priority;

                break;
            }
        }
    }

    if ( !already_in_array )
    {
        temp_struct = spawnstruct();
        temp_struct.vision_set = str_visionset;
        temp_struct.priority = int_priority;
        self._zombie_visionset_list = add_to_array( self._zombie_visionset_list, temp_struct, 0 );
    }

    vision_to_set = self zombie_highest_vision_set_apply();

    if ( isdefined( vision_to_set ) )
        visionsetnaked( int_clientnum, vision_to_set, flt_transition_time );
    else
        visionsetnaked( int_clientnum, "undefined", flt_transition_time );


}
main()
{
    //2025 fix?
    //noticed that some fxs stopped playing from game
    //replacefunc( clientscripts\mp\zm_transit_fx::precache_scripted_fx, ::precache_scripted_fx_new );
    //replacefunc( clientscripts\mp\zm_transit_fx::precache_createfx_fx, ::precache_createfx_fx_new );
    //level thread transit_vision_c hange();
    //level thread print_all_vision_triggers_to_get_an_idea();
    //replacefunc( clientscripts\mp\_visionset_mgr::finalize_type_clientfields, ::clientfielders );
    //replacefunc( clientscripts\mp\zm_transit::main, ::main_new );
   // replacefunc( clientscripts\mp\zombies\_zm::zombie_vision_set_apply, ::zanew );
   // replacefunc( clientscripts\mp\zombies\_zm::zombie_highest_vision_set_apply, ::newest_vision_set );
   // replacefunc( clientscripts\mp\zombies\_zm_utility::init_fog_vol_to_visionset_monitor, ::init_fog_vol_to_visionset_monitor_new );
    //replacefunc( clientscripts\mp\zm_transit::init_fog_vol_to_visionset, ::lollipopvol );
   // replacefunc( clientscripts\mp\_visionset_mgr::init_fogvols, ::do_this_ );
   // level thread all_gumps();
    //level thread print_all_vison_fog_vols();
    //level thread print_get_worldfogscriptid();
    //level thread delete_heavy_infos();
 //  //level thread try_to_alter_heavyinfos();
   // level thread add_rain();
  //  level thread add_rain_other();
}



precache_util_fx()
{

}





precache_scripted_fx_new()
{
    level._effect["eye_glow"] = loadfx( "misc/fx_zombie_eye_single" );
    level._effect["blue_eyes"] = loadfx( "maps/zombie/fx_zombie_eye_single_blue" );
    level._effect["headshot"] = loadfx( "impacts/fx_flesh_hit" );
    level._effect["headshot_nochunks"] = loadfx( "misc/fx_zombie_bloodsplat" );
    level._effect["bloodspurt"] = loadfx( "misc/fx_zombie_bloodspurt" );
    level._effect["animscript_gib_fx"] = loadfx( "weapon/bullet/fx_flesh_gib_fatal_01" );
    level._effect["animscript_gibtrail_fx"] = loadfx( "trail/fx_trail_blood_streak" );
    level._effect["maxis_sparks"] = loadfx( "maps/zombie/fx_zmb_race_trail_grief" );
    level._effect["richtofen_sparks"] = loadfx( "maps/zombie/fx_zmb_race_trail_neutral" );
    level._effect["sq_common_lightning"] = loadfx( "maps/zombie/fx_zmb_tranzit_sq_lightning_orb" );
    level._effect["fx_headlight"] = loadfx( "maps/zombie/fx_zmb_tranzit_bus_headlight" );
    level._effect["fx_headlight_lenflares"] = loadfx( "lens_flares/fx_lf_zmb_tranzit_bus_headlight" );
    level._effect["fx_brakelight"] = loadfx( "maps/zombie/fx_zmb_tranzit_bus_brakelights" );
    level._effect["fx_emergencylight"] = loadfx( "maps/zombie/fx_zmb_tranzit_bus_flashing_lights" );
    level._effect["fx_turn_signal_right"] = loadfx( "maps/zombie/fx_zmb_tranzit_bus_turnsignal_right" );
    level._effect["fx_turn_signal_left"] = loadfx( "maps/zombie/fx_zmb_tranzit_bus_turnsignal_left" );
    level._effect["mc_trafficlight"] = loadfx( "maps/zombie/fx_zmb_morsecode_traffic_loop" );
    level._effect["mc_towerlight"] = loadfx( "maps/zombie/fx_zmb_morsecode_loop" );
}

precache_createfx_fx_new ()
{
    level._effect["fx_insects_swarm_md_light"] = loadfx( "bio/insects/fx_insects_swarm_md_light" );
    level._effect["fx_zmb_tranzit_flourescent_flicker"] = loadfx( "maps/zombie/fx_zmb_tranzit_flourescent_flicker" );
    level._effect["fx_zmb_tranzit_flourescent_glow"] = loadfx( "maps/zombie/fx_zmb_tranzit_flourescent_glow" );
    level._effect["fx_zmb_tranzit_flourescent_glow_lg"] = loadfx( "maps/zombie/fx_zmb_tranzit_flourescent_glow_lg" );
    level._effect["fx_zmb_tranzit_flourescent_dbl_glow"] = loadfx( "maps/zombie/fx_zmb_tranzit_flourescent_dbl_glow" );
    level._effect["fx_zmb_tranzit_depot_map_flicker"] = loadfx( "maps/zombie/fx_zmb_tranzit_depot_map_flicker" );
    level._effect["fx_zmb_tranzit_light_bulb_xsm"] = loadfx( "maps/zombie/fx_zmb_tranzit_light_bulb_xsm" );
    level._effect["fx_zmb_tranzit_light_glow"] = loadfx( "maps/zombie/fx_zmb_tranzit_light_glow" );
    level._effect["fx_zmb_tranzit_light_glow_xsm"] = loadfx( "maps/zombie/fx_zmb_tranzit_light_glow_xsm" );
    level._effect["fx_zmb_tranzit_light_glow_fog"] = loadfx( "maps/zombie/fx_zmb_tranzit_light_glow_fog" );
    level._effect["fx_zmb_tranzit_light_depot_cans"] = loadfx( "maps/zombie/fx_zmb_tranzit_light_depot_cans" );
    level._effect["fx_zmb_tranzit_light_desklamp"] = loadfx( "maps/zombie/fx_zmb_tranzit_light_desklamp" );
    level._effect["fx_zmb_tranzit_light_town_cans"] = loadfx( "maps/zombie/fx_zmb_tranzit_light_town_cans" );
    level._effect["fx_zmb_tranzit_light_town_cans_sm"] = loadfx( "maps/zombie/fx_zmb_tranzit_light_town_cans_sm" );
    level._effect["fx_zmb_tranzit_light_street_tinhat"] = loadfx( "maps/zombie/fx_zmb_tranzit_light_street_tinhat" );
    level._effect["fx_zmb_tranzit_street_lamp"] = loadfx( "maps/zombie/fx_zmb_tranzit_street_lamp" );
    level._effect["fx_zmb_tranzit_truck_light"] = loadfx( "maps/zombie/fx_zmb_tranzit_truck_light" );
    level._effect["fx_zmb_tranzit_spark_int_runner"] = loadfx( "maps/zombie/fx_zmb_tranzit_spark_int_runner" );
    level._effect["fx_zmb_tranzit_spark_ext_runner"] = loadfx( "maps/zombie/fx_zmb_tranzit_spark_ext_runner" );
    level._effect["fx_zmb_tranzit_spark_blue_lg_loop"] = loadfx( "maps/zombie/fx_zmb_tranzit_spark_blue_lg_loop" );
    level._effect["fx_zmb_tranzit_spark_blue_sm_loop"] = loadfx( "maps/zombie/fx_zmb_tranzit_spark_blue_sm_loop" );
    level._effect["fx_zmb_tranzit_bar_glow"] = loadfx( "maps/zombie/fx_zmb_tranzit_bar_glow" );
    level._effect["fx_zmb_tranzit_transformer_on"] = loadfx( "maps/zombie/fx_zmb_tranzit_transformer_on" );
    level._effect["fx_zmb_fog_closet"] = loadfx( "fog/fx_zmb_fog_closet" );
    level._effect["fx_zmb_fog_low_300x300"] = loadfx( "fog/fx_zmb_fog_low_300x300" );
    //level._effect["fx_zmb_fog_thick_600x600"] = loadfx( "fog/fx_zmb_fog_thick_600x600" );
    //level._effect["fx_zmb_fog_thick_1200x600"] = loadfx( "fog/fx_zmb_fog_thick_1200x600" );
    level._effect["fx_zmb_fog_transition_600x600"] = loadfx( "fog/fx_zmb_fog_transition_600x600" );
    level._effect["fx_zmb_fog_transition_1200x600"] = loadfx( "fog/fx_zmb_fog_transition_1200x600" );
    level._effect["fx_zmb_fog_transition_right_border"] = loadfx( "fog/fx_zmb_fog_transition_right_border" );
    level._effect["fx_zmb_tranzit_smk_interior_md"] = loadfx( "maps/zombie/fx_zmb_tranzit_smk_interior_md" );
    level._effect["fx_zmb_tranzit_smk_interior_heavy"] = loadfx( "maps/zombie/fx_zmb_tranzit_smk_interior_heavy" );
    level._effect["fx_zmb_ash_ember_1000x1000"] = loadfx( "maps/zombie/fx_zmb_ash_ember_1000x1000" );
    level._effect["fx_zmb_ash_ember_2000x1000"] = loadfx( "maps/zombie/fx_zmb_ash_ember_2000x1000" );
    level._effect["fx_zmb_ash_rising_md"] = loadfx( "maps/zombie/fx_zmb_ash_rising_md" );
    level._effect["fx_zmb_ash_windy_heavy_sm"] = loadfx( "maps/zombie/fx_zmb_ash_windy_heavy_sm" );
    level._effect["fx_zmb_ash_windy_heavy_md"] = loadfx( "maps/zombie/fx_zmb_ash_windy_heavy_md" );
    level._effect["fx_zmb_lava_detail"] = loadfx( "maps/zombie/fx_zmb_lava_detail" );
    level._effect["fx_zmb_lava_edge_100"] = loadfx( "maps/zombie/fx_zmb_lava_edge_100" );
    level._effect["fx_zmb_lava_50x50_sm"] = loadfx( "maps/zombie/fx_zmb_lava_50x50_sm" );
    level._effect["fx_zmb_lava_100x100"] = loadfx( "maps/zombie/fx_zmb_lava_100x100" );
    level._effect["fx_zmb_lava_river"] = loadfx( "maps/zombie/fx_zmb_lava_river" );
    level._effect["fx_zmb_lava_creek"] = loadfx( "maps/zombie/fx_zmb_lava_creek" );
    level._effect["fx_zmb_lava_crevice_glow_50"] = loadfx( "maps/zombie/fx_zmb_lava_crevice_glow_50" );
    level._effect["fx_zmb_lava_crevice_glow_100"] = loadfx( "maps/zombie/fx_zmb_lava_crevice_glow_100" );
    level._effect["fx_zmb_lava_crevice_smoke_100"] = loadfx( "maps/zombie/fx_zmb_lava_crevice_smoke_100" );
    level._effect["fx_zmb_lava_smoke_tall"] = loadfx( "maps/zombie/fx_zmb_lava_smoke_tall" );
    level._effect["fx_zmb_lava_smoke_pit"] = loadfx( "maps/zombie/fx_zmb_lava_smoke_pit" );
    level._effect["fx_zmb_tranzit_bowling_sign_fog"] = loadfx( "maps/zombie/fx_zmb_tranzit_bowling_sign_fog" );
    level._effect["fx_zmb_tranzit_lava_distort"] = loadfx( "maps/zombie/fx_zmb_tranzit_lava_distort" );
    level._effect["fx_zmb_tranzit_lava_distort_sm"] = loadfx( "maps/zombie/fx_zmb_tranzit_lava_distort_sm" );
    level._effect["fx_zmb_tranzit_lava_distort_detail"] = loadfx( "maps/zombie/fx_zmb_tranzit_lava_distort_detail" );
    level._effect["fx_zmb_tranzit_fire_med"] = loadfx( "maps/zombie/fx_zmb_tranzit_fire_med" );
    level._effect["fx_zmb_tranzit_fire_lrg"] = loadfx( "maps/zombie/fx_zmb_tranzit_fire_lrg" );
    level._effect["fx_zmb_tranzit_smk_column_lrg"] = loadfx( "maps/zombie/fx_zmb_tranzit_smk_column_lrg" );
    level._effect["fx_zmb_papers_windy_slow"] = loadfx( "maps/zombie/fx_zmb_papers_windy_slow" );
    level._effect["fx_zmb_tranzit_god_ray_short_warm"] = loadfx( "maps/zombie/fx_zmb_tranzit_god_ray_short_warm" );
    level._effect["fx_zmb_tranzit_god_ray_vault"] = loadfx( "maps/zombie/fx_zmb_tranzit_god_ray_vault" );
    level._effect["fx_zmb_tranzit_key_glint"] = loadfx( "maps/zombie/fx_zmb_tranzit_key_glint" );
    level._effect["fx_zmb_tranzit_god_ray_interior_med"] = loadfx( "maps/zombie/fx_zmb_tranzit_god_ray_interior_med" );
    level._effect["fx_zmb_tranzit_god_ray_interior_long"] = loadfx( "maps/zombie/fx_zmb_tranzit_god_ray_interior_long" );
    level._effect["fx_zmb_tranzit_god_ray_depot_cool"] = loadfx( "maps/zombie/fx_zmb_tranzit_god_ray_depot_cool" );
    level._effect["fx_zmb_tranzit_god_ray_depot_warm"] = loadfx( "maps/zombie/fx_zmb_tranzit_god_ray_depot_warm" );
    level._effect["fx_zmb_tranzit_god_ray_tunnel_warm"] = loadfx( "maps/zombie/fx_zmb_tranzit_god_ray_tunnel_warm" );
    level._effect["fx_zmb_tranzit_god_ray_pwr_station"] = loadfx( "maps/zombie/fx_zmb_tranzit_god_ray_pwr_station" );
    level._effect["fx_zmb_tranzit_light_safety"] = loadfx( "maps/zombie/fx_zmb_tranzit_light_safety" );
    level._effect["fx_zmb_tranzit_light_safety_off"] = loadfx( "maps/zombie/fx_zmb_tranzit_light_safety_off" );
    level._effect["fx_zmb_tranzit_light_safety_max"] = loadfx( "maps/zombie/fx_zmb_tranzit_light_safety_max" );
    level._effect["fx_zmb_tranzit_light_safety_ric"] = loadfx( "maps/zombie/fx_zmb_tranzit_light_safety_ric" );
    level._effect["fx_zmb_tranzit_bridge_dest"] = loadfx( "maps/zombie/fx_zmb_tranzit_bridge_dest" );
    level._effect["fx_zmb_tranzit_power_pulse"] = loadfx( "maps/zombie/fx_zmb_tranzit_power_pulse" );
    level._effect["fx_zmb_tranzit_power_on"] = loadfx( "maps/zombie/fx_zmb_tranzit_power_on" );
    level._effect["fx_zmb_tranzit_power_rising"] = loadfx( "maps/zombie/fx_zmb_tranzit_power_rising" );
    level._effect["fx_zmb_avog_storm"] = loadfx( "maps/zombie/fx_zmb_avog_storm" );
    level._effect["fx_zmb_avog_storm_low"] = loadfx( "maps/zombie/fx_zmb_avog_storm_low" );
    level._effect["glass_impact"] = loadfx( "maps/zombie/fx_zmb_tranzit_window_dest_lg" );
    level._effect["fx_zmb_tranzit_spark_blue_lg_os"] = loadfx( "maps/zombie/fx_zmb_tranzit_spark_blue_lg_os" );
    level._effect["spawn_cloud"] = loadfx( "maps/zombie/fx_zmb_race_zombie_spawn_cloud" );
}




loop_fog_value()
{
    while ( true )
    {
        players = getlocalplayers();

        for ( i = 0; i < players.size; i++ )
        {
            println( "SETTING FOG BANK TO ^3PLAYER ^7" + i + ", ^2fogbank ^3: " + 2 );
            setworldfogactivebank( i, 2 );
        }
        wait 0.05;
            
    }
}

/*
init_game_mode_objects( mode, location )
{
    level._game_mode_location = location;
    level._game_mode_mode = mode;

    if ( !is_true( level.game_objects_setup ) )
    {
        switch ( level._game_mode_mode )
        {
            case "meat":
            case "race":
            case "zmeat":
            case "zrace":
                players = getlocalplayers();

                for ( i = 0; i < players.size; i++ )
                {
                    trigs = getentarray( i, "vision_trig", "targetname" );

                    foreach ( trig in trigs )
                        trig delete();
                }
        }

        level thread setup_game_mode_objects( mode, location );
        level thread setup_animated_signs();
        level.game_objects_setup = 1;
    }

    if ( level._game_mode_mode == "zrace" || level._game_mode_mode == "race" )
        usealternatereviveicon( 1 );
}
*/  
replace_common_setup()
{
    
}
add_rain_other()
{
     waitforclient( 0 );
    while( true )
    {
        id = GetWorldFogScriptID( 0 );
        players = GetLocalPlayers();
        //players[ 0 ] setworldfogactivebank( 9 );
        //SetWorldFogActiveBank( 4, 4 );
        //0,6 sets spawn fog to 0
        //0,0 keeps -1 everywhere
        //0,4 brings the getworldfogscriptid to -1 always

        //0,3 brings the getworldfogscriptid to 0 at bust station & town, elsewhere values are set normally, changes to 12 when entering tunnel
        //0,2 brings it to -1 or 0 to most
        //0,1 brings nothing
        println( id );
        wait 1;
    }

}

clientfielders()
{
    if ( 1 >= self.info.size )
    {
        //level thread init_fogvols(); //commenting this out seems to m ake it so that vision doesnt change but fog still cxhanges
        println( "tried to init fog vols" );
        return;
    }
    
    self.in_use = 0;
    
    self.cf_slot_bit_count = getminbitcountfornum( self.info.size - 1 );
    self.cf_lerp_bit_count = self.info[self.sorted_name_keys[0]].lerp_bit_count;

    for ( i = 0; i < self.sorted_name_keys.size; i++ )
    {
    self.info[self.sorted_name_keys[i]].slot_index = i;

   if ( self.info[self.sorted_name_keys[i]].lerp_bit_count > self.cf_lerp_bit_count )
         self.cf_lerp_bit_count = self.info[self.sorted_name_keys[i]].lerp_bit_count;
  }

    registerclientfield( "toplayer", self.cf_slot_name, self.highest_version, self.cf_slot_bit_count, "int", self.cf_slot_cb, 0, 1 );

     if ( 1 < self.cf_lerp_bit_count )
     registerclientfield( "toplayer", self.cf_lerp_name, self.highest_version, self.cf_lerp_bit_count, "float", self.cf_lerp_cb, 0, 1 );
}
main_new()
{
    //level thread add_rain_other();
    level thread clientscripts\mp\zm_transit_ffotd::main_start();
    level.default_start_location = "transit";
    level.default_game_mode = "zclassic";
    level._no_water_risers = 1;
    level.riser_fx_on_client = 1;
    level.setupcustomcharacterexerts = clientscripts\mp\zm_transit::setup_personality_character_exerts;
    level.zombiemode_using_doubletap_perk = 1;
    level.zombiemode_using_juggernaut_perk = 1;
    level.zombiemode_using_marathon_perk = 1;
    level.zombiemode_using_revive_perk = 1;
    level.zombiemode_using_sleightofhand_perk = 1;
    level.zombiemode_using_tombstone_perk = 1;
    clientscripts\mp\zm_transit_bus::init_animtree();
    clientscripts\mp\zm_transit_bus::init_props_animtree();
    clientscripts\mp\zm_transit_automaton::init_animtree();
    clientscripts\mp\zombies\_zm_equip_turbine::init_animtree();
    clientscripts\mp\zm_transit::start_zombie_stuff();

    if ( level.scr_zm_ui_gametype == "zclassic" )
        clientscripts\mp\zombies\_zm_equip_turbine::init();

    init_gamemodes();
    clientscripts\mp\zm_transit_fx::main();
    thread clientscripts\mp\zm_transit_amb::main();
    thread clientscripts\mp\zm_transit_gump::init_transit_gump();
    clientscripts\mp\zm_transit::register_client_fields();
    register_client_flags();
    register_clientflag_callbacks();
    registerclientfield( "allplayers", "playerinfog", 1, 1, "int", clientscripts\mp\zm_transit::infog_clientfield_cb, 0 );
    clientscripts\mp\zm_transit::register_screecher_lights();
    level._override_eye_fx = level._effect["blue_eyes"];
    clientscripts\mp\zombies\_zm::zombe_gametype_premain();
    claymores = getstructarray( "claymore_purchase", "targetname" );

    if ( isdefined( claymores ) )
    {
        foreach ( struct in claymores )
        {
            weapon_model = getstruct( struct.target, "targetname" );

            if ( isdefined( weapon_model ) )
                weapon_model.script_vector = vectorscale( ( 0, -1, 0 ), 90.0 );
        }
    }

    level thread clientscripts\mp\zm_transit_ffotd::main_end();
    waitforclient( 0 );
    get_pl = GetLocalPlayers();
    SwitchToServerVolumetricFog( get_pl[ 0 ] );
    level thread clientscripts\mp\zm_transit_bus::main();
    level._power_on = 0;
    
    clientscripts\mp\_teamset_cdc::level_init();
    //level thread init_fog_vol_to_visionset();
    level thread lollipopvol();
    level thread clientscripts\mp\zm_transit::set_fog_on_bus();
    level thread clientscripts\mp\zm_transit::power_controlled_lights();
    level thread level_true_thread();
    if ( level.scr_zm_ui_gametype == "zclassic" )
    {
        if ( isdefined( level.createfxexploders ) )
            clientscripts\mp\_fx::activate_exploder( 1966 );

        setup_morsecode();
    }
}

level_true_thread()
{
     get_pl = GetLocalPlayers();
        
    while( true )
    {
       SwitchToServerVolumetricFog( get_pl[ 0 ] );
       wait 0.1;
    }
}
init_gamemodes()
{
    add_map_gamemode( "zclassic", undefined, undefined );
    add_map_gamemode( "zgrief", undefined, undefined );
    add_map_gamemode( "zstandard", undefined, undefined );
    add_map_location_gamemode( "zclassic", "transit", clientscripts\mp\zm_transit_classic::precache, clientscripts\mp\zm_transit_classic::premain, clientscripts\mp\zm_transit_classic::main );
    add_map_location_gamemode( "zstandard", "transit", clientscripts\mp\zm_transit_standard_station::precache, undefined, clientscripts\mp\zm_transit_standard_station::main );
    add_map_location_gamemode( "zstandard", "farm", clientscripts\mp\zm_transit_standard_farm::precache, undefined, clientscripts\mp\zm_transit_standard_farm::main );
    add_map_location_gamemode( "zstandard", "town", clientscripts\mp\zm_transit_standard_town::precache, undefined, clientscripts\mp\zm_transit_standard_town::main );
    add_map_location_gamemode( "zgrief", "transit", clientscripts\mp\zm_transit_grief_station::precache, undefined, clientscripts\mp\zm_transit_grief_station::main );
    add_map_location_gamemode( "zgrief", "farm", clientscripts\mp\zm_transit_grief_farm::precache, undefined, clientscripts\mp\zm_transit_grief_farm::main );
    add_map_location_gamemode( "zgrief", "town", clientscripts\mp\zm_transit_grief_town::precache, undefined, clientscripts\mp\zm_transit_grief_town::main );
}
register_client_flags()
{

}

register_clientflag_callbacks()
{

}


lollipopvol()
{
    init_fog_vol_to_visionset_monitor_new( "zm_transit_diner_ext", 2 );
    fog_vol_to_visionset_set_suffix( "_off" );
    fog_vol_to_visionset_set_info( 0, "zm_transit_diner_ext");
    
    fog_vol_to_visionset_set_info( 1, "zm_transit_diner_ext" );
    fog_vol_to_visionset_set_info( 2, "zm_transit_diner_ext" );
    fog_vol_to_visionset_set_info( 3, "zm_transit_diner_ext" );
    fog_vol_to_visionset_set_info( 4, "zm_transit_diner_ext" );
    fog_vol_to_visionset_set_info( 5, "zm_transit_diner_ext" );
    fog_vol_to_visionset_set_info( 6, "zm_transit_diner_ext" );
    fog_vol_to_visionset_set_info( 7, "zm_transit_diner_ext" );
    fog_vol_to_visionset_set_info( 8, "zm_transit_diner_ext" );
    fog_vol_to_visionset_set_info( 9, "zm_transit_diner_ext" );
    fog_vol_to_visionset_set_info( 10, "zm_transit_diner_ext" );
    fog_vol_to_visionset_set_info( 11, "zm_transit_diner_ext" );
    fog_vol_to_visionset_set_info( 12, "zm_transit_diner_ext" );
    //fog_vol_to_visionset_set_info( 510, "zm_transit_diner_ext", 999 );
    //fog_vol_to_visionset_set_info( 506, "zm_transit_diner_ext", 999 );
   // fog_vol_to_visionset_set_info( 508, "zm_transit_diner_ext", 999 );
   // fog_vol_to_visionset_set_info( 501, "zm_transit_diner_ext", 999 );
   // fog_vol_to_visionset_set_info( 502, "zm_transit_diner_ext", 999 );
    
}




init_fog_vol_to_visionset_monitor_new( default_visionset, default_trans_in, host_migration_active )
{
    level._fv2vs_default_visionset = "zm_transit_gump_diner";
    level._fv2vs_default_trans_in = 0;
    level._fv2vs_unset_visionset = "_fv2vs_unset";
    level._fv2vs_prev_visionsets = [];
    level._fv2vs_prev_visionsets[0] = level._fv2vs_unset_visionset;
    level._fv2vs_prev_visionsets[1] = level._fv2vs_unset_visionset;
    level._fv2vs_prev_visionsets[2] = level._fv2vs_unset_visionset;
    level._fv2vs_prev_visionsets[3] = level._fv2vs_unset_visionset;

    if ( !isdefined( host_migration_active ) )
    {
        level._fv2vs_infos = [];
        fog_vol_to_visionset_set_info( 1, "zm_transit_gump_diner", 1 ); 
    }

    level._fogvols_inited = 1;
}

fog_vol_to_visionset_set_suffix( suffix )
{
    level._fv2vs_suffix = suffix;
}

fog_vol_to_visionset_set_info( id, visionset, trans_in )
{
    if ( !isdefined( trans_in ) )
        trans_in = level._fv2vs_default_trans_in;

    level._fv2vs_infos[id] = spawnstruct();
    level._fv2vs_infos[id].visionset = visionset;
    level._fv2vs_infos[id].trans_in = trans_in;
}
print_get_worldfogscriptid()
{
    wait 7;
    while( true )
    {
        
        id = getworldfogscriptid( 0 ); //0 should be level.players[ ultimateman ] 
        //seems to be that the fog value banks ie 8 is for power exterior, while 508 is power exterior heavy fog
        //each gump & "heavy fog area seem to have correspoding "500" match with its original x value exterior i.e town_exterior = 4, town_exterior heavy fog = 504
        //see if we can delete all those vision sets with 500 prefix.

        println( "FOG ID CURRENTLY: " + id );
        wait 1;
        //for( i = 0; i < level._fv2vs_infos.size; i++ )
        //{
        //    println( "VISIONSET ORIGIN STRUCT: " + level._fv2vs_infos[ i ].origin + " , level._fv2vs_infos index" + i );
        //    wait 1;
        //}
        
    }
}

try_to_alter_heavyinfos()
{
    wait 15;
    while( true )
    {
        
       players = getlocalplayers();
        //level.current_fog = -1;
        //set first value to zero then second value to 4 it, cause it to use global volume aka -1 value, all else seem to not work
        //level notify( "OBS" );
        setworldfogactivebank(0,  5 ); 
        //println( "SET WORLDFOG TO 5" );
        id = getworldfogscriptid( 0 ); //0 should be level.players[ ultimateman ] 
        //seems to be that the fog value banks ie 8 is for power exterior, while 508 is power exterior heavy fog
        //each gump & "heavy fog area seem to have correspoding "500" match with its original x value exterior i.e town_exterior = 4, town_exterior heavy fog = 504
        //see if we can delete all those vision sets with 500 prefix.
        println( "FOG ID CURRENTLY: " + id );
        // visionsetnaked( 0, "zm_transit_diner_ext", 0 );
        wait 1;
        //println( "SET THE FOG BANK BY FORCE TO BANK: " + 4 );
    }
}

zombie_highest_vision_set_apply()
{
    
}

add_rain()
{
    waitforclient( 0 );
    println( "^2HEAVY RAIN SET" );
    activateambientroom( 0, "heavy_rain", 0 );

}

print_all_vision_triggers_to_get_an_idea()
{
    //waitforclient( 0 );

    //players = getlocalplayers();
    
    
       //println( level.current_fog );
       //setworldfogactivebank( 0, level.current_fog );
       //visionsetnaked( 0, "zm_transit_gump_diner", 0 );
       //for( i = 0; i < self._zombie_visionset_list.size; i++ )
       //{
       //     println( i + " ^2Players visionlist ^3" + self._zombie_visionset_list[ i ].vision_set );
       //     println( i + " ^2Players visionlist ^3" + self._zombie_visionset_list[ i ].priority );
       //}
      // wait 0.05;
    
}

newest_vision_set()
{
    if ( !isdefined( self._zombie_visionset_list ) )
        return;

    highest_score = 4;
    highest_score_vision = "zm_transit_gump_diner";

    //for ( i = 0; i < self._zombie_visionset_list.size; i++ )
    //{
    //    if ( isdefined( self._zombie_visionset_list[i].priority ) && self._zombie_visionset_list[i].priority > highest_score )
    //    {
    //        highest_score = self._zombie_visionset_list[i].priority;
   //         highest_score_vision = self._zombie_visionset_list[i].vision_set;
    //    }
   // }

    return highest_score_vision;
}
delete_heavy_infos()
{
    wait 10;
    println( "STARTING TO DELETE HEAVY VISIONSETS" );
    level.fv2vs_infos[ 501 ].visionset = "zm_transit_gump_diner";
    level.fv2vs_infos[ 502 ].visionset = "zm_transit_gump_diner";
    level.fv2vs_infos[ 504 ].visionset = "zm_transit_gump_diner";
    wait 0.05;
    level.fv2vs_infos[ 506 ].visionset = "zm_transit_gump_diner";
    wait 0.05;
    level.fv2vs_infos[ 508 ].visionset = "zm_transit_gump_diner";
    wait 0.05;
    level.fv2vs_infos[ 510 ].visionset = "zm_transit_gump_diner";
    println( " ALL ALTERED VISIONS " );
    wait 0.05;
}
print_all_vison_fog_vols()
{
    wait 5;
    while( true )
    {
        for( s = 0; s < level.fv2vs_infos.size; s++ )
        {
            println( "FOGVOL BANK NUMBER: " + s + " visionset: " + level._fv2vs_infos[s].visionset );
            wait 0.25;
        }
        wait 1;
    }
}

do_this_()
{
    while ( !isdefined( level._fogvols_inited ) )
        wait 0.1;
}
all_gumps()
{
    wait 10;
    gump_trigs = getentarray( 0, "gump_triggers", "targetname" );
    wait 0.1;
    //if this for loop is enabled, only diners models will load and everything else will be missing. /
    /*
    for( s = 0; s < gump_trigs.size; s++ )
    {
        if( gump_trigs[ s ].script_string != "zm_transit_gump_diner" )
        {
            gump_trigs[ s ].script_string = "zm_transit_gump_diner";
        }
    }
    */
    array_thread( gump_trigs, ::transit_vision_change, 0 );
}
transit_vision_change()
{
    while ( true )
    {
        self waittill( "trigger", who );
        wait 1;

        println( "PLAYER TRIED HITTING GUMP TRIGGER" );
        who thread print_all_vision_triggers_to_get_an_idea();
        wait 0.1;
        
        
        if ( !isdefined( who ) || !who islocalplayer() )
            continue;

        local_clientnum = who getlocalclientnumber();
        visionset = "zm_transit_base";

        if ( isdefined( self.script_string ) )
         visionset = self.script_string;

        if ( isdefined( who._previous_vision ) && visionset == who._previous_vision )
            continue;

        if ( isdefined( self.script_float ) )
            trans_time = self.script_float;
        else
            trans_time = 2;

        if ( !isdefined( who._previous_vision ) )
            who._previous_vision = visionset;
        else
            who clientscripts\mp\zombies\_zm::zombie_vision_set_remove( who._previous_vision, trans_time, local_clientnum );


        if ( isdefined( self.script_string ) )
            println( "*** Client : Changing vision set " + self.script_string + " but we change it to ^2zm_transit_gump_diner" );// self.script_string );

        who clientscripts\mp\zombies\_zm::zombie_vision_set_apply("zm_transit_gump_diner", 1, trans_time, local_clientnum );
        who._previous_vision = visionset;
        
    }
}
