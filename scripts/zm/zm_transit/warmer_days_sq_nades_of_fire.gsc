//this script is responsible for the tranzit 2.0 v2 "Ray Nades" sidequest logic
//small sidequest for players to complete in the map
//upon completing the quest, players receive upgraded nades that when thrown, launch up in the air shooting a burst of rays towards zombies in the close vicinity

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
    //this purpose is to play fake fire nade if one is already targeting zombies
    //otherwise we g_spawn error due to too many models in the map simultaneously
    level.fake_handle_required = false;


    precachemodel( "c_zom_farmgirl_viewhands" );
    precachemodel( "c_zom_oldman_viewhands" );
    precachemodel( "c_zom_engineer_viewhands" );
    precachemodel( "c_zom_reporter_viewhands" );
    precachemodel( "c_zom_player_farmgirl_fb" );
    precachemodel( "c_zom_player_oldman_fb" );
    precachemodel( "c_zom_player_engineer_fb" );
    precachemodel( "c_zom_player_reporter_fb" );
    precachemodel( "c_zom_avagadro_fb" );
    precachemodel( "c_zom_player_cdc_fb" );
    precachemodel( "c_zom_player_cia_fb"  );
    precachemodel( "c_zom_hazmat_viewhands" );
    precachemodel( "c_zom_suit_viewhands" );
    //precachemodel
    //precachemodel
    //precachemodel
    //precachemodel
    //disable zombies, enable godm, 50k pts
    //level thread fordev();
    //level thread make_characters_for_trailer();
    //build check for printlines
    level.dev_time = false;
    
    //fire nade quest, step1 triggers
    level.trigger_to_hit_with_nade = []; 

    //is the quest thread running?
    level.firegrenade_quest_active = false;

    //setup firenade quest
    level thread quest_firenades_init(); //enable later back on

    //for summoning
    //ignore_find_flesh
    level.ignore_find_flesh = ::stop_zomb;
    
}

make_characters_for_trailer()
{
    level endon( "end_game" );
    flag_wait( "initial_blackscreen_passed"  );
    wait 4;
    chars = [];
    views = [];
    chars[ 0 ] = ( "c_zom_player_farmgirl_fb" );
    chars[ 1 ] = ( "c_zom_player_oldman_fb" );
    chars[ 2 ] = ( "c_zom_player_engineer_fb" );
    chars[ 3 ] = ( "c_zom_player_reporter_fb" );
    //chars[ 4 ] = ( "c_zom_avagadro_fb" );
    //chars[ 5 ] = ( "c_zom_player_cdc_fb" );
    //chars[ 6 ] = ( "c_zom_player_cia_fb"  );

    views[ 0 ] = ( "c_zom_farmgirl_viewhands"  ); //self set_player_is_female( 1 );
    views[ 1 ] = ( "c_zom_oldman_viewhands" );
    views[ 2 ] = ( "c_zom_engineer_viewhands"  );
    views[ 3 ] = ( "c_zom_reporter_viewhands" );
    //views[ 4 ] = ( "c_zom_reporter_viewhands" );
    //views[ 5 ] = ( "c_zom_hazmat_viewhands" );
    //views[ 6 ] = ( "c_zom_suit_viewhands" );

    wait 1;
    s = 0;
    while( true )
    {
        if( level.players[ 0 ] useButtonPressed() && level.players[ 0 ] adsButtonPressed() )
        {
            level.players[ 0 ] setmodel( chars[ s ] );
            level.players[ 0 ] setViewModel( views[ s ] );
            wait 0.1;
            s++;
            if( s > chars.size  )
            {
                s = 0;
            }
        }
        else 
        {
            wait 0.15;
        }
        wait 0.05;
    }
}

tm_()
{
    self endon( "death" );
    self endon( "disconnect" );

    for (;;)
    {
        wait 10.0;
        notifydata = spawnstruct();
        notifydata.titletext = "THIS_SHIIIIIIIT";
        notifydata.notifytext = "wheee";
        notifydata.sound = "mp_challenge_complete";
        self thread maps\mp\gametypes_zm\_hud_message::notifymessage( notifydata );
    }
}


//remove
fordev()
{
    level endon( "end_game" );

    flag_wait( "initial_blackscreen_passed" );

    level.player_out_of_playable_area_monitor = false;
    //setdvar( "sv_cheats", 1 );
    //setdvar( "g_ai", false );
    setdvar( "player_clipSizeMultiplier", 2.0 );    
    for( i = 0; i < level.players.size; i++ )
    {
        //level.players[ i ] enableInvulnerability();  
        //level.players[ i ].score += 10000;
        //level.players[ i ] thread firegrenades_step2();
    }
}

