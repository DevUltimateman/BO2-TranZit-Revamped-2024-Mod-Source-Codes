//codename: wamer_days_sq_rewards
//purpose: handles the side quest rewarding
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


init()
{
    level.e_trap_ee_kills = 0;
    level.e_trap_ee_kills_required = 30;
    level thread intro_credit_camera();
    precache_these_models();
    //level thread debug_placement();
    replacefunc( maps\mp\zombies\_zm_equip_electrictrap::zap_zombie, ::zap_zombies ); //make it to also increase level.e_tarp_ee_kills
    flag_wait( "initial_blackscreen_passed" );
    level thread spawn_barret_buyables();
    level thread spawn_smr_buyables();
    level thread spawn_hamr_buyables();
    level thread spawn_rpd_buyables();
    level thread activate_avogadro_zombies();
    wait 15;
    level thread reward_clip_size_4x(); //at one point players get 4x multiplier clip
    //level thread track_e_trap_ee_kills(); //mini ee that unlocks zombies to come avogadros
}

intro_credit_camera()
{
    level endon( "end_game" );
    flag_wait( "initial_players_connected" );
    wait 2;
    level thread intro_camera_blackscreen();
    init_loc = ( -6824, 4831.33, 188.543 );
    init_ang = ( -25, 125, 0 );


    fin_loc = (-5955.32, 4454.9, 75.1119 ); 
    fin_ang = ( 0, 185, 0 );
    fin_ang2 = ( 0, 115, 0 );


    shack_lock = ( -6169.78, 4228.92, 65.0207 );
    shack_angs = ( 0, 140, 0 );
    dolly_cam = spawn( "script_model", init_loc );
    dolly_cam setmodel( "tag_origin" );
    dolly_cam.angles = init_ang;

    

    wait 0.1;
    foreach( p in level.players )
    {
        p enableInvulnerability();
        p disableWeapons();
        p freezeControls(true);
        p CameraSetPosition( dolly_cam );
        p CameraSetLookAt();
        p CameraActivate( true );
        
        //p CameraSetAngles( init_ang );
       
    }

    level thread intro_camera_credit(); //map creadit
    dolly_cam moveto( fin_loc, 20, 2.5, 2.5 );
    dolly_cam rotateTo( fin_ang, 8, 1.5, 2.5 );
    wait 8;
    dolly_cam rotateTo(shack_angs, 8, 2.5, 2.5 );
    wait 7;
    level notify( "start_fading_again" );
    wait 5.5;
    foreach( p in level.players )
    {
        
        p disableInvulnerability();
        p enableWeapons();
        p freezeControls(false);
        p CameraSetPosition( p.origin, p.angles );
        p CameraActivate( false );
    }
}

intro_camera_blackscreen()
{
    level.keep_everything_off = true;
    intro_screen = newHudElem();
    intro_screen.x = 0;
    intro_screen.y = 0;
    intro_screen.vertalign = "fullscreen";
    intro_screen.horzalign = "fullscreen";
    intro_screen.foreground = 0;
    intro_screen.hidewheninmenu = 0;
    intro_screen.sort = 50;
    intro_screen setshader( "black", 640, 480 );
    intro_screen.alpha = 1;
    wait 1;
    intro_screen fadeOverTime( 1.5 );
    intro_screen.alpha = 0;
    level waittill( "start_fading_again" );
    intro_screen fadeOverTime( 4.5 );
    intro_screen.alpha = 1;
    wait 6;
    intro_screen fadeOverTime( 0.5 );
    intro_screen.alpha = 0;
    wait 1;
    intro_screen destroy();
    wait 0.05;
    level notify( "can_start_normal_zombie_huds" );
    level.keep_everything_off = false;
}

track_e_trap_ee_kills()
{
    level endon( "end_game" );
    while( level.e_trap_ee_kills < level.e_trap_ee_kills_required )
    {
        wait 1;
    }
    wait 1;
    level thread activate_avogadro_zombies();
}

