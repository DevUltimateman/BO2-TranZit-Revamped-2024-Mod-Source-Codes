#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_weapons;
#include clientscripts\mp\zombies\_zm_utility;
#include clientscripts\mp\zombies\_zm_weap_blundersplat;
#include clientscripts\mp\_filter;
#include clientscripts\mp\_visionset_mgr;
#include clientscripts\mp\zombies\_zm;
#include clientscripts\mp\zombies\_zm_equipment;

main()
{
    clientscripts\mp\zombies\_zm_weap_blundersplat::init();
    level._entityspawned_override = ::entityspawned_transit;
}

entityspawned_transit( localclientnum )
{
    if ( !isdefined( self.type ) )
    {
/#
        println( "Entity type undefined!" );
#/
        return;
    }

    if ( self.type == "player" )
        self thread playerspawned( localclientnum );

    if ( self.type == "missile" )
    {
        switch ( self.weapon )
        {
            case "blundersplat_explosive_dart_zm":
                self thread clientscripts\mp\zombies\_zm_weap_blundersplat::spawned( localclientnum );
                break;
        }
    }
}