//call all quest logic in here
quest_firenades_init()
{
    level endon( "end_game" );
    flag_wait( "initial_blackscreen_passed" );
    wait 5;
    
    level.firegrenade_quest_active = true;
    if( level.dev_time )
    {
        iprintlnbold( "FIREGUEST ACTIVE: ^3" + level.firegrenade_quest_active );
    }
    

    /* STEP 1 | STEP 1 | STEP 1 | STEP 1 */
    for( s = 0; s < level.players.size; s++ )
    {
        //assign player threads
        level.players[ s ] thread firegrenade_monitor_throw();
    }

    //actual step1
    level thread firegrenades_step1();
    
    /*  failsafe for connecting players when the quest is active
        assigns a hit_list array to every newly connecting player   */
    level thread firegrenade_assign_hitlist_to_connecting_midgame();

    /* STEP 2 | STEP 2 | STEP 2 | STEP 2 */



    
}

//firenade locations & trigger + model set up
firegrenades_step1()
{
    level endon( "end_game" );

    //trigger origins
    locations = [];
    locations[ 0 ] = ( -2598.9, 651.268, -301.243 ); //broken bridge, lava creek
    locations[ 1 ] = ( 10999.5, 8596.1, -1018.74 ) + ( 0, 0, 750 ); //power station, lava pit, tried to raise it to be more easy to hit
    locations[ 2 ] = ( -5379.64, 5284.82, 79.4646 ); //left of bus depot
    locations[ 3 ] = ( 7218.47, -6443.15, -72.0212 ); //farm
    locations[ 4 ] = ( 2898.9, -462.642, -63.1327 ); //back town

    
    wait 1;

    for( x = 0; x < locations.size; x++ )
    {
        level.trigger_to_hit_with_nade[ x ] = spawn( "trigger_radius", locations[ x ], 0, 300, 300 );
        level.trigger_to_hit_with_nade[ x ] setHintString( "" );
	    level.trigger_to_hit_with_nade[ x ] setCursorHint( "HINT_NOICON" );
        wait 0.05;
        
        //visualize trigger origin
        playfx( level.myFx[ 78 ], level.trigger_to_hit_with_nade[ x ].origin );
        wait 0.05;

        //if nade hits trigger, we need to pass the x value to notifier, otherwise all triggers will activate
        level.trigger_to_hit_with_nade[ x ] thread firegrenade_monitor_someone_hit_trigger( x ); 

        //spawn a grenade model to each trig loc indicate something for players...
        grenade_mod = spawn( "script_model", level.trigger_to_hit_with_nade[ x ].origin /*offset*/  );
        grenade_mod setmodel( "t6_wpn_grenade_frag_world" );
        grenade_mod thread mover_z( 50, -50, 3, 0.1, 0.1 ); //elevator loop
        grenade_mod thread spinner_yaw( 360, -360, 1, 0, 0 ); //rotator loop

        //link trigger to a moving object
        level.trigger_to_hit_with_nade[ x ] linkto( grenade_mod, "tag_origin" );
        
        //needs at least a frame before it can apply an fx on spawned model's tag
        wait 0.1;
        playfxontag( level.myFx[ 2 ], grenade_mod, "tag_origin" );

        //give engine time to rest
        wait( 1 );
    }
    
}

//play fx on grenade trigger origin when grenade hits it
firegrenade_monitor_someone_hit_trigger( value )
{
    level endon( "end_game" );

    while( true )
    {
        if( isdefined( self ) )
        {
            self waittill( "someone_located_" + value  );
            self playsound( "zmb_avogadro_death_short" );
            playfx( level._effect[ "avogadro_ascend_aerial" ], self.origin );
            for( i = 0; i < 10; i++ )
            {
                playfx( level.myFx[ 9 ], self.origin  );
                playfx( level.myFx[ 3 ], self.origin );
                
                wait randomfloatrange( 0.05, 0.08 );
            }

            wait 1; break;
        }
        wait 0.05;
        
    }
}

firegrenades_step2()
{
    level endon( "end_game" );
    self endon( "disconnect" );

    //self waittill( "spawned_player" );
    
    //the least amount of uses we can have / start with
    self.nades_used = 0;
    //this many times math zombie - nade origin < 870 / randomint( 0, 6 ) has to happen before goal == reached
    to_use = 2; //12 = release value or 6 in total...
    
    //idx will be the player entity eventually
    idx = undefined;

    //waiter because we initiate this thread upon when spawned in and can't start counting entity.nade_used till the notify "its_time" happens
   
   //*************************************************** */
   
    self waittill( "its_time" ); //enable back on later


    //*************************************************** */
    //while we are less than the goal to hit
    while( self.nade_used < to_use )
    {
        //self == player that the thread is running from
        self waittill( "grenade_fire", nade ); 
        //nade._has_activated = false; //debugger
        wait 0.05;
        //assigning self aka the thread that this is running on to variable idx.
        idx = self; 

        //prevent from bugging if repicked from ground
        //nade._has_activated = true; //debugger

        //give frametime
        wait 0.05;
        //requires player id also to know who's self.nades_used index to increase
        nade thread charge_player_nades( idx );
        if( self.nades_used >= to_use )
        {
            nade notify( "please_notify" ); //force kill charge_player_nades function
            self notify( "reward_me" ); //notify global func to give player their firenades
            if( level.dev_time ){ iprintlnbold( "dev_time info: Player " + idx.name + " received ^3firenades"); }
            //iprintlnbold( "Player " + idx.name + " achieved ^3firenades" );
            ///a required statement? We are in while( this ) loop..
            break;
        }
    }
    wait 0.05;

    if( level.dev_time ){ iprintlnbold( "NADES GOT NOTIFIED TO FINISH UP THE WRAPPER\nPlease see {[+grenade]}");}
    wait 0.4;
    //notify the nade entity & thread caller
    if( self.nade_used >= to_use ){ nade notify( "please_notify" ); self notify( "reward_me" ); }
    if( level.dev_time ){ iprintlnbold( "WE PASSED THE NADES NOTIFIER WITH CLEAR COLORS" ); }

}