activate_avogadro_zombies()
{
    level endon( "end_game" );
    
    knife_loc = ( 11092.5, 8447.29, -545.993 );
    cant_be_done = false;
    first = true;
    while( true )
    {
        for( s = 0; s < level.players.size; s++ )
        {
            if( distance( knife_loc, level.players[ s ].origin ) < 150 )
            {
                if( level.players[ s ] meleeButtonPressed() )
                {
                    if( !cant_be_done )
                    {
                        cant_be_done = true;
                        level thread reward_mini_quest_avogadro_zombies();
                        if( first )
                        {
                            iprintlnbold( "^8What have you done?!" );
                            level.players[ s ].score += 1500;
                            level.players[ s ] playsound( "zmb_cha_ching" );
                            first = false;
                        }
                        
                        wait 5;
                        //break;
                    }
                    else if( cant_be_done )
                    {
                        level notify( "stop_avogadro_shit" );
                        cant_be_done = false;
                        wait 5;
                    }
                    
                }
            }
        }
        wait 0.1;
    }
}
zap_zombies( zombie )
{
    if ( isdefined( zombie.ignore_electric_trap ) && zombie.ignore_electric_trap )
        return;

    if ( zombie.health > level.etrap_damage )
    {
        zombie dodamage( level.etrap_damage, self.origin );
        zombie.ignore_electric_trap = 1;
        return;
    }

    self playsound( "wpn_zmb_electrap_zap" );

    if ( !( isdefined( level.electrocuting_zombie ) && level.electrocuting_zombie ) )
    {
        thread electrocution_lockout( 2 );
        zombie thread play_elec_vocals();
        level.e_trap_ee_kills++;
        zombie thread maps\mp\zombies\_zm_traps::electroctute_death_fx();
        zombie.is_on_fire = 0;
        zombie notify( "stop_flame_damage" );
    }

    zombie thread electrictrapkill( self );
}
reward_mini_quest_avogadro_zombies() 
{
    level endon( "end_game" );
    level endon( "stop_avogadro_shit" );
    while( true )
    {
        foreach( zom in getAIArray( level.zombie_team ) )
        {
            if( zom.model != "c_zom_avagadro_fb" )
            {
                zom setmodel( "c_zom_avagadro_fb" );
                //zom detach( zom.headmodel );
                zom detachall();
            }
            
        }
        wait 1;
    }
    
}
take_ss()
{
    level endon( "end_game" );
    wait 20;
        if( isdefined( self.clays_shade ) ) { self.clays_shade.alpha = 0; }
        if( isdefined( self.clays ) ) { self.clays.alpha = 0; }
        if( isdefined( self.jetgun_ammo_hud ) ) { self.jetgun_ammo_hud.alpha = 0; }
        if( isdefined( self.jetgun_name_hud ) ) { self.jetgun_name_hud.alpha = 0; }
        if( isdefined( self.location_hud ) ) { self.location_hud.alpha = 0; }
        if( isdefined( self.survivor_points ) ) { self.survivor_points.alpha = 0; }
        if( isdefined( self.real_score_hud ) ) { self.real_score_hud.alpha = 0; }
        if( isdefined( self.weapon_ammo ) ) { self.weapon_ammo.alpha = 0; }
        if( isdefined( self.weapon_ammo_stock ) ) { self.weapon_ammo_stock.alpha = 0; }
        if( isdefined( self.playname ) ) { self.playname.alpha = 0; }
        wait 0.05;
    level.huddefcon.alpha = 0;
    level.huddefconline.alpha = 0;
    level.hud.alpha = 0;

}
reward_clip_size_4x()
{
    level endon( "end_game" );
    level endon( "fail_s_end_4x_reward_waittill" );
    while( true )
    {
        if( level.round_number == 24 )
        {
            while( level.round_number != 25 )
            {
                wait 1;
            }
            wait 10;
            level thread print_text_middle( "^9Call Of Juarez ^3x2 ^8Reward Unlocked", "^8Survivors now pack twice the amount of original ^9Call Of Juarez' ^8clip size.", "^8Survivor's ammo pouche capacity has been increased.", 6, 0.25 );
            foreach( playa in level.players )
            {
                playa playsound( "evt_player_upgrade" );
                playa setclientdvar( "player_clipsizemultiplier", 4.0 );
            }
            setdvar( "player_clipSizeMultiplier", 4.0 ); 
            break;
            level notify( "fail_s_end_4x_reward_waittill" );
        }
        wait 1;
    }
}
reward_give_phd()
{
    level endon( "end_game" );
    self endon( "disconnect" );
    wait 1.5;
    self thread monitor_flopping();
    set_zombie_var( "zombie_perk_divetonuke_radius", 300 );
    set_zombie_var( "zombie_perk_divetonuke_min_damage", 1000 );
    set_zombie_var( "zombie_perk_divetonuke_max_damage", 99999 );

    self setperk( "specialty_flakjacket"  );

    while( true )
    {
        self waittill_any( "death", "remove_static", "disconnect" );
        wait 1;
        self waittill( "spawned_player" );
        self setperk( "specialty_flakjacket"  );

    }

}

monitor_flopping()
{
    self endon( "disconnect" );
    level endon( "end_game" );
    allowed = true;
    while( true )
    {
        if( self StanceButtonPressed() && allowed )
        {
            wait 0.1;
            h_old = self.origin[2];
            allowed = false;
            if( self getStance() == "prone" )
            {
                if( !self isOnGround() )
                {   
                    while( !self isOnGround() )
                    {
                        wait 0.05;
                    }
                    h_new = self.origin[2];
                    if( h_new < h_old && h_new < h_old - 100 )
                    {
                        org = self getOrigin();
                        self thread divetonuke_explode( self, org );
                    }               
                }
            }
            allowed = true;
        }
        wait 0.05;
    }
}

divetonuke_host_migration_func()
{
    flop = getentarray( "vending_divetonuke", "targetname" );

    foreach ( perk in flop )
    {
        if ( isdefined( perk.model ) && perk.model == level.machine_assets["divetonuke"].on_model )
        {
            perk perk_fx( undefined, 1 );
            perk thread perk_fx( "divetonuke_light" );
        }
    }
}

divetonuke_explode( attacker, origin )
{
    radius = level.zombie_vars["zombie_perk_divetonuke_radius"];
    min_damage = level.zombie_vars["zombie_perk_divetonuke_min_damage"];
    max_damage = level.zombie_vars["zombie_perk_divetonuke_max_damage"];

   
    radiusdamage( origin, radius, max_damage, min_damage, attacker, "MOD_GRENADE_SPLASH" );

    playfx( level.myFx[ 91 ], origin );
    wait 0.05;
    playfx( level.myFx[ 9 ], origin );
    attacker playsound( "zmb_phdflop_explo" );
    //maps\mp\_visionset_mgr::vsmgr_activate( "visionset", "zm_perk_divetonuke", attacker );
    wait 1;
    //maps\mp\_visionset_mgr::vsmgr_deactivate( "visionset", "zm_perk_divetonuke", attacker );
}


