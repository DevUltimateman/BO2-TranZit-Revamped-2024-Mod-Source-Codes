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
    level thread level_play();
    flag_wait( "initial_blackscreen_passed" );  
    level thread do_everything_for_axe_logic();
    
    
    //level thread print_org();

    //level thread trailer_cams( 9 );


}


trailer_cams( waiting )
{
    cams = [];
    angs = [];
    cams[ 0 ] = ( -6071.81, 4468.55, -88.8755 );
    angs[  0] = ( 0, 133, 0 );
    cams[ 1 ] = ( -6667.58, 4892.79, 59.962 );
    angs[ 1 ] = ( 0, 134, 0 );
    
    cams[ 2 ] = ( -6364.77, -6442.76, -31.4244 );
    angs[ 2 ] = ( 0, -36, 0 );
    cams[ 3 ] = ( -5273.2, -7143.32, 108.777 );
    angs[ 3 ] = ( 0, -28, 0 );
    
    
    cams[ 4 ] = ( 8188.39, -5656.07, 95.6527 );
    angs[ 4 ] = ( 20, 85, 0 );
    cams[ 5 ] = ( 8237.87, -4601.25, 161.089 );
    angs[ 5 ] = ( 20, 85, 0 );
    
    wait waiting;

    mover = spawn( "script_model", cams[ 0 ] + ( -20, 0, 0 ) );
    mover setmodel( "tag_origin" );
    mover.angles = angs[ 0 ];
    wait 1;
    ind = 0;
    

    //level.players[ 0 ] hide();
    
    while( true )
    {
        if( level.players[ 0 ] useButtonPressed() && level.players[ 0 ] adsButtonPressed() )
        {
            level.players[ 0 ] CameraActivate(true );
            level.players[ 0 ] camerasetposition( mover);
            level.players[ 0 ] camerasetlookat();
            level.players[ 0 ] enableInvulnerability();
            mover moveto( cams[ ind ], 7, 0, 0 );
            mover rotateto( angs[ ind ], 7, 0 ,0 );
            ind++;
            wait 7.1;
            level.players[ 0 ] CameraActivate(false);
            level.players[ 0 ] CameraSetPosition(level.players[ 0 ].origin );
            level.players[ 0 ] setorigin( mover.origin + ( 0, 0, 40 ) );
            level.players[ 0 ] setPlayerAngles( mover.angles );
            if( ind >= cams.size )
            {
                ind = 0;
            }
        }
        wait 0.1;
    }

}
print_org()
{
    level endon( "end_game" );
    while( true )
    {
       iprintln( "ORIGIN : ^1" + level.players[ 0 ].origin + " ^3ANGLES : ^2" + level.players[ 0 ].angles );
        wait 1;
    }
}
level_play()
{
    level endon( "end_game" );
    while( true )
    {
        level waittill( "connected", p );
        p thread print_player_piece();
    }
}
do_everything_for_axe_logic()
{
    level endon( "end_game" );
    location = ( 5200.45, 6316.76, -63.875 );

    trig = spawn( "trigger_radius_use", location, 0, 48, 48 );
    trig setHintString( "" );
    trig setCursorHint( "HINT_NOICON" );
    trig TriggerIgnoreTeam();
    
    mod = spawn( "script_model", location );
    mod setmodel( "tag_origin" );
    mod.angles = ( 0, 0, 0 );

    wait 1;

    playfxontag( level.myFx[ 44 ], mod, "tag_origin" ); 

    while( true )
    {
        trig waittill( "trigger", p );
        if( !is_player_valid( p ) )
        {
            wait 0.1;
            continue;
        }
        playfx( level._effects[ 77 ], location );
        PlaySoundAtPosition("zmb_box_poof", location );
        p takeWeapon( p getCurrentWeapon() );
        p giveWeapon( "raygun_mark2_zm" );
        p switchToWeapon( "raygun_mark2_zm" );
        wait 0.1;
        trig delete();
        mod delete();
        break;

    }
}

print_player_piece()
{
    self endon( "disconnect" );
    level endon( "end_game" );
    self waittill( "spawned_player" );
    self thread do_shader_pickup();
    wait 10;
    while( true )
    {
        if( !isdefined( self player_get_buildable_piece() ) )
        {
            if( self._pickup_shader != "" )
            {
                self._pickup_shader fadeovertime( 1  );
                self._pickup_shader.alpha = 0;
                wait 1;
                self._pickup_shader setshader( "" );
            }
            wait 0.1;
        }
        else
        {
            
            if( level.dev_time ){ iprintln( "PLAYER HAS PIECE: ^1" +  self player_get_buildable_piece().modelname ); }
            self._pickup_shader fadeovertime( 1 );
            self._pickup_shader.alpha = 1;
            self._pickup_shader.width = 80;
            self._pickup_shader.height = 80;
            self._pickup_shader setshader( return_updated_shader( self player_get_buildable_piece().modelname ), 15, 15 );
            wait 1;
        }
        wait 0.05;
    }
}