charge_player_nades( id_ ) //implement repick nade failsafe
{
    level endon( "end_game" );
    self endon( "please_notify" );

    //zombie pool
    zombies_to_pass = undefined;
    //if zombie is being targeted
    is_this_the_right_one = undefined;
    //if soft_spot = true, add a wait delay so that all the zombies wont get the fx spawned on them simulteniously
    soft_spot_active = false;
    //only add 1 to idx size despite the size of zombies near check
    this_time_not_used = true;
    //randomize the distance check per throw
    in_reach = 870 / randomintrange( 0, 6 );
    //dev
    if( level.dev_time ){ iprintlnbold( "Value for _in_reach: ^3" + in_reach ); }
    //small wait 
    wait 1.2;
    zombies_to_pass = getaiarray( level.zombie_team );
    for( s = 0; s < zombies_to_pass.size; s++ )
    {
        is_this_the_right_one = distance( zombies_to_pass[ s ].origin, self.origin );
        if( is_this_the_right_one < in_reach && this_time_not_used )
        {
            //increase player's total pool size
            id_.nades_used++;
            soft_spot_active = true;
            if( level.dev_time )
            {
                iprintlnbold( "Player " + id_.name + " increased zombies_to_pass index" );
                iprintln( "Player " + id_.name + "'s idx count for firegrenades is at " + id_.nades_used + "/12" );
            }
            //dont let other zombies increase nades_used size despite them "getting affected by visual fxs too".
            this_time_not_used = false;
            wait( 0.05 );
            //self notify( "please_notify" );
        }

        //do visuals only
        if( is_this_the_right_one < in_reach )
        {
            
            zz = zombies_to_pass[ s ];
            zz_head = zz gettagorigin( "j_head" );
            for( i = 2; i < 10 / 2; i++ )
            {
                playfx( level.myFx[ 9 ], zz_head );
                wait 0.05;
                playfxontag( level.myfx[ 0 ], zz, zz_head );
            }
            playfxontag( level.myFx[ 2 ], zz, "j_head" );
            wait 0.05;
            playfxontag( level.myfx[ 29 ], zz, "j_head" );
            wait randomfloatrange( 0.1, 0.3 );
            
            self_nade_up = self.origin + ( 0, 0, 800 ); // might not just wanna use self...
            level thread charging_fx_from_zombie_to_sky_then_to_player( zz, self_nade_up, id_ );
        }

        //need time if nade has been targeted so that the fxs wont spawn all at same time
        if( soft_spot_active )
        {
            wait( randomfloatrange( 0.05, 0.08 ) );
        }
    }
}
//zombie fx mover to firenade summoning
charging_fx_from_zombie_to_sky_then_to_player( my_zombie, nade_loc, me_player )
{
    level endon( "end_game" );
    head = my_zombie gettagorigin( "j_head" );

    //spawn temp model
    newspawn = spawn( "script_model", head );
    newspawn setmodel( "tag_origin" );
    //frame rest
    wait 0.05;
    playfxontag( level.myfx[ 35 ], newspawn, "tag_origin" );
    playfxontag( level.myFx[ 69 ], head, "tag_origin" );
    my_zombie dodamage( my_zombie.health + 1000, head );
    playfxontag( level.myFx[ 1 ], newspawn, "tag_origin" );
    my_zombie playsound( level.jsn_snd_lst[ 34 ] ); //screams from spooked guyyyy
    //assign the variable for new target
    if( isDefined( nade_loc ) )
    {
        new_target = nade_loc;
        newspawn moveTo( new_target, randomfloatrange( 0.07, 0.12 ), 0, 0.05 );
        newspawn waittill( "movedone" );
        for( i = 0; i < 2; i++ )
        {
            playfx( level.myfx[ 9 ], new_target );
            wait 0.05;
        }

    }
    wait 0.09;
    //failsafe for stuck fxs
    //if( !isAlive( my_zombie ) )
    //{
        
        //new_target = my_zombie.origin + ( randomintrange( 120, 250 ), randomintrange( -50, 50 ), 2 );
        

        //fist time stabilizers
        t_x = randomintrange( 0, 5 );
        t_y = 0;
        t_z = randomintrange( 15, 55 );

        //THIS PART IS FOR PLAYERS GET CHARGED WITH PLASMA¨
        org = me_player getEye() + anglesToForward( 200 );
        
        new_target = org; //+ (  t_x, t_y, t_z );
        newspawn moveTo( new_target, 0.2, 0.05, 0 );
        wait 0.05;
        newspawn notify( "movedone" );
        //this way we can bounce & keep track of new origin
        while( newspawn.origin != new_target )
        {
            //loop till we get to players loc
           //t_x = randomintrange( 1, -1 );
           // t_y = randomintrange( 1, -1 );
          //  t_z = randomintrange( 45, 55 );

            //newtarget = me_player.origin + ( t_x, t_y, t_z );
            org = me_player getEye() + anglesToForward( 200 );
            new_target = org; //+ (  t_x, t_y, t_z );
            newspawn moveTo( new_target, 0.2, 0.05, 0 );
            wait 0.2;
            newspawn notify( "movedone" );
            playfx( level.myfx[ 9 ], me_player gettagorigin( "j_neck" ) ); 
            break;
        } 
                
        
    //}

    
    
    wait 0.05;
    if( isDefined( newspawn ) )
    {
        playfx( level.myFx[ 9 ], newspawn.origin );
    }
    
    wait 0.1;
    newspawn delete();
    
}