notiff()
{
    //iprintlnbold( "TEST" );
}
waittill_rewards()
{
    level endon( "end_game" );
    //commented out to debug
    //level waittill( "final_quest_reached" );

    level thread be_rewarded();
}

be_rewarded()
{
    level endon( "end_game" );

    r_player = level.players;
    //add a Schruder notifier in here or elsewhere at upon player reward
    for( i = 0; i < r_player.size; i++ )
    {
        //normal perks
        r_player[ i ] thread perk_give_normal();
        //phd + stamina, need to change stamina up to something else ( mule ? )
        r_player[ i ] thread perk_give_extra();
        wait( 1 );
        //15k point increase
        r_player[ i ] reward_fortunes();

        
    }

}

reward_fortunes()
{
    self playsoundtoplayer( "purchase", self );
    self.score += 15000;
}
//give player percaholic effect for normal perks
perk_give_normal()
{
    self endon( "disconnect" );

    //create a list of perks
    mod_perks = [];
    mod_perks[ 0 ] = ( "specialty_quickrevive" );
    mod_perks[ 1 ] = ( "specialty_fastreload" );
    mod_perks[ 2 ] = ( "specialty_armorvest" );
    mod_perks[ 3 ] = ( "specialty_rof" );
    mod_perks[ 4 ] = ( "specialty_scavenger" );

    //sound to play
    snd = "cac_cmn_beep";

    //firsttime check
    firsttime = true;
    
    while( true )
    {
        if( !firsttime )
        {
            self waittill( "spawned_player" );
            wait 0.5;
        }

        if( firsttime ){ firsttime = false; }

        for( s = 0; s < mod_perks.size; s++ )
        {
            if( !self hasPerk( mod_perks[ s ] ) )
            {
                self playLocalSound( snd );
                self give_perk( mod_perks[ s ], 0 );
                self setperk( mod_perks[ s ] );
                wait 1;
            }
        }

        self._retain_perks = true;
        for( i = 0; i < 6; i++ )
        {
            self playLocalSound( snd );
            wait 0.1;
        }
        wait 1;
        //waittill loop again
        self waittill_any( "death", "player_downed" );
        
    }
    
}

perk_give_extra()
{
    level endon( "end_game" );
    self endon( "death" );
    self endon( "disconnect" );


    always_on = false;
    self thread player_reward_flopper();
    for( i = 0; i < 6; i++ )
    {
        self playSoundToPlayer( "cac_cmn_beep", self );
    }
    self thread player_reward_marathon();
    wait 1;
}



player_reward_flopper()
{
    
    level endon( "end_game" );
    self endon( "disconnect" );
    
    wait 1;
    
    //notifier has been moved into main caller func
    self.talk_phd = [];
    r_width = 20;
    r_height = 20;

    width = 310;
    height = 16;
    x = 1.8;
    r = 1.6;
    x = 0;

    self.talker_phd = newClientHudElem( self );
    self.talker_phd.x = -40;
    self.talker_phd.alignx = "center";
    self.talker_phd.aligny = "center";
    self.talker_phd.horzalign = "user_center";
    self.talker_phd.vertalign = "user_center";
    self.talker_phd.alpha = 0;
    self.talker_phd.foreground = true;
    self.talker_phd.hidewheninmenu = true;
    self.talker_phd setshader( "hud_chalk_3", r_width, r_height );
    self.talker_phd.color = ( 1, 0, 1 );
    self.talker_phd.y = -25;
    s = 0;

    for ( f = 0; f < 2; f++ )
    {
        self.talk_phd[ f ] = newClientHudElem( self );
        self.talk_phd[ f ].x = 0;
        self.talk_phd[ f ].y = 0;
        self.talk_phd[ f ].alignx = "center";
        self.talk_phd[ f ].aligny = "center";
        self.talk_phd[ f ].horzalign = "user_center";
        self.talk_phd[ f ].vertalign = "user_center";
        self.talk_phd[ f ].foreground = true;
        self.talk_phd[ f ].alpha = 0;
        self.talk_phd[ f ].color = ( 1, 1, 1 );
        self.talk_phd[ f ].inuse = false;
        self.talk_phd[ f ].hidewheninmenu = true;
        self.talk_phd[ f ].font = "default";
    }
    wait 0.05;
    self.talk_phd[ 0 ].y = 10;
    self.talk_phd[ 1 ].y = -5;
   

    self.talk_phd[ 0 ].fontscale = 1.6;
    self.talk_phd[ 1 ].fontscale = 1.3;
    

    self.talk_phd[ 0 ] settext( "[ ^6Permament Perk Rewarded^7 ]" );
    self.talk_phd[ 1 ] settext( "PHD ^6Flopper" );
    
    
    self.talk_phd[ 0 ].alpha = 0;
    self.talk_phd[ 1 ].alpha = 0;

    f = 2;
    for ( s = 0; s < self.talk_phd.size; s++ )
    {
        self.talk_phd[ s ].alpha = 0;
        self.talk_phd[ s ] fadeovertime( f );
        self.talk_phd[ s ].alpha = 1;
        wait 1.5;
        f -= 0.25;
    }


    self.talker_phd.alpha = 0;
    self.talker_phd fadeovertime( 1 );
    self.talker_phd.alpha = 1;
    
    wait 6;

    self.talker_phd.alpha = 1;
    self.talker_phd fadeovertime( 2 );
    self.talker_phd.alpha = 0;

    f = 2;
    for ( s = 0; s < self.talk_phd.size; s++ )
    {
        self.talk_phd[ s ].alpha = 1;
        self.talk_phd[ s ] fadeovertime( f );
        self.talk_phd[ s ].alpha = 0;
        wait 1.5;
        f -= 0.25;
    }
    wait 3;
    self.talker_phd.alignx = "left";
    self.talker_phd.aligny = "bottom";
    self.talker_phd.horzalign = "user_left";
    self.talker_phd.vertalign = "user_bottom";

    for( s = 0; s < self.talk_phd.size; s++ )
    {
        self.talk_phd[ s ].alignx = "left";
        self.talk_phd[ s ].aligny = "bottom";
        self.talk_phd[ s ].horzalign = "user_left";
        self.talk_phd[ s ].vertalign = "user_bottom";
        wait 0.08;
    }
    self.talker_phd.x = 10;
    self.talker_phd.y = -45;
    self.talk_phd[ 1 ].x = 25;
    self.talk_phd[ 1 ].y = -50;

    self.talker_phd.alpha = 0;
    self.talker_phd fadeovertime( 1.5 );
    self.talker_phd.alpha = 1; 

    wait 0.05;

    self.talk_phd[ 1 ].alpha = 0;
    self.talk_phd[ 1 ] fadeovertime( 1.5 );
    self.talk_phd[ 1 ].alpha = 1; 

    wait 1.5;

    self setperk( "specialty_phd" );
    self setperk( "specialty_flakjacket" );
    //self setperk( "specialty_armorvest" );
    self waittill_any( "death", "remove_static", "disconnect" );
    self.talker_phd destroy_hud();
    self.talk_phd[ 0 ] destroy_hud();
    self.talk_phd[ 1 ] destroy_hud();

}


