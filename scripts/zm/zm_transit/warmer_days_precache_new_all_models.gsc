init()
{
    level.x_models = array(
        "ch_water_fountain", //bus depo  1
        "com_payphone_america", //bus depo 2 
        "p6_stanchion_post", //bus depo 3 
        "p_rus_locker_closed", //bus depo 4 
        "p_rus_locker_open", //bus depo 5 
        "p_eb_lg_suitcase", //bus depo 6  // use for bus depo step
        "p_eb_med_suitcase",  // 7       // use for bus depo step after interacting
        "ny_harbor_planter", //bus depo 8
        "p6_chair_damaged_trash_panama", //bus depo 9
        "p6_zm_street_power_pole", //bus depo 10
        "p6_sofa_damaged_trash_panama", //bus depo 11
        "p6_sofa_damaged_panama", //bus depo 12
        "com_bike_destroyed", //bus depo 13
        "berlin_wood_table",//14
        "p6_zm_sign_bus_rooftop",//15
        "ch_radiator01",//16
        "p6_zm_water_tower",//17
        "p_rus_ac_unit",//18
        "com_restaurantchair_2",//1§9
        "com_junktire",//20
        "light_outdoorwall01",//21
        "p_rus_dumpster_zm_bstation",////22
        "p6_zm_bench_plastic",//23
        "p6_zm_magazines_rack",//24
        "mp_m_trash_pile",//25
        "p6_zm_bench_old",//26
        "p_lights_hangingbulb_on_depot",//27
        "p_glo_trashcan",//218
        "p_rus_electricalbox_02",//29
        "p6_pak_electric_box_set_03",//30
        "p_glo_electrical_pipes_t",//31
        "p_rus_electricalbox_02",//32
        "p_glo_electrical_pipes_90deg_depot",//33
        "p_glo_electrical_pipes_45deg",//34
        "p_glo_lights_fluorescent_yellow_on_depot",//35
        "p_rus_rollup_door_136",//36
        "p_zom_fence_chainlink", //Diner starts//37
        "p_rus_table_steel",//38
        "p_glo_tools_chest_tall_1",//39
        "p_rus_storage_cabinet",//40
        "paris_kitchen_counter_a",//41
        "com_restaurantsink_2comps",//42
        "ch_gas_pump",//43
        "com_hub_cap_1",//44
        "com_hub_cap_3",//45
        "p_jun_metal_shelves",//46
        "p_glo_coiledwire",//47
        "com_cash_register_gstation",//48
        "p_zom_clock_diner",//49
        "p_glo_bathroom_toilet",//50
        "p_rus_bathroom_papertowel",//51
        "p_rus_rollup_door_120",//522
        "p6_window_frame_wood_white_diner",//535
        "ch_dinerboothtable",//54
        "diner_stool_01",//55
        "me_dumpster_close",//56
        "p6_billboard_pillar_top",//57
        "p_rus_fuelstorage_tank_rusty_zm_gstation",//58
        "iw_rooftop_ac_unit",//59
        "com_roofvent3",//60
        "p_jun_coffeepotold",//61
        "com_food_prep_station_fryer",//62
        "ch_dinerboothchair_2_d",//63
        "p6_zm_sign_diner",//64
        "com_restaurantkitchenvent",//65
        "p6_zm_sign_diner_rooftop",//66
        "berlin_lamp_post_sidewalk_01",//67
        "p6_car_lift",//68
        "p6_car_lift_lowered",//69
        "com_paintcan",//70
        "com_spray_can01",//71
        "p_glo_cans_multiple",//72
        "p_glo_gascan",//73
        "p_rus_electricalbox_01",//74
        "p_glo_lights_fluorescent_yellow_on_diner",//75
        "p6_zm_gas_sign_01",//76
        "p6_zm_gasstation_oilrack",
        "zombie_modular_wires_lg"//77
        /*
        "com_powerline_tower_top2_broken2_forest",
        "p_jun_int_table_lg",
        "p_jun_old_tv",
        "p_rus_oven_iron_body",
        "p6_zm_weapon_locker",
        "zombie_theater_folded_chair",
        "p_jun_barbed_wire_cage",
        "p_jun_chickencoop",
        "ehicle_tractor_2",
        "p6_plant_cornstalk_lrg_row_256_dry_farm",
        "p_jun_storage_crate",
        "p_jun_dockpost_pow",
        "p_glo_sandbags_green_long_128x64_khe_sahn",
        "rb_fence06",
        "p_rus_fuelstorage_tank_rusty_zm_farm",
        "com_restaurantkitchentable_1",
        "com_cardboardbox_dusty_01",
        "com_cardboardbox_dusty_02",
        "p_rus_electricalbox_03",
        "p_glo_tools_shovel",
        "p_glo_tools_rake",
        "p_glo_tools_hoe",
        "p_glo_tools_saw",
        "p_glo_tools_wheelbarrow",
        "p_lights_lantern_hang_on",
        "p_rus_bookcase_fncy",
        "p6_antenna_3",
        "p6_longtable_sink",
        "p_glo_sandbags_green_long",
        "p_rus_tank_large_midsection",
        "p_rus_tank_large_rooftop",
        "com_crate02_farm",
        "com_crate01_farm",
        "lights_indlight_on_farm",
        "lights_indlight_farm",
        "p6_zm_farm_trough",
        "p6_zm_farm_chickencoop",
        "p6_zm_rain_gutter_01",
        "afr_wooden_fence_rail_01",
        "afr_wooden_fence_rail_03",
        "p_jun_rubble02",
        "p6_pak_veh_train_boxcar",
        "mp_radiation_building_supports02",
        "p_rus_building_supports01",
        "ny_harbor_sub_int_pipes_under",
        "p_dest_electrical_transformer01_dest",

        "p_rus_rocket_wire_debris",
        "p6_zm_catwalk_128_straight",
        "com_pipe_4x256_metal",
        "p6_monitor_small",
        "p6_zm_monitor_table_display_01",
        "p6_zm_monitor_table_01",
        "com_powerline_tower_top_broken2",
        "lights_indlight_power",
        "p_rus_wires_modular_straight_256_pstation",
        "p6_zm_core_panel_02",
        "com_woodlog_16_192_a",
        "com_woodlog_16_192_b",
        "com_woodlog_16_192_c",
        "com_woodlog_16_192_d",
        "com_woodlog_24_96_a",
        "com_woodlog_24_96_b",
        "com_woodlog_24_96_c",
        "p6_table_bunker_sm",
        "afr_chimp_skull_03",
        "afr_chimp_skull_01",
        "p_glo_tools_axe",
        "com_powerline_tower_top2_broken2",
        "africa_skulls_pile_large",
        "p6_zm_wind_turbine",
        "p6_plant_cornstalk_lrg_row_256_dry",
        "p6_plant_cornstalk_lrg_row_512_dry",
        "p6_plant_cornstalk_lrg_dry",
        "p6_zm_wind_turbine_rotor",
        "berlin_hotel_lights_wall2_on",
        "p6_zm_sign_neon_open",
        "p_rus_air_vent",
        "com_cash_register",
        "furniture_pool_table_snooker",
        "ap_table01",
        "ch_washer_01",
        "berlin_traffic_signal_01_off",
        "p6_zm_sign_bookstore",
        "p6_zm_sign_deptstore",
        "p6_zm_sign_laundromat",
        "p6_zm_shoe_rack",
        "p6_zm_sign_bowling_large",
        "p6_zm_sign_neon_loans",
        "p6_zm_pool_table_lamp",
        "p6_zm_ball_return",
        "p_rus_dumpster_zm_town",
        "p_glo_street_light01",
        "rb_fence02",
        "p_rus_electric_boxes4",
        "p_rus_pneumatic_dolly",
        "undr_locker_military_red",
        "p_rus_crate_metal_2",
        "p_rus_handrail_yellow_64_end",
        "com_debris_engine02",
        "com_trafficcone01"*/ );

        foreach( m in level.x_models )
        {
            preCacheModel( m );
        }
}

pre_()
{
    m = 2;

    
}