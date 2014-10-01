#!/bin/sh

# Only take action on hard host states...
case "$2" in
HARD)
        case "$1" in
        DOWN)
                # The master host has gone down!
                # We should now become the master host and take
                # over the responsibilities of monitoring the 
                # network, so enable notifications...
                /usr/share/icinga/plugins/eventhandlers/enable_notifications
                ;;
        UP)
                # The master host has recovered!
                # We should go back to being the slave host and
                # let the master host do the monitoring, so 
                # disable notifications...
                /usr/share/icinga/plugins/eventhandlers/disable_notifications
                ;;
        esac
        ;;
esac
exit 0