player_reward_marathon()
{
    
    level endon( "end_game" );
    self endon( "disconnect" );

    wait 1;
    
    self.talk_marathon = [];
    r_width = 20;
    r_height = 20;

    width = 310;
    height = 16;
    x = 1.8;
    r = 1.6;
    x = 0;

    self.talker_marathon = newClientHudElem( self );
    self.talker_marathon.x = -40;
    self.talker_marathon.alignx = "center";
    self.talker_marathon.aligny = "center";
    self.talker_marathon.horzalign = "user_center";
    self.talker_marathon.vertalign = "user_center";
    self.talker_marathon.alpha = 0;
    self.talker_marathon.foreground = true;
    self.talker_marathon.hidewheninmenu = true;
    self.talker_marathon setshader( "hud_chalk_3", r_width, r_height );
    self.talker_marathon.color = ( 1, 0.7, 0 );
    self.talker_marathon.y = -25;
    s = 0;

    for ( f = 0; f < 2; f++ )
    {
        self.talk_marathon[ f ] = newClientHudElem( self );
        self.talk_marathon[ f ].x = 0;
        self.talk_marathon[ f ].y = 0;
        self.talk_marathon[ f ].alignx = "center";
        self.talk_marathon[ f ].aligny = "center";
        self.talk_marathon[ f ].horzalign = "user_center";
        self.talk_marathon[ f ].vertalign = "user_center";
        self.talk_marathon[ f ].foreground = true;
        self.talk_marathon[ f ].alpha = 0;
        self.talk_marathon[ f ].color = ( 1, 1, 1 );
        self.talk_marathon[ f ].inuse = false;
        self.talk_marathon[ f ].hidewheninmenu = true;
        self.talk_marathon[ f ].font = "default";
    }
    wait 0.05;
    self.talk_marathon[ 0 ].y = 10;
    self.talk_marathon[ 1 ].y = -5;
   

    self.talk_marathon[ 0 ].fontscale = 1.6;
    self.talk_marathon[ 1 ].fontscale = 1.3;
    

    self.talk_marathon[ 0 ] settext( "[ ^3Permament Perk Rewarded^7 ]" );
    self.talk_marathon[ 1 ] settext( "Stamina ^3Up" );
    
    
    self.talk_marathon[ 0 ].alpha = 0;
    self.talk_marathon[ 1 ].alpha = 0;

    f = 2;
    for ( s = 0; s < self.talk_marathon.size; s++ )
    {
        self.talk_marathon[ s ].alpha = 0;
        self.talk_marathon[ s ] fadeovertime( f );
        self.talk_marathon[ s ].alpha = 1; //1
        wait 1.5;
        f -= 0.25;
    }


    self.talker_marathon.alpha = 0;
    self.talker_marathon fadeovertime( 1 );
    self.talker_marathon.alpha = 1;
   
    wait 6;

    self.talker_marathon.alpha = 1;
    self.talker_marathon fadeovertime( 2 );
    self.talker_marathon.alpha = 0;

    f = 2;
    for ( s = 0; s < self.talk_marathon.size; s++ )
    {
        self.talk_marathon[ s ].alpha = 1;
        self.talk_marathon[ s ] fadeovertime( f );
        self.talk_marathon[ s ].alpha = 0;
        wait 1.5;
        f -= 0.25;
    }
    wait 3;
    self.talker_marathon.alignx = "left";
    self.talker_marathon.aligny = "bottom";
    self.talker_marathon.horzalign = "user_left";
    self.talker_marathon.vertalign = "user_bottom";

    for( s = 0; s < self.talk_marathon.size; s++ )
    {
        self.talk_marathon[ s ].alignx = "left";
        self.talk_marathon[ s ].aligny = "bottom";
        self.talk_marathon[ s ].horzalign = "user_left";
        self.talk_marathon[ s ].vertalign = "user_bottom";
        wait 0.08;
    }
    self.talker_marathon.x = 10;
    self.talker_marathon.y = -25;
    self.talk_marathon[ 1 ].x = 25;
    self.talk_marathon[ 1 ].y = -30;

    self.talker_marathon.alpha = 0;
    self.talker_marathon fadeovertime( 1.5 );
    self.talker_marathon.alpha = 1;

    wait 0.05;

    self.talk_marathon[ 1 ].alpha = 0;
    self.talk_marathon[ 1 ] fadeovertime( 1.5 );
    self.talk_marathon[ 1 ].alpha = 1;

    wait 1.5;

    self setperk( "specialty_unlimitedsprint" );
	self setperk( "specialty_fastmantle" );
    self setClientDvar( "player_backSpeedScale", 1 );
	self setClientDvar( "player_strafeSpeedScale", 1 );
	self setClientDvar( "player_sprintStrafeSpeedScale", 1 );

	self setClientDvar( "dtp_post_move_pause", 0 );
	self setClientDvar( "dtp_exhaustion_window", 100 );
	self setClientDvar( "dtp_startup_delay", 100 );

    self waittill_any( "death", "remove_static", "disconnect" );
    self.talker_marathon destroy_hud();
    self.talk_marathon[ 0 ] destroy_hud();
    self.talk_marathon[ 1 ] destroy_hud();

}