//player thread, monitors grenade button
// self == player
firegrenade_monitor_throw()
{
    self endon( "disconnect" );
    self endon( "stop_grenade_track" );

    //initialise self triggers for nade ( per player )
    self.hits = 0;      //the amount of hittable spots = 5
    self.has_hit_ = 0; //tracker
    self.hit_list = [];
    self.hit_list[ 0 ] = false;
    self.hit_list[ 1 ] = false;
    self.hit_list[ 2 ] = false;
    self.hit_list[ 3 ] = false;
    self.hit_list[ 4 ] = false;
    self thread firegrenade_player_wait_for_upgrade(); //println noti
    self firegrenade_has_player_hit_list(); //false, true list of hit locs
    
    while( true )
    {
        self waittill( "grenade_fire", my_grenade );
        wait 0.05;                                      
        my_grenade thread firegrenade_touched( self ); //pass player as self to increase hit list size on impact
    } 
}

//monitor hit triggers, if all true, thread reward
firegrenade_player_wait_for_upgrade()
{
    level endon( "end_game" );
    self endon( "disconnect" );

    self waittill( "start_step2" );
    wait 4.5;
    self thread firegrenades_step2();
    wait 0.1;
    self notify( "_start_sq_nade_step2_for_player" );
    //player hit all the spots, reward the player
    if( level.dev_time ){ iprintlnbold( "Player ^3" + self.name + " ^8 reached part: WHIZZ NEAR BY ZOMBIES with NADES" ); }
    
    //the real on screen subtitles for this step
    /* TEXT | LOWER TEXT | DURATION | FADEOVERTIME */
    self _someone_unlocked_something_client( "^9Dr. Schruder: ^8What!? How did you find all the nades so quickly?", "^8Try using those grenades now till they are fully charged up with energy!", 8, 0.1 );

    //notify the waittill("its_time") to progress into firenade step 2
    self notify( "its_time" ); //custom noti / waittill
    
    //wait player to achieve fireblaze nades ( happens after getting 12 near by kills with throwable grenades against zombies. )
    self waittill( "reward_me" ); //custom noti / waittill
        
    //do the actual thread that rewards the player
    level thread firegrenade_reward_player( self ); //self == the player
    self notify( "stop_grenade_track" ); //custom noti / waittill
}


//give the player that's passed in as an argument firenades
firegrenade_reward_player( to_who )
{
    level endon( "end_game" );
    to_who thread firegrenades_throw_logic(); //to_who == self player, firegrenade think logic thread()
    to_who.has_up_nades = true;
    /* TEXT | LOWER TEXT | DURATION | FADEOVERTIME */
    self _someone_unlocked_something( "^8Haha! How do you like your new ^9nades^8?", "^8I hope they'll come to good use.. ^9Wunderbar!", 8, 0.1 );
}

//monitor firegrenade usage
firegrenades_throw_logic()
{
    self endon( "disconnect" );
    level endon( "end_game" );

    xpl_fx = level.myFx[ 9 ];
    orb_fx = level.myFx[ 1 ]; 

    while( true )
    {
        self waittill( "grenade_fire", g, weapname );
        while( self fragButtonPressed()) { wait 0.05; } 
        //l
        if(  g || weapname == "jetgun_zm" )             { wait 0.05; continue;}
        if(  g || weapname == "turbine_zm" )            { wait 0.05; continue;}
        if(  g || weapname == "equip_turbine_zm" )      { wait 0.05; continue;}
        if(  g || weapname == "equip_electrictrap_zm" ) { wait 0.05; continue;}
        if(  g || weapname == "electrictrap_zm" )       { wait 0.05; continue;}
        if(  g || weapname == "turbine" )               { wait 0.05; continue;}
        if(  g || weapname == "electrictrap" )          { wait 0.05; continue;}
        if(  g || weapname == "blundersplat_zm" )       { wait 0.05; continue;}
        if(  g || weapname == "blundergat_zm" )         { wait 0.05; continue;}

        //if none of the above, then do this sexy grenade shit
        self thread firegrenade_funny_time( xpl_fx, orb_fx, g, self ); //self on the parameter for "thrower"
        wait 0.1;
    }
}