return_updated_shader( get_player_piece )
{
    switch( get_player_piece )
    {
        case "p6_zm_buildable_turbine_mannequin":
            return "zm_hud_icon_mannequin";
        case "p6_zm_buildable_turbine_rudder":
            return "zm_hud_icon_rudder";
        case "p6_zm_buildable_turbine_fan":
            return "zm_hud_icon_fan";
        case "p6_zm_buildable_battery":
            return "zm_hud_icon_battery";
            case "t6_wpn_zmb_shield_dolly":
            return "zm_hud_icon_dolly";
            case "t6_wpn_zmb_shield_door":
            return "zm_hud_icon_cardoor";
            case "p6_zm_buildable_pswitch_hand":
            return "zm_hud_icon_arm";
            case "p6_zm_buildable_pswitch_body":
            return "zm_hud_icon_panel";
            case "p6_zm_buildable_pswitch_lever":
            return "zm_hud_icon_lever";
            case "p6_zm_buildable_pap_body":
            return "zm_hud_icon_papbody";
            case "p6_zm_buildable_pap_table":
            return "zm_hud_icon_chairleg";
            case "t6_wpn_lmg_rpd_world":
            return "zm_hud_icon_turrethead";
            case "p6_zm_buildable_turret_mower":
            return "zm_hud_icon_lawnmower";
            case "p6_zm_buildable_turret_ammo":
            return "zm_hud_icon_ammobox";
            case "p6_zm_buildable_etrap_base":
            return "zm_hud_icon_coil";
            case "p6_zm_buildable_etrap_tvtube":
            return  "zm_hud_icon_tvtube";
            case "p6_zm_buildable_jetgun_wires":
            return "zm_hud_icon_jetgun_wires";
            case "p6_zm_buildable_jetgun_engine":
            return "zm_hud_icon_jetgun_engine";
            case "p6_zm_buildable_jetgun_guages":
            return "zm_hud_icon_jetgun_gauges";
            case "p6_zm_buildable_jetgun_handles":
            return "zm_hud_icon_jetgun_handles";
            case "veh_t6_civ_bus_zombie_cow_catcher":
            return "zm_hud_icon_plow";
            case "veh_t6_civ_bus_zombie_roof_hatch":
            return "zm_hud_icon_hatch";
            case "com_stepladder_large_closed":
            return "zm_hud_icon_ladder";
            case "p6_zm_buildable_sq_electric_box":
            return "zm_hud_icon_sq_powerbox";
            case "p6_zm_buildable_sq_meteor":
            return "zm_hud_icon_sq_meteor";
            case "p6_zm_buildable_sq_scaffolding":
            return "zm_hud_icon_sq_scafold";
            case "p6_zm_buildable_sq_transceiver":
            return "zm_hud_icon_sq_tranceiver";
        default:
        return;
    }
}

do_shader_pickup()
{
    self endon( "disconnect" );
    level endon( "end_game" );

    r_width = 80;
    r_height = 80;

    width = 25;
    height = 25;

    self._pickup_shader = newClientHudElem( self );
    self._pickup_shader.x = 410;
    self._pickup_shader.y = 170;
    self._pickup_shader.alignx = "center";
    self._pickup_shader.aligny = "center";
    self._pickup_shader.horzalign = "user_center";
    self._pickup_shader.vertalign = "user_center";
    self._pickup_shader.alpha = 0;
    self._pickup_shader.foreground = true;
    self._pickup_shader.hidewheninmenu = true;
    self._pickup_shader setshader( "", 18, 18 );
    self._pickup_shader.color = ( 1, 1, 0.75 );
   // self thread update_shader();
}

update_shader()
{
    self endon( "disconnect" );
    level endon( "end_game" );
    while( true )
    {
        shader = self player_get_buildable_piece().modelname;
        if( self player_get_buildable_piece().modelname != shader )
        {
            self._pickup_shader setshader( self player_get_buildable_piece().name );
            self._pickup_shader fadeovertime( 1.5 );
            self._pickup_shader.alpha = 1;
        }

        if( self player_get_buildable_piece().modelname == "" )
        {
            if( self._pickup_shader.alpha == 1 )
            {
                self._pickup_shader fadeovertime( 1.5 );
                self._pickup_shader.alpha = 0;
                wait 1;
                if( self player_get_buildable_piece().modelname == "" )
                {
                    while( self player_get_buildable_piece().modelname == "" )
                    {
                        wait 1;
                    }
                }
            }
        }
        wait 0.1;
    }
}