print_text_middle( textbig, textsmall, textsmall_lower, duration, fadefloat )
{
    if( duration > 6 )
    {
        duration = 5;
    }
    level endon( "end_game" );
    if( level.hudtext.alpha != 0 )
    {
        wait 0.05;
        while( level.hudtext.alpha != 0 )
        {
            wait 0.5;
        }
    }
    if( isdefined( level.mid_print_text_big ) && level.mid_print_text_big != "" )
    {
        while( isdefined( level.mid_print_text_big ) && level.mid_print_text_big != "" )
        {
            wait 2.5;
        }
    }
    wait 1;
    make_middle_print_struct();
    level.mid_print_text_big.alpha = 0;
    level.mid_print_text_small.alpha = 0;
    level.mid_print_text_small_lower.alpha = 0;
    level.mid_print_text_big settext( textbig );
    level.mid_print_text_small settext( "^8" +textsmall );
    level.mid_print_text_small_lower settext( "^8"+ textsmall_lower );

    level.mid_print_text_big fadeOverTime( 1.5 );
    level.mid_print_text_big.alpha = 1;
    wait 1.5;

    level.mid_print_text_small fadeovertime( 1.5 );
    level.mid_print_text_small.alpha = 1;
    wait 0.5;
    level.mid_print_text_small_lower fadeovertime( 1 );
    level.mid_print_text_small_lower.alpha = 1;
    wait duration;

    level.mid_print_text_big fadeOverTime( 1.5 );
    level.mid_print_text_big.alpha = 0;
    wait 1;
    level.mid_print_text_small fadeOverTime( 1.5 );
    level.mid_print_text_small.alpha = 0;
    wait 1;
    level.mid_print_text_small_lower fadeOverTime( 1 );
    level.mid_print_text_small_lower.alpha = 0;
    wait 1.5;
    level.mid_print_text_small_lower setText( "" );
    level.mid_print_text_big settext( "" );
    level.mid_print_text_small settext( "" );

    level.mid_print_text_big destroy();
    level.mid_print_text_small destroy();
    level.mid_print_text_small_lower destroy();

    level.mid_print_text_big = undefined;
    level.mid_print_text_small = undefined;
    level.mid_print_text_small_lower = undefined;
}





make_middle_print_struct()
{
    level.mid_print_text_big = NewHudElem();
	level.mid_print_text_big.x = 0;
	level.mid_print_text_big.y = 125;
	level.mid_print_text_big SetText( "" );
	level.mid_print_text_big.fontScale = 2.25;
	level.mid_print_text_big.alignX = "CENTER";
	level.mid_print_text_big.alignY = "CENTER";
	level.mid_print_text_big.horzAlign = "center";
	level.mid_print_text_big.vertAlign = "center";
	level.mid_print_text_big.sort = 1;

    level.mid_print_text_small = newhudelem();
    level.mid_print_text_small.x = 0;
    level.mid_print_text_small.y = 170;
    level.mid_print_text_small settext( "" );
    level.mid_print_text_small.fontscale = 1.15;
    level.mid_print_text_small.alignx = "CENTER";
    level.mid_print_text_small.aligny = "CENTER";
    level.mid_print_text_small.horzalign = "CENTER";
    level.mid_print_text_small.vertalign = "CENTER";
    level.mid_print_text_small.sort = true;

    level.mid_print_text_small_lower = newhudelem();
    level.mid_print_text_small_lower.x = 0;
    level.mid_print_text_small_lower.y = 182.5;
    level.mid_print_text_small_lower settext( "" );
    level.mid_print_text_small_lower.fontscale = 1.05;
    level.mid_print_text_small_lower.alignx = "CENTER";
    level.mid_print_text_small_lower.aligny = "CENTER";
    level.mid_print_text_small_lower.horzalign = "CENTER";
    level.mid_print_text_small_lower.vertalign = "CENTER";
    level.mid_print_text_small_lower.sort = true;
}