//do the firegrenade explosion
firegrenade_funny_time( explo, trail, linkto_object, thrower )
{
    self endon( "disconnect" );
    level endon( "end_game" );
    
    //handle the orb fx as object's tag.
    playFXOnTag( trail, linkto_object, "tag_origin" );
    
    //reset for loop
    first_time = true; 
    

    //custom explo array
    temp_array = [];

    temp_array[ 0 ] = ( randomintrange( -15, 15 ), randomintrange( -25, 35 ), randomintrange( 1, 45 ) );
    temp_array[ 1 ] = ( randomintrange( -15, 215 ), randomintrange( -25, 35 ), randomintrange( 1, 345 ) );
    temp_array[ 2 ] = ( randomintrange( -15, 15 ), randomintrange( -125, 135 ), randomintrange( 1, 145 ) );
    temp_array[ 3 ] = ( randomintrange( -15, 15 ), randomintrange( -25, 35 ), randomintrange( 1, 45 ) );
    temp_array[ 4 ] = ( randomintrange( -15, 315 ), randomintrange( -225, 35 ), randomintrange( 1, 45 ) );
    temp_array[ 5 ] = ( randomintrange( -15, 215 ), randomintrange( -25, 35 ), randomintrange( 1, 245 ) );
    temp_array[ 6 ] = ( randomintrange( -15, 15 ), randomintrange( -25, 235 ), randomintrange( 1, 245 ) );
    temp_array[ 7 ] = ( randomintrange( -15, 315 ), randomintrange( -25, 35 ), randomintrange( 1, 125 ) );
    temp_array[ 8 ] = ( randomintrange( -15, 15 ), randomintrange( -25, 35 ), randomintrange( 1, 45 ) );
    temp_array[ 9 ] = ( randomintrange( -15, 15 ), randomintrange( -25, 35 ), randomintrange( 1, 145 ) );
    temp_array[ 10 ] = ( randomintrange( -15, 15 ), randomintrange( -235, 35 ), randomintrange( 1, 45 ) );
    temp_array[ 11 ] = ( randomintrange( -15, 15 ), randomintrange( -25, 35 ), randomintrange( 1, 245 ) );
    temp_array[ 12 ] = ( randomintrange( -15, 15 ), randomintrange( -125, 35 ), randomintrange( 1, 45 ) );
    temp_array[ 13 ] = ( randomintrange( -15, 115 ), randomintrange( -25, 35 ), randomintrange( 1, 345 ) );
    temp_array[ 14 ] = ( randomintrange( -15, 115 ), randomintrange( -25, 235 ), randomintrange( 1, 45 ) );
    temp_array[ 15 ] = ( randomintrange( -15, 15 ), randomintrange( -25, 35 ), randomintrange( 1, 145 ) );

    //halfway number
    hw = temp_array.size / 2;
    
    //linkto_obj = grenade that is currently in world¨
    //thrower = player entity
    level thread firegrenade_go_poke( linkto_object, thrower );

    //combine all under 1 variable
    comboer = undefined;

    //give the trail fx that was spawned in some time to lingerr
    wait randomfloatrange( 1.4, 2.8 );

    for( i = 0; i < temp_array.size; i++ )
    {
        //start from the beginning for a longer explo effect time
        if( first_time && i >= hw )
        {
            i = 0;
            level notify( "death_by" + thrower );
            //can't jump into this if anymore
            first_time = false;
        }
        if( i == hw )
        {
            //spawn in some lava fxs, we might wanna attach mspawner to a  rotateYAW func
            mspawn = spawn( "script_model", linkto_object.origin + temp_array[ i ] );
            mspawn setmodel( "tag_origin" );
            wait 0.05;
            playfxontag( level.myFx[ 17 ], mspawn, "tag_origin" ); //temp fx for now to see whats fucking
        }

        //assign temp array random values to grenade loc & combine grenade + temp_array random values into one variable = comboer
        comboer = linkto_object.origin + temp_array[ i ];
        playfx( explo, comboer );
        wait randomfloatrange( 0.08, 0.3 );
    }

    wait 10; //originally 0.2. something gets fucked so check
    temp_array delete(); //temp random locations []
    mspawn delete(); //model
    
}

