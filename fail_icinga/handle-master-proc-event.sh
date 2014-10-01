#!/bin/sh

# Only take action on hard service states...
case "$2" in
HARD)
        case "$1" in
        CRITICAL)
                # The master Icinga process is not running!
                # We should now become the master host and
                # take over the responsibility of monitoring
                # the network, so enable notifications...
                /usr/share/icinga/plugins/eventhandlers/enable_notifications
                ;;
        WARNING | UNKNOWN)
                # The master Icinga process may or may not
                # be running.. We won't do anything here, but
                # to be on the safe side you may decide you 
                # want the slave host to become the master in
                # these situations...
                ;;
        OK)
                # The master Icinga process running again!
                # We should go back to being the slave host, 
                # so disable notifications...
                /usr/share/icinga/plugins/eventhandlers/disable_notifications
                ;;
        esac
        ;;
esac
exit 0