intro_camera_credit()
{
    level endon( "end_game" );

    setdvar( "g_ai", false );
    level.i_b_t = NewHudElem();
	level.i_b_t.x = -210;
	level.i_b_t.y = 275;
	level.i_b_t SetText( "^9Tranzit ^8Revamped" );
	level.i_b_t.fontScale = 2.05;
	level.i_b_t.alignX = "CENTER";
	level.i_b_t.alignY = "CENTER";
	level.i_b_t.horzAlign = "center";
	level.i_b_t.vertAlign = "center";
	level.i_b_t.sort = 1;
    level.i_b_t.alpha = 0;


    level.i_s_t = newhudelem();
    level.i_s_t.x = -175;
    level.i_s_t.y = 300;
    level.i_s_t settext( "By: Ultimateman" );
    level.i_s_t.fontscale = 1.15;
    level.i_s_t.alignx = "CENTER";
    level.i_s_t.aligny = "CENTER";
    level.i_s_t.horzalign = "CENTER";
    level.i_s_t.vertalign = "CENTER";
    level.i_s_t.sort = true;

    level.i_s_t.color = ( 0.69, 0.78, 0.54 );
    level.i_s_t.alpha = 0;

    wait 4;
    level.i_b_t fadeOverTime( 2 );
    level.i_b_t.alpha = 1;
    wait 3;
    level.i_s_t fadeovertime( 1.5 );
    level.i_s_t.alpha = 1;
    wait 12;

    level.i_s_t fadeovertime( 1.5 ); 
    level.i_b_t fadeOverTime( 1.5 );
    level.i_b_t.alpha = 0;
    level.i_s_t.alpha = 0;
    wait 1;

    level.i_b_t destroy();
    level.i_s_t destroy();
    wait 4.5;
    setdvar( "g_ai", true  );
}



precache_these_models()
{
    precachemodel( "t6_wpn_lmg_rpd_world" );
    precachemodel( "t6_wpn_lmg_rpd_world" );
    precachemodel( "t6_wpn_lmg_rpd_world" );
    precachemodel( "t6_wpn_lmg_rpd_world" );

    
}


debug_placement()
{
    level endon( "end_game" );
    flag_wait( "initial_blackscreen_passed" );
    mod = "t6_wpn_lmg_rpd_world";
    s = spawn( "script_model", level.players[ 0 ].origin );
    s setmodel( mod );
    s.angles = ( 0, 0, 0 );
    s thread move_with_me();
    p = level.players[ 0 ];

    x = 0;
    y = 0;
    z = 0;
    max = 360;
    min = -360;

    list = [];
    list[ 0 ] = ( "t6_wpn_lmg_rpd_world" );
    list[ 1 ] = ( "t6_wpn_lmg_hamr_world" );
    list[ 2 ] = ( "t6_wpn_shotty_srm1216_world" );
    list[ 3 ] = ( "t6_wpn_sniper_m82_world" );
    wait 1;
    while( true )
    {
        if( level.players[ 0 ] attackButtonPressed() && level.players[ 0 ] ActionSlotOneButtonPressed() )
        {
            x++;
            s.angles = ( x, s.angles[ 1 ], s.angles[ 2 ] );
            wait 0.05;
            iprintln( "WEAPON IS AT: ^1" + s.origin + "\n^7WEAPON ANG IS: ^3" + s.angles );
            if( x >= max )
            {
                x = 360;
            }
        }

        if( level.players[ 0 ] adsButtonPressed() && level.players[ 0 ] ActionSlotOneButtonPressed() )
        {
            x--;
            s.angles = ( x, s.angles[ 1 ], s.angles[ 2 ] );
            wait 0.05;
            iprintln( "WEAPON IS AT: ^1" + s.origin + "\n^7WEAPON ANG IS: ^3" + s.angles );
            if( x <= min )
            {
                x = -360;
            }
        }



        if( level.players[ 0 ] attackButtonPressed() && level.players[ 0 ] ActionSlottwoButtonPressed() )
        {
            y++;
            s.angles = ( s.angles[ 0], y, s.angles[ 2 ] );
            wait 0.05;
            iprintln( "WEAPON IS AT: ^1" + s.origin + "\n^7WEAPON ANG IS: ^3" + s.angles );
            if( y >= max )
            {
                y = 360;
            }
        }

        if( level.players[ 0 ] adsButtonPressed() && level.players[ 0 ] ActionSlottwoButtonPressed() )
        {
            y--;
            s.angles = ( s.angles[ 0], y, s.angles[ 2 ] );
            wait 0.05;
            iprintln( "WEAPON IS AT: ^1" + s.origin + "\n^7WEAPON ANG IS: ^3" + s.angles );
            if( y <= min )
            {
                y = -360;
            }
        }

        if( level.players[ 0 ] attackButtonPressed() && level.players[ 0 ] ActionSlotthreeButtonPressed() )
        {
            z++;
            s.angles = ( s.angles[ 0 ], s.angles[ 1 ], z );
            wait 0.05;
            iprintln( "WEAPON IS AT: ^1" + s.origin + "\n^7WEAPON ANG IS: ^3" + s.angles );
            if( z >= max )
            {
                z = 360;
            }
        }

        if( level.players[ 0 ] adsButtonPressed() && level.players[ 0 ] ActionSlotthreeButtonPressed() )
        {
            z--;
            s.angles = ( s.angles[ 0 ], s.angles[ 1 ], z );
            wait 0.05;
            iprintln( "WEAPON IS AT: ^1" + s.origin + "\n^7WEAPON ANG IS: ^3" + s.angles );
            if( z <= min )
            {
                z = -360;
            }
        }

        if( level.players[ 0 ] attackButtonPressed() && level.players[ 0 ] meleeButtonPressed() )
        {
            ind++;
            s setmodel(list[ ind ] );
            wait 0.05;
            if( ind > list.size )
            {
                ind = 0;
            }
        }
        wait 0.05;
    }
}