firegrenade_go_poke( grenade_model, who_id )
{
    // ent = grenade
    //who_id = player entity
    //self endon( "disconnect" );
    level endon( "end_game" );

    level waittill( "death_by" + who_id );
    location_ = grenade_model.origin;
    x = 0;
    grenade_that_flies_to_sky = spawn( "script_model", location_ );
    grenade_that_flies_to_sky setmodel( "tag_origin" );
    grenade_that_flies_to_sky.angles = grenade_that_flies_to_sky.angles;

    zombies = getAIArray( level.zombie_team );
    distance_ = 500;

    playfxontag( level.myfx[ 35 ], grenade_that_flies_to_sky, "tag_origin" );

    temporarily_targeted_zombies = [];
    for( i = 0; i < zombies.size; i++ )
    {
        if( i == 0 )
        {
            x = 0;
            if( level.dev_time ) { iprintlnbold( "NADE ^3first time check i = 0, init X" );}
        }
        

        if( distance( grenade_that_flies_to_sky, zombies[ i ] ) < distance_ )
        {
            //look into this temporarily_targeted_zombies array. 
            //think something with it fucks the nade from not gettting released from sky sometimes. 
            //usually happens when multiple nades are waiting to get launched
            temporarily_targeted_zombies[ x ] = zombies[ i ];
            x++;
            temporarily_targeted_zombies[ x ].marked_to_summon = true;
        }
    }

    
    wait randomfloatrange( 1, 1.5 );
    //let's delete the entity ( grenade )
    if( isDefined( grenade_model ) )
    {
        grenade_that_flies_to_sky.origin = grenade_model.origin;
        wait 0.05;
        grenade_model delete();
    }
    //this shoots the orb up in the air from the grenade
    playfxontag( level.myfx[ 2 ], grenade_that_flies_to_sky, "tag_origin" );
    earthquake( 0.2, 4, grenade_that_flies_to_sky.origin, 5000 );
    //earthquake(<scale>, <duration>, <source>, <radius>)
    grenade_that_flies_to_sky movez( randomintrange( 750, 1200), randomfloatrange( 1, 1.4 ), 0.31, 0 );
    grenade_that_flies_to_sky waittill( "movedone" );
    if( level.fake_handle_required )
    {
        wait 0.5;
        grenade_that_flies_to_sky delete();
        array_delete( temporarily_targeted_zombies );
        if( isdefined( grenade_model ) ) { grenade_model delete(); }
        wait 0.1;
        return;
    }
    wait 0.05;
    //if we get this far, enable this so that other players grenades can fly to sky but not target zombies
    //when this global is active.
    level.fake_handle_required = true; 
    for( s = 0; s < temporarily_targeted_zombies.size; s++ )
    {
        trail_from_sky_to_ground = spawn( "script_model", grenade_that_flies_to_sky.origin );
        trail_from_sky_to_ground setmodel( "tag_origin" );
        trail_from_sky_to_ground.angles = trail_from_sky_to_ground.angles;
        wait 0.1;
        playfxontag( level.myfx[ 1 ], trail_from_sky_to_ground, "tag_origin" );
        trail_from_sky_to_ground thread find_and_destroy_zombie( temporarily_targeted_zombies[ s ], trail_from_sky_to_ground );
    }

    wait 0.1;
    grenade_that_flies_to_sky delete();

    //remove array to free up usage
    array_delete( temporarily_targeted_zombies );
    //we seem to leave a trail fx hanging on the sky sometimes meaning that said fx's entity does not get removed from the world from previous logic for some reason
    if( isdefined( grenade_model ) ) { grenade_model delete(); }
    wait 3;
    //let other players fire grenades target zombies again
    level.fake_handle_required = false;

}

//this function has been fixed now. no more orbs staying stuck on the sky in some cases, force deletes the entity if that happens
find_and_destroy_zombie( zombie_to_kill, orb_from_sky )
{
    self endon( "death" );
    level endon( "end_game" );

    //add a failsafe in case the targeting system fails, otherwise sky will have orbs hovering that do not get deleted when needed. 
    level thread failsafe_remove( self );
    self moveto( zombie_to_kill.origin + ( 0, 0, 40 ), randomfloatrange( 0.1, 0.28 ), 0, 0 );
    self waittill( "movedone" );

    //orb has been moved to zombie's location, now play somew spark fxs before killing it
    for( i = 0; i < 4; i++ )
    {
        playfx( level.myfx[ 85 ], self.origin + ( randomintrange( -40, 40 ), randomintrange( -60, 60 ), randomintrange( -15, 15 ) ) );
        wait .05;
    }
    playfxontag( level.myf[ 68 ], zombie_to_kill, zombie_to_kill getTagOrigin( "j_head" ) );
    wait 0.1;
    level thread move_fire_below_and_delete( level.myfx[ 70 ], zombie_to_kill.origin + ( 0, 0, 90 ) );
    zombie_to_kill doDamage( zombie_to_kill.health + 1000, zombie_to_kill.origin );
    zombie_to_kill StartRagdoll();

    wait( 0.05 );

    zombie_to_kill LaunchRagdoll( ( 0, 0, 100 ) );
    //delete the entity once it has hit zombie
    orb_from_sky delete();
}

move_fire_below_and_delete( fx, zombie_death_loc )
{
    ent_mover = spawn( "script_model", zombie_death_loc );
    ent_mover setmodel( "tag_origin" );
    ent_mover.angles = ent_mover.angles;

    wait 0.05;
    playfxontag( fx, ent_mover, "tag_origin" );
    ent_mover movez( -400, 4, 3, 0 );
    ent_mover waittill( "movedone" );
    ent_mover delete();
}

failsafe_remove( object )
{
    wait 5;
    if( isdefined( object ) ) { object delete(); }
}

hoverme( linked )
{
    level endon("end_game");
    self endon( "death" );
    while( isAlive( linked ) )
    {
        self movez( 40, 0.5, 0.11, 0 );
        self waittill( "movedone" );
        self movez( -40, 0.34, 0.1, 0 );
        self waittill( "movedone" );
    }
}