move_with_me()
{
    level endon( "end_game" );
    while( isdefined( self ) )
    {
        self.origin = level.players[0].origin;
        wait 0.05;
    }
}

do_weapon_buy( weapon, weapon_loc, weapon_angs, str, cost, real_weapon, upgrade_alias )
{
    level endon( "end_game" );
    mod = spawn( "script_model", weapon_loc );
    mod setmodel( weapon );
    mod.angles = weapon_angs;
    wait 1;
    playfxontag( level.myFx[ 47 ], mod, "tag_origin" ); //bar glow

    trig = spawn( "trigger_radius_use", mod.origin, 0,45,45 );
    trig setCursorHint( "HINT_NOICON" );
    trig setHintString( str );
    trig TriggerIgnoreTeam();
    location_takes = [];

    if( real_weapon == "hamr_zm" )
    {
        location_takes[  location_takes.size ] = "hamr_upgraded_zm+reflex";
        location_takes[  location_takes.size ] = "hamr_upgraded_zm+grip";
        location_takes[  location_takes.size ] = "hamr_upgraded_zm+acog";
        location_takes[  location_takes.size ] = "hamr_upgraded_zm";
    }

    if( real_weapon == "rpd_zm" )
    {
        location_takes[  location_takes.size ] = "rpd_upgraded_zm";
    }

    if( real_weapon == "srm1216_zm" )
    {
        location_takes[  location_takes.size ] = "srm1216_upgraded_zm+extbarrel";
        location_takes[  location_takes.size ] = "srm1216_upgraded_zm+reflex";
    }

    if( real_weapon == "hamr_zm" )
    {
        location_takes[  location_takes.size ] = "hamr_upgraded_zm+reflex";
        location_takes[  location_takes.size ] = "hamr_upgraded_zm+grip";
        location_takes[  location_takes.size ] = "hamr_upgraded_zm+acog";
        location_takes[  location_takes.size ] = "hamr_upgraded_zm";
    }

    if( real_weapon == "barretm82_zm" )
    {
        location_takes[  location_takes.size ] = "barretm82_upgraded_zm";
        location_takes[  location_takes.size ] = "barretm82_upgraded_zm+vzoom";
    }

    weapons_up_list = [];
    weapons_up_list_short = [];
    weapons_up_list[ weapons_up_list.size ] = "hamr_upgraded_zm+reflex";
    weapons_up_list[ weapons_up_list.size ] = "hamr_upgraded_zm+grip";
    weapons_up_list[ weapons_up_list.size ] = "hamr_upgraded_zm+acog";
    weapons_up_list[ weapons_up_list.size ] = "barretm82_upgraded_zm+vzoom";
    weapons_up_list[ weapons_up_list.size ] = "barretm82_upgraded_zm";
    weapons_up_list[ weapons_up_list.size ] = "srm1216_upgraded_zm+extbarrel";
    weapons_up_list[ weapons_up_list.size ] = "srm1216_upgraded_zm+reflex";
    weapons_up_list[ weapons_up_list.size ] = "rpd_upgraded_zm";

    weapons_up_list_short[ weapons_up_list_short.size ] = "upgraded_zm+reflex";
    weapons_up_list_short[ weapons_up_list_short.size ] = "upgraded_zm+grip";
    weapons_up_list_short[ weapons_up_list_short.size ] = "upgraded_zm+acog";
    weapons_up_list_short[ weapons_up_list_short.size ] = "upgraded_zm+vzoom";
    weapons_up_list_short[ weapons_up_list_short.size ] = "upgraded_zm+extbarrel";
    weapons_up_list_short[ weapons_up_list_short.size ] = "upgraded_zm";
    w_cost = cost;
    f = false;
    cant_do = true;
    while( true )
    {
        trig waittill( "trigger", buyer );
        wait 0.05;
        //this check checks the wallbuy's upgrade alt name
        
        if( is_player_valid( buyer ) )
        {

            get_alt_up = buyer getcurrentweapon();
            gi = buyer getweaponslistprimaries();


            for( s = 0; s < location_takes.size; s++ )
            {
                if( buyer hasweapon( location_takes[ s ] ) )
                {
                    if( buyer.score >= 5000 )
                    {
                        buyer playsound( "zmb_cha_ching" );
                        buyer.score -= 5000;
                        buyer givemaxammo( location_takes[ s ] );
                        wait 1;
                        continue;
                    }
                }
            }

            if( buyer hasweapon( real_weapon ) )
            {
                if( buyer.score >= 750 )
                {
                    buyer playsound( "zmb_cha_ching" );
                    buyer.score -= 750;
                    buyer givemaxammo( real_weapon );
                    wait 1;
                    continue;
                }
            }



            else if( !buyer hasweapon( real_weapon )   )
            {
                for( u = 0; u < location_takes.size; u++ )
                {
                    if( buyer hasweapon( location_takes[ u ] ) )
                    {
                        wait 1;
                        cant_do = false;
                        continue;
                    }
                }
                if( !cant_do ){ wait 1; continue; }
                list = buyer getweaponslistprimaries();
                if( list.size > 1 )
                {
                    buyer takeweapon( buyer getcurrentweapon() );
                    wait 0.05;
                }
                if( buyer.score < cost ){ wait 0.05; continue; }
                buyer playsound( "zmb_cha_ching" );
                buyer.score -= cost;
                buyer giveweapon( real_weapon );
                buyer givemaxammo( real_weapon );
                buyer switchtoweapon( real_weapon );
                wait 1;
                continue;
            }
        }
        wait 1;
    }
}
spawn_rpd_buyables()
{
    level endon( "end_game" );

    locs = [];
    angs = [];
    
    //cabin tree
    locs[ 0 ] = ( 4659.38, 5971.31, -48.0945 );
    angs[ 0 ] = ( -54, 0, -86 );

    cost = 1750;
    list[ 0 ] = ( "t6_wpn_lmg_rpd_world" );
    list[ 1 ] = ( "t6_wpn_lmg_hamr_world" );
    list[ 2 ] = ( "t6_wpn_shotty_srm1216_world" );
    list[ 3 ] = ( "t6_wpn_sniper_m82_world" );
    upgrade_alias = "rpd_upgraded_zm";
    strings = "^8[ ^9[{+activate}] ^8To Purchase ^9RPD ^8]\n^8Cost: ^9" + cost + "^8 | ^9Ammo: ^8750 ^9/ ^8Upgraded: ^95000";
    level thread do_weapon_buy( list[ 0 ], locs[ 0 ], angs[ 0 ], strings, cost, "rpd_zm", upgrade_alias  );
    

    //locs[  ] = (  );
    //angs[  ] = (  );

    //locs[  ] = (  );
    //angs[  ] = (  );
}

spawn_hamr_buyables()
{
    level endon( "end_game" );

    locs = [];
    angs = [];


    //p station white car below jump down
    locs[ 0 ] = ( 10408.6, 8289.28, -557.757 );
    angs[ 0 ] = ( -57, -20, -95 );

    //town bar outside
    locs[ 1 ] = (  1953.29, -134.163, -35.5762 );
    angs[ 1 ] = ( -109, 263, -62 );


    cost = 2000;
    list[ 0 ] = ( "t6_wpn_lmg_rpd_world" );
    list[ 1 ] = ( "t6_wpn_lmg_hamr_world" );
    list[ 2 ] = ( "t6_wpn_shotty_srm1216_world" );
    list[ 3 ] = ( "t6_wpn_sniper_m82_world" );
    strings = "^8[ ^9[{+activate}] ^8To Purchase ^9HAMR LMG ^8]\n^8Cost: ^9" + cost + "^8 | ^9Ammo: ^8750 ^9/ ^8Upgraded: ^95000";
    upgrade_alias = "hamr_upgraded_zm";
    level thread do_weapon_buy( list[ 1 ], locs[ 0 ], angs[ 0 ], strings, cost, "hamr_zm" );
    wait 1;
    level thread do_weapon_buy( list[ 1 ], locs[ 1 ], angs[ 1 ], strings, cost, "hamr_zm", upgrade_alias );
}

spawn_smr_buyables()
{
    level endon( "end_game" );

    locs = [];
    angs = [];

    //nacht
    locs[ 0 ] = ( 13537.5, -322.785, -168.664 );
    angs[ 0 ] = ( -73, -19, 95 ); 

    //church
    locs[ 1 ] = ( 1903.66, -2668.69, -0.745096 );
    angs[ 1 ] = ( -95, 169, -61 );

    cost = 1050;
    list[ 0 ] = ( "t6_wpn_lmg_rpd_world" );
    list[ 1 ] = ( "t6_wpn_lmg_hamr_world" );
    list[ 2 ] = ( "t6_wpn_shotty_srm1216_world" );
    list[ 3 ] = ( "t6_wpn_sniper_m82_world" );
    upgrade_alias = "srm1216_upgraded_zm";
    strings = "^8[ ^9[{+activate}] ^8To Purchase ^9SRM1216 ^8]\n^8Cost: ^9" + cost + "^8 | ^9Ammo: ^8750 ^9/ ^8Upgraded: ^95000";
    level thread do_weapon_buy( list[ 2 ], locs[ 0 ], angs[ 0 ], strings, cost, "srm1216_zm" );
    wait 1;
    level thread do_weapon_buy( list[ 2 ], locs[ 1 ], angs[ 1 ], strings, cost, "srm1216_zm", upgrade_alias );
}

spawn_barret_buyables()
{
    level endon( "end_game" );

    locs = [];
    angs = [];

    //middle field road at corn
    locs[ 0 ] = ( 10118.7, -452.578, -204.328 );
    angs[ 0 ] = ( -77, 124, 73 );

    //bus depo outside waiting area
    locs[ 1 ] = ( -7352.28, 4591.31, -34.7923 );
    angs[ 1 ] = (  -81, 306, -18 );

    cost = 850;
    list[ 0 ] = ( "t6_wpn_lmg_rpd_world" );
    list[ 1 ] = ( "t6_wpn_lmg_hamr_world" );
    list[ 2 ] = ( "t6_wpn_shotty_srm1216_world" );
    list[ 3 ] = ( "t6_wpn_sniper_m82_world" );
    upgrade_alias = "barretm82_upgraded_zm";
    //"barretm82_upgraded_zm+vzoom"
    //"barretm82_upgraded_zm"
    strings = "^8[ ^9[{+activate}] ^8To Purchase ^9Barretta M82 ^8]\n^8Cost: ^9" + cost + "^8 | ^9Ammo: ^8750 ^9/ ^8Upgraded: ^95000";
    level thread do_weapon_buy( list[ 3 ], locs[ 0 ], angs[ 0 ], strings, cost, "barretm82_zm" );
    wait 1;
    level thread do_weapon_buy( list[ 3 ], locs[ 1 ], angs[ 1 ], strings, cost, "barretm82_zm", upgrade_alias );
}