stop_zomb()
{
	if ( is_true( self.marked_to_summon ) ) { return true; } return false;
}

//player's own list of hit triggers
firegrenade_has_player_hit_list()
{
    level endon( "end_game" );
    self.hit_list = [];
    self.hit_list[ 0 ] = false;
    self.hit_list[ 1 ] = false;
    self.hit_list[ 2 ] = false;
    self.hit_list[ 3 ] = false;
    self.hit_list[ 4 ] = false;
    self.has_picked_up_boots = false;
    self.has_up_nades = false;
}

//logic for grenade when looking for a trigger to touch
firegrenade_touched( who )
{
    self endon( "disconnect" );
    level endon( "end_game" );
    self endon( "gucci" );
    amount = 0;
    while( isdefined( self ) )
    {
        for( i = 0; i < level.trigger_to_hit_with_nade.size; i++ )
        {
            if( isdefined( self ) && self istouching( level.trigger_to_hit_with_nade[ i ] ) )
            {
                

                if( who.hit_list[ i ] == false )
                { 
                    //add this trigger to player's claimed nodes    
                    who.hits++;
                    who.hit_list[ i ] = true;
                    wait 0.05;
                    for( s = 0; s < who.hit_list.size; s++ )
                    {
                        if( who.hit_list[ s ] == true )
                        {
                            amount++;
                        }
                        else { amount = amount; }
                    }
                    wait 0.05;
                    who _someone_unlocked_something_client( "^8Fire Grenades Found", "^9[ ^8" + amount + " ^9/^8 5 ^9]", 4, 1 );
                    //who.hits++; //increase player who hit score
                    //iprintlnbold( who.name + "HIT, TRIGGER : ^3" + level.trigger_to_hit_with_nade[ i ] );
                    //self notify( "gucci" ); 
                    playfx( level.myfx[ 78 ], level.trigger_to_hit_with_nade[ i ].origin );
                    playsoundatposition( "zmb_avogadro_death_short", level.trigger_to_hit_with_nade[ i ].origin );
                    //if no claimed node, notify the black_hole thread to play an fx on notifier + i's value
                    level.trigger_to_hit_with_nade[ i ] notify( "someone_located_" + i );  
                    wait 0.1;
                    if( who.hit_list[ 0 ] == true &&
                        who.hit_list[ 1 ] == true &&
                        who.hit_list[ 2 ] == true && 
                        who.hit_list[ 3 ] == true &&
                        who.hit_list[ 4 ] == true  )
                    {
                        wait 1.5;
                        who notify( "start_step2" );
                        break;
                    }

                    
                    break;

                }

                //check if player has already claimed this node by checking if the i matches to self.hit_list  in h_players_claimed_nodes
                //if true, force end this function
                if( who.hit_list[ i ] == true )
                {
                    //end, break this thread since we have touched this
                    if( level.dev_time ){ iprintlnbold( "skipping player, since player already has this trigger claimed. Node_num: ^3" + i ) ; }
                    wait 0.05;
                    break;
                }
            }
            wait 0.05;
        }
        wait 0.05;
    }
    
}

//check if firegrenade quest is active and assign a hit_list to a connecting player if thats the case
firegrenade_assign_hitlist_to_connecting_midgame()
{
    level endon( "end_game" );
    self endon( "disconnect" );

    while( true )
    {
        level waittill( "connected", newComer );
        if( level.firegrenade_quest_active )
        {
            newComer thread firegrenade_has_player_hit_list();
        }
    }

}



// HUD SPECIFIC | HUD SPECIFIC | HUD SPECIFIC | HUD SPECIFIC | HUD SPECIFIC | HUD SPECIFIC //

//this is a global sayer, all players in game will receive this at once
_someone_unlocked_something( subtitle_upper, subtitle_lower, duration, fadetimer )
{
    level endon( "end_game" );
	level thread SchruderSays( "^9Dr. Schruder: ^8" + subtitle_upper, subtitle_lower, duration, fadetimer );
}

_someone_unlocked_something_client( subtitle_upper, subtitle_lower, duration, fadetimer )
{
    level endon( "end_game" );
    self endon( "disconnect ");
	self thread SchruderSaysClient( subtitle_upper, subtitle_lower, duration, fadetimer );
}

SchruderSaysClient( sub_up, sub_low, duration, fadeTimer )
{
    if( isdefined( level.subtitles_on_so_have_to_wait ) && level.subtitles_on_so_have_to_wait )
    {
        u_y = -86;
        l_y = -64;
    }

    else if( isdefined( level.subtitles_on_so_have_to_wait ) && !level.subtitles_on_so_have_to_wait )
    {
        u_y = -42;
        l_y = -24;
    }
    if( isdefined( subtitle_upper ) )
    {
        subtitle_upper destroy_hud();
    }
	subtitle_upper = NewClientHudElem( self );
	subtitle_upper.x = 0;
	subtitle_upper.y = u_y;
	subtitle_upper SetText( sub_up );
	subtitle_upper.fontScale = 1.32;
	subtitle_upper.alignX = "center";
	subtitle_upper.alignY = "middle";
	subtitle_upper.horzAlign = "center";
	subtitle_upper.vertAlign = "bottom";
	subtitle_upper.sort = 1;
    
	subtitle_lower = undefined;
	subtitle_upper.alpha = 0;
    subtitle_upper fadeovertime( fadeTimer );
    subtitle_upper.alpha = 1;

	if ( IsDefined( sub_low ) )
	{
        if( isdefined( subtitle_lower ) )
        {
            subtitle_lower destroy_hud();
        }
		subtitle_lower = NewClientHudElem( self );
		subtitle_lower.x = 0;
		subtitle_lower.y = l_y;
		subtitle_lower SetText( sub_low );
		subtitle_lower.fontScale = 1.22;
		subtitle_lower.alignX = "center";
		subtitle_lower.alignY = "middle";
		subtitle_lower.horzAlign = "center";
		subtitle_lower.vertAlign = "bottom";
		subtitle_lower.sort = 1;
        subtitle_lower.alpha = 0;
        subtitle_lower fadeovertime( fadeTimer );
        subtitle_lower.alpha = 1;
	}
	
	wait ( duration );
	level thread flyby_nades_hud_elem( subtitle_upper );
    subtitle_upper fadeovertime( fadeTimer );
    subtitle_upper.alpha = 0;
    wait fadeTimer;
    
	//subtitle Destroy();
	
	if ( IsDefined( subtitle_lower ) )
	{
		level thread flyby_nades_hud_elem( subtitle_lower );
        subtitle_lower fadeovertime( fadeTimer );
        subtitle_lower.alpha = 0;
        wait fadeTimer;
        
	}

   // wait 1.5;
   // subtitle_upper destroy_hud();
   // subtitle_lower destroy_hud();
}


SchruderSays( sub_up, sub_low, duration, fadeTimer )
{
    if( isdefined( level.subtitles_on_so_have_to_wait ) && level.subtitles_on_so_have_to_wait )
    {
        u_y = -86;
        l_y = -64;
    }
	subtitle_upper = NewHudElem();
	subtitle_upper.x = 0;
	subtitle_upper.y = u_y;
	subtitle_upper SetText( sub_up );
	subtitle_upper.fontScale = 1.32;
	subtitle_upper.alignX = "center";
	subtitle_upper.alignY = "middle";
	subtitle_upper.horzAlign = "center";
	subtitle_upper.vertAlign = "bottom";
	subtitle_upper.sort = 1;
    
	subtitle_lower = undefined;
	subtitle_upper.alpha = 0;
    subtitle_upper fadeovertime( fadeTimer );
    subtitle_upper.alpha = 1;

	if ( IsDefined( sub_low ) )
	{
		subtitle_lower = NewHudelem();
		subtitle_lower.x = 0;
		subtitle_lower.y = l_y;
		subtitle_lower SetText( sub_low );
		subtitle_lower.fontScale = 1.22;
		subtitle_lower.alignX = "center";
		subtitle_lower.alignY = "middle";
		subtitle_lower.horzAlign = "center";
		subtitle_lower.vertAlign = "bottom";
		subtitle_lower.sort = 1;
        subtitle_lower.alpha = 0;
        subtitle_lower fadeovertime( fadeTimer );
        subtitle_lower.alpha = 1;
	}
	
	wait ( duration );
	level thread flyby_nades_hud_elem( subtitle_upper );
    subtitle_upper fadeovertime( fadeTimer );
    subtitle_upper.alpha = 0;
    wait fadeTimer;
	if ( IsDefined( subtitle_lower ) )
	{
		level thread flyby_nades_hud_elem( subtitle_lower );
        subtitle_lower fadeovertime( fadeTimer );
        subtitle_lower.alpha = 0;
        wait fadeTimer;
	}
    
}

//this a gay ass hud flyer, still choppy af
flyby_nades_hud_elem( element )
{
    level endon( "end_game" );
    x = 0;
    on_right = 640;

    while( element.x < on_right )
    {
        element.x += 100;
        wait 0.05;
    }
    //failsafe timer
    wait 0.1;
    element destroy();
}



// RANDOM REGS | RANDOM REGS | RANDOM REGS | RANDOM REGS | RANDOM REGS //


//for moving the hittable nade spots
mover_z( up, down, timer, acc, decc )
{
    level endon( "end_game" );
    while( true )
    {
        if( isdefined( self ) )
        {
            self movez( up, timer, acc, decc );
            self waittill( "movedone" );
            self movez( down, timer, acc, decc );
            self waittill( "movedone" );
        }
        
    }
}

//for spinning the hittable nade spots
spinner_yaw( clockwise, counterclock, timer, lerp_acc, lerp_decc )
{
    level endon( "end_game" );
    while( true )
    {
        if( isdefined( self ) )
        {
            self rotateYaw( clockwise, timer, lerp_acc, lerp_decc );
            self waittill( "movedone" );
            self rotateyaw( counterclock, timer, lerp_acc, lerp_decc );
            self waittill( "movedone" );
        }

    }
}


















































































